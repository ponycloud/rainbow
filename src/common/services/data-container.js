// Generated by CoffeeScript 1.6.3
(function() {
  var factoryFunction, module;

  module = angular.module('rainbowServices');

  factoryFunction = function(auth, $q, $rootScope, WS_URL) {
    return {
      data: {},
      abSession: $q.defer(),
      currentTenantSubs: null,
      connected: false,
      registerResource: function(resource, pkey) {
        return this.data[pkey] = resource;
      },
      registerEntity: function(type, entity) {
        if (this.data[type] === void 0) {
          return this.data[type] = [
            {
              'collection': entity,
              'items': new function() {
                var item, _i, _len, _ref;
                _ref = $(entity);
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  item = _ref[_i];
                  this[item.pkey] = item;
                }
                return this;
              }
            }
          ];
        } else {
          return this.data[type].push({
            'collection': entity,
            'items': new function() {
              var item, _i, _len, _ref;
              _ref = $(entity);
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                item = _ref[_i];
                this[item.pkey] = item;
              }
              return this;
            }
          });
        }
      },
      setEntity: function(type, pkey, entity) {
        var _this = this;
        return $rootScope.$apply(function() {
          var col, index;
          if (!entity.desired && !entity.current) {
            for (col in _this.data[type]) {
              index = _this.data[type][col]['collection'].indexOf(_this.data[type][col]['items'][pkey]);
              if (index >= 0) {
                _this.data[type][col]['collection'].splice(index, 1);
              }
              delete _this.data[type][col]['items'][pkey];
            }
            return delete _this.data[pkey];
          } else {
            for (col in _this.data[type]) {
              if (_this.data[type][col]['items'][pkey] !== void 0) {
                angular.copy(entity, _this.data[type][col]['items'][pkey]);
              } else {
                _this.data[type][col]['collection'].push(entity);
                if (_this.data[type][col]['items'][pkey] === void 0) {
                  _this.data[type][col]['items'][pkey] = entity;
                } else {
                  angular.extend(_this.data[type][col]['items'][pkey], entity);
                }
              }
            }
            if (_this.data[pkey]) {
              return angular.extend(_this.data[pkey], entity);
            }
          }
        });
      },
      listenSocket: function() {
        return ab.connect(WS_URL, this._socketConnected, ab.log, {
          'caller': this
        });
      },
      subscribeUser: function() {
        return this.subscribeWithToken(auth.getUserToken());
      },
      subscribeTenant: function(tenant) {
        if (this.currentTenantSubs != null) {
          this.unsubscribeTenant();
        }
        return this.subscribeWithToken(auth.getTenantToken(tenant));
      },
      subscribeWithToken: function(token) {
        var _this = this;
        return this.abSession.promise.then(function() {
          return token.then(function(userToken) {
            return _this.session.auth(userToken).then(function(permissions) {
              var permission, _i, _len, _ref, _results;
              _ref = permissions['pubsub'];
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                permission = _ref[_i];
                console.log(permission);
                _results.push(_this.session.subscribe(permission.uri, function(topic, event) {
                  return _this._onNewMessage(topic, event);
                }, ab.log));
              }
              return _results;
            });
          });
        });
      },
      unsubscribeTenant: function() {
        var uri;
        uri = this.currentSessionSubs;
        this.currentSessionSubs = null;
        return this.session.unsubscribe(uri);
      },
      isConnected: function() {
        return this.connected;
      },
      _socketConnected: function(session) {
        this.options.caller.session = session;
        this.options.caller.abSession.resolve();
        this.options.caller.subscribeUser();
        return this.options.caller.connected = true;
      },
      _onNewMessage: function(topic, event) {
        console.log(topic, event);
        return this.setEntity(event.type, event.pkey, {
          current: event.current,
          desired: event.desired,
          pkey: event.pkey
        });
      }
    };
  };

  module.factory('dataContainer', factoryFunction);

}).call(this);
