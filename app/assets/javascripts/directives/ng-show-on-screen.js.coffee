directives.directive("ngShowOnScreen", () ->
  link: (scope, element, attrs) ->
    if attrs.ngShowOnScreen == "true"
      $("html, body").animate({
        scrollTop: $(element).offset().top - 100
      }, 200);
)
