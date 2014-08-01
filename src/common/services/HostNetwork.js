// Generated by CoffeeScript 1.7.1
(function() {
  var factoryFunction, s;

  s = angular.module('rainbowServices');

  factoryFunction = function(Api, Host, HostNic, HostBond, HostBondRole, $http, $q) {
    return {
      getNetwork: function(hostUuid) {
        var bonds, nics, promise;
        bonds = HostBond.list({
          'host': hostUuid
        });
        nics = HostNic.list({
          'host': hostUuid
        });
        promise = $q.all([bonds.$promise, nics.$promise]);
        return promise;
      },
      composeNetwork: function(hostUuid, items) {
        var index, index_nic, nic, obj, promises, result, _i, _j, _len, _len1, _ref, _ref1;
        result = {
          'bonds': items[0],
          'nics': items[1]
        };
        promises = [];
        _ref = items[0];
        for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
          obj = _ref[index];
          result.bonds[index].desired.roles = HostBondRole.list({
            'host': hostUuid,
            'bond': result.bonds[index].desired.uuid
          });
          result.bonds[index].desired.nics = [];
          promises.push(result.bonds[index].desired.roles.$promise);
          _ref1 = items[1];
          for (index_nic = _j = 0, _len1 = _ref1.length; _j < _len1; index_nic = ++_j) {
            nic = _ref1[index_nic];
            if (result.nics[index_nic].desired.bond === result.bonds[index].desired.uuid) {
              result.bonds[index].desired.nics.push(result.nics[index_nic]);
            }
          }
        }
        return {
          'promise': $q.all(promises),
          'result': result
        };
      },
      saveNetwork: function(hostUuid, networkData, originalData) {
        var b, bond, counter, diff, getBondData, getDiff, host, is_empty, newBond, newBonds, newNics, newRoles, nic, oldBonds, role, uuid, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _len6, _len7, _m, _n, _o, _p, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
        _ref = [{}, {}, {}], oldBonds = _ref[0], newBonds = _ref[1], newNics = _ref[2];
        counter = 0;
        _ref1 = originalData.bonds;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          bond = _ref1[_i];
          oldBonds[bond.desired.uuid] = bond.desired;
        }
        _ref2 = networkData.bonds;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          bond = _ref2[_j];
          newBonds[bond.desired.uuid || ++counter] = bond.desired;
        }
        host = Api.patchHost(hostUuid);
        is_empty = function(obj) {
          var key;
          if ((obj == null) || obj.length === 0) {
            return true;
          }
          if ((obj.length != null) && obj.length > 0) {
            return false;
          }
          for (key in obj) {
            if (Object.prototype.hasOwnProperty.call(obj, key)) {
              return false;
            }
          }
          return true;
        };
        getDiff = function(oldObj, newObj) {
          var diff, key, keys, val, _k, _len2;
          diff = {};
          keys = [];
          for (key in oldObj) {
            val = oldObj[key];
            keys.push(key);
          }
          for (key in newObj) {
            val = newObj[key];
            keys.push(key);
          }
          for (_k = 0, _len2 = keys.length; _k < _len2; _k++) {
            key = keys[_k];
            if (key[0] === '$' || key[0] === '_') {
              continue;
            }
            if (newObj[key] instanceof Array || oldObj[key] instanceof Array) {
              continue;
            }
            if (!oldObj[key] && newObj[key]) {
              diff[key] = newObj[key];
            } else if (oldObj[key] && !newObj[key]) {
              diff[key] = null;
            } else {
              if (newObj[key] !== oldObj[key]) {
                diff[key] = newObj[key];
              }
            }
          }
          if (is_empty(diff)) {
            return false;
          }
          return diff;
        };
        getBondData = function(bond) {
          return {
            "mode": bond['mode'],
            "xmit_hash_policy": bond['xmit_hash_policy'],
            "lacp_rate": bond['lacp_rate']
          };
        };
        for (uuid in oldBonds) {
          bond = oldBonds[uuid];
          if (!newBonds[uuid]) {
            host.removeBond(uuid);
          }
        }
        for (uuid in newBonds) {
          bond = newBonds[uuid];
          newRoles = {};
          if (!bond.uuid) {
            b = getBondData(bond);
            newBond = host.addBond({
              "desired": b
            });
            _ref3 = bond.roles;
            for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
              role = _ref3[_k];
              newBond.addRole({
                "desired": role.desired
              });
            }
            _ref4 = bond.nics;
            for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
              nic = _ref4[_l];
              newNics[nic.desired.hwaddr] = nic.desired;
              host.mergeNic(nic.desired.hwaddr, {
                'bond': newBond.id
              });
            }
          } else {
            diff = getDiff(oldBonds[uuid], bond);
            if (diff) {
              host.mergeBond(uuid, diff);
            }
            _ref5 = bond.roles;
            for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
              role = _ref5[_m];
              newRoles[role.desired.role] = role.desired;
              if (!role.desired.uuid) {
                host.Bond(uuid).addRole({
                  "desired": role.desired
                });
              }
            }
            _ref6 = oldBonds[uuid].roles;
            for (_n = 0, _len5 = _ref6.length; _n < _len5; _n++) {
              role = _ref6[_n];
              if (!newRoles[role.desired.role]) {
                host.Bond(uuid).removeRole(role.desired.uuid);
              } else {
                diff = getDiff(role.desired, newRoles[role.desired.role]);
                console.log(diff);
                if (diff) {
                  host.Bond(uuid).mergeRole(role.desired.uuid, diff);
                }
              }
            }
            _ref7 = bond.nics;
            for (_o = 0, _len6 = _ref7.length; _o < _len6; _o++) {
              nic = _ref7[_o];
              newNics[nic.desired.hwaddr] = nic.desired;
              if (!nic.desired.bond) {
                host.mergeNic(nic.desired.hwaddr, {
                  'bond': uuid
                });
              }
            }
          }
        }
        for (uuid in newBonds) {
          bond = newBonds[uuid];
          if (!oldBonds[uuid]) {
            continue;
          }
          _ref8 = oldBonds[uuid].nics;
          for (_p = 0, _len7 = _ref8.length; _p < _len7; _p++) {
            nic = _ref8[_p];
            if (!newNics[nic.desired.hwaddr]) {
              host.mergeNic(nic.desired.hwaddr, {
                'bond': null
              });
            }
          }
        }
        console.log(JSON.stringify(host.ops));
        return Host.patch({
          'host': hostUuid
        }, JSON.stringify(host.ops));
      }
    };
  };

  s.factory('HostNetwork', factoryFunction);

}).call(this);
