toArray = (data) ->
  _.toArray(JSON.parse(data))
s = angular.module "rainbowServices"
methods = {"list":  {method:"GET", isArray:true, transformResponse: toArray}, "query": {method: "GET", isArray: true, transformResponse: toArray}}
options = {"stripTrailingSlashes": false}
s.factory "StoragePool", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool", {}, methods, options)
s.factory "StoragePoolVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/volume/:volume", {}, methods, options)
s.factory "StoragePoolDisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/disk/:disk", {}, methods, options)
s.factory "Image", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/image/:image", {}, methods, options)
s.factory "ImageVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/image/:image/volume/:volume", {}, methods, options)
s.factory "Switch", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch", {}, methods, options)
s.factory "SwitchVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/vnic/:vnic", {}, methods, options)
s.factory "SwitchNetwork", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network", {}, methods, options)
s.factory "SwitchNetworkRoute", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/route/:route", {}, methods, options)
s.factory "SwitchNetworkAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/address/:address", {}, methods, options)
s.factory "CpuProfile", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/cpu-profile/:cpu_profile", {}, methods, options)
s.factory "Host", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host", {}, methods, options)
s.factory "HostStoragePool", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/storage-pool/:storage_pool", {}, methods, options)
s.factory "HostInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/instance/:instance", {}, methods, options)
s.factory "HostNic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/nic/:nic", {}, methods, options)
s.factory "HostImage", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/image/:image", {}, methods, options)
s.factory "HostVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/volume/:volume", {}, methods, options)
s.factory "HostCpuProfile", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/cpu-profile/:cpu_profile", {}, methods, options)
s.factory "HostDisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/disk/:disk", {}, methods, options)
s.factory "HostEvent", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/event/:event", {}, methods, options)
s.factory "HostBond", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond", {}, methods, options)
s.factory "HostBondNic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/nic/:nic", {}, methods, options)
s.factory "HostBondRole", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/role/:role", {}, methods, options)
s.factory "User", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/user/:user", {}, methods, options)
s.factory "UserMember", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/user/:user/member/:member", {}, methods, options)
s.factory "Disk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/disk/:disk", {}, methods, options)
s.factory "Config", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/config/:config", {}, methods, options)
s.factory "Event", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/event/:event", {}, methods, options)
s.factory "Tenant", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant", {}, methods, options)
s.factory "TenantMember", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/member/:member", {}, methods, options)
s.factory "TenantAffinityGroup", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group", {}, methods, options)
s.factory "TenantAffinityGroupInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group/instance/:instance", {}, methods, options)
s.factory "TenantImage", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image", {}, methods, options)
s.factory "TenantImageVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image/volume/:volume", {}, methods, options)
s.factory "TenantQuota", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/quota/:quota", {}, methods, options)
s.factory "TenantVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume", {}, methods, options)
s.factory "TenantVolumeVdisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume/vdisk/:vdisk", {}, methods, options)
s.factory "TenantInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance", {}, methods, options)
s.factory "TenantInstanceVdisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vdisk/:vdisk", {}, methods, options)
s.factory "TenantInstanceAffinityGroup", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/affinity-group/:affinity_group", {}, methods, options)
s.factory "TenantInstanceVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic", {}, methods, options)
s.factory "TenantInstanceVnicAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", {}, methods, options)
s.factory "TenantInstanceEvent", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/event/:event", {}, methods, options)
s.factory "TenantSwitch", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch", {}, methods, options)
s.factory "TenantSwitchVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/vnic/:vnic", {}, methods, options)
s.factory "TenantSwitchNetwork", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network", {}, methods, options)
s.factory "TenantSwitchNetworkRoute", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/route/:route", {}, methods, options)
s.factory "TenantSwitchNetworkAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/address/:address", {}, methods, options)

