// Generated by CoffeeScript 1.6.3
(function() {
  var s, serverUrl;

  s = angular.module("rainbowServices");

  serverUrl = "http://localhost:8080/api/v1";

  s.factory("StoragePool", function(resource) {
    return resource("" + serverUrl + "/storage-pool/:storage_pool", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("StoragePoolVolume", function(resource) {
    return resource("" + serverUrl + "/storage-pool/:storage_pool/volume/:volume", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("StoragePoolDisk", function(resource) {
    return resource("" + serverUrl + "/storage-pool/:storage_pool/disk/:disk", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Image", function(resource) {
    return resource("" + serverUrl + "/image/:image", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("ImageVolume", function(resource) {
    return resource("" + serverUrl + "/image/:image/volume/:volume", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Switch", function(resource) {
    return resource("" + serverUrl + "/switch/:switch", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("SwitchVnic", function(resource) {
    return resource("" + serverUrl + "/switch/:switch/vnic/:vnic", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("SwitchNetwork", function(resource) {
    return resource("" + serverUrl + "/switch/:switch/network/:network", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("SwitchNetworkRoute", function(resource) {
    return resource("" + serverUrl + "/switch/:switch/network/:network/route/:route", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("SwitchNetworkAddress", function(resource) {
    return resource("" + serverUrl + "/switch/:switch/network/:network/address/:address", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("CpuProfile", function(resource) {
    return resource("" + serverUrl + "/cpu-profile/:cpu_profile", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Host", function(resource) {
    return resource("" + serverUrl + "/host/:host", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostStoragePool", function(resource) {
    return resource("" + serverUrl + "/host/:host/storage-pool/:storage_pool", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostInstance", function(resource) {
    return resource("" + serverUrl + "/host/:host/instance/:instance", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostNic", function(resource) {
    return resource("" + serverUrl + "/host/:host/nic/:nic", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostImage", function(resource) {
    return resource("" + serverUrl + "/host/:host/image/:image", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostVolume", function(resource) {
    return resource("" + serverUrl + "/host/:host/volume/:volume", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostCpuProfile", function(resource) {
    return resource("" + serverUrl + "/host/:host/cpu-profile/:cpu_profile", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostDisk", function(resource) {
    return resource("" + serverUrl + "/host/:host/disk/:disk", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostEvent", function(resource) {
    return resource("" + serverUrl + "/host/:host/event/:event", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostBond", function(resource) {
    return resource("" + serverUrl + "/host/:host/bond/:bond", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostBondNic", function(resource) {
    return resource("" + serverUrl + "/host/:host/bond/:bond/nic/:nic", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("HostBondRole", function(resource) {
    return resource("" + serverUrl + "/host/:host/bond/:bond/role/:role", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("User", function(resource) {
    return resource("" + serverUrl + "/user/:user", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("UserMember", function(resource) {
    return resource("" + serverUrl + "/user/:user/member/:member", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Disk", function(resource) {
    return resource("" + serverUrl + "/disk/:disk", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Config", function(resource) {
    return resource("" + serverUrl + "/config/:config", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Event", function(resource) {
    return resource("" + serverUrl + "/event/:event", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("Tenant", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantMember", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/member/:member", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstance", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstanceVdisk", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance/vdisk/:vdisk", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstanceCluster", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance/cluster/:cluster", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstanceVnic", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance/vnic/:vnic", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstanceVnicAddress", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantInstanceEvent", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/instance/:instance/event/:event", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantImage", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/image/:image", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantImageVolume", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/image/:image/volume/:volume", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantQuota", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/quota/:quota", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantVolume", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/volume/:volume", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantVolumeVdisk", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/volume/:volume/vdisk/:vdisk", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantCluster", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/cluster/:cluster", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantClusterInstance", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/cluster/:cluster/instance/:instance", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantSwitch", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/switch/:switch", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantSwitchVnic", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/switch/:switch/vnic/:vnic", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantSwitchNetwork", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/switch/:switch/network/:network", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantSwitchNetworkRoute", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/switch/:switch/network/:network/route/:route", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

  s.factory("TenantSwitchNetworkAddress", function(resource) {
    return resource("" + serverUrl + "/tenant/:tenant/switch/:switch/network/:network/address/:address", {
      '8080': ':8080'
    }, {
      query: {
        method: 'GET',
        isArray: false
      }
    });
  });

}).call(this);
