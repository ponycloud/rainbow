module = angular.module 'host', []

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/host/', {
    templateUrl: 'platform/host/host-list.tpl.html',
    controller: HostListCtrl
  }
]

module.controller 'HostListCtrl',
  class HostListCtrl
    @inject = ['$scope', 'Host', 'dataContainer']

    constructor: ($scope, Host, dataContainer) ->
      Host.list().$promise.then (i) ->
        $scope.hosts = i
        dataContainer.registerEntity 'host', $scope.hosts
