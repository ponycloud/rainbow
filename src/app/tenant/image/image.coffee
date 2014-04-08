module = angular.module 'tenant-image', []

module.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:tenant/image', {
    templateUrl: 'tenant/image/image-list.tpl.html',
    controller: 'ImageListCtrl'
  }
]

module.controller 'ImageListCtrl',
  class ImageListCtrl
    @inject = ['$scope', '$routeParams', 'TenantImage']

    constructor: ($scope, $routeParams, TenantImage) ->
      $scope.images = TenantImage.get {'tenant': $routeParams.tenant}
