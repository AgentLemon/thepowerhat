controllers.controller("userController", ($scope, $route, $location, usersAPI) ->

  controller = @

  builder = new controllers.ControllerBuilder(controller, $scope, $route)
  builder.extendWithFormats()
  builder.extendWithDebtsProcessor()

  $scope.loading = true
  $scope.model = null
  $scope.totalDebt = 0
  $scope.debts = []

  usersAPI.loadRecord($route.current.params.id).success( (response) ->
    $scope.model = new models.User(response)
    $scope.totalDebt = $scope.model.paid - $scope.model.debt
    $scope.debts = controller.processDebts(response.debts, response.paids)
    $scope.loading = false
  )

)
