(($) ->

  $.fn.tagsHighlight = (opts = {}) ->
    $this = $(this)

    split = (val) ->
      val.split /\s+/

    predicate = ""
    predicates = /^(-|#)(.*)/
    extractLast = (term) ->
      result = split(term).pop()
      match = result.match(predicates)
      if match
        predicate = match[1]
        result = match[2]
      else
        predicate = ""
      result

    loadData = (like, callback) ->
      $.get(
        "/tags/autocomplete",
        like: extractLast(like),
        format: "json",
        (response) ->
          callback(response)
      )

    $this.bind("keydown", (event) ->
      event.preventDefault() if event.keyCode == $.ui.keyCode.TAB && $(this).autocomplete("instance").menu.active
    ).autocomplete
      minLength: 0

      source: (request, response) ->
        _.debounce(( -> loadData(request.term, response)), 200)()

      focus: ->
        false

      select: (event, ui) ->
        terms = split(@value)
        terms.pop()
        terms.push(predicate + ui.item.value)
        terms.push ""
        @value = terms.join(" ")
        opts["select"](@value) if opts["select"]
        false

)(jQuery)
