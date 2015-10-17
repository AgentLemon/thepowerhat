$.HttpDecorator = ($http) ->
  @success = (callback) ->
    $.setGlobalLoading(true)

    $http.success((response) ->
      callback(response)
      $.setGlobalLoading(false)
    )
    @

  @error = (callback) ->
    $http.error((response) ->
      callback(response)
      $.setGlobalLoading(false)
    )
    @

  @
