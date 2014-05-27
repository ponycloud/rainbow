module = angular.module 'tenantInstance', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/instance',
    templateUrl: 'tenant/instance/instance-list.tpl.html'
    controller: 'InstanceListCtrl'

  $routeProvider.when '/:tenant/instance/:instance',
    templateUrl: 'tenant/instance/instance-detail.tpl.html'
    controller: 'InstanceDetailCtrl'
]

module.controller 'InstanceListCtrl',
  class InstanceListCtrl
    @inject = ['$scope', '$routeParams', 'TenantInstance', 'dataContainer']
    constructor: ($scope, $routeParams, TenantInstance, dataContainer) ->
      list = TenantInstance.list {tenant: $routeParams.tenant}
      list.$promise.then (i) ->
        $scope.instances = i
        dataContainer.registerEntity 'instance', $scope.instances


module.controller 'InstanceDetailCtrl',
  class InstanceDetailCtrl
    @$inject = ['$scope', '$routeParams', 'TenantInstance', 'TenantInstanceVdisk', 'TenantInstanceVnic', 'TenantInstanceVnicAddress', 'StoragePool']

    constructor: ($scope, $routeParams, TenantInstance, TenantInstanceVdisk, TenantInstanceVnic, TenantInstanceVnicAddress, StoragePool) ->
      $scope.instance = TenantInstance.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vdisks = TenantInstanceVdisk.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vnics = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance

      $scope.vnicIps = TenantInstanceVnic.get
        tenant: $routeParams.tenant
        instance: $routeParams.instance
        vnic: $routeParams.vnic
