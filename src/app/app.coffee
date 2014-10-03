module = angular.module 'jm.i18next'

module.config ['$i18nextProvider', ($i18nextProvider) ->
  $i18nextProvider.options = {
    lng: 'en',
    useCookie: false,
    useLocalStorage: false,
    fallbackLng: 'dev',
    resGetPath: '../common/locales/__lng__/__ns__.json'
   }
]

app_module = angular.module 'app', ['ngSanitize', 'ngRoute', 'ngAnimate', 'ngResource',
    'mgcrea.ngStrap', 'mgo-angular-wizard', 'ui.sortable', 'pony.bytes',
    'rainbowServices', 'rainbowDirectives', 'jm.i18next', 'tenantInstance', 'tenantSwitch',
    'tenantAffinityGroup', 'platformTenant', 'commonControllers', 'tenantImage', 'tenantVolume',
    'tenantDashboard', 'hostNetwork', 'appLogin', 'host', 'tenantNetwork']

app_module.config ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider.otherwise {redirectTo: '/tenant'}
]

app_module.run ['$rootScope', '$route', ($rootScope, $route) ->
  $rootScope.messages = []
]


