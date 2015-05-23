directives.directive("expandableImage", () ->
  template: '<img ng-src="{{image.thumbUrl}}">',
  link: (scope, element, attrs) ->
    $image = $($(element).find("img"))
    $image.on("click", ->
      $div = $(".expanded-image-modal")
      $img = $div.find("img:first")
      $img.attr("src", scope.image.url)

      $div.modal("show")
    )
)
