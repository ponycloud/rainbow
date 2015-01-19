// Generated by CoffeeScript 1.8.0
(function() {
  var VolumeDetailCtrl, VolumeListCtrl, module,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  module = angular.module('tenantVolume', ['rainbowServices']);

  module.config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/:tenant/volume', {
        templateUrl: 'tenant/volume/volume-list.tpl.html',
        controller: 'VolumeListCtrl'
      });
      return $routeProvider.when('/:tenant/volume/:volume', {
        templateUrl: 'tenant/volume/volume-detail.tpl.html',
        controller: 'VolumeDetailCtrl'
      });
    }
  ]);

  module.controller('VolumeListCtrl', VolumeListCtrl = (function() {
    VolumeListCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantVolume', 'StoragePool', 'TenantImage', 'Image', 'ImageVolume', 'dataContainer', '$modal'];

    function VolumeListCtrl($scope, $rootScope, $routeParams, TenantVolume, StoragePool, TenantImage, Image, ImageVolume, dataContainer, $modal) {
      var setDefaultVolumeSize;
      TenantVolume.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(VolumeList) {
        $scope.volumes = VolumeList;
        dataContainer.registerEntity('volume', $scope.volumes);
        return $scope.$watchCollection('volumes', function(newVal, oldVal) {
          return $scope.filteredVolumes = newVal.filter(function(item) {
            if (!item.desired.image) {
              return item;
            }
          });
        });
      });
      $scope.$watch('volume.base_image', function(value) {
        return setDefaultVolumeSize(value);
      });
      $scope.$watch('volume.initialize', function(value) {
        if (!value) {
          if ($scope.volume) {
            return $scope.volume.size = null;
          }
        } else {
          $scope.volume.base_image = $scope.images[0].desired.uuid;
          return setDefaultVolumeSize($scope.volume.base_image);
        }
      });
      StoragePool.list().$promise.then(function(StoragePoolList) {
        $scope.storagepools = StoragePoolList;
        return dataContainer.registerEntity('storagepool', $scope.storagepools);
      });
      Image.list().$promise.then(function(ImageList) {
        $scope.globalImages = ImageList;
        return dataContainer.registerEntity('image', $scope.images);
      });
      TenantImage.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(ImageList) {
        $scope.images = ImageList;
        dataContainer.registerEntity('image', $scope.images);
        return $scope.$watchCollection('images', function(newVal, oldVal) {
          var image, volume, _i, _len, _ref, _results;
          if (!$scope.imageDict) {
            $scope.imageDict = {};
          }
          if (!$scope.imageSize) {
            $scope.imageSize = {};
          }
          _ref = $scope.volumes;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            volume = _ref[_i];
            _results.push((function() {
              var _j, _len1, _results1;
              _results1 = [];
              for (_j = 0, _len1 = newVal.length; _j < _len1; _j++) {
                image = newVal[_j];
                if (volume.desired.image) {
                  if (!$scope.imageDict[volume.desired.storage_pool]) {
                    $scope.imageDict[volume.desired.storage_pool] = [];
                  }
                  $scope.imageDict[volume.desired.storage_pool].push(volume.desired.image);
                  _results1.push($scope.imageSize[volume.desired.image] = volume.desired.size);
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            })());
          }
          return _results;
        });
      });
      setDefaultVolumeSize = function(image) {
        if ($scope.volume) {
          if ($scope.volume.size !== 0) {
            return $scope.volume.size = $scope.imageSize[image];
          }
        }
      };
      $scope.getFilteredImages = function(storage_pool) {
        var image, rval, _i, _len, _ref, _ref1;
        rval = [];
        _ref = $scope.images;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          if (_ref1 = image.desired.uuid, __indexOf.call($scope.imageDict[storage_pool], _ref1) >= 0) {
            rval.push(image);
          }
        }
        return rval.concat($scope.globalImages);
      };
      $scope.filterType = function(actual, expected) {
        expected = expected.toLowerCase();
        if ((actual != null) && 'image'.search(expected) > -1) {
          return true;
        }
        if ((actual == null) && 'volume'.search(expected) > -1) {
          return true;
        }
        return false;
      };
      $scope.volumeModal = $modal({
        scope: $scope,
        template: 'tenant/volume/volume-modal.tpl.html',
        show: false
      });
      $scope.open = function() {
        $scope.volume = {
          storagepools: {},
          desired: {}
        };
        return $scope.volumeModal.show();
      };
      $scope.close = function() {
        $scope.volumeModal.hide();
        return false;
      };
      $scope.createVolume = function() {
        var newVolume;
        newVolume = new TenantVolume();
        newVolume.desired = {
          'name': $scope.volume.name,
          'state': 'present',
          'size': $scope.volume.size,
          'storage_pool': $scope.volume.storagepool
        };
        if ($scope.volume.initialize) {
          newVolume.desired.base_image = $scope.volume.base_image;
        }
        return newVolume.$save({
          'tenant': $routeParams.tenant
        }, function(response) {
          return $scope.close();
        });
      };
      $scope.deleteSelected = function(items) {
        var item, params, patch, _i, _len;
        patch = [];
        params = {
          'tenant': $routeParams.tenant
        };
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          patch.push({
            'op': 'remove',
            'path': '/' + item
          });
        }
        return TenantVolume.patch(params, patch);
      };
    }

    return VolumeListCtrl;

  })());

  module.controller('VolumeDetailCtrl', VolumeDetailCtrl = (function() {
    VolumeDetailCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantVolume', 'TenantVolumeVdisk', 'TenantInstance', 'dataContainer', '$modal'];

    function VolumeDetailCtrl($scope, $routeParams, TenantVolume, TenantVolumeVdisk, TenantInstance, dataContainer, $modal, $route) {
      TenantVolume.get({
        tenant: $routeParams.tenant,
        volume: $routeParams.volume
      }).$promise.then(function(volume) {
        $scope.volume = volume;
        return dataContainer.registerResource($scope.volume, $scope.volume.desired.uuid);
      });
      TenantVolumeVdisk.list({
        tenant: $routeParams.tenant,
        volume: $routeParams.volume
      }).$promise.then(function(vdisks) {
        $scope.vdisks = vdisks;
        dataContainer.registerEntity('vdisk', $scope.vdisks);
        return $scope.$watch('vdisks', function(value) {
          return $scope.filteredVdisks = $scope.vdisks.filter(function(item) {
            if (item.desired.volume === $routeParams.volume) {
              return item;
            }
          });
        }, true);
      });
      TenantInstance.list({
        tenant: $routeParams.tenant
      }).$promise.then(function(instances) {
        $scope.instances = instances;
        dataContainer.registerEntity('instance', $scope.instance);
        return $scope.$watch('instances', function(value) {
          var instance, _i, _len, _results;
          $scope.instanceDict = {};
          _results = [];
          for (_i = 0, _len = value.length; _i < _len; _i++) {
            instance = value[_i];
            _results.push($scope.instanceDict[instance.desired.uuid] = instance);
          }
          return _results;
        });
      });
      $scope.volumeEditModal = $modal({
        scope: $scope,
        template: 'tenant/volume/volume-edit-modal.tpl.html',
        show: false
      });
      $scope.open = function() {
        return $scope.volumeEditModal.show();
      };
      $scope.close = function() {
        $scope.volumeEditModal.hide();
        return false;
      };
      $scope.unlink = function(volume) {
        var params, patch;
        patch = JSON.stringify([
          {
            'op': 'x-merge',
            'path': '/desired',
            'value': {
              'volume': null
            }
          }
        ]);
        params = {
          'tenant': $routeParams.tenant,
          'volume': volume.desired.uuid
        };
        return TenantVolume.patch(params, patch, function() {
          return $scope.backVolumes.splice($scope.backVolumes.indexOf(volume), 1);
        });
      };
      $scope.editVolume = function() {
        var params, patch;
        patch = JSON.stringify([
          {
            'op': 'x-merge',
            'path': '/desired',
            'value': {
              'name': $scope.volume.desired.name,
              'size': $scope.volume.desired.size
            }
          }
        ]);
        params = {
          'tenant': $routeParams.tenant,
          'volume': $routeParams.volume
        };
        return TenantVolume.patch(params, patch, function() {
          return $scope.close();
        });
      };
    }

    return VolumeDetailCtrl;

  })());

}).call(this);
