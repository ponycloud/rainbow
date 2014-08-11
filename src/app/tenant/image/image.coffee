module = angular.module 'tenantImage', ['rainbowServices']

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
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantImage', 'StoragePool', 'TenantVolume', 'dataContainer', '$modal', '$location']

    constructor: ($scope, $rootScope, $routeParams, TenantImage, StoragePool, TenantVolume, dataContainer, $modal, @$location) ->
      # Simple list of images
      TenantImage.list({'tenant': $routeParams.tenant}).$promise.then((ImageList) ->
        $scope.images = ImageList
        dataContainer.registerEntity('image', $scope.images)
      )
      # List of storagepools (for the purpose of the modal)
      # TODO Could be created on demand
      StoragePool.list().$promise.then((StoragePoolList) ->
        $scope.storagepools = StoragePoolList
        dataContainer.registerEntity('storage_pool', $scope.storagepools)
      )
      $scope.filterStatus = (actual, expected) ->
        expected = expected.toLowerCase()
        if actual? and 'initializing'.search(expected) > -1
          return true
        if !actual? and 'ready'.search(expected) > -1
          return true
        return false

      $scope.$location = $location

     # Modal initialization
      $scope.imageModal = $modal({scope: $scope, template: 'tenant/image/image-modal.tpl.html', show: false})

      $scope.open = () ->
        $scope.image = {'storagepools': {}}
        $scope.imageModal.show()

      $scope.close = () ->
        $scope.imageModal.hide()
        false

      # Get data from the $scope.image
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

      # Plain and simple delete
      $scope.deleteImage = (uuid) ->
        params = {'tenant': $routeParams.tenant, 'image': uuid}

        TenantImage.delete(params, () ->
          $scope.images = $scope.images.filter(
            (item) ->
              item.desired.uuid != uuid
          )
          $scope.message("Image deleted", 'success')
        )

      $scope.deleteSelected = (items) ->
        for item in items
          $scope.deleteImage item


module.controller 'ImageDetailCtrl',
  class ImageDetailCtrl
    @inject =
      ['$scope', '$rootScope', '$routeParams', 'TenantImage',
       'TenantImageVolume', 'TenantVolume', 'StoragePool', 'dataContainer', '$modal']

    constructor: ($scope, $routeParams, TenantImage, TenantImageVolume, TenantVolume, StoragePool, dataContainer, $modal, $route) ->
      criteria = {'tenant': $routeParams.tenant, 'image': $routeParams.image}
      TenantImage.get(criteria).$promise.then((image) ->
        $scope.image = image
        dataContainer.registerResource $scope.image, $scope.image.desired.uuid
      )

      TenantVolume.list({'tenant': $routeParams.tenant}).$promise.then((volumes) ->
        $scope.volumes = volumes
        dataContainer.registerEntity 'volume', $scope.volumes
      )

      $scope.storagepools = {}

      $scope.imageEditModal = $modal({scope: $scope, template: 'tenant/image/image-edit-modal.tpl.html', show: false})
      $scope.volumeListModal = $modal({scope: $scope, template: 'tenant/image/volume-list-modal.tpl.html', show: false})

      StoragePool.list().$promise.then((StoragePoolList) ->
        $scope.splist = StoragePoolList
        dataContainer.registerEntity 'storagepool', $scope.storagepools

        TenantImageVolume.list(criteria).$promise.then((TenantImageList) ->
          $scope.backVolumes = TenantImageList
          dataContainer.registerEntity 'volume', $scope.backVolumes
       )
      )

      $scope.$watch 'backVolumes', (value) ->
        $scope.refreshVolumes()
      , true


      $scope.refreshVolumes = () ->
        unless $scope.splist
          return

        # Create a 'dict' of storagepools where keys are desired.uuids
        $scope.storagepools = {}
        $scope.storagepools[storagepool.desired.uuid] = storagepool for storagepool in $scope.splist
        for key of $scope.storagepools
          $scope.storagepools[key].volumes = []
          $scope.storagepools[key].used = false
          $scope.storagepools[key].used_space = 0

        for volume in $scope.backVolumes
          $scope.storagepools[volume.desired.storage_pool].used = true

          unless volume in $scope.storagepools[volume.desired.storage_pool].volumes
            $scope.storagepools[volume.desired.storage_pool].volumes.push volume
            $scope.storagepools[volume.desired.storage_pool].used_space += volume.desired.size

          $scope.imageSize = volume.desired.size
          $scope.image.size = $scope.imageSize


      # Open modal dialog with image details
      $scope.open = () ->
        $scope.volumes = $scope.volumes.filter(
          (item) ->
            item unless item.desired.image or item.desired.image is $routeParams.image
        )
        $scope.imageEditModal.show()

      # Close modal dialog with image details
      $scope.close = (reload=true) ->
        $scope.imageEditModal.hide()
        if reload
            $route.reload()
        false

      $scope.volumeListOpen = () ->
        # Display the modal with volumes
        $scope.volumeListModal.show()

      $scope.volumeListClose = () ->
        $scope.volumeListModal.hide()
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
        newVolume.$save({'tenant': $routeParams.tenant})

      $scope.deallocate = (storagepool) ->
        for volume in storagepool.volumes
          params = {'tenant': $routeParams.tenant, 'volume': volume.desired.uuid }
          TenantVolume.delete(params, () ->
          )

      $scope.unlink = (volume) ->
        patch = JSON.stringify([
          {'op': 'x-merge', 'path': '/desired', 'value': {
            'image': null
          } }
        ])

        params = {'tenant': $routeParams.tenant, 'volume': volume.desired.uuid}
        TenantVolume.patch(params, patch, () ->
          $scope.backVolumes.splice $scope.backVolumes.indexOf(volume), 1
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
          $scope.close(false)
        )
