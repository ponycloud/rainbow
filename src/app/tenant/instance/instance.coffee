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

      $scope.setStateSelected = (selected, state) ->
          params = {'tenant': $routeParams.tenant}
          patch = []
          for item in selected
            patch.push
              op: 'x-merge'
              path: '/'+item+'/desired/state'
              value: state
          TenantInstance.patch(params, patch)

      $scope.deleteSelected = (items) ->
        patch = []
        params = {'tenant': $routeParams.tenant}
        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantInstance.patch(params, patch)


module.controller 'InstanceDetailCtrl',
  class InstanceDetailCtrl
    @$inject = ['$scope', '$routeParams', '$modal', 'TenantInstance',
                'TenantVolume', 'TenantSwitch', 'TenantSwitchNetwork',
                'TenantInstanceVdisk', 'TenantInstanceVnic',
                'TenantInstanceVnicAddress', 'TenantVolumeVdisk',
                'StoragePool', 'CpuProfile', 'dataContainer']

    constructor: ($scope, $routeParams, $modal, TenantInstance, TenantVolume,
      TenantSwitch, TenantSwitchNetwork, TenantInstanceVdisk, TenantInstanceVnic,
      TenantInstanceVnicAddress, TenantVolumeVdisk, StoragePool, CpuProfile
      dataContainer) ->

      $scope.instanceEditModal = $modal
        keyboard: true
        scope: $scope
        template: 'tenant/instance/instance-edit-modal.tpl.html'
        show: false
      $scope.vnicEditModal = $modal
        keyboard: true
        scope: $scope
        template: 'tenant/instance/vnic-edit-modal.tpl.html'
        show: false
      $scope.vdiskListModal = $modal
        keyboard: true
        scope: $scope
        template: 'tenant/instance/vdisk-list-modal.tpl.html'
        show: false

      # Instance

      TenantInstance.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance
      .$promise.then (instance) ->
        $scope.instance = instance
        dataContainer.registerResource $scope.instance, $scope.instance.desired.uuid

      CpuProfile.list()
      .$promise.then (cp) ->
        $scope.cpu_profiles = cp
        dataContainer.registerEntity 'cpu_profile', $scope.cpu_profiles

      $scope.instanceEditClose = (reload) ->
        if reload
          TenantInstance.get
            tenant: $routeParams.tenant
            instance: $routeParams.instance
          .$promise.then (instance) ->
            $scope.instance = instance

        $scope.instanceEditModal.hide()

      $scope.instanceEditOpen = () ->
        $scope.instance.ns = []
        for ns in $scope.instance.desired.ns
          $scope.instance.ns.push {'value': ns}

        $scope.instanceEditModal.show()

      $scope.addNameserver = () ->
        $scope.instance.ns.push {'value':''}

      $scope.removeNameserver = (ns) ->
        $scope.instance.ns = $scope.instance.ns.filter(
          (item) ->
            item.$$hashKey != ns.$$hashKey
        )

      $scope.instanceEditSave = () ->
          params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
          desired = $scope.instance.desired
          ns = []
          for item in $scope.instance.ns
            ns.push item['value']

          patch = [{
            op: 'x-merge'
            path: '/desired'
            value:
              name: desired.name
              vcpu: desired.vcpu
              rcpu: desired.rcpu
              cpu_profile: desired.cpu_profile
              boot: desired.boot
              mem: desired.mem
              ns: ns
              state: desired.state
          }]
          TenantInstance.patch(params, patch)
          $scope.instanceEditClose()

      $scope.instanceSetState = (state) ->
        params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
        patch = [{
          op: 'x-merge'
          path: '/desired/state'
          value: state
        }]
        TenantInstance.patch(params, patch)

      # vNICs

      TenantInstanceVnic.list
        tenant: $routeParams.tenant
        instance: $routeParams.instance
      .$promise.then (vnics) ->
        $scope.vnics = vnics
        dataContainer.registerEntity 'vnic', $scope.vnics

      $scope.vnicIps = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance
        vnic: $routeParams.vnic


      # Update index of vNICs when resorted
      $scope.sortVnics = {
        stop: (e, ui) ->
          i = 0
          patch = []
          params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}

          for vnic in $scope.vnics
            patch.push({'op': 'x-merge', 'path': '/'+vnic.desired.uuid+'/desired/index', 'value': i++ })
          TenantInstanceVnic.patch(params, patch)
      }

      initializeVnicModal = () ->
        $scope.$watch 'vnic.desired.switch', (value) ->
          $scope.renewNetworks value

        $scope.vnicEditModal.$promise.then(
          TenantSwitch.list
            tenant: $routeParams.tenant
          .$promise.then (ts) ->
            $scope.switches = ts
            unless $scope.vnic.desired.switch
              $scope.vnic.desired.switch = ts[0].desired.uuid
            dataContainer.registerEntity 'switch', $scope.switches
        )

      $scope.createVnic = () ->
        $scope.vnicEditModal.show()
        $scope.vnic = 
          'desired':
            'macaddr': null
            'switch': null
            'index': null
          'addresses': []
        initializeVnicModal()

      $scope.editVnic = (vnic) ->
        $scope.vnicEditModal.show()
        $scope.vnic = vnic
        TenantInstanceVnicAddress.list
          tenant: $routeParams.tenant
          instance: $routeParams.instance
          vnic: vnic.desired.uuid
        .$promise.then (addresses) ->
          $scope.vnic.addresses = addresses
        initializeVnicModal()

      $scope.vnicEditClose = () ->
        $scope.vnicEditModal.hide()

      $scope.addAddress = (networkUUID) ->
        # Default value
        unless networkUUID
          networkUUID = $scope.vnic.networks[0].desired.uuid

        $scope.vnic.addresses.push
          'desired':
            'ip': '',
            'ptr':'',
            'network': networkUUID
            'vnic': $scope.vnic.desired.uuid

      $scope.removeAddress = (address) ->
        if address.desired.uuid
          address.toDelete = true
        else
          $scope.vnic.addresses = $scope.vnic.addresses.filter(
            (item) ->
              item.$$hashKey != address.$$hashKey
          )

      $scope.renewNetworks = (switchUUID) ->
        TenantSwitchNetwork.list
          tenant: $routeParams.tenant
          switch: switchUUID
        .$promise.then((networks) ->
          $scope.vnic.networks = networks
        )

      $scope.renewAddresses = (networkUUID) ->
        for address in $scope.vnic.addresses
          address.desired.network = networkUUID

        # Add one address if there is none
        if $scope.vnic.addresses.length == 0
          $scope.addAddress networkUUID

      $scope.vnicEditSave = () ->
        params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance, 'vnic': $scope.vnic.desired.uuid}
        # vNIC
        if $scope.vnic.desired.uuid
          patch = JSON.stringify([{'op': 'x-merge', 'path': '/desired', 'value':
            'macaddr': $scope.vnic.desired.macaddr,
            'switch': $scope.vnic.desired.switch
          }])
          TenantInstanceVnic.patch(params, patch, (response) ->
            processAddresses(params)
          )
        else
          delete params.vnic
          unless $scope.vnic.desired.macaddr
            delete $scope.vnic.desired.macaddr

          vnic = new TenantInstanceVnic()
          vnic.desired = $scope.vnic.desired
          vnic.$save(params, (response) ->
            $scope.vnic.desired.uuid = response.uuids.POST
            params.vnic = response.uuids.POST
            processAddresses(params)
          )

        $scope.vnicEditClose()

      # Function for updating addresses in a vNIC
      processAddresses = (params) ->
        # Addresses are created, modified and destroyed
        # using a JSON-patch
        addr_patch = []
        i = 0
        for address in $scope.vnic.addresses
          unless address.desired.ip
            delete address.desired.ip
          if address.toDelete and address.desired.uuid
            # Delete
            addr_patch.push({'op': 'remove', 'path': '/'+address.desired.uuid})
          else if address.desired.uuid
            # Modify
            addr_patch.push({'op': 'x-merge', 'path': '/'+address.desired.uuid+'/desired', 'value':
              'ip': address.desired.ip
              'ptr': address.desired.ptr
              'network': address.desired.network
            })
          else
            # Add addresses
            addr_patch.push({
              'op': 'add',
              'path': '/addr' + i++,
              'value':{
                'desired': address.desired
              }
            })

        if addr_patch
          TenantInstanceVnicAddress.patch(params, addr_patch)


      # Delete vNICs
      $scope.deleteSelectedVnics = (items) ->
        patch = []
        params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantInstanceVnic.patch(params, patch)


      # vDisks

      TenantInstanceVdisk.list {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
      .$promise.then (vdisks) ->
        $scope.vdisks = vdisks
        dataContainer.registerEntity 'vdisk', $scope.vdisks

        $scope.$watchCollection 'vdisks', (newVals, oldVals) ->
          for item in newVals
            if jQuery.inArray(item, oldVals) < 0 or newVals.length != oldVals.length
              refreshVdiskDict($scope.filteredVolumes)

      TenantVolume.list {'tenant': $routeParams.tenant}
      .$promise.then (VolumeList) ->
        $scope.volumes = VolumeList
        dataContainer.registerEntity 'volume', $scope.volumes

        # Filter out images
        $scope.$watchCollection 'volumes', (newVals, oldVals) ->
          $scope.filteredVolumes = []

          # We need to know if volume has any other vdisks
          # beside this instance
          for volume in newVals
            unless volume.desired.image
              $scope.filteredVolumes.push volume

          refreshVdiskDict($scope.filteredVolumes)

          $scope.volumeDict = {}
          for volume in newVals
            $scope.volumeDict[volume.desired.uuid] = volume


      # Update index of vDisks when resorted
      $scope.sortVdisks = {
        stop: (e, ui) ->
          i = 0
          patch = []
          params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}

          for vdisk in $scope.vdisks
            patch.push({'op': 'x-merge', 'path': '/'+vdisk.desired.uuid+'/desired/index', 'value': i++ })
          TenantInstanceVdisk.patch(params, patch)
      }

      $scope.vdiskListClose = () ->
        $scope.vdiskListModal.hide()

      $scope.vdiskListOpen = () ->
        $scope.vdiskListModal.show()

      refreshVdiskDict = (volumes) ->
        unless $scope.vdiskDict
          $scope.vdiskDict = {}
        unless volumes
          return
        for volume in volumes
          uuid = volume.desired.uuid
          do (uuid) ->
            TenantVolumeVdisk.list {'tenant': $routeParams.tenant, 'volume': uuid}
            .$promise.then (vdisks) ->
              $scope.vdiskDict[uuid] =
                vdisks: vdisks
                used_here: false
              do (vdisks) ->
                for vdisk in vdisks
                  if vdisk.desired.instance == $routeParams.instance
                    $scope.vdiskDict[uuid].used_here = true

        # Filtering for vDisks/volumes
        $scope.volumeFilter = (actual, expected) ->
          regex = new RegExp("^"+expected, 'i')
          nameTest = regex.test $scope.volumeDict[actual].desired.name
          sizeTest = regex.test $scope.volumeDict[actual].desired.size
          nameTest || sizeTest


      $scope.createVdisk = (volume) ->
        newVdisk = new TenantInstanceVdisk()
        newVdisk.desired = {
          'volume': volume.desired.uuid
          'name': volume.desired.name
        }

        newVdisk.$save({'tenant': $routeParams.tenant, 'instance': $routeParams.instance}, (response) ->
          #$scope.message("Volume created", 'success')
        )

      # Delete vDisks
      $scope.deleteSelectedVdisks = (items) ->
        patch = []
        params = {'tenant': $routeParams.tenant, 'instance': $routeParams.instance}
        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantInstanceVdisk.patch(params, patch)



module.controller 'InstanceWizardCtrl',
  class InstanceWizardCtrl
    @$inject = ['$scope', '$routeParams', '$modal', 'TenantInstance', 'TenantSwitchNetwork',
                'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantSwitch', 'Tenant',
                'TenantInstanceVnicAddress', 'TenantVolume', 'StoragePool', 
                'CpuProfile', 'TenantAffinityGroup', 'TenantImage', 'Image', 'dataContainer']

    constructor: ($scope, $routeParams, $modal, TenantInstance, TenantSwitchNetwork, TenantInstanceVdisk,
                  TenantInstanceVnic, TenantSwitch, Tenant, TenantInstanceVnicAddress, TenantVolume,
                  StoragePool, CpuProfile, TenantAffinityGroup, TenantImage, Image, dataContainer) ->

      # Variable that should contain all information
      # about instance accross the creation wizard
      $scope.instance =
        uuid: '%instance_uuid%'
        selectedVolumes: []
        vdisks: []
        vnics: []
        boot: 'disk'
        ns: [{'value': ''}]
        state: 'running'

      # List of volumes without image
      TenantVolume.list({'tenant': $routeParams.tenant}).$promise.then (VolumeList) ->
        $scope.volumes = VolumeList
        dataContainer.registerEntity 'volume', $scope.volumes

        $scope.$watchCollection 'volumes', (newVals, oldVals) ->
          $scope.filteredVolumes = $scope.volumes.filter(
            (item) ->
              item unless item.desired.image
          )

      $scope.$watch 'volume.base_image', (value) ->
          setDefaultVolumeSize(value)

      $scope.$watch 'volume.initialize', (value) ->
       if !value
          $scope.volume.size = null
          $scope.volume.base_image = null
        else
          $scope.volume.base_image = $scope.images[0].desired.uuid
          setDefaultVolumeSize($scope.volume.base_image)


      StoragePool.list()
      .$promise.then (items) ->
        $scope.storagepools = items
        dataContainer.registerEntity 'storage_pool', $scope.storagepools

      Image.list().$promise.then (ImageList) ->
        $scope.globalImages = ImageList
        dataContainer.registerEntity 'image', $scope.images

      TenantImage.list({'tenant': $routeParams.tenant}).$promise.then (ImageList) ->
        $scope.images = ImageList
        dataContainer.registerEntity 'image', $scope.images

        $scope.$watchCollection 'images', (newVal, oldVal) ->
          # ImageDict is a simple dict keyed by storage pools that is used
          # for peeking in which storage pools a particular image
          # is available.
          unless $scope.imageDict
            $scope.imageDict = {}

          unless $scope.imageSize
            $scope.imageSize = {}

          for volume in $scope.volumes
            for image in newVal
              if volume.desired.image
                unless $scope.imageDict[volume.desired.storage_pool]
                  $scope.imageDict[volume.desired.storage_pool] = []
                $scope.imageDict[volume.desired.storage_pool].push(volume.desired.image)

                # Get the size
                $scope.imageSize[volume.desired.image] = volume.desired.size

      setDefaultVolumeSize = (image) ->
        unless $scope.volume.size == 0
          unless !$scope.volume.initialize
            $scope.volume.size = $scope.imageSize[image]

      $scope.addNameserver = () ->
        $scope.instance.ns.push {'value':''}

      $scope.removeNameserver = (ns) ->
        $scope.instance.ns = $scope.instance.ns.filter(
          (item) ->
            item.$$hashKey != ns.$$hashKey
        )

      $scope.getFilteredImages = (storage_pool) ->
        # TODO filter globalImages for available
        rval = []
        for image in $scope.images
          if image.desired.uuid in $scope.imageDict[storage_pool]
            rval.push image
        return rval.concat $scope.globalImages

      CpuProfile.list()
      .$promise.then (items) ->
        $scope.cpu_profiles = items
        $scope.instance.cpu_profile = items[0].desired.uuid
        dataContainer.registerEntity 'cpu_profile', $scope.cpu_profiles

      TenantSwitch.list
        tenant: $routeParams.tenant
      .$promise.then (ts) ->
        $scope.switches = ts
        $scope.instance.vnics[0].switch = ts[0].desired.uuid
        dataContainer.registerEntity 'switch', $scope.switches

      $scope.wizardVdiskListModal = $modal
        keyboard: true
        scope: $scope
        template: 'tenant/instance/wizard-vdisk-list-modal.tpl.html'
        show: false

      $scope.wizardVdiskListClose = () ->
        $scope.wizardVdiskListModal.hide()

      # Iterator used for assinging placeholders
      # for volumes which are created in-place
      $scope.volumeIterator = 0
      $scope.wizardVdiskListOpen = () ->
        $scope.volume = {}
        $scope.wizardVdiskListModal.show()

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
        defSwitch = null
        if $scope.switches
          defSwitch = $scope.switches[0].desired.uuid
        c = $scope.instance.vnics.push {'switch': defSwitch, 'addresses': []}
        $scope.$watch 'instance.vnics['+(c-1)+'].switch', (value) ->
          $scope.renewNetworks value, c-1

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
            'ip': null,
            'ptr': null,
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
          $scope.renewAddresses networks[0].desired.uuid,index
        )

      $scope.appendVolume = (desired) ->
        volume =
          desired: desired
          current: {}
        volume.desired.state = 'present'
        volume.to_create = true

        $scope.volumeIterator++
        volume.desired.uuid = '%volume-'+$scope.volumeIterator+'_uuid%'

        $scope.assignVolume volume
        $scope.wizardVdiskListClose()

      $scope.assignVolume = (volume) ->
        volume.selected = true

        $scope.instance['vdisks'].push
          'desired':
            'volume': volume.desired.uuid,
            'instance': $scope.instance.uuid,
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

      $scope.createInstance = () ->
        params = {'tenant': $routeParams.tenant}

        patch = []
        volumes = {}
        vdisks = {}
        for vdisk in $scope.instance.vdisks
          if vdisk.volume.to_create
            volumes[vdisk.volume.desired.uuid] =
                desired: vdisk.volume.desired

          vdisks[vdisk.$$hashKey] =
            desired: vdisk.desired

        vnics = {}
        for vnic in $scope.instance.vnics
          addresses = {}
          for address in vnic.addresses
            addresses[address.$$hashKey] =
              desired: address.desired

          vnics[vnic.$$hashKey] =
            desired:
              switch: vnic.switch
              index: vnic.index
              uuid: vnic.$$hashKey
            children:
              address: addresses

        instancePatch =
          op: 'x-merge'
          path: '/'
          value:
            children:
              instance: {}
              volume: volumes

        ns = []
        for item in $scope.instance.ns
          ns.push item.value
        console.log ns

        instancePatch['value']['children']['instance'][$scope.instance.uuid] =
          desired:
            name:  $scope.instance.name
            vcpu:  $scope.instance.vcpu
            rcpu:  $scope.instance.rcpu
            mem:   $scope.instance.mem
            boot:  $scope.instance.boot
            state: $scope.instance.state
            ns:    ["10.0.1.1"]
            cpu_profile: $scope.instance.cpu_profile
          children:
            vdisk: vdisks
            vnic: vnics

        patch.push instancePatch

        Tenant.patch(params, patch)

