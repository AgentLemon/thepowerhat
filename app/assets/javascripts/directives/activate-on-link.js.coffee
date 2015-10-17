directives.directive("activateOnLink", () ->
  (scope, element, attrs) ->
    if window.screen.width > 480
      $(element).find("input:first").focus()
)
