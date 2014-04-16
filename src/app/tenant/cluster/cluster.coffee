module = angular.module 'tenant-cluster', ['rainbowServices']

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/cluster', {
    templateUrl: 'tenant/cluster/cluster-list.tpl.html',
    controller: 'ClusterListCtrl'
  }
  $routeProvider.when '/:tenant/cluster/:cluster', {
    templateUrl:'tenant/cluster/cluster-detail.tpl.html',
    controller: 'ClusterDetailCtrl'
  }
]

module.controller 'ClusterListCtrl',
  class ClusterListCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantCluster', 'dataContainer']

    constructor: ($scope, $rootScope, $routeParams, TenantCluster, dataContainer) ->
      TenantCluster.list({'tenant': $routeParams.tenant}).$promise.then((clusterList) ->
        $scope.clusters = clusterList
        dataContainer.registerEntity('cluster', $scope.clusters)
      )

      $scope.opts = {
        backdropFade: true,
        dialogFade: true
      }

      $scope.open = (cluster) ->
        $scope.clusterModal = true
        if typeof(cluster) != 'undefined'
          $scope.cluster = cluster.desired
        else
          $scope.cluster = null

      $scope.close = () ->
        $scope.closeMsg = 'I was closed at: ' + new Date()
        $scope.clusterModal = false
        false

      $scope.createCluster = () ->
          newCluster = new TenantCluster()
          newCluster.desired = {'name': $scope.cluster.name}
          newCluster.$save({'tenant': $routeParams.tenant}, (response) ->
            # Construct data to push to the list.
            $scope.clusters.push({'desired': {'uuid':response.uuids.POST, 'name': $scope.cluster.name}})
            #$scope.message("Cluster created", 'success')
          )

      $scope.modifyCluster = () ->
        if typeof($scope.cluster.uuid) == 'undefined'
          $scope.createCluster()
        else
          $scope.editCluster()
        $scope.close()

      $scope.editCluster = () ->
        patch = JSON.stringify([{'op': 'x-merge', 'path': '/desired', 'value': {'name': $scope.cluster.name}}])
        params = {'tenant': $routeParams.tenant, 'cluster': $scope.cluster.uuid}
        TenantCluster.patch(params, patch, () ->
          $scope.message("Cluster modified", 'success')
        )

      $scope.deleteCluster = (cluster, index) ->
        position = $scope.clusters.indexOf(cluster)
        params = {'tenant': $routeParams.tenant, 'cluster': cluster.desired.uuid}
        TenantCluster.delete(params, () ->
          $scope.clusters.splice(position,1)
          $scope.message("Cluster deleted", 'success')
        )


module.controller 'ClusterDetailCtrl',
  class ClusterDetailCtrl
    @inject = ['$scope', '$rootScope', '$routeParams', 'TenantCluster', 'dataContainer']

    constructor: ($scope, $routeParams, TenantCluster, TenantClusterInstanceJoin) ->
      $scope.cluster = TenantCluster.get({'tenant': $routeParams.tenant, 'cluster': $routeParams.cluster})
      $scope.instances = TenantClusterInstanceJoin.list({'tenant': $routeParams.tenant, 'cluster': $routeParams.cluster})

