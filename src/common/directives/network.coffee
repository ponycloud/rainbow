module = angular.module 'rainbowDirectives', []

module.directive 'networkInterfaces', () ->
  restrict: 'E'
  templateUrl: '../common/directives/network-interfaces.html'
  require: '?ngModel'
  replace: true
  scope:
    ngModel: '='
    saveFunction: '='

  link: (scope, element, attrs) ->
    scope.$watch 'ngModel.nics', () ->
      if scope.ngModel.nics?
        for nic,index in scope.ngModel.nics
          scope.availableNics[nic.desired.hwaddr] = {enabled: true}

    scope.$watch 'ngModel.bonds', () ->
      if scope.ngModel.bonds?
        for bond in scope.ngModel.bonds
          bond.desired.roles.$promise.then (roles) ->
            for role in roles
              scope.availableRoles[role.desired.role].enabled = false

          for nic in bond.desired.nics
            scope.availableNics[nic.desired.hwaddr].enabled = false

  controller: ($scope) ->
    $scope.roleDefaults = {}
    $scope.availableNics = {}

    $scope.availableRoles =
      public: name: "Public", enabled: true
      management:name: "Management", enabled: true
      storage: name: "Storage", enabled: true
      virtual: name: "Virtual", enabled: true
      core: name: "Core", enabled: true

    $scope.addNicRole = (bond, role) ->
      if $scope.availableRoles[role].enabled
        new_role = desired:
          role: role
          address: null

        if $scope.roleDefaults[role]
          new_role.desired.vlan_id = $scope.roleDefaults[role].vlan_id
          new_role.desired.address = $scope.roleDefaults[role].address

        bond.desired.roles.push new_role
        $scope.availableRoles[role].enabled = false

    $scope.removeNicRole = (bond, index) ->
      role = bond.desired.roles[index].desired
      $scope.roleDefaults[role.role] =
        vlan_id: role.vlan_id
        address: role.address

      $scope.availableRoles[role.role].enabled = true
      bond.desired.roles.splice index, 1

    $scope.removeNicRole = (bond, index) ->
      role = bond.desired.roles[index].desired
      $scope.roleDefaults[role.role] =
        vlan_id: role.vlan_id
        address: role.address

      $scope.availableRoles[role.role].enabled = true
      bond.desired.roles.splice index, 1

    $scope.addNic = (bond, mac) ->
      if $scope.availableNics[mac].enabled
        bond.desired.nics.push desired:
          hwaddr: mac
        $scope.availableNics[mac].enabled = false

    $scope.addAllAvailableResources = (bond, resource) ->
      res = if resource == 'nic' then  $scope.availableNics else $scope.availableRoles
      add_function = if resource == 'nic' then $scope.addNic else $scope.addNicRole
      add_function bond, key for key, item of res when item.enabled

    $scope.removeNic = (bond, index) ->
      nic = bond.desired.nics[index]
      $scope.availableNics[nic.desired.hwaddr].enabled = true
      bond.desired.nics.splice index, 1

    $scope.removeAggregation = (index) ->
      bond = $scope.ngModel.bonds[index]

      for i in [(bond.desired.roles.length - 1)..0]
        $scope.removeNicRole bond, i

      $scope.ngModel.bonds.splice index, 1

    $scope.createAggregation = () ->
      $scope.ngModel.bonds.push desired:
        mode: 'active-backup'
        roles: []
        nics: []

    $scope.hasAvailableResource = (resource) ->
      # todo: optimize (called too many times, store results somewhere)
      res = if resource == "nic" then $scope.availableNics else $scope.availableRoles
      count = 0
      count++ for item of res when item.enabled
      count > 0

    $scope.saveNetwork = () -> $scope.saveFunction()

    $('#availableItemsAffix').affix
      offset: 55
