###
Directive that rewrites value of a given model to 'null'
if the value of a model is an empty string
###

module = angular.module 'rainbowDirectives'

module.directive 'emptyToNull', ($parse) ->
  restrict: 'A'
  require: 'ngModel'

  link: (scope, element, attrs, ctrl) ->
    ctrl.$parsers.push (viewValue) ->
      if viewValue?
        if viewValue is ""
          return null
        return viewValue


