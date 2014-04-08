module = angular.module 'tenant-dashboard', []

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/dashboard',
    templateUrl: 'tenant/tenant-dashboard.tpl.html'
    conroller: 'TenantDashboardCtrl'

]

module.controller 'TenantDashboardCtrl',
  class TenanatDashboardCtrl
    @$inject = ['$scope', '$routeParams', 'Tenant']

    constructor: ($scope, $routeParams, Tenant) ->
      $scope.tenant = Tenant.get {tenant: $routeParams.tenant}
