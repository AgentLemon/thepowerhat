directives.directive("activateOnLink", () ->
  (scope, element, attrs) ->
    if screen.width > 480
      $(element).find("input:first").focus()
)
