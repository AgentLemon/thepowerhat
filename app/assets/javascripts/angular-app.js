var ThePowerHat = angular.module("ThePowerHat", ["ngRoute", "ngSanitize", "ThePowerHat.controllers", "ThePowerHat.services", "ThePowerHat.directives"]);

ThePowerHat.config(function($routeProvider, $locationProvider, $provide, $httpProvider) {
  $locationProvider.html5Mode(true);
  $routeProvider
    .when("/login", { templateUrl: "/templates/login", controller: "loginController" })
    .when("/logout", { templateUrl: "/templates/login", controller: "loginController" })
    .when("/", { templateUrl: "/templates/posts.html", controller: "postsController", reloadOnSearch: false })
    .when("/profile", { templateUrl: "/templates/profile.html", controller: "profileController" })
    .when("/posts/:id", { templateUrl: "/templates/post.html", controller: "postController"})
    .when("/budget", { templateUrl: "/templates/budget_list.html", controller: "budgetListController", reloadOnSearch: false })
    .when("/parties", { templateUrl: "/templates/parties.html", controller: "partiesController", reloadOnSearch: false })
    .when("/users", { templateUrl: "/templates/users.html", controller: "usersController", reloadOnSearch: false })
    .when("/users/:id", { templateUrl: "/templates/user.html", controller: "userController" })
    .when("/users/:id/edit", { templateUrl: "/templates/profile.html", controller: "profileController" })
    .otherwise({redirectTo: "/"});

  $provide.factory("AccessDeniedInterceptor", function ($q, $location) {

    function showMessages(response) {
      if (response.data.error) {
        $.message.error(response.data.error);
      }
      if (response.data.success) {
        $.message.success(response.data.success);
      }
    }

    return {
      response: function(response) {
        showMessages(response);
        return response || $q.when(response);
      },
      responseError: function(rejection) {
        showMessages(rejection);

        if (rejection.status == 403 && rejection.data.redirect) {
          $location.url(rejection.data.redirect);
        }

        return $q.reject(rejection);
      }
    };

  });

  $httpProvider.interceptors.push("AccessDeniedInterceptor");
});

var controllers = angular.module("ThePowerHat.controllers", []);
var services = angular.module("ThePowerHat.services", []);
var directives = angular.module("ThePowerHat.directives", []);
window.models = {};