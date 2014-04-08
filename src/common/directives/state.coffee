module = angular.module 'rainbowDirectives'

module.directive 'state', () ->
  restrict: 'E'
  templateUrl: 'partials/directives/state.html'
  require: '?ngModel'
  scope:
    model: '=ngModel'
    attr: '@ngAttr'
  replace: true
  controller: () ->

