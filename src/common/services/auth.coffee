module = angular.module 'rainbowServices', ['rainbowConfig']

factoryFunction = ($q, $timeout, WEB_URL, API_SUFFIX) ->
  serverUrl: WEB_URL + API_SUFFIX
  userTokenPromise: $q.defer()

  getToken: (id) ->
    return localStorage.getItem(id + '-token')

  getTokenValidity: (id) ->
    return localStorage.getItem(id + '-valid')

  isTokenValid: (id) ->
    return @getTokenValidity(id) > Date.now() / 1000

  getUserToken: () ->
    return @userTokenPromise.promise

  getTenantToken: (tenant) ->
    id = 'tenant-' + tenant
    token = @getToken id
    promise = $q.defer()
    if !token? or !@isTokenValid(id)
      userToken = @getUserToken()
      userToken.then (userTokenValue) =>
        response = @retreiveToken 'tenant', userTokenValue, tenant
        response.then (data) =>
          @setToken id, data.data
          promise.resolve data.data.token
    else
      promise.resolve token
    promise.promise

  retreiveToken: (type, auth, tenant) ->
    if type == 'tenant'
      authHeader= 'Token ' + auth
      authUrl = @serverUrl + '/tenant/' + tenant + '/token'
    else if type =='user-token'
      authHeader = 'Token ' + auth
      authUrl = @serverUrl + '/token'
    else
      authHeader = 'Basic ' + auth
      authUrl = @serverUrl + '/token'

    # avoiding circular dependency with $http
    # route -> http -> auth-interceptor -> auth -> http
    injector = angular.injector(['ng'])
    return injector.invoke ($http) ->
      requestConfig = {
        headers: {'Authorization': authHeader}
      }
      $http.get authUrl, requestConfig

  setToken: (id, data) ->
    localStorage.setItem id + '-token', data.token
    localStorage.setItem id + '-valid', data.valid
    if id == 'user'
      # resolve promise in case someone has the old one,
      # typically during login
      @userTokenPromise.resolve data.token
      @userTokenPromise = $q.defer()
      @userTokenPromise.resolve data.token

    @setRefreshTokenTimer id

  setRefreshTokenTimer: (id) ->
    if !@getToken(id) or !@isTokenValid(id)
      return false

    timeout = (@getTokenValidity(id) * 1000 - Date.now()) * 0.9
    doRefresh = (me) ->
      return () ->
        me.refreshToken id

    $timeout doRefresh(this), timeout

  refreshToken: (id) ->
    userToken = @getToken 'user'
    if id == 'user'
      token = @retreiveToken 'user-token', userToken
    else
      token = @retreiveToken 'tenant', userToken, id.replace('tenant-', '')

    token.then (tokenData) =>
      @setToken id, tokenData.data

  login: (name, password) ->
    auth = window.btoa(name + ':' + password)
    token = @retreiveToken 'user', auth
    token.then (response) =>
        @setToken 'user', response.data

  isLogged: () ->
    return @getToken('user')? and @isTokenValid('user')

  initTokens: () ->
    if @isLogged()
      @userTokenPromise.resolve @getToken('user')
      @setRefreshTokenTimer 'user'

    for i in [0...localStorage.length] by 1
      key = localStorage.key i

      tenantSearch = /tenant-([0-9a-z-]*)-token/
      tenantUuid = tenantSearch.exec key

      if tenantUuid?
        @setRefreshTokenTimer 'tenant-' + tenantUuid[1]


module.factory 'auth', factoryFunction
