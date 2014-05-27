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

      $scope.deleteAffinityGroup = (affinityGroup, index) ->
        position = $scope.affinityGroups.indexOf(affinityGroup)
        params = {'tenant': $routeParams.tenant, 'affinity_group': affinityGroup.desired.uuid}
        TenantAffinityGroup.delete(params, () ->
          $scope.affinityGroups.splice(position,1)
          $scope.message("Affinity group deleted", 'success')
        )


module.controller 'AffinityGroupDetailCtrl',
  class AffinityGroupDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantAffinityGroup', 'TenantInstance', 'TenantAffinityGroupInstance', 'dataContainer']

    constructor: ($scope, $routeParams, TenantAffinityGroup, TenantAffinityGroupInstanceJoin, TenantInstance, TenantAffinityGroupInstance) ->
      $scope.affinityGroup = TenantAffinityGroup.get({'tenant': $routeParams.tenant, 'affinity_group': $routeParams.affinity_group})
      $scope.instances = TenantAffinityGroupInstanceJoin.list({'tenant': $routeParams.tenant, 'affinity_group': $routeParams.affinity_group})
      console.log($scope.instances)
      TenantInstance.list({'tenant': $routeParams.tenant}).$promise.then((allInstances) ->
        $scope.allInstances = allInstances
        $scope.filteredInstances = $scope.filterUsedInstances(allInstances, $scope.instances)
       )

      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      }

      # Filter those instances that are not linked
      $scope.filterUsedInstances = (all, linked) ->
        filtered = []
        for item, key in all
          isLinked = false
          for linkedItem in linked
            if item.desired.uuid == linkedItem.desired.uuid
              isLinked = true
              break
          if !isLinked
            filtered.push item

        return filtered

      # Save the affinity group form
      $scope.editAffinityGroup = () ->
        patch = JSON.stringify([{'op': 'x-merge', 'path': '/desired', 'value': {
              'name': $scope.affinityGroup.desired.name,
              'type': $scope.affinityGroup.desired.type
        }}])
        params = {'tenant': $routeParams.tenant, 'affinity_group': $scope.affinityGroup.desired.uuid}
        TenantAffinityGroup.patch(params, patch, () ->
          $scope.close()
          $scope.message("Affinity group modified", 'success')
        )

      $scope.link = (instance) ->
        newLink = new TenantAffinityGroupInstance()
        desired = {'affinity_group': $routeParams.affinity_group, 'instance': instance.desired.uuid}
        newLink.desired = desired
        newLink.$save({
          'tenant': $routeParams.tenant,
          'affinity_group': $routeParams.affinity_group,
        }, (response) ->
          desired['uuid'] = response.uuids.POST
          instance['joined'] = {}
          instance['joined'][desired.uuid] = desired
          console.log instance
          $scope.instances.push instance
          $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances)
        )

      $scope.unlink = (instance) ->
        for key of instance.joined
          params = {'tenant': $routeParams.tenant, 'affinity_group': $routeParams.affinity_group, 'instance': key}
          TenantAffinityGroupInstance.delete(params, (response) ->
          # Remove from instances
          $scope.instances = $scope.instances.filter(
            (item) ->
              item.desired.uuid != instance.desired.uuid
            )
          )
          $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances)

      # Open the modal of the aff. group details
      $scope.open = (affinityGroup) ->
        $scope.affinityGroupModal = true

      $scope.close = () ->
        $scope.affinityGroupModal = false
        false

      # Open the modal with unlinked instances
      $scope.instanceListOpen = () ->
        $scope.filteredInstances = $scope.filterUsedInstances($scope.allInstances, $scope.instances)
        $scope.instanceListModal = true

      $scope.instanceListClose = () ->
        $scope.instanceListModal = false
        false

