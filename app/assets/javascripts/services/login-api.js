services.factory("loginAPI", function($http) {
  var loginAPI = {};

  loginAPI.getToken = function() {
    return $http({
      method: "GET",
      url: "/token"
    });
  };

  loginAPI.signIn = function(token, login, password, rememberme) {
    return $http({
      method: "POST",
      url: '/login.json',
      params: {
        authenticity_token: token,
        email: login,
        password: password,
        remember_me: rememberme
      }
    });
  };

  loginAPI.signOut = function() {
    return $http({
      method: "GET",
      url: "/logout.json"
    });
  };

  return loginAPI;
});