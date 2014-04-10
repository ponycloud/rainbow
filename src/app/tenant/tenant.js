// Generated by CoffeeScript 1.6.3
(function() {
  var TenantDashboardCtrl, module;

  module = angular.module('tenant-dashboard', ['rainbowServices']);

  module.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/:tenant/dashboard', {
        templateUrl: 'tenant/tenant-dashboard.tpl.html',
        controller: TenantDashboardCtrl
      });
    }
  ]);

  module.controller('TenantDashboardCtrl', TenantDashboardCtrl = (function() {
    TenantDashboardCtrl.$inject = ['$scope', '$routeParams', 'Tenant', 'StoragePool'];

    function TenantDashboardCtrl($scope, $routeParams, Tenant, StoragePool) {
      console.log('hello');
      $scope.tenant = Tenant.get({
        tenant: $routeParams.tenant
      });
      StoragePool.get({});
    }

    return TenantDashboardCtrl;

  })());

}).call(this);
