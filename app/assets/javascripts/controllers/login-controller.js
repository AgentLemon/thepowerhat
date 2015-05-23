controllers.controller("loginController", function($scope, $route, $location, loginAPI) {

  $scope.signIn = function() {
    loginAPI.signIn($scope.token, $scope.login, $scope.password, $scope.rememberme).success(function(response) {
      var redirectTo = response.redirect;
      var match = redirectTo.match(/https?:\/\/[^\/]+(.*)/)
      if (match) {
        redirectTo = match[1];
      }
      $location.url(redirectTo);
    });
  };

  loginAPI.getToken().success(function(response) {
    $scope.token = response;
  });

  if ($route.current.originalPath == "/logout") {
    loginAPI.signOut().success(function(response) {
      $location.url(response.redirect);
    });
  }

});