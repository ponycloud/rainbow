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

app_module = angular.module 'app', ['rainbowServices', 'rainbowDirectives', 
    '$strap.directives', 'jm.i18next', 'ui.bootstrap', 'tenant-instance', 
    'tenant-affinity-group', 'platform-tenant', 'common-controllers', 'tenant-image', 
    'tenant-dashboard', 'host-network', 'app-login', 'host']

app_module.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.otherwise {redirectTo: '/tenant'}
]

app_module.run ['$rootScope', '$route', ($rootScope, $route) ->
  $rootScope.messages = []
]
