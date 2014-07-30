// Generated by CoffeeScript 1.6.3
(function() {
  var factoryFunction, module;

  module = angular.module('rainbowServices');

  factoryFunction = function(authProvider) {
    this.$get = function() {
      var auth;
      auth = authProvider.$get();
      return function() {
        return {
          'request': function(config) {
            var tenantSearch, tenantUrl, token;
            tenantSearch = /\/tenant\/([0-9a-z-]*)\//;
            tenantUrl = tenantSearch.exec(config.url);
            if ((config['headers']['Authorization'] != null) || config.url.indexOf('/api/') === -1) {
              return config;
            }
            if (tenantUrl) {
              token = auth.getTenantToken(tenantUrl[1]);
            } else {
              token = auth.getUserToken();
            }
            if (token != null) {
              config['headers'] = angular.extend(config['headers'] || {}, {
                'Authorization': 'Token ' + token
              });
            }
            return config;
          }
        };
      };
    };
  };

  module.provider('authInterceptor', factoryFunction);

}).call(this);
