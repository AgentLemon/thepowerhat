directives.directive("debtsMatrix", () ->
  link: (scope, element, attrs) ->
    scope.$watch(attrs.debtsMatrix, (newValue) ->
      if newValue
        $(element).modal("show")
    )
)
