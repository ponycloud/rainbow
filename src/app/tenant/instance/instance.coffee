module = angular.module 'tenantInstance', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/instance',
    templateUrl: 'tenant/instance/instance-list.tpl.html'
    controller: 'InstanceListCtrl'

  $routeProvider.when '/:tenant/instance/create',
    templateUrl: 'tenant/instance/instance-wizard.tpl.html'
    controller: 'InstanceWizardCtrl'

  $routeProvider.when '/:tenant/instance/:instance',
    templateUrl: 'tenant/instance/instance-detail.tpl.html'
    controller: 'InstanceDetailCtrl'
]


module.controller 'InstanceListCtrl',
  class InstanceListCtrl
    @inject = ['$scope', '$routeParams', 'TenantInstance', 'dataContainer']
    constructor: ($scope, $routeParams, TenantInstance, dataContainer, $modal) ->
      list = TenantInstance.list {tenant: $routeParams.tenant}
      list.$promise.then (i) ->
        $scope.instances = i
        dataContainer.registerEntity 'instance', $scope.instances


module.controller 'InstanceDetailCtrl',
  class InstanceDetailCtrl
    @$inject = ['$scope', '$routeParams', '$modal', 'TenantInstance', 'TenantVolume',
                'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantInstanceVnicAddress',
                'StoragePool', 'dataContainer']

    constructor: ($scope, $routeParams, $modal, TenantInstance, TenantVolume, TenantInstanceVdisk, TenantInstanceVnic, TenantInstanceVnicAddress, StoragePool, dataContainer) ->

      $scope.instanceEditModal = $modal({keyboard: true, scope: $scope, template: 'tenant/instance/instance-edit-modal.tpl.html', show: false})
      $scope.vnicListModal = $modal({keyboard: true, scope: $scope, template: 'tenant/instance/vnic-list-modal.tpl.html', show: false})
      $scope.vdiskListModal = $modal({keyboard: true, scope: $scope, template: 'tenant/instance/vdisk-list-modal.tpl.html', show: false})

      $scope.vdiskListClose = () ->
        $scope.vdiskListModal.hide()

      $scope.vdiskListOpen = () ->
        $scope.vdiskListModal.show()


      $scope.instance = TenantInstance.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      TenantInstanceVdisk.list {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
      .$promise.then (vdisks) ->
        $scope.vdisks = vdisks
        dataContainer.registerEntity 'vdisk', $scope.vdisks

      TenantVolume.list {'tenant': $routeParams.tenant}
      .$promise.then (volumes) ->
        $scope.volumes = volumes
        dataContainer.registerEntity 'volume', $scope.volumes

        $scope.$watch 'volumes', (value) ->
          $scope.volumeDict = {}
          $scope.filteredVolumes = []
          for volume in value
            $scope.volumeDict[volume.desired.uuid] = volume

            if not volume.desired.image
              $scope.filteredVolumes.push volume


      TenantInstanceVnic.list
        tenant: $routeParams.tenant
        instance: $routeParams.instance
      .$promise.then (vnics) ->
        $scope.vnics = vnics

      $scope.vnicIps = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance
        vnic: $routeParams.vnic

      $scope.volumeFilter = (actual, expected) ->
        regex = new RegExp("^"+expected, 'i')
        nameTest = regex.test $scope.volumeDict[actual].desired.name
        sizeTest = regex.test $scope.volumeDict[actual].desired.size
        nameTest || sizeTest

      $scope.createVdisk = (volume) ->
        max = 0
        for item in $scope.vdisks
          if item.desired.index > max
            max = item.desired.index

        newVdisk = new TenantInstanceVdisk()
        newVdisk.desired = {
          'volume': volume.desired.uuid
          'index': max + 1
          'name': volume.desired.name
        }

        newVdisk.$save({'tenant': $routeParams.tenant, 'instance': $routeParams.instance}, (response) ->
          $scope.vdiskListClose()
          #$scope.message("Volume created", 'success')
        )

      # Plain and simple delete
      $scope.deleteVdisk = (vdisk) ->
        vdisk = JSON.parse(vdisk)
        params = {'tenant': $routeParams.tenant, 'vdisk': vdisk.desired.uuid, 'instance': vdisk.desired.instance}

        TenantInstanceVdisk.delete(params, () ->
          $scope.message("Vdisk deleted", 'success')
        )

      $scope.deleteSelectedVdisks = (items) ->
        for item in items
          $scope.deleteVdisk item



module.controller 'InstanceWizardCtrl',
  class InstanceWizardCtrl
    @$inject = ['$scope', '$routeParams', 'TenantInstance', 'TenantSwitchNetwork',
                'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantSwitch',
                'TenantInstanceVnicAddress', 'TenantVolume', 'StoragePool', 
                'CpuProfile', 'TenantAffinityGroup','dataContainer']

    constructor: ($scope, $routeParams, TenantInstance, TenantSwitchNetwork, TenantInstanceVdisk,
                  TenantInstanceVnic, TenantSwitch, TenantInstanceVnicAddress, TenantVolume,
                  StoragePool, CpuProfile, TenantAffinityGroup, dataContainer) ->

      # Variable that should contain all information
      # about instance accross the creation wizard
      $scope.instance = {'selectedVolumes': [], 'vdisks': [], 'vnics': []}

      CpuProfile.list()
      .$promise.then (cp) ->
        $scope.cpu_profiles = cp
        dataContainer.registerEntity 'cpu_profile', $scope.cpu_profiles
      TenantSwitch.list
        tenant: $routeParams.tenant
      .$promise.then (ts) ->
        $scope.switches = ts
        dataContainer.registerEntity 'switch', $scope.switches


      # List of volumes without image
      TenantVolume.list({'tenant': $routeParams.tenant}).$promise.then (VolumeList) ->
        $scope.volumes = VolumeList
        dataContainer.registerEntity('volume', $scope.volumes)

        $scope.$watch 'volumes', (value) ->
          $scope.filteredVolumes = $scope.volumes.filter(
            (item) ->
              item unless item.desired.image
          )
        , true

      # List of affinity groups
      TenantAffinityGroup.list
        tenant: $routeParams.tenant
      .$promise.then (ag) ->
        $scope.affinity_groups = ag
        dataContainer.registerEntity 'affinity_group', $scope.affinity_groups

      $scope.removeVnic = (vnic) ->
        $scope.instance['vnics'] = $scope.instance['vnics'].filter(
          (item) ->
            item.$$hashKey != vnic.$$hashKey
          )


      $scope.addVnic = () ->
        c = $scope.instance.vnics.push {'switch': null, 'network': null, 'addresses': []}
        $scope.$watch 'instance.vnics['+(c-1)+'].switch', (value) ->
          $scope.renewNetworks value, c-1

        $scope.$watch 'instance.vnics['+(c-1)+'].network', (value) ->
          $scope.renewAddresses value, c-1


      # Add first vNIC
      $scope.addVnic()

      $scope.finishedWizard = () ->
        console.log "Dokonceno!"

      $scope.renewAddresses = (networkUUID, index) ->
        for address in $scope.instance.vnics[index].addresses
          address.desired.network = networkUUID

        # Add one address if there is none
        if $scope.instance.vnics[index].addresses.length == 0
          $scope.addAddress networkUUID, $scope.instance.vnics[index]

      $scope.addAddress = (networkUUID, vnic) ->
        k = jQuery.inArray(vnic, $scope.instance.vnics)

        $scope.instance.vnics[k].addresses.push
          'desired':
            'ip': '',
            'ptr':'',
            'network': networkUUID

      $scope.removeAddress = (address, vnic) ->
        k = jQuery.inArray(vnic, $scope.instance.vnics)

        $scope.instance.vnics[k].addresses = $scope.instance.vnics[k].addresses.filter(
          (item) ->
            item.$$hashKey != address.$$hashKey
        )


      $scope.renewNetworks = (switchUUID, index) ->
        TenantSwitchNetwork.list
          tenant: $routeParams.tenant
          switch: switchUUID
        .$promise.then((networks) ->
          $scope.instance.vnics[index].networks = networks
          # Remove old mappings
          $scope.renewAddresses '',index
        )

      $scope.assignVolume = (volume) ->
        volume.selected = true

        $scope.instance['vdisks'].push
          'desired':
            'volume': volume.desired.uuid,
            'instance': '%instance_uuid%',
            'index': $scope.instance['vdisks'].length+1
          'volume': volume

      $scope.unassignVolume = (volume) ->
        # Uncheck volume
        for item in $scope.volumes
          if volume.desired.uuid == item.desired.uuid
            item.selected = false
        # Remove vdisk from the table
        $scope.instance['vdisks'] = $scope.instance['vdisks'].filter(
          (item) ->
            item.volume.desired.uuid != volume.desired.uuid
          )

