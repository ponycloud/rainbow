
class Entity
  @serial: 0
  path: ''
  ops: []
  parent: null
  id: null
  pkey: null

  @_incrementSerial: -> Entity.serial++

  constructor: (@parent, @path, @id) ->
    if not @id
      @id = "%autoid#{ Entity.serial }"
      Entity.serial++

  _getPath: ->
    return @path

  _replaceId: (path, id) ->
    r = path.replace /%id/g, if id then id else @id
    r = r.replace "//", "/"
    return r

  _fixValue: (value, pkey, id) ->
    #if not value[pkey] and pkey
    #  value[pkey] = id

    return value

  _add: (op, path, value, pkey, id) ->
    value = @_fixValue value, pkey, id

    if @parent
      @parent._add op, @_replaceId(@_getPath()) + @_replaceId(path,id), value
    else
      @ops.push {
          op: op,
          path: @_replaceId(path,id),
          value: value
      }

  _remove: (path, id) ->
    if @parent
      @parent._remove @_replaceId(@_getPath()) + @_replaceId(path, id)
    else
      @ops.push {
        op: 'remove',
        path: @_replaceId(path, id)
      }

  _replace: (path, id, newData) ->
    if @parent
      @parent._replace @_replaceId(@_getPath()) + @_replaceId(path, id, newData), id, newData
    else
      @ops.push {
        op: 'replace',
        path: @_replaceId(path, id),
        value: newData
      }

  _merge: (path, id, newData) ->
    if @parent
      @parent._merge @_replaceId(@_getPath()) + @_replaceId(path, id, newData), id, newData
    else
      @ops.push {
        op: 'x-merge',
        path: @_replaceId(path, id),
        value: newData
      }

class StoragePool extends Entity
  addVolume: (data, id) ->
    _volume = new Volume this, "/children/volume/%id/"
    @_add "add", "/children/volume/%id",data,"uuid",_volume.id
    return _volume

  removeVolume: (uuid) ->
    @_remove "/children/volume/%id", uuid

  replaceVolume: (uuid, newData) ->
    @_replace "/children/volume/%id/desired", uuid, newData

  mergeVolume: (uuid, newData) ->
    @_merge "/children/volume/%id/desired", uuid, newData

  Volume: (id) ->
    return new Volume this, "/children/volume/%id/", id

  addDisk: (data, id) ->
    _disk = new Disk this, "/children/disk/%id/"
    @_add "add", "/children/disk/%id",data,"id",_disk.id
    return _disk

  removeDisk: (uuid) ->
    @_remove "/children/disk/%id", uuid

  replaceDisk: (uuid, newData) ->
    @_replace "/children/disk/%id/desired", uuid, newData

  mergeDisk: (uuid, newData) ->
    @_merge "/children/disk/%id/desired", uuid, newData

  Disk: (id) ->
    return new Disk this, "/children/disk/%id/", id


class Image extends Entity
  addVolume: (data, id) ->
    _volume = new Volume this, "/children/volume/%id/"
    @_add "add", "/children/volume/%id",data,"uuid",_volume.id
    return _volume

  removeVolume: (uuid) ->
    @_remove "/children/volume/%id", uuid

  replaceVolume: (uuid, newData) ->
    @_replace "/children/volume/%id/desired", uuid, newData

  mergeVolume: (uuid, newData) ->
    @_merge "/children/volume/%id/desired", uuid, newData

  Volume: (id) ->
    return new Volume this, "/children/volume/%id/", id


class Cluster extends Entity

class Disk extends Entity

class Event extends Entity

class Network extends Entity
  addRoute: (data, id) ->
    _route = new Route this, "/children/route/%id/"
    @_add "add", "/children/route/%id",data,"uuid",_route.id
    return _route

  removeRoute: (uuid) ->
    @_remove "/children/route/%id", uuid

  replaceRoute: (uuid, newData) ->
    @_replace "/children/route/%id/desired", uuid, newData

  mergeRoute: (uuid, newData) ->
    @_merge "/children/route/%id/desired", uuid, newData

  Route: (id) ->
    return new Route this, "/children/route/%id/", id

  addAddress: (data, id) ->
    _address = new Address this, "/children/address/%id/"
    @_add "add", "/children/address/%id",data,"uuid",_address.id
    return _address

  removeAddress: (uuid) ->
    @_remove "/children/address/%id", uuid

  replaceAddress: (uuid, newData) ->
    @_replace "/children/address/%id/desired", uuid, newData

  mergeAddress: (uuid, newData) ->
    @_merge "/children/address/%id/desired", uuid, newData

  Address: (id) ->
    return new Address this, "/children/address/%id/", id


class CpuProfile extends Entity

class Vdisk extends Entity

class Member extends Entity

class Instance extends Entity

class Role extends Entity

class Config extends Entity

class Vnic extends Entity

class Nic extends Entity

class Quota extends Entity

class Volume extends Entity

class Host extends Entity
  addStoragePool: (data, id) ->
    _storagepool = new StoragePool this, "/children/storage-pool/%id/"
    @_add "add", "/children/storage-pool/%id",data,"[u'host', u'storage_pool']",_storagepool.id
    return _storagepool

  removeStoragePool: (uuid) ->
    @_remove "/children/storage-pool/%id", uuid

  replaceStoragePool: (uuid, newData) ->
    @_replace "/children/storage-pool/%id/desired", uuid, newData

  mergeStoragePool: (uuid, newData) ->
    @_merge "/children/storage-pool/%id/desired", uuid, newData

  StoragePool: (id) ->
    return new StoragePool this, "/children/storage-pool/%id/", id

  addInstance: (data, id) ->
    _instance = new Instance this, "/children/instance/%id/"
    @_add "add", "/children/instance/%id",data,"[u'host', u'instance']",_instance.id
    return _instance

  removeInstance: (uuid) ->
    @_remove "/children/instance/%id", uuid

  replaceInstance: (uuid, newData) ->
    @_replace "/children/instance/%id/desired", uuid, newData

  mergeInstance: (uuid, newData) ->
    @_merge "/children/instance/%id/desired", uuid, newData

  Instance: (id) ->
    return new Instance this, "/children/instance/%id/", id

  addNic: (data, id) ->
    _nic = new Nic this, "/children/nic/%id/"
    @_add "add", "/children/nic/%id",data,"hwaddr",_nic.id
    return _nic

  removeNic: (uuid) ->
    @_remove "/children/nic/%id", uuid

  replaceNic: (uuid, newData) ->
    @_replace "/children/nic/%id/desired", uuid, newData

  mergeNic: (uuid, newData) ->
    @_merge "/children/nic/%id/desired", uuid, newData

  Nic: (id) ->
    return new Nic this, "/children/nic/%id/", id

  addImage: (data, id) ->
    _image = new Image this, "/children/image/%id/"
    @_add "add", "/children/image/%id",data,"[u'host', u'image']",_image.id
    return _image

  removeImage: (uuid) ->
    @_remove "/children/image/%id", uuid

  replaceImage: (uuid, newData) ->
    @_replace "/children/image/%id/desired", uuid, newData

  mergeImage: (uuid, newData) ->
    @_merge "/children/image/%id/desired", uuid, newData

  Image: (id) ->
    return new Image this, "/children/image/%id/", id

  addVolume: (data, id) ->
    _volume = new Volume this, "/children/volume/%id/"
    @_add "add", "/children/volume/%id",data,"[u'host', u'volume']",_volume.id
    return _volume

  removeVolume: (uuid) ->
    @_remove "/children/volume/%id", uuid

  replaceVolume: (uuid, newData) ->
    @_replace "/children/volume/%id/desired", uuid, newData

  mergeVolume: (uuid, newData) ->
    @_merge "/children/volume/%id/desired", uuid, newData

  Volume: (id) ->
    return new Volume this, "/children/volume/%id/", id

  addCpuProfile: (data, id) ->
    _cpuprofile = new CpuProfile this, "/children/cpu-profile/%id/"
    @_add "add", "/children/cpu-profile/%id",data,"[u'host', u'cpu_profile']",_cpuprofile.id
    return _cpuprofile

  removeCpuProfile: (uuid) ->
    @_remove "/children/cpu-profile/%id", uuid

  replaceCpuProfile: (uuid, newData) ->
    @_replace "/children/cpu-profile/%id/desired", uuid, newData

  mergeCpuProfile: (uuid, newData) ->
    @_merge "/children/cpu-profile/%id/desired", uuid, newData

  CpuProfile: (id) ->
    return new CpuProfile this, "/children/cpu-profile/%id/", id

  addDisk: (data, id) ->
    _disk = new Disk this, "/children/disk/%id/"
    @_add "add", "/children/disk/%id",data,"[u'host', u'disk']",_disk.id
    return _disk

  removeDisk: (uuid) ->
    @_remove "/children/disk/%id", uuid

  replaceDisk: (uuid, newData) ->
    @_replace "/children/disk/%id/desired", uuid, newData

  mergeDisk: (uuid, newData) ->
    @_merge "/children/disk/%id/desired", uuid, newData

  Disk: (id) ->
    return new Disk this, "/children/disk/%id/", id

  addEvent: (data, id) ->
    _event = new Event this, "/children/event/%id/"
    @_add "add", "/children/event/%id",data,"hash",_event.id
    return _event

  removeEvent: (uuid) ->
    @_remove "/children/event/%id", uuid

  replaceEvent: (uuid, newData) ->
    @_replace "/children/event/%id/desired", uuid, newData

  mergeEvent: (uuid, newData) ->
    @_merge "/children/event/%id/desired", uuid, newData

  Event: (id) ->
    return new Event this, "/children/event/%id/", id

  addBond: (data, id) ->
    _bond = new Bond this, "/children/bond/%id/"
    @_add "add", "/children/bond/%id",data,"uuid",_bond.id
    return _bond

  removeBond: (uuid) ->
    @_remove "/children/bond/%id", uuid

  replaceBond: (uuid, newData) ->
    @_replace "/children/bond/%id/desired", uuid, newData

  mergeBond: (uuid, newData) ->
    @_merge "/children/bond/%id/desired", uuid, newData

  Bond: (id) ->
    return new Bond this, "/children/bond/%id/", id


class User extends Entity
  addMember: (data, id) ->
    _member = new Member this, "/children/member/%id/"
    @_add "add", "/children/member/%id",data,"uuid",_member.id
    return _member

  removeMember: (uuid) ->
    @_remove "/children/member/%id", uuid

  replaceMember: (uuid, newData) ->
    @_replace "/children/member/%id/desired", uuid, newData

  mergeMember: (uuid, newData) ->
    @_merge "/children/member/%id/desired", uuid, newData

  Member: (id) ->
    return new Member this, "/children/member/%id/", id


class Address extends Entity

class Tenant extends Entity
  addMember: (data, id) ->
    _member = new Member this, "/children/member/%id/"
    @_add "add", "/children/member/%id",data,"uuid",_member.id
    return _member

  removeMember: (uuid) ->
    @_remove "/children/member/%id", uuid

  replaceMember: (uuid, newData) ->
    @_replace "/children/member/%id/desired", uuid, newData

  mergeMember: (uuid, newData) ->
    @_merge "/children/member/%id/desired", uuid, newData

  Member: (id) ->
    return new Member this, "/children/member/%id/", id

  addInstance: (data, id) ->
    _instance = new Instance this, "/children/instance/%id/"
    @_add "add", "/children/instance/%id",data,"uuid",_instance.id
    return _instance

  removeInstance: (uuid) ->
    @_remove "/children/instance/%id", uuid

  replaceInstance: (uuid, newData) ->
    @_replace "/children/instance/%id/desired", uuid, newData

  mergeInstance: (uuid, newData) ->
    @_merge "/children/instance/%id/desired", uuid, newData

  Instance: (id) ->
    return new Instance this, "/children/instance/%id/", id

  addImage: (data, id) ->
    _image = new Image this, "/children/image/%id/"
    @_add "add", "/children/image/%id",data,"uuid",_image.id
    return _image

  removeImage: (uuid) ->
    @_remove "/children/image/%id", uuid

  replaceImage: (uuid, newData) ->
    @_replace "/children/image/%id/desired", uuid, newData

  mergeImage: (uuid, newData) ->
    @_merge "/children/image/%id/desired", uuid, newData

  Image: (id) ->
    return new Image this, "/children/image/%id/", id

  addQuota: (data, id) ->
    _quota = new Quota this, "/children/quota/%id/"
    @_add "add", "/children/quota/%id",data,"uuid",_quota.id
    return _quota

  removeQuota: (uuid) ->
    @_remove "/children/quota/%id", uuid

  replaceQuota: (uuid, newData) ->
    @_replace "/children/quota/%id/desired", uuid, newData

  mergeQuota: (uuid, newData) ->
    @_merge "/children/quota/%id/desired", uuid, newData

  Quota: (id) ->
    return new Quota this, "/children/quota/%id/", id

  addVolume: (data, id) ->
    _volume = new Volume this, "/children/volume/%id/"
    @_add "add", "/children/volume/%id",data,"uuid",_volume.id
    return _volume

  removeVolume: (uuid) ->
    @_remove "/children/volume/%id", uuid

  replaceVolume: (uuid, newData) ->
    @_replace "/children/volume/%id/desired", uuid, newData

  mergeVolume: (uuid, newData) ->
    @_merge "/children/volume/%id/desired", uuid, newData

  Volume: (id) ->
    return new Volume this, "/children/volume/%id/", id

  addCluster: (data, id) ->
    _cluster = new Cluster this, "/children/cluster/%id/"
    @_add "add", "/children/cluster/%id",data,"uuid",_cluster.id
    return _cluster

  removeCluster: (uuid) ->
    @_remove "/children/cluster/%id", uuid

  replaceCluster: (uuid, newData) ->
    @_replace "/children/cluster/%id/desired", uuid, newData

  mergeCluster: (uuid, newData) ->
    @_merge "/children/cluster/%id/desired", uuid, newData

  Cluster: (id) ->
    return new Cluster this, "/children/cluster/%id/", id

  addSwitch: (data, id) ->
    _switch = new Switch this, "/children/switch/%id/"
    @_add "add", "/children/switch/%id",data,"uuid",_switch.id
    return _switch

  removeSwitch: (uuid) ->
    @_remove "/children/switch/%id", uuid

  replaceSwitch: (uuid, newData) ->
    @_replace "/children/switch/%id/desired", uuid, newData

  mergeSwitch: (uuid, newData) ->
    @_merge "/children/switch/%id/desired", uuid, newData

  Switch: (id) ->
    return new Switch this, "/children/switch/%id/", id


class Route extends Entity

class Switch extends Entity
  addVnic: (data, id) ->
    _vnic = new Vnic this, "/children/vnic/%id/"
    @_add "add", "/children/vnic/%id",data,"uuid",_vnic.id
    return _vnic

  removeVnic: (uuid) ->
    @_remove "/children/vnic/%id", uuid

  replaceVnic: (uuid, newData) ->
    @_replace "/children/vnic/%id/desired", uuid, newData

  mergeVnic: (uuid, newData) ->
    @_merge "/children/vnic/%id/desired", uuid, newData

  Vnic: (id) ->
    return new Vnic this, "/children/vnic/%id/", id

  addNetwork: (data, id) ->
    _network = new Network this, "/children/network/%id/"
    @_add "add", "/children/network/%id",data,"uuid",_network.id
    return _network

  removeNetwork: (uuid) ->
    @_remove "/children/network/%id", uuid

  replaceNetwork: (uuid, newData) ->
    @_replace "/children/network/%id/desired", uuid, newData

  mergeNetwork: (uuid, newData) ->
    @_merge "/children/network/%id/desired", uuid, newData

  Network: (id) ->
    return new Network this, "/children/network/%id/", id


class Bond extends Entity
  addNic: (data, id) ->
    _nic = new Nic this, "/children/nic/%id/"
    @_add "add", "/children/nic/%id",data,"hwaddr",_nic.id
    return _nic

  removeNic: (uuid) ->
    @_remove "/children/nic/%id", uuid

  replaceNic: (uuid, newData) ->
    @_replace "/children/nic/%id/desired", uuid, newData

  mergeNic: (uuid, newData) ->
    @_merge "/children/nic/%id/desired", uuid, newData

  Nic: (id) ->
    return new Nic this, "/children/nic/%id/", id

  addRole: (data, id) ->
    _role = new Role this, "/children/role/%id/"
    @_add "add", "/children/role/%id",data,"uuid",_role.id
    return _role

  removeRole: (uuid) ->
    @_remove "/children/role/%id", uuid

  replaceRole: (uuid, newData) ->
    @_replace "/children/role/%id/desired", uuid, newData

  mergeRole: (uuid, newData) ->
    @_merge "/children/role/%id/desired", uuid, newData

  Role: (id) ->
    return new Role this, "/children/role/%id/", id


class Api extends Entity
  @patchStoragePool: (_storagepool) ->
    return new StoragePool null, "/storage-pool/#{_storagepool}/", _storagepool
  @patchStoragePoolVolume: (_storagepool, _volume) ->
    return new Volume null, "/storage-pool/#{_storagepool}/volume/#{_volume}/", _volume
  @patchStoragePoolDisk: (_storagepool, _disk) ->
    return new Disk null, "/storage-pool/#{_storagepool}/disk/#{_disk}/", _disk
  @patchImage: (_image) ->
    return new Image null, "/image/#{_image}/", _image
  @patchImageVolume: (_image, _volume) ->
    return new Volume null, "/image/#{_image}/volume/#{_volume}/", _volume
  @patchSwitch: (_switch) ->
    return new Switch null, "/switch/#{_switch}/", _switch
  @patchSwitchVnic: (_switch, _vnic) ->
    return new Vnic null, "/switch/#{_switch}/vnic/#{_vnic}/", _vnic
  @patchSwitchNetwork: (_switch, _network) ->
    return new Network null, "/switch/#{_switch}/network/#{_network}/", _network
  @patchSwitchNetworkRoute: (_switch, _network, _route) ->
    return new Route null, "/switch/#{_switch}/network/#{_network}/route/#{_route}/", _route
  @patchSwitchNetworkAddress: (_switch, _network, _address) ->
    return new Address null, "/switch/#{_switch}/network/#{_network}/address/#{_address}/", _address
  @patchCpuProfile: (_cpuprofile) ->
    return new CpuProfile null, "/cpu-profile/#{_cpuprofile}/", _cpuprofile
  @patchHost: (_host) ->
    return new Host null, "/host/#{_host}/", _host
  @patchHostStoragePool: (_host, _storagepool) ->
    return new StoragePool null, "/host/#{_host}/storage-pool/#{_storagepool}/", _storagepool
  @patchHostInstance: (_host, _instance) ->
    return new Instance null, "/host/#{_host}/instance/#{_instance}/", _instance
  @patchHostNic: (_host, _nic) ->
    return new Nic null, "/host/#{_host}/nic/#{_nic}/", _nic
  @patchHostImage: (_host, _image) ->
    return new Image null, "/host/#{_host}/image/#{_image}/", _image
  @patchHostVolume: (_host, _volume) ->
    return new Volume null, "/host/#{_host}/volume/#{_volume}/", _volume
  @patchHostCpuProfile: (_host, _cpuprofile) ->
    return new CpuProfile null, "/host/#{_host}/cpu-profile/#{_cpuprofile}/", _cpuprofile
  @patchHostDisk: (_host, _disk) ->
    return new Disk null, "/host/#{_host}/disk/#{_disk}/", _disk
  @patchHostEvent: (_host, _event) ->
    return new Event null, "/host/#{_host}/event/#{_event}/", _event
  @patchHostBond: (_host, _bond) ->
    return new Bond null, "/host/#{_host}/bond/#{_bond}/", _bond
  @patchHostBondNic: (_host, _bond, _nic) ->
    return new Nic null, "/host/#{_host}/bond/#{_bond}/nic/#{_nic}/", _nic
  @patchHostBondRole: (_host, _bond, _role) ->
    return new Role null, "/host/#{_host}/bond/#{_bond}/role/#{_role}/", _role
  @patchUser: (_user) ->
    return new User null, "/user/#{_user}/", _user
  @patchUserMember: (_user, _member) ->
    return new Member null, "/user/#{_user}/member/#{_member}/", _member
  @patchDisk: (_disk) ->
    return new Disk null, "/disk/#{_disk}/", _disk
  @patchConfig: (_config) ->
    return new Config null, "/config/#{_config}/", _config
  @patchEvent: (_event) ->
    return new Event null, "/event/#{_event}/", _event
  @patchTenant: (_tenant) ->
    return new Tenant null, "/tenant/#{_tenant}/", _tenant
  @patchTenantMember: (_tenant, _member) ->
    return new Member null, "/tenant/#{_tenant}/member/#{_member}/", _member
  @patchTenantInstance: (_tenant, _instance) ->
    return new Instance null, "/tenant/#{_tenant}/instance/#{_instance}/", _instance
  @patchTenantInstanceVdisk: (_tenant, _instance, _vdisk) ->
    return new Vdisk null, "/tenant/#{_tenant}/instance/#{_instance}/vdisk/#{_vdisk}/", _vdisk
  @patchTenantInstanceCluster: (_tenant, _instance, _cluster) ->
    return new Cluster null, "/tenant/#{_tenant}/instance/#{_instance}/cluster/#{_cluster}/", _cluster
  @patchTenantInstanceVnic: (_tenant, _instance, _vnic) ->
    return new Vnic null, "/tenant/#{_tenant}/instance/#{_instance}/vnic/#{_vnic}/", _vnic
  @patchTenantInstanceVnicAddress: (_tenant, _instance, _vnic, _address) ->
    return new Address null, "/tenant/#{_tenant}/instance/#{_instance}/vnic/#{_vnic}/address/#{_address}/", _address
  @patchTenantInstanceEvent: (_tenant, _instance, _event) ->
    return new Event null, "/tenant/#{_tenant}/instance/#{_instance}/event/#{_event}/", _event
  @patchTenantImage: (_tenant, _image) ->
    return new Image null, "/tenant/#{_tenant}/image/#{_image}/", _image
  @patchTenantImageVolume: (_tenant, _image, _volume) ->
    return new Volume null, "/tenant/#{_tenant}/image/#{_image}/volume/#{_volume}/", _volume
  @patchTenantQuota: (_tenant, _quota) ->
    return new Quota null, "/tenant/#{_tenant}/quota/#{_quota}/", _quota
  @patchTenantVolume: (_tenant, _volume) ->
    return new Volume null, "/tenant/#{_tenant}/volume/#{_volume}/", _volume
  @patchTenantVolumeVdisk: (_tenant, _volume, _vdisk) ->
    return new Vdisk null, "/tenant/#{_tenant}/volume/#{_volume}/vdisk/#{_vdisk}/", _vdisk
  @patchTenantCluster: (_tenant, _cluster) ->
    return new Cluster null, "/tenant/#{_tenant}/cluster/#{_cluster}/", _cluster
  @patchTenantClusterInstance: (_tenant, _cluster, _instance) ->
    return new Instance null, "/tenant/#{_tenant}/cluster/#{_cluster}/instance/#{_instance}/", _instance
  @patchTenantSwitch: (_tenant, _switch) ->
    return new Switch null, "/tenant/#{_tenant}/switch/#{_switch}/", _switch
  @patchTenantSwitchVnic: (_tenant, _switch, _vnic) ->
    return new Vnic null, "/tenant/#{_tenant}/switch/#{_switch}/vnic/#{_vnic}/", _vnic
  @patchTenantSwitchNetwork: (_tenant, _switch, _network) ->
    return new Network null, "/tenant/#{_tenant}/switch/#{_switch}/network/#{_network}/", _network
  @patchTenantSwitchNetworkRoute: (_tenant, _switch, _network, _route) ->
    return new Route null, "/tenant/#{_tenant}/switch/#{_switch}/network/#{_network}/route/#{_route}/", _route
  @patchTenantSwitchNetworkAddress: (_tenant, _switch, _network, _address) ->
    return new Address null, "/tenant/#{_tenant}/switch/#{_switch}/network/#{_network}/address/#{_address}/", _address
s = angular.module "rainbowPatchApi", []
s.factory "Api", () -> return Api

