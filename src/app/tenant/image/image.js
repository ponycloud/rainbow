// Generated by CoffeeScript 1.7.1
(function() {
  var ImageDetailCtrl, ImageListCtrl, module;

  module = angular.module('tenantImage', ['rainbowServices']);

  module.config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/:tenant/image', {
        templateUrl: 'tenant/image/image-list.tpl.html',
        controller: 'ImageListCtrl'
      });
      return $routeProvider.when('/:tenant/image/:image', {
        templateUrl: 'tenant/image/image-detail.tpl.html',
        controller: 'ImageDetailCtrl'
      });
    }
  ]);

  module.controller('ImageListCtrl', ImageListCtrl = (function() {
    ImageListCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantImage', 'StoragePool', 'TenantVolume', 'dataContainer', '$modal'];

    function ImageListCtrl($scope, $rootScope, $routeParams, TenantImage, StoragePool, TenantVolume, dataContainer, $modal) {
      TenantImage.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(ImageList) {
        $scope.images = ImageList;
        return dataContainer.registerEntity('image', $scope.images);
      });
      $scope.imageModal = $modal({
        scope: $scope,
        template: 'tenant/image/image-modal.tpl.html',
        show: false
      });
      StoragePool.list().$promise.then(function(StoragePoolList) {
        $scope.storagepools = StoragePoolList;
        return dataContainer.registerEntity('storagepools', $scope.storagepools);
      });
      $scope.open = function() {
        $scope.image = {
          'storagepools': {}
        };
        return $scope.imageModal.show();
      };
      $scope.close = function() {
        $scope.imageModal.hide();
        return false;
      };
      $scope.createImage = function() {
        var newImage;
        console.log($scope.image);
        newImage = new TenantImage();
        newImage.desired = {
          'name': $scope.image.name,
          'type': $scope.image.type,
          'description': $scope.image.description,
          'source_uri': $scope.image.source_uri
        };
        return newImage.$save({
          'tenant': $routeParams.tenant
        }, function(response) {
          var newVolume, storagepool, _results;
          $scope.images.push({
            'desired': {
              'uuid': response.uuids.POST,
              'name': $scope.image.name,
              'type': $scope.image.type
            }
          });
          _results = [];
          for (storagepool in $scope.image.storagepools) {
            if ($scope.image.storagepools[storagepool]) {
              newVolume = new TenantVolume();
              newVolume.desired = {
                'name': 'Image - "' + $scope.image.name + '"',
                'state': 'present',
                'size': $scope.image.size,
                'storage_pool': storagepool,
                'image': response.uuids.POST
              };
              _results.push(newVolume.$save({
                'tenant': $routeParams.tenant
              }, function(response) {
                return $scope.close();
              }));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        });
      };
      $scope.deleteImage = function(image, index) {
        var params, position;
        position = $scope.images.indexOf(image);
        params = {
          'tenant': $routeParams.tenant,
          'image': image.desired.uuid
        };
        return TenantImage["delete"](params, function() {
          $scope.images.splice(position, 1);
          return $scope.message("Image deleted", 'success');
        });
      };
    }

    return ImageListCtrl;

  })());

  module.controller('ImageDetailCtrl', ImageDetailCtrl = (function() {
    ImageDetailCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantImage', 'TenantImageVolume', 'TenantVolume', 'StoragePool', 'dataContainer', '$modal'];

    function ImageDetailCtrl($scope, $routeParams, TenantImage, TenantImageVolume, TenantVolume, StoragePool, dataContainer, $modal) {
      var criteria, remove_volume;
      criteria = {
        'tenant': $routeParams.tenant,
        'image': $routeParams.image
      };
      $scope.image = TenantImage.get(criteria);
      $scope.volumes = TenantVolume.list({
        'tenant': $routeParams.tenant
      });
      $scope.storagepools = {};
      $scope.imageEditModal = $modal({
        scope: $scope,
        template: 'tenant/image/image-edit-modal.tpl.html',
        show: false
      });
      $scope.volumeListModal = $modal({
        scope: $scope,
        template: 'tenant/image/volume-list-modal.tpl.html',
        show: false
      });
      StoragePool.list().$promise.then(function(StoragePoolList) {
        var storagepool, storagepools, _i, _len;
        storagepools = StoragePoolList;
        dataContainer.registerEntity('storagepools', $scope.storagepools);
        for (_i = 0, _len = storagepools.length; _i < _len; _i++) {
          storagepool = storagepools[_i];
          $scope.storagepools[storagepool.desired.uuid] = storagepool;
        }
        return TenantImageVolume.list(criteria).$promise.then(function(TenantImageList) {
          var volume, _j, _len1, _ref, _results;
          $scope.backVolumes = TenantImageList;
          _ref = $scope.backVolumes;
          _results = [];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            volume = _ref[_j];
            if (volume.desired.storage_pool in $scope.storagepools) {
              $scope.storagepools[volume.desired.storage_pool].used = true;
              if (!$scope.storagepools[volume.desired.storage_pool].volumes) {
                $scope.storagepools[volume.desired.storage_pool].volumes = [];
                $scope.storagepools[volume.desired.storage_pool].used_space = 0;
              }
              $scope.storagepools[volume.desired.storage_pool].volumes.push(volume);
              $scope.storagepools[volume.desired.storage_pool].used_space += volume.desired.size;
              _results.push($scope.image.size = volume.desired.size);
            } else {
              _results.push($scope.storagepools[volume.desired.storage_pool].used = false);
            }
          }
          return _results;
        });
      });
      $scope.open = function() {
        $scope.volumes = $scope.volumes.filter(function(item) {
          if (!item.desired.image || item.desired.image === $routeParams.image) {
            return item;
          }
        });
        return $scope.imageEditModal.show();
      };
      $scope.close = function() {
        $scope.imageEditModal.hide();
        return false;
      };
      $scope.volumeListOpen = function() {
        return $scope.volumeListModal.show();
      };
      $scope.volumeListClose = function() {
        $scope.volumeListModal.hide();
        return false;
      };
      $scope.allocate = function(storagepool, size) {
        var desired, newVolume;
        desired = {
          'name': 'Image - "' + $scope.image.desired.name + '"',
          'state': 'present',
          'size': size,
          'storage_pool': storagepool.desired.uuid,
          'image': $scope.image.desired.uuid
        };
        newVolume = new TenantVolume();
        newVolume.desired = desired;
        return newVolume.$save({
          'tenant': $routeParams.tenant
        }, function(response) {
          var pool;
          desired.uuid = response.uuids.POST;
          pool = $scope.storagepools[storagepool.desired.uuid];
          if (!pool.volumes) {
            pool.used_space = 0;
            pool.volumes = [];
          }
          pool.used = true;
          pool.used_space += desired.size;
          pool.volumes.push({
            desired: desired
          });
          return $scope.backVolumes.push({
            desired: desired
          });
        });
      };
      remove_volume = function(volume) {
        $scope.storagepools[volume.desired.storage_pool].used_space -= volume.desired.size;
        $scope.storagepools[volume.desired.storage_pool].used = false;
        $scope.storagepools[volume.desired.storage_pool].volumes = [];
        return $scope.backVolumes = $scope.backVolumes.filter(function(item) {
          return item.desired.uuid !== volume.desired.uuid;
        });
      };
      $scope.deallocate = function(storagepool) {
        var params, volume, _i, _len, _ref, _results;
        _ref = storagepool.volumes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          volume = _ref[_i];
          params = {
            'tenant': $routeParams.tenant,
            'volume': volume.desired.uuid
          };
          _results.push(TenantVolume["delete"](params, function() {
            return remove_volume(volume);
          }));
        }
        return _results;
      };
      $scope.unlink = function(volume) {
        var params, patch;
        patch = JSON.stringify([
          {
            'op': 'x-merge',
            'path': '/desired',
            'value': {
              'image': null
            }
          }
        ]);
        params = {
          'tenant': $routeParams.tenant,
          'volume': volume.desired.uuid
        };
        return TenantVolume.patch(params, patch, function() {
          return remove_volume(volume);
        });
      };
      $scope.editImage = function() {
        var params, patch;
        patch = JSON.stringify([
          {
            'op': 'x-merge',
            'path': '/desired',
            'value': {
              'name': $scope.image.desired.name,
              'description': $scope.image.desired.description,
              'type': $scope.image.desired.type,
              'source_uri': $scope.image.desired.source_uri
            }
          }
        ]);
        params = {
          'tenant': $routeParams.tenant,
          'image': $routeParams.image
        };
        return TenantImage.patch(params, patch, function() {
          return $scope.close();
        });
      };
    }

    return ImageDetailCtrl;

  })());

}).call(this);
