module = angular.module 'rainbowServices'

factoryFunction = (authProvider) ->
  this.$get = () ->
    auth = authProvider.$get()
    () ->
      {
        'request': (config) ->
          tenantSearch = /\/tenant\/([0-9a-z-]*)\//
          tenantUrl = tenantSearch.exec config.url

          # ignore non-api calls and don't overwrite requests with auth header
          if config['headers']['Authorization']? or
             config.url.indexOf('/api/') == -1
            return config

          if tenantUrl
            token = auth.getTenantToken tenantUrl[1]
          else
            token = auth.getUserToken()

          if token?
            config['headers'] = angular.extend(config['headers'] || {},
            {'Authorization': 'Token '+ token})

          config
      }
  return

module.provider 'authInterceptor', factoryFunction
