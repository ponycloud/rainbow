module = angular.module 'rainbowServices', ['ng', 'rainbowResource', 'rainbowPatchApi']

factoryFunction = ($http, $q, $timeout) ->
  serverUrl: 'http://localhost:8080/api/v1'
  getUserToken: () ->
    return localStorage.getItem 'user'

  getTenantToken: (tenant) ->
    token = localStorage.getItem 'tenant-' + tenant

    if !token or token.valid < Date.now()
      promise = $http.get @serverUrl + '/tenant/' + tenant + '/token', 
        {
          'headers': {
            'Authorization': 'Token ' + this.getUserToken()
          }
        }
      me = this
      $q.all([promise]).then (items) ->
        console.log(items[0].data.token)
        me.setTenantToken tenant, JSON.stringify(items[0].data)
      return JSON.parse(localStorage.getItem("tenant-" + tenant))['token']

    return JSON.parse(token)['token']

  setUserToken: (token) ->
    localStorage.setItem 'user', token.token
    console.log token
    timeout = token.valid * 1000 - new Date().getTime() - 30 * 1000
    console.log 'Refresh timeout ', timeout
    #todo fix
    #$timeout @refreshUserToken, timeout

  refreshUserToken: () ->
    auth = 'Token ' + @getUserToken()
    return @getToken auth

  setUserTokenRefreshTimeout: () ->

  setTenantToken: (tenant, token) ->
    localStorage.setItem "tenant-" + tenant, token

  clearAllTokens: () ->
    # todo: better way
    localStorage.clear()

  getUsername: () ->
    return localStorage.getItem 'username'

  login: (name, password) ->
    localStorage.setItem 'username', name
    auth = 'Basic ' + window.btoa(name + ':' + password)
    return @getToken auth

  getToken: (auth) ->
    return $http.get @serverUrl + '/token', {
        'headers': {
            'Authorization': auth
        }
    }

  isLogged: () ->
    return @getUserToken() ? false

module.factory 'auth', factoryFunction
