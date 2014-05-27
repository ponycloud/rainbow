module = angular.module 'platformTenant', []

module.config ['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/tenant',  {
      templateUrl: 'platform/tenant/tenant-list.tpl.html',
      controller: 'TenantListCtrl'
    }
]

module.controller 'TenantListCtrl',
  class TenantListCtrl
    @inject = ['$scope', 'Tenant', 'dataContainer']

    constructor: ($scope, Tenant, dataContainer) ->
      Tenant.list().$promise.then (i) ->
        $scope.tenants = i
        dataContainer.registerEntity 'tenant', $scope.tenants

