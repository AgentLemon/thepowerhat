directives.directive("adminEnabled", () ->
  (scope, element, attrs) ->
    if $("body").hasClass("admin")
      $(element).find("*:disabled,[disabled='disabled']").removeAttr("disabled").removeClass("disabled")
)
