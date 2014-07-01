// Generated by CoffeeScript 1.6.3
(function() {
  var AffinityGroupDetailCtrl, AffinityGroupListCtrl, module;

  module = angular.module('tenantAffinityGroup', ['rainbowServices']);

  module.config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/:tenant/affinity-group', {
        templateUrl: 'tenant/affinity-group/affinity-group-list.tpl.html',
        controller: 'AffinityGroupListCtrl'
      });
      return $routeProvider.when('/:tenant/affinity-group/:affinity_group', {
        templateUrl: 'tenant/affinity-group/affinity-group-detail.tpl.html',
        controller: 'AffinityGroupDetailCtrl'
      });
    }
  ]);

  module.controller('AffinityGroupListCtrl', AffinityGroupListCtrl = (function() {
    AffinityGroupListCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'dataContainer'];

    function AffinityGroupListCtrl($scope, $rootScope, $routeParams, TenantAffinityGroup, dataContainer, $modal) {
      TenantAffinityGroup.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(affinityGroupList) {
        $scope.affinityGroups = affinityGroupList;
        return dataContainer.registerEntity('affinityGroup', $scope.affinityGroups);
      });
      $scope.affinityGroupListModal = $modal({
        scope: $scope,
        template: 'tenant/affinity-group/affinity-group-list-modal.tpl.html',
        show: false
      });
      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      };
      $scope.open = function(affinityGroup) {
        $scope.affinityGroupListModal.show();
        return $scope.affinityGroup = {};
      };
      $scope.close = function() {
        $scope.closeMsg = 'I was closed at: ' + new Date();
        $scope.affinityGroupListModal.hide();
        return false;
      };
      $scope.createAffinityGroup = function() {
        var newAffinityGroup;
        newAffinityGroup = new TenantAffinityGroup();
        newAffinityGroup.desired = {
          'name': $scope.affinityGroup.name,
          'type': $scope.affinityGroup.type
        };
        return newAffinityGroup.$save({
          'tenant': $routeParams.tenant
        }, function(response) {
          $scope.affinityGroup.uuid = response.uuids.POST;
          $scope.affinityGroups.push({
            'desired': $scope.affinityGroup
          });
          return $scope.affinityGroupListModal.hide();
        });
      };
      $scope.deleteAffinityGroup = function(uuid) {
        var params;
        params = {
          'tenant': $routeParams.tenant,
          'affinity_group': uuid
        };
        return TenantAffinityGroup["delete"](params, function() {
          return $scope.affinityGroups = $scope.affinityGroups.filter(function(item) {
            return item.desired.uuid !== uuid;
          });
        });
      };
      $scope.deleteSelected = function(items) {
        var item, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          _results.push($scope.deleteAffinityGroup(item));
        }
        return _results;
      };
    }

    return AffinityGroupListCtrl;

  })());

  module.controller('AffinityGroupDetailCtrl', AffinityGroupDetailCtrl = (function() {
    AffinityGroupDetailCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'TenantInstance', 'TenantAffinityGroupInstance', 'dataContainer', '$modal'];

    function AffinityGroupDetailCtrl($scope, $routeParams, TenantAffinityGroup, TenantAffinityGroupInstanceJoin, TenantInstance, TenantAffinityGroupInstance, $modal) {
      $scope.affinityGroup = TenantAffinityGroup.get({
        'tenant': $routeParams.tenant,
        'affinity_group': $routeParams.affinity_group
      });
      $scope.instances = TenantAffinityGroupInstanceJoin.list({
        'tenant': $routeParams.tenant,
        'affinity_group': $routeParams.affinity_group
      });
      TenantInstance.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(allInstances) {
        $scope.allInstances = allInstances;
        return $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances);
      });
      $scope.affinityGroupEditModal = $modal({
        keyboard: true,
        scope: $scope,
        template: 'tenant/affinity-group/affinity-group-edit-modal.tpl.html',
        show: false
      });
      $scope.instanceListModal = $modal({
        keyboard: true,
        scope: $scope,
        template: 'tenant/affinity-group/instance-list-modal.tpl.html',
        show: false
      });
      console.log($scope.instanceListModal);
      $scope.filterUsedInstances = function(all, linked) {
        var filtered, isLinked, item, key, linkedItem, _i, _j, _len, _len1;
        filtered = [];
        for (key = _i = 0, _len = all.length; _i < _len; key = ++_i) {
          item = all[key];
          isLinked = false;
          for (_j = 0, _len1 = linked.length; _j < _len1; _j++) {
            linkedItem = linked[_j];
            if (item.desired.uuid === linkedItem.desired.uuid) {
              isLinked = true;
              break;
            }
          }
          if (!isLinked) {
            filtered.push(item);
          }
        }
        return filtered;
      };
      $scope.editAffinityGroup = function() {
        var params, patch;
        patch = JSON.stringify([
          {
            'op': 'x-merge',
            'path': '/desired',
            'value': {
              'name': $scope.affinityGroup.desired.name,
              'type': $scope.affinityGroup.desired.type
            }
          }
        ]);
        params = {
          'tenant': $routeParams.tenant,
          'affinity_group': $scope.affinityGroup.desired.uuid
        };
        return TenantAffinityGroup.patch(params, patch, function() {
          $scope.close();
          return $scope.message("Affinity group modified", 'success');
        });
      };
      $scope.link = function(instance) {
        var desired, newLink;
        newLink = new TenantAffinityGroupInstance();
        desired = {
          'affinity_group': $routeParams.affinity_group,
          'instance': instance.desired.uuid
        };
        newLink.desired = desired;
        return newLink.$save({
          'tenant': $routeParams.tenant,
          'affinity_group': $routeParams.affinity_group
        }, function(response) {
          desired['uuid'] = response.uuids.POST;
          instance['joined'] = {};
          instance['joined'][desired.uuid] = desired;
          $scope.instances.push(instance);
          return $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances);
        });
      };
      $scope.unlink = function(instance) {
        var key, params, _results;
        _results = [];
        for (key in instance.joined) {
          params = {
            'tenant': $routeParams.tenant,
            'affinity_group': $routeParams.affinity_group,
            'instance': key
          };
          TenantAffinityGroupInstance["delete"](params, function(response) {}, $scope.instances = $scope.instances.filter(function(item) {
            return item.desired.uuid !== instance.desired.uuid;
          }));
          _results.push($scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances));
        }
        return _results;
      };
      $scope.open = function(affinityGroup) {
        return $scope.affinityGroupEditModal.show();
      };
      $scope.close = function() {
        $scope.affinityGroupEditModal.hide();
        $scope.affinityGroup = TenantAffinityGroup.get({
          'tenant': $routeParams.tenant,
          'affinity_group': $routeParams.affinity_group
        });
        return false;
      };
      $scope.instanceListOpen = function() {
        $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances);
        return $scope.instanceListModal.show();
      };
      $scope.instanceListClose = function() {
        $scope.instanceListModal.hide();
        return false;
      };
    }

    return AffinityGroupDetailCtrl;

  })());

}).call(this);
