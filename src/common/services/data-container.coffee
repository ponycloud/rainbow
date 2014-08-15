module = angular.module 'rainbowServices'

factoryFunction = (auth, $q, $rootScope, WS_URL) ->
  data: {}
  abSession: $q.defer()

  registerResource: (resource, pkey) ->
    @data[pkey] = resource

  registerEntity: (type, entity) ->
    if @data[type] is undefined
      @data[type] = [{
        'collection': entity,
        'items': new ->
          @[item.pkey] = item for item in $ entity
          this
      }]
    else
      @data[type].push({
        'collection': entity,
        'items': new ->
          @[item.pkey] = item for item in $ entity
          this
      })

  setEntity: (type, pkey, entity) ->
    $rootScope.$apply () =>
      if !entity.desired and !entity.current
        for col of @data[type]
          index = @data[type][col]['collection'].indexOf(@data[type][col]['items'][pkey])
          if index >= 0
            @data[type][col]['collection'].splice(index, 1)
          delete @data[type][col]['items'][pkey]

        # TODO Perhaps do something else
        delete @data[pkey]

      else
        for col of @data[type]
          if @data[type][col]['items'][pkey] != undefined
            angular.copy entity, @data[type][col]['items'][pkey]
          else
            @data[type][col]['collection'].push entity
            if @data[type][col]['items'][pkey] == undefined
              @data[type][col]['items'][pkey] = entity
            else
              angular.extend @data[type][col]['items'][pkey], entity

        if @data[pkey]
          angular.extend(@data[pkey],entity)

  listenSocket: () ->
    ab.connect WS_URL, @_socketConnected, ab.log, {'caller': this}

  subscribeTenant: (tenant) ->
    @abSession.promise.then () =>
      auth.getTenantToken(tenant).then (tenantToken) =>
        @session.auth(tenantToken).then (permissions) =>
          @session.subscribe permissions['pubsub'][1].uri, ((topic, event) =>
            @_onNewMessage topic, event), ab.log

  _socketConnected: (session) ->
    @options.caller.session = session
    @options.caller.abSession.resolve()

  _onNewMessage: (topic, event) ->
    console.log topic,event
    @setEntity event.type, event.pkey, {current: event.current, desired: event.desired, pkey: event.pkey}

module.factory 'dataContainer', factoryFunction
