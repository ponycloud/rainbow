// Generated by CoffeeScript 1.7.1
(function() {
  var NetworkDetailCtrl, module;

  module = angular.module('tenantNetwork', ['rainbowServices']);

  module.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/:tenant/switch/:switch/network/:network', {
        templateUrl: 'tenant/network/network-detail.tpl.html',
        controller: 'NetworkDetailCtrl'
      });
    }
  ]);

  module.controller('NetworkDetailCtrl', NetworkDetailCtrl = (function() {
    NetworkDetailCtrl.inject = ['$scope', '$rootScope', '$routeParams', 'TenantSwitchNetwork', 'TenantSwitchNetworkRoute', 'dataContainer', '$modal'];

    function NetworkDetailCtrl($scope, $routeParams, TenantSwitchNetwork, TenantSwitchNetworkRoute, $modal) {
      $scope.network = TenantSwitchNetwork.get({
        'tenant': $routeParams.tenant,
        'switch': $routeParams["switch"],
        'network': $routeParams.network
      });
      $scope.routes = TenantSwitchNetworkRoute.list({
        'tenant': $routeParams.tenant,
        'switch': $routeParams["switch"],
        'network': $routeParams.network
      });
      $scope.routeModal = $modal({
        scope: $scope,
        template: 'tenant/network/route-modal.tpl.html',
        show: false
      });
      $scope.createRoute = function() {
        var newRoute;
        newRoute = new TenantSwitchNetworkRoute();
        newRoute.desired = {
          'route': $scope.route.route,
          'via': $scope.route.via
        };
        return newRoute.$save({
          'tenant': $routeParams.tenant,
          'switch': $routeParams["switch"],
          'network': $routeParams.network
        }, function(response) {
          $scope.route.uuid = response.uuids.POST;
          $scope.routes.push({
            'desired': $scope.route
          });
          return $scope.routeModalClose();
        });
      };
      $scope.deleteRoute = function(uuid) {
        var params;
        params = {
          'tenant': $routeParams.tenant,
          'switch': $routeParams["switch"],
          'network': $routeParams.network,
          'route': uuid
        };
        return TenantSwitchNetworkRoute["delete"](params, function() {
          return $scope.routes = $scope.routes.filter(function(item) {
            return item.desired.uuid !== uuid;
          });
        });
      };
      $scope.deleteSelectedRoutes = function(items) {
        var item, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          _results.push($scope.deleteRoute(item));
        }
        return _results;
      };
      $scope.routeModalOpen = function() {
        $scope.routeModal.show();
        return $scope.route = {};
      };
      $scope.routeModalClose = function() {
        return $scope.routeModal.hide();
      };
    }

    return NetworkDetailCtrl;

  })());

}).call(this);
