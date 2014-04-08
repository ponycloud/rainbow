module = angular.module 'common-controllers', ['rainbowServices']

module.controller 'MainCtrl',
  class MainCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', '$location', 'dataContainer', '$route', 'auth', 'Tenant']

    constructor: (@$scope, @$rootScope, @$routeParams, @$location, dataContainer, $route, auth, Tenant) ->
      $scope.currentTenant =  $routeParams
      $scope.socketsActive = false

      if !auth.isLogged()
        $location.path "/login"

      $scope.$on '$routeChangeSuccess', () ->
        $scope.activePath = $location.path().split('/').pop()
        $scope.tenant = $routeParams.tenant

        if (auth.isLogged() && !$scope.socketsActive)
          dataContainer.listenSocket()

        $rootScope.layoutPartial = () ->
          if $route.current['layoutPartial']
            return '../common/layouts/' + $route.current['layoutPartial']
          else
            return '../common/layouts/default.html'

          if $scope.tenant
            currentTenant = Tenant.get {'tenant': $routeParams.tenant}, () ->
              if $scope.currentTenantName != currentTenant.desired.name
                $scope.currentTenantName = currentTenant.desired.name

          $rootScope.messages = []

      $rootScope.message = () ->
        $rootScope.messages.unshift {'text': text, 'type': type}
        if $rootScope.messages.length > 1
           $rootScope.messages.pop()
