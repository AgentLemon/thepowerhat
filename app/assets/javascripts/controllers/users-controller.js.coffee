controllers.controller("usersController", ($scope, $route, $location, usersAPI) ->

  controller = @

  builder = new controllers.ControllerBuilder(controller, $scope, $route)
  builder.extendWithBase()
  builder.extendWithDecorator(models.User)
  builder.extendWithInlineEdit()
  builder.extendWithAPI(usersAPI)
  builder.extendWithFormats()
  builder.extendWithLocationChanged()
  builder.extendWithPages()

  @getData = (clean) ->
    if clean
      $scope.collection = []

    $scope.loading = true
    $.setGlobalLoading(true)
    usersAPI.getRecords($scope.search, $scope.page).success((response) ->
      if response.users
        $scope.collection = $scope.collection.concat(controller.decorateCollection(response.users))
      $scope.remain_pages = response.remain_pages
      $scope.page = response.page
      $scope.loading = false
      $.setGlobalLoading(false)
    )

  $scope.newSearch = ->
    search = $scope.search && $scope.search.trim() || undefined
    if $route.current.params["search"] != search
      $scope.records = []
      $location.search("search", search)

  $scope.totalDebt = (user) ->
    user.paid - user.debt

  $scope.debtsMatrix = null

  processDebtsMatrix = (response) ->
    matrix = {}
    _.each(response.users, (user) ->
      matrix[user.id] = {
        id: user.id,
        username: user.username,
        avatar_url: user.avatar_url,
        debts: {},
        balance: user.paid - user.debt
      }
    )
    _.each(response.users, (user) ->
      _.each(user.debts, (debt) ->
        amount = parseInt(debt.amount, 10)
        if matrix[user.id]
          matrix[user.id].debts[debt.whom_id] ||= 0
          matrix[user.id].debts[debt.whom_id] += amount
        if matrix[debt.whom_id]
          matrix[debt.whom_id].debts[user.id] ||= 0
          matrix[debt.whom_id].debts[user.id] -= amount
      )
    )
    matrix = _.sortBy(_.map(matrix, (i) -> i), (i) -> i.username)

    _.each(matrix, (userN, n) ->
      _.each(matrix, (userM, m) ->
        if (m >= n)
          userN.debts[userM.id] = null
      )
    )

    $scope.debtsMatrix = matrix
    $.setGlobalLoading(false)

  $scope.showDebtsMatrix = ->
    $.setGlobalLoading(true)
    usersAPI.getDebtsMatrix().success(processDebtsMatrix)

  $scope.recountDebts = ->
    $.setGlobalLoading(true)
    usersAPI.recountDebts().success(processDebtsMatrix)

  @getData()
)
