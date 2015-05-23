( ->
  loadData = (like, callback) ->
    $.get(
      "/users/autocomplete",
      like: like,
      format: "json",
      (response) ->
        callback(response)
    )

  directives.directive("ngMembersHighlight", () ->
    link: (scope, element, attrs) ->
      member = scope.$eval(attrs.ngMember)

      $(element).bind("keydown", (event) ->
        event.preventDefault() if event.keyCode == $.ui.keyCode.TAB && $(this).autocomplete("instance").menu.active
      ).autocomplete(
        minLength: 0

        source: (request, response) ->
          _.debounce(( -> loadData(request.term, response)), 200)()

        focus: ->
          false

        select: (event, ui) ->
          if attrs.ngMembersHighlight == "search"
            @value = ui.item.username
            scope.$apply( -> scope.search = ui.item.username )
            return false
          else
            scope.$apply( ->
              member.isNew = undefined
              member.username = ui.item.username
              member.avatar_url = ui.item.avatar_url
              member.user_id = ui.item.id
            )
          null
      ).autocomplete("instance")._renderItem = (ul, item) ->
        $img = $("<img>").addClass("avatar32px").attr("src", item.avatar_url)
        $span = $("<span>").addClass("autocomplete-username").text(item.username)
        $("<li>").addClass("user-autocomplete").append($img).append($span).appendTo(ul)
  )
)()
