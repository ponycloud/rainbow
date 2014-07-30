// Generated by CoffeeScript 1.6.3
(function() {
  var app_module, module;

  module = angular.module('jm.i18next');

  module.config([
    '$i18nextProvider', function($i18nextProvider) {
      return $i18nextProvider.options = {
        lng: 'en',
        useCookie: false,
        useLocalStorage: false,
        fallbackLng: 'dev',
        resGetPath: '../common/locales/__lng__/__ns__.json'
      };
    }
  ]);

  app_module = angular.module('app', ['ngRoute', 'ngResource', 'rainbowServices', 'rainbowDirectives', '$strap.directives', 'jm.i18next', 'ui.bootstrap', 'tenant-instance', 'tenant-cluster', 'platform-tenant', 'common-controllers', 'tenant-image', 'tenant-dashboard', 'host-network', 'app-login', 'host']);

  app_module.config([
    '$routeProvider', '$locationProvider', '$httpProvider', 'authInterceptorProvider', function($routeProvider, $locationProvider, $httpProvider, authInterceptor) {
      $routeProvider.otherwise({
        redirectTo: '/tenant'
      });
      return $httpProvider.interceptors.push(authInterceptor.$get());
    }
  ]);

  app_module.run([
    '$rootScope', '$route', function($rootScope, $route) {
      return $rootScope.messages = [];
    }
  ]);

}).call(this);
