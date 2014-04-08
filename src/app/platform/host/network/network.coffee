module = angular.module 'host-network', []

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/host/:host/network', {
  templateUrl: 'platform/host/network/network.tpl.html',
  controller: 'HostNetworkCtrl'
  }
]

module.controller 'HostNetworkCtrl',
  class HostNetworkCtrl
    @inject = ['$scope', '$routeParams', 'HostNetwork']

    constructor: ($scope, $routeParams, HostNetwork) ->
       $scope.networkData = []
       $scope.originalData = null
       HostNetwork.getNetwork($routeParams.host).then (items) ->
         data = HostNetwork.composeNetwork $routeParams.host, items
         data['promise'].then () ->
           $scope.networkData = data['result']
           $scope.originalData = angular.copy($scope.networkData)

       $scope.saveNetwork = () ->
        HostNetwork.saveNetwork($routeParams.host, $scope.networkData,
          $scope.originalData)

