// Generated by CoffeeScript 1.6.3
/*
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
*/


(function() {
  var module;

  module = angular.module('rainbowDirectives');

  module.directive('pcTable', function($parse, $filter, $compile) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        scope.attrs = attrs;
        scope.filter = $filter('filter');
        return scope.sorter = $filter('orderBy');
      },
      controller: function($scope) {
        $scope.filterFields = [];
        $scope.sortFields = {};
        $scope.currentSort = 'desired.name';
        $scope.reverse = false;
        $scope.getFiltered = function(data) {
          var filtered, sortFn, sorted;
          filtered = this.filter(data, $scope.getFilter());
          sortFn = $scope.sortFields[$scope.currentSort];
          sorted = $filter('orderBy')(filtered, sortFn(), $scope.reverse);
          return sorted;
        };
        $scope.getFilter = function() {
          return function(value) {
            return $scope.searchFilter(value, $scope.attrs['pcTable'], $scope.filterFields);
          };
        };
        $scope.getSort = function() {
          return function(item) {
            return $scope.getFieldValue(item, $scope.currentSort);
          };
        };
        this.addField = function(field, filterFn, sortFn, element) {
          var filter;
          if (typeof filterFn === 'function') {
            filter = {
              'key': field,
              'fn': filterFn
            };
          } else if (filterFn !== false) {
            filter = field;
          }
          $scope.filterFields.push(filter);
          if (sortFn !== false) {
            return this.addSortField(field, sortFn, element);
          }
        };
        this.addSortField = function(field, sortFn, element) {
          var caret, caretHtml, clsDef, fn, ss;
          clsDef = "{'caret-inactive': currentSort != '" + field + "',";
          clsDef += "'caret-reversed': reverse && (currentSort == '" + field + "')}";
          caretHtml = '<span class="caret" ng-class="' + clsDef + '"></span>';
          caretHtml = $compile(caretHtml)($scope);
          caret = element.append(caretHtml);
          if ($scope.currentSort == null) {
            $scope.currentSort = field;
          }
          fn = typeof sortFn === 'function' ? sortFn : $scope.getSort;
          $scope.sortFields[field] = fn;
          ss = this.setSort;
          element.bind('click', function() {
            return ss(field);
          });
          return element.addClass('with-caret');
        };
        this.setSort = function(field) {
          return $scope.$apply(function() {
            if ($scope.currentSort === field) {
              $scope.reverse = !$scope.reverse;
            } else {
              $scope.reverse = false;
            }
            return $scope.currentSort = field;
          });
        };
        $scope.getFieldValue = function(obj, key) {
          var part, value, _i, _len, _ref;
          value = obj;
          _ref = key.split('.');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            part = _ref[_i];
            value = value[part];
          }
          return value;
        };
        $scope.searchFilter = function(item, model, fields) {
          var field, value, _i, _len;
          if (model == null) {
            return true;
          }
          for (_i = 0, _len = fields.length; _i < _len; _i++) {
            field = fields[_i];
            if (field instanceof Object) {
              value = this.getFieldValue(item, field['key']);
              if (field['fn'](value, model)) {
                return true;
              }
            } else {
              value = this.getFieldValue(item, field);
              if (value == null) {
                value = '';
              }
              value = value.toLowerCase();
              if (value.search(model) > -1) {
                return true;
              }
            }
          }
          return false;
        };
      }
    };
  });

  module.directive('pcColumn', function($parse) {
    return {
      restrict: 'A',
      require: '^pcTable',
      link: function(scope, element, attrs, tableCtrl) {
        var def, fns, i, predicate, type, _i, _len, _ref;
        def = attrs['pcColumn'].split(':');
        fns = [null, null];
        _ref = [1, 2];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if (def[i] != null) {
            predicate = $parse(def[i])(scope);
            type = typeof predicate;
            if ((type === 'boolean' && predicate) || type === 'function') {
              fns[i - 1] = predicate;
            }
          } else {
            fns[i - 1] = true;
          }
        }
        return tableCtrl.addField(def[0], fns[0], fns[1], element);
      }
    };
  });

}).call(this);
