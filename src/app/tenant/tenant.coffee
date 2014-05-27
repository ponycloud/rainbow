module = angular.module 'tenantDashboard', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/dashboard', {
    templateUrl: 'tenant/tenant-dashboard.tpl.html',
    controller: TenantDashboardCtrl
  }
]

module.controller 'TenantDashboardCtrl',
  class TenantDashboardCtrl
    @$inject = ['$scope', '$routeParams', 'Tenant', 'StoragePool']

    constructor: ($scope, $routeParams, Tenant, StoragePool) ->
      console.log('hello')
      $scope.tenant = Tenant.get {tenant: $routeParams.tenant}
      StoragePool.get({})
