angular.module('tenant-cluster', [])

.config(['$routeProvider', function ($routeProvider) {
  $routeProvider
      .when('/:tenant/cluster', {
        templateUrl:'tenant/cluster/cluster-list.tpl.html', controller:'ClusterListCtrl'
      })
      .when('/:tenant/cluster/:cluster', {
        templateUrl:'tenant/cluster/cluster-detail.tpl.html', controller:'ClusterDetailCtrl'
      });
}])

.controller('ClusterListCtrl', ['$scope', '$rootScope', '$routeParams', 'TenantCluster', 'dataContainer',

    function ($scope, $rootScope, $routeParams, TenantCluster, dataContainer) {
       TenantCluster.list({'tenant': $routeParams.tenant}).$promise.then(function(i) {
        $scope.clusters = i;
        dataContainer.registerEntity('cluster', $scope.clusters);
    });

    $scope.open = function () {
        $scope.shouldBeOpen = true;
    };

    $scope.close = function () {
        $scope.closeMsg = 'I was closed at: ' + new Date();
        $scope.shouldBeOpen = false;
    };

    $scope.items = ['item1', 'item2'];

    $scope.opts = {
        backdropFade: true,
        dialogFade:true
    };

    $scope.createCluster = function() {
        var newCluster = new TenantCluster();
        newCluster.name = $scope.cluster.name;
        newCluster.$save({'tenant': $routeParams.tenant}, function(response) {
            $scope.clusters.push({'desired': response});
            $scope.message("Cluster created", 'success');
        });
    }

    $scope.deleteCluster = function(cluster, index) {
        var position = $scope.clusters.indexOf(cluster);
        TenantCluster.delete({'tenant': $routeParams.tenant, 'cluster': cluster.desired.uuid}, function() {
            $scope.clusters.splice(position,1);
            $scope.message("Cluster deleted", 'success');
        });
    }
}])

.controller('ClusterDetailCtrl', ['$scope', '$routeParams', 'TenantCluster',
    function ($scope, $routeParams, TenantCluster) {
        $scope.cluster = TenantCluster.get({'tenant': $routeParams.tenant, 'cluster': $routeParams.cluster});
    }
]);