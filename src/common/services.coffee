s = angular.module "rainbowServices"
serverUrl = "http://localhost:8080/api/v1"
s.factory "StoragePool", (resource) ->
	resource("#{serverUrl}/storage-pool/:storage_pool", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "StoragePoolVolume", (resource) ->
	resource("#{serverUrl}/storage-pool/:storage_pool/volume/:volume", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "StoragePoolDisk", (resource) ->
	resource("#{serverUrl}/storage-pool/:storage_pool/disk/:disk", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Image", (resource) ->
	resource("#{serverUrl}/image/:image", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "ImageVolume", (resource) ->
	resource("#{serverUrl}/image/:image/volume/:volume", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Switch", (resource) ->
	resource("#{serverUrl}/switch/:switch", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "SwitchVnic", (resource) ->
	resource("#{serverUrl}/switch/:switch/vnic/:vnic", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetwork", (resource) ->
	resource("#{serverUrl}/switch/:switch/network/:network", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetworkRoute", (resource) ->
	resource("#{serverUrl}/switch/:switch/network/:network/route/:route", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "SwitchNetworkAddress", (resource) ->
	resource("#{serverUrl}/switch/:switch/network/:network/address/:address", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "CpuProfile", (resource) ->
	resource("#{serverUrl}/cpu-profile/:cpu_profile", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Host", (resource) ->
	resource("#{serverUrl}/host/:host", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostStoragePool", (resource) ->
	resource("#{serverUrl}/host/:host/storage-pool/:storage_pool", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostInstance", (resource) ->
	resource("#{serverUrl}/host/:host/instance/:instance", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostNic", (resource) ->
	resource("#{serverUrl}/host/:host/nic/:nic", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostImage", (resource) ->
	resource("#{serverUrl}/host/:host/image/:image", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostVolume", (resource) ->
	resource("#{serverUrl}/host/:host/volume/:volume", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostCpuProfile", (resource) ->
	resource("#{serverUrl}/host/:host/cpu-profile/:cpu_profile", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostDisk", (resource) ->
	resource("#{serverUrl}/host/:host/disk/:disk", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostEvent", (resource) ->
	resource("#{serverUrl}/host/:host/event/:event", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostBond", (resource) ->
	resource("#{serverUrl}/host/:host/bond/:bond", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostBondNic", (resource) ->
	resource("#{serverUrl}/host/:host/bond/:bond/nic/:nic", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "HostBondRole", (resource) ->
	resource("#{serverUrl}/host/:host/bond/:bond/role/:role", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "User", (resource) ->
	resource("#{serverUrl}/user/:user", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "UserMember", (resource) ->
	resource("#{serverUrl}/user/:user/member/:member", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Disk", (resource) ->
	resource("#{serverUrl}/disk/:disk", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Config", (resource) ->
	resource("#{serverUrl}/config/:config", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Event", (resource) ->
	resource("#{serverUrl}/event/:event", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "Tenant", (resource) ->
	resource("#{serverUrl}/tenant/:tenant", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantMember", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/member/:member", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstance", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVdisk", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance/vdisk/:vdisk", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceCluster", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance/cluster/:cluster", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVnic", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance/vnic/:vnic", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceVnicAddress", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantInstanceEvent", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/instance/:instance/event/:event", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantImage", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/image/:image", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantImageVolume", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/image/:image/volume/:volume", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantQuota", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/quota/:quota", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantVolume", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/volume/:volume", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantVolumeVdisk", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/volume/:volume/vdisk/:vdisk", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantCluster", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/cluster/:cluster", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantClusterInstance", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/cluster/:cluster/instance/:instance", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitch", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/switch/:switch", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchVnic", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/switch/:switch/vnic/:vnic", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetwork", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/switch/:switch/network/:network", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetworkRoute", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/switch/:switch/network/:network/route/:route", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })
s.factory "TenantSwitchNetworkAddress", (resource) ->
	resource("#{serverUrl}/tenant/:tenant/switch/:switch/network/:network/address/:address", {'8080': ':8080'}, {query: {method: 'GET', isArray: false} })

