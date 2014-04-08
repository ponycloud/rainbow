// Generated by CoffeeScript 1.6.3
(function() {
  var HostNetworkCtrl, module;

  module = angular.module('host-network', []);

  module.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/host/:host/network', {
        templateUrl: 'platform/host/network/network.tpl.html',
        controller: 'HostNetworkCtrl'
      });
    }
  ]);

  module.controller('HostNetworkCtrl', HostNetworkCtrl = (function() {
    HostNetworkCtrl.inject = ['$scope', '$routeParams', 'HostNetwork'];

    function HostNetworkCtrl($scope, $routeParams, HostNetwork) {
      $scope.networkData = [];
      $scope.originalData = null;
      HostNetwork.getNetwork($routeParams.host).then(function(items) {
        var data;
        data = HostNetwork.composeNetwork($routeParams.host, items);
        return data['promise'].then(function() {
          $scope.networkData = data['result'];
          return $scope.originalData = angular.copy($scope.networkData);
        });
      });
      $scope.saveNetwork = function() {
        return HostNetwork.saveNetwork($routeParams.host, $scope.networkData, $scope.originalData);
      };
    }

    return HostNetworkCtrl;

  })());

}).call(this);
