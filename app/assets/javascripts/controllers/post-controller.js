controllers.controller("postController", function($scope, $route, $location, postsAPI) {
  $scope.id = $route.current.params.id;
  $scope.loading = true;

  $scope.save = function() {
    postsAPI.savePost($scope.post).success(function(response) {
      $scope.errorMessages = undefined;
      $scope.errors = undefined;

      var afterSaveSuccess = function() {
        $.message.success("Saved!");
        if (!$scope.post.id) {
          $location.url("/posts/" + response.id);
        }
        $scope.post = response;
      };

      var ids = $.map(response.images, function(image) {
        return image.uploaded ? null : image.id;
      });

      if (ids.length === 0) {
        afterSaveSuccess();
      }

      $.each($scope.post.images, function(index, image) {
        if (image.uploaded === false && image.file) {
          image.uploading = true;
          image.progress = 0;
          image.id = ids.splice(0, 1);

          var $form = $('<form enctype="multipart/form-data"/>');
          var $file = $('<input type="file" name="file"/>').appendTo($form);
          $file[0].files = image.file;
          $form.ajaxSubmit({
            type: "POST",
            url: "/images/" + image.id + "/upload",
            uploadProgress: function(event, position, total, percentComplete) {
              $scope.$apply(function() {
                image.progress = percentComplete;
              });
            },
            success: function(response) {
              $scope.$apply(function() {
                image.uploading = false;
                image.thumbUrl = response.thumbUrl;
                image.uploaded = true;
                image.file = undefined;

                if (ids.length === 0) {
                  afterSaveSuccess();
                  $.each($scope.post.images, function(index, item) { item.uploaded = true; });
                }
              });
            },
            error: function() {
              $.message.error("Uploading error");
              $scope.$apply(function() {
                $scope.errors = { images: "Uploading error" };
                $scope.errorMessages = ["Image wasn't uploaded. Something went wrong."];
              });
            }
          });
        }
      });
    }).error(function(response) {
      $.message.error("Saving error");
      $scope.errorMessages = response.messages;
      $scope.errors = response.errors;
    });
  };

  $scope.decryptSecuredMessage = function(message) {
    message.loading = true;

    postsAPI.decryptSecuredMessage(message.url, message.key).success(function(response) {
      message.message = response.message || undefined;
      message.error = response.error;
      message.loading = false;
    });
  };

  $scope.addImage = function(fileInput) {
    var image = {
      id: null,
      file: fileInput.files,
      uploaded: false
    };

    var reader = new FileReader();
    reader.onload = function (e) {
      $scope.$apply(function() {
        image.thumbUrl = e.target.result;
      });
    };
    reader.readAsDataURL(image.file[0]);

    $scope.$apply(function() {
      $scope.post.images.push(image);
    });
  };

  getData();

  function getData() {
    $scope.loading = true;
    postsAPI.getPost($scope.id).success(function(response) {
      $scope.post = response;
      $scope.loading = false;
    });
  }
});