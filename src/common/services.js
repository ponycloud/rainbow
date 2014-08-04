// Generated by CoffeeScript 1.6.3
(function() {
  var methods, options, s, toArray;

  toArray = function(data) {
    return _.toArray(JSON.parse(data));
  };

  s = angular.module("rainbowServices");

  methods = {
    "list": {
      method: "GET",
      isArray: true,
      transformResponse: toArray
    },
    "query": {
      method: "GET",
      isArray: true,
      transformResponse: toArray
    }
  };

  options = {
    "stripTrailingSlashes": false
  };

  s.factory("StoragePool", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/storage-pool/:storage_pool", {}, methods, options);
  });

  s.factory("StoragePoolVolume", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/storage-pool/:storage_pool/volume/:volume", {}, methods, options);
  });

  s.factory("StoragePoolDisk", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/storage-pool/:storage_pool/disk/:disk", {}, methods, options);
  });

  s.factory("Image", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/image/:image", {}, methods, options);
  });

  s.factory("ImageVolume", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/image/:image/volume/:volume", {}, methods, options);
  });

  s.factory("Switch", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/switch/:switch", {}, methods, options);
  });

  s.factory("SwitchVnic", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/switch/:switch/vnic/:vnic", {}, methods, options);
  });

  s.factory("SwitchNetwork", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/switch/:switch/network/:network", {}, methods, options);
  });

  s.factory("SwitchNetworkRoute", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/switch/:switch/network/:network/route/:route", {}, methods, options);
  });

  s.factory("SwitchNetworkAddress", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/switch/:switch/network/:network/address/:address", {}, methods, options);
  });

  s.factory("CpuProfile", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/cpu-profile/:cpu_profile", {}, methods, options);
  });

  s.factory("Host", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host", {}, methods, options);
  });

  s.factory("HostStoragePool", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/storage-pool/:storage_pool", {}, methods, options);
  });

  s.factory("HostStoragePoolHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/storage-pool/:storage_pool/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostStoragePoolJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/storage-pool/:storage_pool/_join/", {}, methods, options);
  });

  s.factory("HostInstance", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/instance/:instance", {}, methods, options);
  });

  s.factory("HostInstanceHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/instance/:instance/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostInstanceJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/instance/:instance/_join/", {}, methods, options);
  });

  s.factory("HostNic", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/nic/:nic", {}, methods, options);
  });

  s.factory("HostImage", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/image/:image", {}, methods, options);
  });

  s.factory("HostImageHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/image/:image/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostImageJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/image/:image/_join/", {}, methods, options);
  });

  s.factory("HostVolume", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/volume/:volume", {}, methods, options);
  });

  s.factory("HostVolumeHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/volume/:volume/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostVolumeJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/volume/:volume/_join/", {}, methods, options);
  });

  s.factory("HostCpuProfile", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/cpu-profile/:cpu_profile", {}, methods, options);
  });

  s.factory("HostCpuProfileHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/cpu-profile/:cpu_profile/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostCpuProfileJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/cpu-profile/:cpu_profile/_join/", {}, methods, options);
  });

  s.factory("HostDisk", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/disk/:disk", {}, methods, options);
  });

  s.factory("HostDiskHostJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/disk/:disk/host/:host/_join/", {}, methods, options);
  });

  s.factory("HostDiskJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/disk/:disk/_join/", {}, methods, options);
  });

  s.factory("HostEvent", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/event/:event", {}, methods, options);
  });

  s.factory("HostBond", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/bond/:bond", {}, methods, options);
  });

  s.factory("HostBondNic", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/bond/:bond/nic/:nic", {}, methods, options);
  });

  s.factory("HostBondRole", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/host/:host/bond/:bond/role/:role", {}, methods, options);
  });

  s.factory("User", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/user/:user", {}, methods, options);
  });

  s.factory("UserMember", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/user/:user/member/:member", {}, methods, options);
  });

  s.factory("Disk", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/disk/:disk", {}, methods, options);
  });

  s.factory("Config", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/config/:config", {}, methods, options);
  });

  s.factory("Event", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/event/:event", {}, methods, options);
  });

  s.factory("Tenant", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant", {}, methods, options);
  });

  s.factory("TenantMember", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/member/:member", {}, methods, options);
  });

  s.factory("TenantAffinityGroup", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/affinity-group/:affinity_group", {}, methods, options);
  });

  s.factory("TenantAffinityGroupInstance", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/affinity-group/:affinity_group/instance/:instance", {}, methods, options);
  });

  s.factory("TenantAffinityGroupInstanceJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/affinity-group/:affinity_group/instance/:instance/_join/", {}, methods, options);
  });

  s.factory("TenantImage", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/image/:image", {}, methods, options);
  });

  s.factory("TenantImageVolume", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/image/:image/volume/:volume", {}, methods, options);
  });

  s.factory("TenantQuota", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/quota/:quota", {}, methods, options);
  });

  s.factory("TenantVolume", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/volume/:volume", {}, methods, options);
  });

  s.factory("TenantVolumeVdisk", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/volume/:volume/vdisk/:vdisk", {}, methods, options);
  });

  s.factory("TenantInstance", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance", {}, methods, options);
  });

  s.factory("TenantInstanceVdisk", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/vdisk/:vdisk", {}, methods, options);
  });

  s.factory("TenantInstanceAffinityGroup", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/affinity-group/:affinity_group", {}, methods, options);
  });

  s.factory("TenantInstanceAffinityGroupInstanceJoin", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/affinity-group/:affinity_group/instance/:instance/_join/", {}, methods, options);
  });

  s.factory("TenantInstanceVnic", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/vnic/:vnic", {}, methods, options);
  });

  s.factory("TenantInstanceVnicAddress", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", {}, methods, options);
  });

  s.factory("TenantInstanceEvent", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/instance/:instance/event/:event", {}, methods, options);
  });

  s.factory("TenantSwitch", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/switch/:switch", {}, methods, options);
  });

  s.factory("TenantSwitchVnic", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/switch/:switch/vnic/:vnic", {}, methods, options);
  });

  s.factory("TenantSwitchNetwork", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/switch/:switch/network/:network", {}, methods, options);
  });

  s.factory("TenantSwitchNetworkRoute", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/switch/:switch/network/:network/route/:route", {}, methods, options);
  });

  s.factory("TenantSwitchNetworkAddress", function($resource, WEB_URL, WEB_PORT, API_SUFFIX) {
    return $resource("" + WEB_URL + API_SUFFIX + "/tenant/:tenant/switch/:switch/network/:network/address/:address", {}, methods, options);
  });

}).call(this);
