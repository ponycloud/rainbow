module = angular.module 'appLogin', []

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/login',  {
    templateUrl: 'login/login.tpl.html',
    controller: 'LoginCtrl',
    layoutPartial: 'fullscreen.html'}
]

module.controller 'LoginCtrl',
  class LoginCtrl
    @$inject = ['$scope', 'auth', '$location']

    constructor: (@$scope, auth, $location) ->
      $scope.error = null

      $scope.setError = (data) -> $scope.error = data
      $scope.loginError = (error) -> $scope.$parent.setError(error.data)

      $scope.login = () ->
        $scope.$parent.setError()
        l = auth.login @username, @password
        newPath = sessionStorage.getItem 'loginUrlRedirect'
        $location.path newPath ? '/tenant'
