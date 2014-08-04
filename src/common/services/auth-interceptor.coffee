module = angular.module 'rainbowServices'

factoryFunction = (auth, $q) ->
  {
    'request': (config) ->
      tenantSearch = /\/tenant\/([0-9a-z-]*)\//
      tenantUrl = tenantSearch.exec config.url

      configPromise = $q.defer()
      # ignore non-api calls and don't overwrite requests with auth header
      if config['headers']['Authorization']? or
         config.url.indexOf('/api/') == -1
        return config

      if tenantUrl
        token = auth.getTenantToken tenantUrl[1]
      else
        token = auth.getUserToken()

      token.then (tokenValue) ->
        if tokenValue?
          config['headers'] = angular.extend(config['headers'] || {},
          {'Authorization': 'Token ' + tokenValue})
        configPromise.resolve(config)

      configPromise.promise
  }

module.factory 'authInterceptor', factoryFunction

module.config ['$httpProvider', ($httpProvider) ->
      $httpProvider.interceptors.push 'authInterceptor'
]
