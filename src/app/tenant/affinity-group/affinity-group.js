// Generated by CoffeeScript 1.7.1
(function() {
  var AffinityGroupDetailCtrl, AffinityGroupListCtrl, module;

  module = angular.module('tenant-affinity-group', ['rainbowServices']);

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

    function AffinityGroupListCtrl($scope, $rootScope, $routeParams, TenantAffinityGroup, dataContainer) {
      TenantAffinityGroup.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(affinityGroupList) {
        $scope.affinityGroups = affinityGroupList;
        return dataContainer.registerEntity('affinityGroup', $scope.affinityGroups);
      });
      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      };
      $scope.open = function(affinityGroup) {
        $scope.affinityGroupModal = true;
        if (typeof affinityGroup !== 'undefined') {
          return $scope.affinityGroup = affinityGroup.desired;
        } else {
          return $scope.affinityGroup = null;
        }
      };
      $scope.close = function() {
        $scope.closeMsg = 'I was closed at: ' + new Date();
        $scope.affinityGroupModal = false;
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
          return $scope.affinityGroups.push({
            'desired': {
              'uuid': response.uuids.POST,
              'name': $scope.affinityGroup.name
            }
          });
        });
      };
      $scope.deleteAffinityGroup = function(affinityGroup, index) {
        var params, position;
        position = $scope.affinityGroups.indexOf(affinityGroup);
        params = {
          'tenant': $routeParams.tenant,
          'affinity_group': affinityGroup.desired.uuid
        };
        return TenantAffinityGroup["delete"](params, function() {
          $scope.affinityGroups.splice(position, 1);
          return $scope.message("Affinity group deleted", 'success');
        });
      };
    }

    return AffinityGroupListCtrl;

  })());

  module.controller('AffinityGroupDetailCtrl', AffinityGroupDetailCtrl = (function() {
    AffinityGroupDetailCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'TenantInstance', 'TenantAffinityGroupInstance', 'dataContainer'];

    function AffinityGroupDetailCtrl($scope, $routeParams, TenantAffinityGroup, TenantAffinityGroupInstanceJoin, TenantInstance, TenantAffinityGroupInstance) {
      $scope.affinityGroup = TenantAffinityGroup.get({
        'tenant': $routeParams.tenant,
        'affinity_group': $routeParams.affinity_group
      });
      $scope.instances = TenantAffinityGroupInstanceJoin.list({
        'tenant': $routeParams.tenant,
        'affinity_group': $routeParams.affinity_group
      });
      console.log($scope.instances);
      TenantInstance.list({
        'tenant': $routeParams.tenant
      }).$promise.then(function(allInstances) {
        $scope.allInstances = allInstances;
        return $scope.filteredInstances = $scope.filterUsedInstances(allInstances, $scope.instances);
      });
      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      };
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
          console.log(instance);
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
        return $scope.affinityGroupModal = true;
      };
      $scope.close = function() {
        $scope.affinityGroupModal = false;
        return false;
      };
      $scope.instanceListOpen = function() {
        $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances);
        return $scope.instanceListModal = true;
      };
      $scope.instanceListClose = function() {
        $scope.instanceListModal = false;
        return false;
      };
    }

    return AffinityGroupDetailCtrl;

  })());

}).call(this);
