module = angular.module 'tenantVolume', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/volume', {
    templateUrl: 'tenant/volume/volume-list.tpl.html',
    controller: 'VolumeListCtrl'
  }
  $routeProvider.when '/:tenant/volume/:volume', {
    templateUrl: 'tenant/volume/volume-detail.tpl.html',
    controller: 'VolumeDetailCtrl'
  }
]

module.controller 'VolumeListCtrl',
  class VolumeListCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantVolume', 'StoragePool', 'TenantImage', 'Image', 'ImageVolume', 'dataContainer', '$modal']

    constructor: ($scope, $rootScope, $routeParams, TenantVolume, StoragePool, TenantImage, Image, ImageVolume, dataContainer, $modal) ->

      # Simple list of volumes
      TenantVolume.list({'tenant': $routeParams.tenant}).$promise.then (VolumeList) ->
        $scope.volumes = VolumeList
        dataContainer.registerEntity('volume', $scope.volumes)

        $scope.$watchCollection 'volumes', (newVal, oldVal) ->
          $scope.filteredVolumes = newVal.filter(
            (item) ->
              item unless item.desired.image
          )

      $scope.$watch 'volume.base_image', (value) ->
        setDefaultVolumeSize(value)

      $scope.$watch 'volume.initialize', (value) ->
        if !value
          $scope.volume.size = null
        else
          setDefaultVolumeSize($scope.volume.base_image)

      StoragePool.list().$promise.then (StoragePoolList) ->
        $scope.storagepools = StoragePoolList
        dataContainer.registerEntity 'storagepool', $scope.storagepools

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
          $scope.volume.size = $scope.imageSize[image]

      $scope.getFilteredImages = (storage_pool) ->
        # TODO filter globalImages for available
        rval = []
        for image in $scope.images
          if image.desired.uuid in $scope.imageDict[storage_pool]
            rval.push image
        return rval.concat $scope.globalImages

      $scope.filterType = (actual, expected) ->
        expected = expected.toLowerCase()
        if actual? and 'image'.search(expected) > -1
          return true
        if !actual? and 'volume'.search(expected) > -1
          return true
        return false

      # Modal initialization
      $scope.volumeModal = $modal({scope: $scope, template: 'tenant/volume/volume-modal.tpl.html', show: false})

      $scope.open = () ->
        $scope.volume = 
          storagepools: {}
          desired: {}
        $scope.volumeModal.show()

      $scope.close = () ->
        $scope.volumeModal.hide()
        false

      # Get data from the $scope.volume
      $scope.createVolume = () ->
        newVolume = new TenantVolume()
        newVolume.desired = {
          'name': $scope.volume.name,
          'state': 'present',
          'size': $scope.volume.size,
          'storage_pool': $scope.volume.storagepool,
        }

        if $scope.volume.initialize
          newVolume.desired.base_image = $scope.volume.base_image

        newVolume.$save({'tenant': $routeParams.tenant}, (response) ->
          $scope.close()
          #$scope.message("Volume created", 'success')
        )

      # Plain and simple delete
      $scope.deleteVolume = (uuid) ->
        params = {'tenant': $routeParams.tenant, 'volume': uuid}

        TenantVolume.delete(params, () ->
          $scope.message("Volume deleted", 'success')
        )

      $scope.deleteSelected = (items) ->
        for item in items
          $scope.deleteVolume item


module.controller 'VolumeDetailCtrl',
  class VolumeDetailCtrl
    @inject =
      ['$scope', '$rootScope', '$routeParams', 'TenantVolume',
       'TenantVolumeVdisk', 'TenantInstance', 'dataContainer', '$modal']

    constructor: ($scope, $routeParams, TenantVolume, TenantVolumeVdisk, TenantInstance, dataContainer, $modal, $route) ->
      criteria = {'tenant': $routeParams.tenant, 'volume': $routeParams.volume}

      TenantVolume.get criteria
      .$promise.then (volume) ->
        $scope.volume = volume
        dataContainer.registerResource $scope.volume, $scope.volume.desired.uuid

      TenantVolumeVdisk.list {'tenant': $routeParams.tenant, 'volume': $routeParams.volume}
      .$promise.then (vdisks) ->
        $scope.vdisks = vdisks
        dataContainer.registerEntity 'vdisk', $scope.vdisks

        $scope.$watch 'vdisks', (value) ->
          $scope.filteredVdisks = $scope.vdisks.filter(
            (item) ->
              item if item.desired.volume == $routeParams.volume
          )
        , true

      TenantInstance.list {'tenant': $routeParams.tenant}
      .$promise.then (instances) ->
        $scope.instances = instances
        dataContainer.registerEntity 'instance', $scope.instance

        $scope.$watch 'instances', (value) ->
          $scope.instanceDict = {}
          for instance in value
            $scope.instanceDict[instance.desired.uuid] = instance

      $scope.volumeEditModal = $modal({scope: $scope, template: 'tenant/volume/volume-edit-modal.tpl.html', show: false})

      # Open modal dialog with volume details
      $scope.open = () ->
       $scope.volumeEditModal.show()

      # Close modal dialog with volume details
      $scope.close = () ->
        $scope.volumeEditModal.hide()
        false

      $scope.unlink = (volume) ->
        patch = JSON.stringify([
          {'op': 'x-merge', 'path': '/desired', 'value': {
            'volume': null
          } }
        ])

        params = {'tenant': $routeParams.tenant, 'volume': volume.desired.uuid}
        TenantVolume.patch(params, patch, () ->
          $scope.backVolumes.splice $scope.backVolumes.indexOf(volume), 1
        )

      # Edit the details of volume
      $scope.editVolume = () ->
        patch = JSON.stringify([
          {'op': 'x-merge', 'path': '/desired', 'value': {
            'name': $scope.volume.desired.name,
            'size': $scope.volume.desired.size
          } }
        ])
        params = {'tenant': $routeParams.tenant, 'volume': $routeParams.volume}
        TenantVolume.patch(params, patch, () ->
          #$scope.message("Volume modified", 'success')
          $scope.close()
        )
