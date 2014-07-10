module = angular.module 'tenantNetwork', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/switch/:switch/network/:network', {
    templateUrl:'tenant/network/network-detail.tpl.html',
    controller: 'NetworkDetailCtrl'
  }
]

module.controller 'NetworkDetailCtrl',
  class NetworkDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantSwitchNetwork', 'TenantSwitchNetworkRoute', 'dataContainer', '$modal']

    constructor: ($scope, $routeParams, TenantSwitchNetwork, TenantSwitchNetworkRoute, $modal) ->
      $scope.network = TenantSwitchNetwork.get({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network})
      $scope.routes = TenantSwitchNetworkRoute.list({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network})

      $scope.routeModal = $modal({scope: $scope, template: 'tenant/network/route-modal.tpl.html', show: false})

      $scope.createRoute = () ->
        newRoute = new TenantSwitchNetworkRoute()
        newRoute.desired = {'route': $scope.route.route, 'via': $scope.route.via}
        newRoute.$save({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network}, (response) ->
          # Construct data to push to the list.
          $scope.route.uuid = response.uuids.POST
          $scope.routes.push({'desired': $scope.route})
          $scope.routeModalClose()
        )

      $scope.deleteRoute = (uuid) ->
        params = {
          'tenant': $routeParams.tenant,
          'switch': $routeParams.switch,
          'network': $routeParams.network,
          'route': uuid
        }

        TenantSwitchNetworkRoute.delete(params, () ->
          $scope.routes = $scope.routes.filter(
            (item) ->
              item.desired.uuid != uuid
          )
          #$scope.message("Network deleted", 'success')
        )

      $scope.deleteSelectedRoutes = (items) ->
        for item in items
          $scope.deleteRoute item

      $scope.routeModalOpen = () ->
        $scope.routeModal.show()
        $scope.route = {}

      $scope.routeModalClose = () ->
        $scope.routeModal.hide()
