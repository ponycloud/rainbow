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
        $scope.switchListModal.hide()

      $scope.createSwitch = () ->
          newSwitch = new TenantSwitch()
          newSwitch.desired = {'name': $scope.switch.name, 'type': $scope.switch.type}
          newSwitch.$save({'tenant': $routeParams.tenant}, (response) ->
            # Construct data to push to the list.
            $scope.switchListModal.hide()
          )

      $scope.deleteSelected = (items) ->
        patch = []
        params =
          tenant: $routeParams.tenant
        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantSwitch.patch(params, patch)


module.controller 'SwitchDetailCtrl',
  class SwitchDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantSwitch', 'TenantSwitchNetwork', 'dataContainer', '$modal']

    constructor: ($scope, $routeParams, TenantSwitch, TenantSwitchNetwork, dataContainer, $modal) ->
      TenantSwitch.get({'tenant': $routeParams.tenant, 'switch': $routeParams.switch}).$promise.then((item) ->
        $scope.switch = item
        dataContainer.registerResource $scope.switch, $scope.switch.desired.uuid
      )

      TenantSwitchNetwork.list({'tenant': $routeParams.tenant, 'switch': $routeParams.switch}).$promise.then((networks) ->
        $scope.networks = networks
        dataContainer.registerEntity 'network', $scope.networks
      )

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
          #$scope.message("Switch modified", 'success')
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
        newNetwork.$save
          tenant: $routeParams.tenant
          switch: $routeParams.switch
          (response) ->
            $scope.networkModal.hide()

      $scope.deleteSelectedNetworks = (items) ->
        patch = []
        params =
          tenant: $routeParams.tenant
          switch: $routeParams.switch,
        for item in items
          patch.push({'op': 'remove', 'path': '/'+item})
        TenantSwitchNetwork.patch(params, patch)


      $scope.networkModalOpen = () ->
        $scope.networkModal.show()
        $scope.network = {}

      $scope.networkModalClose = () ->
        $scope.networkModal.hide()
