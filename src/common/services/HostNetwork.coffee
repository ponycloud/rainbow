s = angular.module 'rainbowServices'

factoryFunction = (Api, Host, HostNic, HostBond, HostBondRole, $http, $q) ->
  getNetwork: (hostUuid) ->
    bonds = HostBond.list {'host': hostUuid}
    nics =  HostNic.list {'host': hostUuid}
    promise =  $q.all [bonds.$promise, nics.$promise]
    return promise

  composeNetwork: (hostUuid, items) ->
    result = {
      'bonds': items[0],
      'nics': items[1]
    }

    promises = []

    for obj, index in items[0]
      result.bonds[index].desired.roles = HostBondRole.list({'host': hostUuid, 'bond': result.bonds[index].desired.uuid})
      result.bonds[index].desired.nics = []
      promises.push result.bonds[index].desired.roles.$promise
      for nic, index_nic in items[1]
        if result.nics[index_nic].desired.bond == result.bonds[index].desired.uuid
          result.bonds[index].desired.nics.push(result.nics[index_nic])

    return {'promise': $q.all(promises), 'result': result}

  saveNetwork: (hostUuid, networkData, originalData) ->

    [oldBonds, newBonds, newNics] = [{}, {}, {}]

    counter = 0
    oldBonds[bond.desired.uuid] = bond.desired for bond in originalData.bonds
    newBonds[bond.desired.uuid or ++counter] = bond.desired for bond in networkData.bonds

    host = Api.patchHost hostUuid

    is_empty = (obj) ->
      return true if not obj? or obj.length is 0
      return false if obj.length? and obj.length > 0

      for key of obj
          return false if Object.prototype.hasOwnProperty.call(obj,key) 
      return true

    getDiff = (oldObj, newObj) ->
      diff = {}
      keys = []
      keys.push key for key, val of oldObj
      keys.push key for key, val of newObj
      for key in keys
        if key[0] == '$' or key[0] == '_'
          continue
        if newObj[key] instanceof Array or oldObj[key] instanceof Array
          continue
        if !oldObj[key] and newObj[key]
          diff[key] = newObj[key]
        else if oldObj[key] and !newObj[key]
          diff[key] = null
        else
          diff[key] = newObj[key] if newObj[key] != oldObj[key]

      if is_empty diff
        return false
      return diff

    getBondData = (bond) ->
      return {
        "mode": bond['mode'],
        "xmit_hash_policy": bond['xmit_hash_policy'],
        "lacp_rate": bond['lacp_rate']
      }

    for uuid, bond of oldBonds
      if !newBonds[uuid]
        host.removeBond uuid

    for uuid, bond of newBonds
      newRoles = {}
      if !bond.uuid
          b = getBondData bond
          newBond = host.addBond {"desired": b}

          for role in bond.roles
            newBond.addRole {"desired": role.desired}

          for nic in bond.nics
            newNics[nic.desired.hwaddr] = nic.desired
            host.mergeNic nic.desired.hwaddr, {'bond': newBond.id} # set right bond
      else
        diff = getDiff oldBonds[uuid], bond
        if diff
          host.mergeBond uuid, diff

        for role in bond.roles
          newRoles[role.desired.role] = role.desired
          if !role.desired.uuid
            host.Bond(uuid).addRole {"desired": role.desired}

        for role in oldBonds[uuid].roles
          if !newRoles[role.desired.role]
            host.Bond(uuid).removeRole role.desired.uuid
          else
            diff = getDiff role.desired, newRoles[role.desired.role]
            console.log diff
            if diff
              host.Bond(uuid).mergeRole role.desired.uuid, diff

        for nic in bond.nics
          newNics[nic.desired.hwaddr] = nic.desired
          if !nic.desired.bond
            host.mergeNic nic.desired.hwaddr, {'bond': uuid}

    for uuid, bond of newBonds
      if !oldBonds[uuid]
        continue
      for nic in oldBonds[uuid].nics
        if !newNics[nic.desired.hwaddr]
          host.mergeNic nic.desired.hwaddr, {'bond': null} #delete bond

    console.log JSON.stringify(host.ops)
    Host.patch {'host': hostUuid}, JSON.stringify(host.ops)


s.factory 'HostNetwork', factoryFunction
