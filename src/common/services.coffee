s = angular.module "rainbowServices"
s.factory "StoragePool", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "StoragePoolVolume", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/volume/:volume", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "StoragePoolDisk", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/disk/:disk", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Image", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/image/:image", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "ImageVolume", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/image/:image/volume/:volume", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Switch", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "SwitchVnic", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/vnic/:vnic", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetwork", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetworkRoute", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/route/:route", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetworkAddress", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/address/:address", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "CpuProfile", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/cpu-profile/:cpu_profile", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Host", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostStoragePool", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/storage-pool/:storage_pool", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostInstance", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/instance/:instance", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostNic", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/nic/:nic", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostImage", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/image/:image", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostVolume", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/volume/:volume", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostCpuProfile", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/cpu-profile/:cpu_profile", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostDisk", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/disk/:disk", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostEvent", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/event/:event", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostBond", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostBondNic", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/nic/:nic", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "HostBondRole", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/role/:role", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "User", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/user/:user", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "UserMember", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/user/:user/member/:member", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Disk", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/disk/:disk", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Config", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/config/:config", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Event", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/event/:event", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "Tenant", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantMember", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/member/:member", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantAffinityGroup", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantAffinityGroupInstance", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group/instance/:instance", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantAffinityGroupInstanceJoin", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group/instance/_join/", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantImage", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantImageVolume", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image/volume/:volume", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantQuota", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/quota/:quota", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantVolume", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantVolumeVdisk", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume/vdisk/:vdisk", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstance", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVdisk", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vdisk/:vdisk", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceAffinityGroup", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/affinity-group/:affinity_group", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVnic", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVnicAddress", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceEvent", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/event/:event", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitch", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchVnic", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/vnic/:vnic", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetwork", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetworkRoute", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/route/:route", port_replace, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetworkAddress", (resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	port_replace = {}
	port_replace[WEB_PORT] = ":" + WEB_PORT
	resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/address/:address", port_replace, {query: {method: 'GET', isArray: false} })

