directives.directive("errorHighlight", () ->
  link: (scope, element, attrs) ->
    scope.$watch(attrs.errorHighlight, (newValue, oldValue) ->
      $element = $(element)

      $element.find(".form-group.has-error").removeClass("has-error")
      $element.find(".highlight-alert").hide().empty()

      if attrs.errorHighlightMessages
        messages = scope.$eval(attrs.errorHighlightMessages)
        if messages
          $ul = $("<ul></ul>")
          _.each(messages, (message) ->
            $li = $("<li></li>").html(message)
            $li.appendTo($ul)
          )
          $element.find(".highlight-alert").append($ul).show()

      _.each(newValue, (field) ->
        $element.find("##{field}").closest(".form-group").addClass("has-error")
      )
    )
)
