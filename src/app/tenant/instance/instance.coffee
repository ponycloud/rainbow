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
    @$inject = ['$scope', '$routeParams', 'TenantInstance', 'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantInstanceVnicAddress', 'StoragePool']

    constructor: ($scope, $routeParams, TenantInstance, TenantInstanceVdisk, TenantInstanceVnic, TenantInstanceVnicAddress, StoragePool) ->
      $scope.instance = TenantInstance.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vdisks = TenantInstanceVdisk.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vnics = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vnicIps = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance
        vnic: $routeParams.vnic

module.controller 'InstanceWizardCtrl',
  class InstanceWizardCtrl
    @$inject = ['$scope', '$routeParams', 'TenantInstance', 'TenantSwitchNetwork',
                'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantSwitch',
                'TenantInstanceVnicAddress', 'TenantVolume', 'StoragePool', 
                'CpuProfile', 'TenantAffinityGroup']

    constructor: ($scope, $routeParams, TenantInstance, TenantSwitchNetwork, TenantInstanceVdisk,
                  TenantInstanceVnic, TenantSwitch, TenantInstanceVnicAddress, TenantVolume,
                  StoragePool, CpuProfile, TenantAffinityGroup) ->

      # Variable that should contain all information
      # about instance accross the creation wizard
      $scope.instance = {'selectedVolumes': [], 'vdisks': [], 'vnics': []}

      $scope.cpu_profiles = CpuProfile.list()
      $scope.switches = TenantSwitch.list
                          tenant: $routeParams.tenant


      # List of volumes without image
      TenantVolume.list
        tenant: $routeParams.tenant
      .$promise.then((volumes) ->
        $scope.volumes = volumes.filter(
          (item) ->
            'image' of item.desired
        )
      )

      $scope.affinity_groups = TenantAffinityGroup.list
        tenant: $routeParams.tenant

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

