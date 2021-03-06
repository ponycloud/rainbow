###
Directive for adding simple checkboxes to tables and create buttons like Delete all.

Usage:

Wrap whole table with some element (like div) with pc-multiactions attribute
directive (no value).

Add <th pc-multiall /></th> to your table header where you need 'select all'
checkbox.

In your ng-repeat add <td pc-multicheck="{{ affinityGroup.desired.uuid }}"></td>to insert checkbox to select that item. Value of multicheck directive should be identifier of given item. This will be returned by getSelected() method.

Add button for your action and pass result of getSelected() to your function.

You can use <pc-multieditbutton ></pc-multieditbutton> to add button that turns on/off edit mode.

Example:

<div pc-multiactions>
    <pc-multieditbutton ></pc-multieditbutton>
    <table class="table table-striped table-responsive table-hover">
    <tr>
     <th pc-multiall></th>
     <th>Name</th>
    </tr>
    <tr ng-repeat="item in items">
        <td pc-multicheck="{{ item.ud }}"></td>
        <td>...</td>
    </tr>
    </table>
    <button class="btn btn-danger" ng-click="deleteSelected(getSelected())">
         <i class="icon-plus-sign icon-white"></i>Delete selected
    </button>
</div>
###

module = angular.module 'rainbowDirectives'

module.directive 'pcMultiactions', ($parse, $filter, $compile) ->
  restrict: 'A',
  scope: true

  link: (scope, element, attrs) ->
    scope.selected = []
    scope.editMode = false
    scope.all = []

  controller: ($scope) ->
    $scope.select = (id) ->
        if !$scope.isSelected id
            $scope.selected.push id
            $scope.selected = _.uniq($scope.selected)
        else
            pos = $scope.selected.indexOf id
            $scope.selected.splice pos, 1

    $scope.isSelected = (id) ->
        return $scope.selected.indexOf(id) > -1

    $scope.isAllSelected = () ->
        $scope.all = _.uniq($scope.all)
        for item in $scope.all
          if not $scope.filterSearch $scope.selected, item
            return false
        return true

    $scope.getSelected = () ->
        return $scope.selected

    $scope.selectAll = () ->
        if $scope.isAllSelected()
            $scope.selected = []
        else
            $scope.selected = $scope.all[..]

    $scope.filterSearch = (dict, pattern) ->
      for k of dict
        if typeof dict[k] == "object"
          if $scope.filterSearch dict[k], pattern
            return true
        else if dict[k] == pattern
          return true
      return false

    $scope.switchEdit = () ->
        $scope.editMode = !$scope.editMode

    search = (dict, pattern) ->
      #iterate over keys and call search recursively for the value
      for k of dict
        if typeof dict[k] == "object"
          if search dict[k], pattern
            return true
        else if dict[k] == pattern
          return true
      return false


    @addToAll = (id) ->
      $scope.all.push id

    return

module.directive 'pcMulticheck', ($parse, $filter, $compile) ->
  restrict: 'A'
  scope: true
  require: '^pcMultiactions'
  replace: true

  link: (scope, element, attrs, ctrl) ->
    scope.itemKey = attrs['pcMulticheck']
    ctrl.addToAll scope.itemKey

  template: '<td ng-show="editMode">
                <button type="button" class="btn btn-default btn-xs"
                    ng-click="select(itemKey)" 
                    ng-class="{\'btn-danger\': isSelected(itemKey)}">
                <span class="fa fa-check" 
                    ng-class="{\'fa-inverse\': !isSelected(itemKey)}">
                </span>
                </button>
            </td>'

module.directive 'pcMultiall', ($parse, $filter, $compile) ->
  restrict: 'A'
  scope: true
  require: '^pcMultiactions'
  replace: true

  template: '<th ng-show="editMode">
                <button type="button" class="btn btn-default btn-xs"
                    ng-click="selectAll()"·
                    ng-class="{\'btn-danger\': isAllSelected()}">
                <span class="fa fa-check"·
                    ng-class="{\'fa-inverse\': !isAllSelected()}">
                </span>
                </button>
            </td>'


module.directive 'pcMultieditbutton', ($parse, $filter, $compile) ->
  restrict: 'E'
  scope: true
  require: '^pcMultiactions'
  replace: true

  template: '<button type="button" class="btn btn-info"
                    ng-click="switchEdit()" ng-switch on="editMode">
                    <span ng-switch-when="false">Edit</span>
                    <span ng-switch-when="true">Cancel</span>
                </button>'
