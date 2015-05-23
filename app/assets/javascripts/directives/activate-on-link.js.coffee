directives.directive("activateOnLink", () ->
  (scope, element, attrs) ->
    $(element).find("input:first").focus()
)
