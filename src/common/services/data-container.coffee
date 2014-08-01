module = angular.module 'rainbowServices'

factoryFunction = (auth, $q, $rootScope, WS_URL) ->
  data: {}
  abSession: $q.defer()
  registerEntity: (type, entity) ->
    @data[type] = {
      'collection': entity,
      'items': {}
    }

    for item in entity
      @data[type]['items'][item.desired.uuid] = item

  setEntity: (type, uuid, entity) ->
    $rootScope.$apply () =>
      if !entity.desired and !entity.current
        @data[type]['collection'].splice(
          @data[type]['collection'].indexOf(@data[type]['items'][uuid]),
          1)
        delete @data[type]['items'][uuid]
      else if @getEntity(type, uuid)
        angular.copy entity, @data[type]['items'][uuid]
      else
        if @data[type]
          @data[type]['collection'].push entity
          @data[type]['items'][uuid] = entity

  getEntity: (type, uuid) ->
    if @data[type]
      return @data[type]['items'][uuid]

  listenSocket: () ->
    ab.connect WS_URL, @_socketConnected, ab.log, {'caller': this}

  subscribeTenant: (tenant) ->
    @abSession.promise.then () =>
      @session.auth(auth.getTenantToken(tenant)).then (permissions) =>
        @session.subscribe permissions['pubsub'][1].uri, ((topic, event) =>
          @_onNewMessage topic, event), ab.log

  _socketConnected: (session) ->
    @options.caller.session = session
    @options.caller.abSession.resolve()

  _onNewMessage: (topic, event) ->
    @setEntity event.type, event.pkey, {current: event.current, desired: event.desired}

module.factory 'dataContainer', factoryFunction
