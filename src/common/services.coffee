res = (pkeyName) ->
  (data) ->
    data = _.toArray(JSON.parse(data))
    for item in data
      item.pkey = item.desired[pkeyName]
    data
s = angular.module "rainbowServices"
options = {"stripTrailingSlashes": false}
s.factory "StoragePool", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "StoragePoolVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/volume/:volume", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "StoragePoolDisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/storage-pool/:storage_pool/disk/:disk", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("id")}, "query": {method: "GET", isArray: true, transformResponse: res("id")}}, options)
s.factory "Image", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/image/:image", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "ImageVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/image/:image/volume/:volume", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "Switch", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "SwitchVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/vnic/:vnic", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "SwitchNetwork", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "SwitchNetworkRoute", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/route/:route", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "SwitchNetworkAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/switch/:switch/network/:network/address/:address", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "CpuProfile", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/cpu-profile/:cpu_profile", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "Host", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "HostStoragePool", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/storage-pool/:storage_pool", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'storage_pool']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'storage_pool']")}}, options)
s.factory "HostStoragePoolHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/storage-pool/:storage_pool/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'storage_pool']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'storage_pool']")}}, options)
s.factory "HostStoragePoolJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/storage-pool/:storage_pool/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'storage_pool']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'storage_pool']")}}, options)
s.factory "HostInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/instance/:instance", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'instance']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'instance']")}}, options)
s.factory "HostInstanceHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/instance/:instance/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'instance']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'instance']")}}, options)
s.factory "HostInstanceJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/instance/:instance/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'instance']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'instance']")}}, options)
s.factory "HostNic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/nic/:nic", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("hwaddr")}, "query": {method: "GET", isArray: true, transformResponse: res("hwaddr")}}, options)
s.factory "HostImage", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/image/:image", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'image']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'image']")}}, options)
s.factory "HostImageHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/image/:image/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'image']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'image']")}}, options)
s.factory "HostImageJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/image/:image/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'image']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'image']")}}, options)
s.factory "HostVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/volume/:volume", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'volume']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'volume']")}}, options)
s.factory "HostVolumeHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/volume/:volume/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'volume']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'volume']")}}, options)
s.factory "HostVolumeJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/volume/:volume/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'volume']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'volume']")}}, options)
s.factory "HostCpuProfile", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/cpu-profile/:cpu_profile", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'cpu_profile']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'cpu_profile']")}}, options)
s.factory "HostCpuProfileHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/cpu-profile/:cpu_profile/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'cpu_profile']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'cpu_profile']")}}, options)
s.factory "HostCpuProfileJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/cpu-profile/:cpu_profile/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'cpu_profile']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'cpu_profile']")}}, options)
s.factory "HostDisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/disk/:disk", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'disk']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'disk']")}}, options)
s.factory "HostDiskHostJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/disk/:disk/host/:host/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'disk']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'disk']")}}, options)
s.factory "HostDiskJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/disk/:disk/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("[u'host', u'disk']")}, "query": {method: "GET", isArray: true, transformResponse: res("[u'host', u'disk']")}}, options)
s.factory "HostEvent", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/event/:event", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("hash")}, "query": {method: "GET", isArray: true, transformResponse: res("hash")}}, options)
s.factory "HostBond", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "HostBondNic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/nic/:nic", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("hwaddr")}, "query": {method: "GET", isArray: true, transformResponse: res("hwaddr")}}, options)
s.factory "HostBondRole", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/host/:host/bond/:bond/role/:role", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "User", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/user/:user", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("email")}, "query": {method: "GET", isArray: true, transformResponse: res("email")}}, options)
s.factory "UserMember", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/user/:user/member/:member", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "Disk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/disk/:disk", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("id")}, "query": {method: "GET", isArray: true, transformResponse: res("id")}}, options)
s.factory "Config", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/config/:config", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("key")}, "query": {method: "GET", isArray: true, transformResponse: res("key")}}, options)
s.factory "Event", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/event/:event", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("hash")}, "query": {method: "GET", isArray: true, transformResponse: res("hash")}}, options)
s.factory "Tenant", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantMember", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/member/:member", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantAffinityGroup", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantAffinityGroupInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group/instance/:instance", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantAffinityGroupInstanceJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/affinity-group/:affinity_group/instance/:instance/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantImage", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantImageVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/image/:image/volume/:volume", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantQuota", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/quota/:quota", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantVolume", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantVolumeVdisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/volume/:volume/vdisk/:vdisk", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstance", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceVdisk", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vdisk/:vdisk", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceAffinityGroup", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/affinity-group/:affinity_group", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceAffinityGroupInstanceJoin", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/affinity-group/:affinity_group/instance/:instance/_join/", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceVnicAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/vnic/:vnic/address/:address", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantInstanceEvent", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/instance/:instance/event/:event", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("hash")}, "query": {method: "GET", isArray: true, transformResponse: res("hash")}}, options)
s.factory "TenantSwitch", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantSwitchVnic", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/vnic/:vnic", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantSwitchNetwork", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantSwitchNetworkRoute", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/route/:route", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)
s.factory "TenantSwitchNetworkAddress", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->
	$resource("#{WEB_URL}#{API_SUFFIX}/tenant/:tenant/switch/:switch/network/:network/address/:address", {}, {"patch": {method:"PATCH"}, "list":  {method:"GET", isArray:true, transformResponse: res("uuid")}, "query": {method: "GET", isArray: true, transformResponse: res("uuid")}}, options)

