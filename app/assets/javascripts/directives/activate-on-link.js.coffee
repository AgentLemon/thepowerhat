directives.directive("activateOnLink", () ->
  (scope, element, attrs) ->
    if innerWidth > 600
      $(element).find("input:first").focus()
)
