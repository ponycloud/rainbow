module = angular.module 'tenant-affinity-group', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/affinity-group', {
    templateUrl: 'tenant/affinity-group/affinity-group-list.tpl.html',
    controller: 'AffinityGroupListCtrl'
  }
  $routeProvider.when '/:tenant/affinity-group/:affinity_group', {
    templateUrl:'tenant/affinity-group/affinity-group-detail.tpl.html',
    controller: 'AffinityGroupDetailCtrl'
  }
]

module.controller 'AffinityGroupListCtrl',
  class AffinityGroupListCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'dataContainer']

    constructor: ($scope, $rootScope, $routeParams, TenantAffinityGroup, dataContainer) ->
      TenantAffinityGroup.list({'tenant': $routeParams.tenant}).$promise.then((affinityGroupList) ->
        $scope.affinityGroups = affinityGroupList
        dataContainer.registerEntity('affinityGroup', $scope.affinityGroups)
      )

      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      }

      $scope.open = (affinityGroup) ->
        $scope.affinityGroupModal = true
        if typeof(affinityGroup) != 'undefined'
          $scope.affinityGroup = affinityGroup.desired
        else
          $scope.affinityGroup = null

      $scope.close = () ->
        $scope.closeMsg = 'I was closed at: ' + new Date()
        $scope.affinityGroupModal = false
        false

      $scope.createAffinityGroup = () ->
          newAffinityGroup = new TenantAffinityGroup()
          newAffinityGroup.desired = {'name': $scope.affinityGroup.name, 'type': $scope.affinityGroup.type}
          newAffinityGroup.$save({'tenant': $routeParams.tenant}, (response) ->
            # Construct data to push to the list.
            $scope.affinityGroups.push({'desired': {'uuid':response.uuids.POST, 'name': $scope.affinityGroup.name}})
            #$scope.message("AffinityGroup created", 'success')
          )

      $scope.modifyAffinityGroup = () ->
        if typeof($scope.affinityGroup.uuid) == 'undefined'
          $scope.createAffinityGroup()
        else
          $scope.editAffinityGroup()
        $scope.close()

      $scope.editAffinityGroup = () ->
        patch = JSON.stringify([{'op': 'x-merge', 'path': '/desired', 'value': {
            'name': $scope.affinityGroup.name,
            'type': $scope.affinityGroup.type
        }}])
        params = {'tenant': $routeParams.tenant, 'affinity_group': $scope.affinityGroup.uuid}
        TenantAffinityGroup.patch(params, patch, () ->
          $scope.message("Affinity group modified", 'success')
        )

      $scope.deleteAffinityGroup = (affinityGroup, index) ->
        position = $scope.affinityGroups.indexOf(affinityGroup)
        params = {'tenant': $routeParams.tenant, 'affinity_group': affinityGroup.desired.uuid}
        TenantAffinityGroup.delete(params, () ->
          $scope.affinityGroups.splice(position,1)
          $scope.message("Affinity group deleted", 'success')
        )


module.controller 'AffinityGroupDetailCtrl',
  class AffinityGroupDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'dataContainer']

    constructor: ($scope, $routeParams, TenantAffinityGroup, TenantAffinityGroupInstanceJoin) ->
      $scope.affinityGroup = TenantAffinityGroup.get({'tenant': $routeParams.tenant, 'affinity_group': $routeParams.affinity_group})
      $scope.instances = TenantAffinityGroupInstanceJoin.list({'tenant': $routeParams.tenant, 'affinity_group': $routeParams.affinity_group})

