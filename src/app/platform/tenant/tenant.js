// Generated by CoffeeScript 1.6.3
(function() {
  var TenantListCtrl, module;

  module = angular.module('platform-tenant', []);

  module.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/tenant', {
        templateUrl: 'platform/tenant/tenant-list.tpl.html',
        controller: 'TenantListCtrl'
      });
    }
  ]);

  module.controller('TenantListCtrl', TenantListCtrl = (function() {
    TenantListCtrl.inject = ['$scope', 'Tenant', 'dataContainer'];

    function TenantListCtrl($scope, Tenant, dataContainer) {
      Tenant.list().$promise.then(function(i) {
        $scope.tenants = i;
        return dataContainer.registerEntity('tenant', $scope.tenants);
      });
    }

    return TenantListCtrl;

  })());

}).call(this);
