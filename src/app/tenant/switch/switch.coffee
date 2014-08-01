module = angular.module 'tenantSwitch', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/switch', {
    templateUrl: 'tenant/switch/switch-list.tpl.html',
    controller: 'SwitchListCtrl'
  }
  $routeProvider.when '/:tenant/switch/:switch', {
    templateUrl:'tenant/switch/switch-detail.tpl.html',
    controller: 'SwitchDetailCtrl'
  }
]

module.controller 'SwitchListCtrl',
  class SwitchListCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantSwitch', 'dataContainer']

    constructor: ($scope, $rootScope, $routeParams, TenantSwitch, dataContainer, $modal, @$location) ->
      TenantSwitch.list({'tenant': $routeParams.tenant}).$promise.then((switchList) ->
        $scope.switches = switchList
        dataContainer.registerEntity('switch', $scope.switches)
      )
      $scope.switchListModal = $modal({scope: $scope, template: 'tenant/switch/switch-list-modal.tpl.html', show: false})

      $scope.open = () ->
        $scope.switchListModal.show()
        $scope.switch = {}

      $scope.close = () ->
        $scope.closeMsg = 'I was closed at: ' + new Date()
        $scope.switchListModal.hide()
        false

      $scope.createSwitch = () ->
          newSwitch = new TenantSwitch()
          newSwitch.desired = {'name': $scope.switch.name, 'type': $scope.switch.type}
          newSwitch.$save({'tenant': $routeParams.tenant}, (response) ->
            # Construct data to push to the list.
            $scope.switch.uuid = response.uuids.POST
            $scope.switches.push({'desired': $scope.switch})
            $scope.switchListModal.hide()
          )

      $scope.deleteSwitch = (uuid) ->
        params = {'tenant': $routeParams.tenant, 'switch': uuid}
        TenantSwitch.delete(params, () ->
          $scope.switches = $scope.switches.filter(
            (item) ->
              item.desired.uuid != uuid
          )
          #$scope.message("Switch deleted", 'success')
        )

      $scope.deleteSelected = (items) ->
        for item in items
          $scope.deleteSwitch item


module.controller 'SwitchDetailCtrl',
  class SwitchDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantSwitch', 'TenantSwitchNetwork', 'dataContainer', '$modal']

    constructor: ($scope, $routeParams, TenantSwitch, TenantSwitchNetwork, $modal) ->
      $scope.switch = TenantSwitch.get({'tenant': $routeParams.tenant, 'switch': $routeParams.switch})
      $scope.networks = TenantSwitchNetwork.list({'tenant': $routeParams.tenant, 'switch': $routeParams.switch})

      $scope.switchEditModal = $modal({keyboard: true, scope: $scope, template: 'tenant/switch/switch-edit-modal.tpl.html', show: false})
      $scope.networkModal = $modal({keyboard: true, scope: $scope, template: 'tenant/switch/network-list-modal.tpl.html', show: false})


      # Save the switch form
      $scope.editSwitch = () ->
        patch = JSON.stringify([{'op': 'x-merge', 'path': '/desired', 'value': {
              'name': $scope.switch.desired.name,
              'type': $scope.switch.desired.type,
              'tag' : if $scope.switch.desired.tag == '' then null else $scope.switch.desired.tag
        }}])
        params = {'tenant': $routeParams.tenant, 'switch': $scope.switch.desired.uuid}
        TenantSwitch.patch(params, patch, () ->
          $scope.close(true)
          $scope.message("Switch modified", 'success')
        )

      # Open the modal of the switch details
      $scope.open = () ->
        $scope.switchEditModal.show()

      $scope.close = (suppress_update=false) ->
        $scope.switchEditModal.hide()
        if !suppress_update
          $scope.switch = TenantSwitch.get({'tenant': $routeParams.tenant, 'switch': $routeParams.switch})
        false

      $scope.createNetwork = () ->
        newNetwork = new TenantSwitchNetwork()
        newNetwork.desired = {'range': $scope.network.range, 'vlan_tag': $scope.network.vlan_tag}
        newNetwork.$save({'tenant': $routeParams.tenant, 'switch': $routeParams.switch}, (response) ->
          # Construct data to push to the list.
          $scope.network.uuid = response.uuids.POST
          $scope.networks.push({'desired': $scope.network})
          $scope.networkModal.hide()
        )

      $scope.deleteNetwork = (uuid) ->
        params = {'tenant': $routeParams.tenant, 'switch': $routeParams.switch, 'network': uuid}
        TenantSwitchNetwork.delete(params, () ->
          $scope.networks = $scope.networks.filter(
            (item) ->
              item.desired.uuid != uuid
          )
          #$scope.message("Network deleted", 'success')
        )
      $scope.deleteSelectedNetworks = (items) ->
        for item in items
          $scope.deleteNetwork item

      $scope.networkModalOpen = () ->
        $scope.networkModal.show()
        $scope.network = {}

      $scope.networkModalClose = () ->
        $scope.networkModal.hide()
