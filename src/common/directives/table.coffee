###
PonyCloud Rainbow Table directive

This directive provides simple sorting and filtering for tables.

Usage:
There are two attribute directives you need to use:
1) pcTable - attach this to <table> element and set it to value of model
   you want to search by.

2) pcColumn - attach this to th you want to sort/filter by.
   Value is defined as "key : filterFn : sortFn", where
   key - key from model to get values from (notation 'foo.bar' supported)
   filterFn: true/false/function:
     true or nothing - use default filter function (eg. find string in string)
     false - do not filter
     function - use this function to filter elements. Function signature is 
        f(actual, expected). Return true to include item in filtered results,
        false otherwise.
   sortFn: similar to filterFn, expcetion function should return item value 
     instead of boolean, which will be used by default comparator.

Lastly use getFiltered function to actually filter data

3) getFiltered(dataset) - returns data from dataset using filtering and 
   sorting

Example:

<input ng-model="searchField">

<table pc-table="{{ searchField }}">
<tr>
    <!-- sort and filter by name using default methods -->
    <th pc-column="desired.name">Name</th>
    <!-- sort using custom function filterType defined in scope -->
    <th pc-column="desired.type:filterType:">Type</th>
    <!-- only filter, do not sort -->
    <th pc-column="desired.status:true:false">Status</th>
</tr>
<tr ng-repeat="item in getFiltered(items)">
    <td>your content here</td>
</tr>
</table>

###

module = angular.module 'rainbowDirectives'

module.directive 'pcTable', ($parse, $filter, $compile) ->
  restrict: 'A',

  link: (scope, element, attrs) ->
    scope.attrs = attrs
    scope.filter = $filter('filter')
    scope.sorter = $filter('orderBy')

  controller: ($scope) ->
    $scope.filterFields = []
    $scope.sortFields = {}
    $scope.currentSort = 'desired.name'
    $scope.reverse = false

    $scope.getFiltered = (data) ->
      filtered = @filter(data, $scope.getFilter())
      sortFn = unless $scope.sortFields[$scope.currentSort] is undefined then $scope.sortFields[$scope.currentSort] else $scope.sortFields[Object.keys($scope.sortFields)[0]]
      sorted = $filter('orderBy')(filtered, sortFn(), $scope.reverse)
      if $scope.all
        $scope.all = $scope.all.filter(
          (item) ->
            $scope.filterSearch sorted, item
        )

      return sorted


    $scope.filterSearch = (dict, pattern) ->
      for k of dict
        if typeof dict[k] == "object"
          if $scope.filterSearch dict[k], pattern
            return true
        else if dict[k] == pattern
          return true
      return false


    $scope.getFilter = () ->
      return (value) ->
        $scope.searchFilter value, $scope.attrs['pcTable'], $scope.filterFields

    $scope.getSort = () ->
      return (item) ->
        return $scope.getFieldValue(item, $scope.currentSort)

    @addField = (field, filterFn, sortFn, element) ->
      if typeof filterFn == 'function'
        filter = {'key': field, 'fn': filterFn}
      else if filterFn != false
        filter = field
      $scope.filterFields.push filter

      if sortFn != false
        @addSortField field, sortFn, element

    @addSortField = (field, sortFn, element) ->
      clsDef = "{'caret-inactive': currentSort != '" + field + "',"
      clsDef += "'caret-reversed': reverse && (currentSort == '" + field + "')}"
      caretHtml = '<span class="caret" ng-class="'+clsDef+'"></span>'
      caretHtml = $compile(caretHtml)($scope)

      caret = element.append caretHtml

      # sort by first field at the beginning
      if !$scope.currentSort?
        $scope.currentSort = field

      fn = if typeof sortFn == 'function' then sortFn else $scope.getSort
      $scope.sortFields[field] = fn
      ss = @setSort
      element.bind 'click', () ->
        ss field
      element.addClass 'with-caret'

    @setSort = (field) ->
      $scope.$apply () ->
        if $scope.currentSort == field
          $scope.reverse = !$scope.reverse
        else
          $scope.reverse = false
        $scope.currentSort = field

    $scope.getFieldValue = (obj, key) ->
      value = obj
      for part in key.split '.'
        value = value[part]
      return value

    $scope.searchFilter = (item, model, fields) ->
      if !model?
          return true

      for field in fields
        if field instanceof Object
          value = @getFieldValue item, field['key']
          if field['fn'](value, model)
            return true
        else
          value = @getFieldValue item, field
          value = '' if !value?
          value = value.toString().toLowerCase()
          if value.search(model.toLowerCase()) > -1
            return true

      return false
    return

module.directive 'pcColumn', ($parse) ->
  restrict: 'A'
  require: '^pcTable'

  link: (scope, element, attrs, tableCtrl) ->
    def = attrs['pcColumn'].split(':')
    fns = [null, null]

    for i in [1,2]
      if def[i]?
        predicate = $parse(def[i])(scope)
        type = typeof predicate
        if (type == 'boolean' and predicate) or type == 'function'
          fns[i - 1] = predicate
      else
        fns[i - 1] = true

    tableCtrl.addField def[0], fns[0], fns[1], element
