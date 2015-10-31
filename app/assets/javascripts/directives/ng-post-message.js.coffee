directives.directive("ngPostMessage", (postsAPI) ->
  link: (scope, element, attrs) ->
    $element = $(element)
    post = scope.$eval(attrs.ngPostMessage)
    message = post.message

    counter = 0
    message = message.replace(/\[(.)\]([^\[]*)(<br>|$)/g, (match, check, text) ->
      checked = if check == ' ' then '' else ' checked'
      result = "<label class=\"inline-checkbox #{checked}\">" +
        "<input type=\"checkbox\" #{checked} data-id=\"#{counter++}\">" +
        "<span class=\"text\">#{text}</span>" +
        "</label>"
      result
    )

    $element.html(message)
    $element.find("input[type=checkbox]").on("change", () ->
      $this = $(this)
      checked = $this.is(":checked")
      $this.closest("label").toggleClass("checked", checked)
      postsAPI.checkBox(post, $this.data("id"), checked).success($.noop)
      null
    )
)
