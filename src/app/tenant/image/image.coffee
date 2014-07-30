module = angular.module 'tenant-image', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/image', {
    templateUrl: 'tenant/image/image-list.tpl.html',
    controller: 'ImageListCtrl'
  }
  $routeProvider.when '/:tenant/image/:image', {
    templateUrl: 'tenant/image/image-detail.tpl.html',
    controller: 'ImageDetailCtrl'
  }
]

module.controller 'ImageListCtrl',
  class ImageListCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantImage', 'StoragePool', 'TenantVolume', 'dataContainer']

    constructor: ($scope, $rootScope, $routeParams, TenantImage, StoragePool, TenantVolume, dataContainer) ->
      TenantImage.list({'tenant': $routeParams.tenant}).$promise.then((ImageList) ->
        $scope.images = ImageList
        dataContainer.registerEntity('image', $scope.images)
      )

      StoragePool.list().$promise.then((StoragePoolList) ->
        $scope.storagepools = StoragePoolList
        dataContainer.registerEntity('storagepools', $scope.storagepools)
      )

      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      }

      $scope.open = () ->
        $scope.image = {'storagepools': {}}
        $scope.imageModal = true

      $scope.close = () ->
        $scope.imageModal = false
        false

      $scope.createImage = () ->
        newImage = new TenantImage()
        newImage.desired = {
          'name': $scope.image.name,
          'type': $scope.image.type,
          'description': $scope.image.description,
          'source_uri': $scope.image.source_uri
        }

        newImage.$save({'tenant': $routeParams.tenant}, (response) ->
          # Construct data to push to the list.
          $scope.images.push({'desired': {
            'uuid': response.uuids.POST,
            'name': $scope.image.name,
            'type': $scope.image.type
          }})

          for storagepool of $scope.image.storagepools
            # Create a backing volume for each selected storagepool
            if $scope.image.storagepools[storagepool]
              newVolume = new TenantVolume()
              newVolume.desired = {
                  'name': 'Image - "'+$scope.image.name+'"',
                  'state': 'present',
                  'size': $scope.image.size,
                  'storage_pool': storagepool,
                  'image': response.uuids.POST
              }
              newVolume.$save({'tenant': $routeParams.tenant}, (response) ->
                  $scope.close()
              )
          #$scope.message("Image created", 'success')
        )

      $scope.deleteImage = (image, index) ->
        position = $scope.images.indexOf(image)
        params = {'tenant': $routeParams.tenant, 'image': image.desired.uuid}

        TenantImage.delete(params, () ->
          $scope.images.splice(position, 1)
          $scope.message("Image deleted", 'success')
        )


module.controller 'ImageDetailCtrl',
  class ImageDetailCtrl
    @inject =
      ['$scope', '$rootScope', '$routeParams', 'TenantImage',
       'TenantImageVolume', 'TenantVolume', 'StoragePool', 'dataContainer']

    constructor: ($scope, $routeParams, TenantImage, TenantImageVolume, TenantVolume, StoragePool, dataContainer) ->
      criteria = {'tenant': $routeParams.tenant, 'image': $routeParams.image}
      $scope.image = TenantImage.get(criteria)
      $scope.volumes = TenantVolume.list({'tenant': $routeParams.tenant})
      $scope.storagepools = {}

      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      }

      StoragePool.list().$promise.then((StoragePoolList) ->
        storagepools = StoragePoolList
        dataContainer.registerEntity('storagepools', $scope.storagepools)
        # Create a 'dict' of storagepools
        $scope.storagepools[storagepool.desired.uuid] = storagepool for storagepool in storagepools

        TenantImageVolume.list(criteria).$promise.then((TenantImageList) ->
          $scope.back_volumes = TenantImageList
          for volume in $scope.back_volumes
            if volume.desired.storage_pool of $scope.storagepools
              # Determine if the storagepool is used
              $scope.storagepools[volume.desired.storage_pool].used = true

              # Create an array of volumes for each storagepool
              if !$scope.storagepools[volume.desired.storage_pool].volumes
                $scope.storagepools[volume.desired.storage_pool].volumes = []
                $scope.storagepools[volume.desired.storage_pool].used_space = 0
              $scope.storagepools[volume.desired.storage_pool].volumes.push volume
              $scope.storagepools[volume.desired.storage_pool].used_space += volume.desired.size

              $scope.image.size = volume.desired.size

            else
              $scope.storagepools[volume.desired.storage_pool].used = false
        )
      )

      # Open modal dialog with image details
      $scope.open = () ->
        $scope.volumes = $scope.volumes.filter(
          (item) ->
            if !item.desired.image || item.desired.image == $routeParams.image
              item
        )
        $scope.imageModal = true

      # Close modal dialog with image details
      $scope.close = () ->
        $scope.imageModal = false
        false

      $scope.volume_list_open = () ->
        # Filter volumes that are backing another image
        # Display the modal with volumes
        $scope.volumeListModal = true

      $scope.volume_list_close = () ->
        $scope.volumeListModal = false
        false

      $scope.allocate = (storagepool, size) ->
        desired = {
            'name': 'Image - "'+$scope.image.desired.name+'"',
            'state': 'present',
            'size': size,
            'storage_pool': storagepool.desired.uuid,
            'image': $scope.image.desired.uuid
        }
        newVolume = new TenantVolume()
        newVolume.desired = desired

        newVolume.$save({'tenant': $routeParams.tenant}, (response) ->
            # Add assigned uuid to desired
            desired.uuid = response.uuids.POST
            # Update model
            pool = $scope.storagepools[storagepool.desired.uuid]
            if !pool.volumes
                pool.used_space = 0
                pool.volumes = []
            pool.used = true
            pool.used_space += desired.size
            pool.volumes.push {desired}
            # Update back_volumes
            $scope.back_volumes.push {desired}
        )

      # Utility function to clean a volume from various places
      remove_volume = (volume) ->
        # Remove from storagepools listing
        $scope.storagepools[volume.desired.storage_pool].used_space -= volume.desired.size
        $scope.storagepools[volume.desired.storage_pool].used = false
        $scope.storagepools[volume.desired.storage_pool].volumes = []
        # Remove from backing volumes
        $scope.back_volumes = $scope.back_volumes.filter(
          (item) ->
            item.desired.uuid != volume.desired.uuid
        )


      $scope.deallocate = (storagepool) ->
        for volume in storagepool.volumes
          params = {'tenant': $routeParams.tenant, 'volume': volume.desired.uuid }
          TenantVolume.delete(params, () ->
            remove_volume(volume)
          )

      $scope.unlink = (volume) ->
        patch = JSON.stringify([
          {'op': 'x-merge', 'path': '/desired', 'value': {
            'image': null
          } }
        ])

        params = {'tenant': $routeParams.tenant, 'volume': volume.desired.uuid}
        TenantVolume.patch(params, patch, () ->
          remove_volume(volume)
        )

      # Edit the details of image
      $scope.editImage = () ->
        patch = JSON.stringify([
          {'op': 'x-merge', 'path': '/desired', 'value': {
            'name': $scope.image.desired.name,
            'description': $scope.image.desired.description,
            'type': $scope.image.desired.type,
            'source_uri': $scope.image.desired.source_uri
          } }
        ])
        params = {'tenant': $routeParams.tenant, 'image': $routeParams.image}
        TenantImage.patch(params, patch, () ->
          #$scope.message("Image modified", 'success')
          $scope.close()
        )
