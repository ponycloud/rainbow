module = angular.module 'rainbowServices'

factoryFunction = (auth, $q, $rootScope) ->
  data: {}

  registerEntity: (type, entity) ->
    @data[type] = {
      'collection': entity,
      'items': {}
    }

    for item in entity
      @data[type]['items'][item.desired.uuid] = item

  setEntity: (type, uuid, entity) ->
    me = this
    $rootScope.$apply () ->
      if !entity.desired and !entity.current
        me.data[type]['collection'].splice(
          me.data[type]['collection'].indexOf(me.data[type]['items'][uuid]),
          1)
        delete me.data[type]['items'][uuid]
      else if me.getEntity(type, uuid)
        angular.copy entity, me.data[type]['items'][uuid]
      else
        if me.data[type]
          me.data[type]['collection'].push entity
          me.data[type]['items'][uuid] = entity

  getEntity: (type, uuid) ->
    if @data[type]
      return @data[type]['items'][uuid]

  listenSocket: () ->
    wsuri = 'ws://localhost:9000'
    ab.connect wsuri, @_socketConnected, ab.log, {'caller': this}

  _socketConnected: (session) ->
    me = this
    console.log 'connected ws'
    session.auth(auth.getUserToken()).then (permissions) ->
      notifyUri = permissions['pubsub'][0].uri
      container = me.options.caller
      session.subscribe notifyUrl, ((topic, event) ->
        container._onNewMessage topic, event), ab.log

  _onNewMessage: (topic, event) ->
    @setEntity event.type, event.pkey, {current: event.current, desired: event.desired}

module.factory 'dataContainer', factoryFunction
