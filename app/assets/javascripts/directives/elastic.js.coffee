directives.directive 'elastic', ->
    restrict: 'A'
    link: ($scope, element) ->
      $scope.initialHeight = $scope.initialHeight or element[0].style.height

      resize = ->
        element[0].style.height = '' + element[0].scrollHeight + 'px'
        return

      element.on 'input change', resize
      $scope.$watch(resize)
