services.factory("usersAPI", ($http) ->
  usersAPI = {}

  usersAPI.getProfile = (id) ->
    HttpDecorator($http(
      method: "GET"
      url: "/profile.json"
      params:
        id: id
    ))

  usersAPI.getRecords = (search, page) ->
    HttpDecorator($http(
      method: "GET"
      url: "/users.json"
      params:
        search: search
        page: page
    ))

  usersAPI.getDebtsMatrix = () ->
    HttpDecorator($http(
      method: "GET"
      url: "/users/debts_matrix.json"
    ))

  usersAPI.recountDebts = () ->
    HttpDecorator($http(
      method: "POST"
      url: "/users/recount_debts.json"
    ))

  builder = new services.ServiceBuilder($http, "users")
  builder.extendWithCRUD(usersAPI)

  usersAPI
)
