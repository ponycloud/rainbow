// Generated by CoffeeScript 1.7.1
(function() {
  var LoginCtrl, module;

  module = angular.module('appLogin', []);

  module.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/login', {
        templateUrl: 'login/login.tpl.html',
        controller: 'LoginCtrl',
        layoutPartial: 'fullscreen.html'
      });
    }
  ]);

  module.controller('LoginCtrl', LoginCtrl = (function() {
    LoginCtrl.$inject = ['$scope', 'auth', '$location'];

    function LoginCtrl($scope, auth, $location) {
      this.$scope = $scope;
      $scope.error = null;
      $scope.setError = function(data) {
        return $scope.error = data;
      };
      $scope.loginError = function(error) {
        return $scope.$parent.setError(error.data);
      };
      $scope.login = function() {
        var l;
        $scope.$parent.setError();
        console.log(this.username, this.password);
        l = auth.login(this.username, this.password);
        return l.then((function(login) {
          var newPath;
          console.log(login);
          auth.setUserToken(login.data);
          newPath = sessionStorage.getItem('loginUrlRedirect');
          return $location.path(newPath != null ? newPath : '/tenant');
        }), $scope.loginError);
      };
    }

    return LoginCtrl;

  })());

}).call(this);
