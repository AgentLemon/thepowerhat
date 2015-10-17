services.factory("postsAPI", function($http) {
  var postsAPI = {};

  postsAPI.getPosts = function(search, page) {
    return HttpDecorator($http({
      method: "GET",
      url: "/posts.json",
      params: {
        search: search,
        page: page
      }
    }));
  };

  postsAPI.decryptSecuredMessage = function(url, key) {
    return HttpDecorator($http({
      method: "GET",
      url: url,
      params: {
        key: key
      }
    }));
  };

  postsAPI.getPost = function(id) {
    return HttpDecorator($http({
      method: "GET",
      url: "/posts/" + id + ".json"
    }));
  };

  postsAPI.savePost = function(post) {
    return HttpDecorator($http({
      method: post.id ? "PUT" : "POST",
      url: (post.id ? ("/posts/" + post.id) : "/posts") + ".json",
      data: {
        authenticity_token: post.authenticity_token,
        post: {
          title: post.title,
          message: post.text,
          a: [],
          secured_messages_attributes:
            $.map(post.securedMessages, function(item) { return {
              id: item.id,
              message: item.message,
              key: item.key,
              _destroy: item._destroy
            }}) || [],
          images_attributes:
            $.map(post.images, function(item) { return {
              id: item.id,
              _destroy: item._destroy
            }}) || []
        }
      }
    }));
  };

  return postsAPI;
});
