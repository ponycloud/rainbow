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

app_module = angular.module 'app', ['ngSanitize', 'ngRoute', 'ngAnimate', 'mgcrea.ngStrap',
    'jm.i18next',  'tenantInstance', 'tenantAffinityGroup', 'tenantSwitch', 'tenantNetwork',
    'platformTenant',
    'commonControllers', 'rainbowServices', 'rainbowDirectives', 'ngTable',
    'tenantImage', 'tenantDashboard', 'hostNetwork', 'appLogin', 'host']

app_module.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.otherwise {redirectTo: '/tenant'}
]

app_module.run ['$rootScope', '$route', ($rootScope, $route) ->
  $rootScope.messages = []
]
