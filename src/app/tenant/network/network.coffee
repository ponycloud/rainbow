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

    constructor: ($scope, $routeParams, TenantSwitchNetwork, TenantSwitchNetworkRoute, dataContainer, $modal) ->
      TenantSwitchNetwork.get({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network}).$promise.then((network) ->
        $scope.network = network
        dataContainer.registerResource $scope.network, $scope.network.desired.uuid
      )

      TenantSwitchNetworkRoute.list({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network}).$promise.then((routes) ->
        $scope.routes = routes
        dataContainer.registerEntity 'route', $scope.routes
      )

      $scope.routeModal = $modal({scope: $scope, template: 'tenant/network/route-modal.tpl.html', show: false})

      $scope.createRoute = () ->
        newRoute = new TenantSwitchNetworkRoute()
        newRoute.desired = {'route': $scope.route.route, 'via': $scope.route.via}
        newRoute.$save({'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': $routeParams.network}, (response) ->
          $scope.routeModalClose()
        )

      $scope.deleteSelectedRoutes = (items) ->
        patch = []
        params =
          tenant: $routeParams.tenant
          switch: $routeParams.switch,
          network: $routeParams.network,

        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantSwitchNetworkRoute.patch(params, patch)


      $scope.routeModalOpen = () ->
        $scope.routeModal.show()
        $scope.route = {}

      $scope.routeModalClose = () ->
        $scope.routeModal.hide()
