controllers.controller("profileController", ($scope, $route, $location, usersAPI) ->

  controller = @

  $scope.loading = true
  $scope.model = null

  $scope.save = ->
    $form = $('<form enctype="multipart/form-data"/>')
    $form.append($(".profile-form input").clone())
    _.each($(".profile-form select"), (item) ->
      $item = $(item)
      $form.append($("<input/>").attr("name", $item.attr("name")).val($item.val()))
    )
    $file = $(".profile-form input:file")
    $form.find("input:file")[0].files = $file[0].files
    _.each($form.find("input"), (item) ->
      $item = $(item)
      $item.attr("name", "user[#{$item.attr('name')}]")
    )
    $form.append($("<input type='hidden' name='_method' value='put'>"))

    $form.ajaxSubmit(
      type: "POST",
      url: "/users/#{$scope.model.id}.json",
      success: (response) ->
        $scope.$apply( ->
          $scope.model.reassignAttributes(response)
        )

        if response.error
          $.message.error(response.error)
        else
          $.message.success("Saved!")
          if !$route.current.params.id
            $("span.username").text($scope.model.username)
          $file[0].value = ""
      ,
      error: (event, statusText, responseText, form) ->
        $.message.error("An error has occured")
    )
    null

  $scope.displayImage = (fileInput) ->
    reader = new FileReader()
    reader.onload = (e) ->
      $scope.$apply( -> $scope.model.avatar_url = e.target.result)
    reader.readAsDataURL(fileInput.files[0]);

  usersAPI.getProfile($route.current.params.id).success( (response) ->
    $scope.model = new models.User(response)
    $scope.loading = false
  )

)
