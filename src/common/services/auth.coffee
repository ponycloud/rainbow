module = angular.module 'rainbowServices', ['rainbowConfig']

factoryFunction = ($timeout, WEB_URL, API_SUFFIX) ->
  serverUrl: WEB_URL + API_SUFFIX

  getToken: (id) ->
    return localStorage.getItem(id + '-token')

  getTokenValidity: (id) ->
    return localStorage.getItem(id + '-valid')

  isTokenValid: (id) ->
    return @getTokenValidity(id) > Date.now() / 1000

  getUserToken: () ->
    return @getToken 'user'

  getTenantToken: (tenant) ->
    id = 'tenant-' + tenant
    token = @getToken id
    if !token? or !@isTokenValid(id)
      response = @retreiveToken 'tenant', @getUserToken(), tenant
      @setToken id, response
    @getToken id

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

    responseText = $.ajax({
      type: "GET",
      url: authUrl,
      async: false,
      headers: {'Authentication': authHeader},
      dataType: 'json'
    }).responseText

    JSON.parse(responseText)

  setToken: (id, data) ->
    localStorage.setItem id + '-token', data.token
    localStorage.setItem id + '-valid', data.valid
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
    if id == 'user'
      token = @retreiveToken 'user-token', @getUserToken()
    else
      token = @retreiveToken 'tenant', @getUserToken(), id.replace('tenant-', '')
    @setToken id, token

  login: (name, password) ->
    auth = window.btoa(name + ':' + password)
    token = @retreiveToken 'user', auth
    @setToken 'user', token
    token

  isLogged: () ->
    return @getUserToken() and @isTokenValid('user')

module.factory 'auth', factoryFunction
