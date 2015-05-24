controllers.controller("postsController", function($scope, $route, $location, postsAPI) {
  var self = this;

  $scope.search = $route.current.params.search || null;
  $scope.page = null;
  $scope.loading = true;
  $scope.posts = [];

  $scope.noItems = function() {
    return !$scope.loading && (!$scope.posts || $scope.posts.length === 0);
  };

  $scope.showMore = function() {
    $scope.page += 1;
    self.getData();
  };

  $scope.newSearch = function() {
    var search = $scope.search && $scope.search.trim() || undefined;
    if ($route.current.params.search !== search) {
      $scope.posts = [];
      $location.search("search", search);
    }
  };

  $scope.decryptSecuredMessage = function(message) {
    message.loading = true;

    postsAPI.decryptSecuredMessage(message.url, message.key).success(function(response) {
      message.message = response.message || undefined;
      message.html = response.html || undefined;
      message.error = response.error;
      message.loading = false;
    });
  };

  this.getData = function(clear) {
    if (clear) {
      $scope.posts = [];
    }

    $scope.loading = true;
    postsAPI.getPosts($scope.search, $scope.page).success(function(response) {
      if (response.posts) {
        $scope.posts = $scope.posts.concat(response.posts);
      }
      $scope.remain_pages = response.remain_pages;
      $scope.page = response.page;
      $scope.loading = false;
    });
  };

  var builder = new controllers.ControllerBuilder(this, $scope, $route);
  builder.extendWithLocationChanged({ beforeLoad: function() { $scope.page = null; } });

  this.getData();
});