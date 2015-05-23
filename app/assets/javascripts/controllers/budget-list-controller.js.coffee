controllers.controller("budgetListController", ($scope, $route, $location, budgetAPI) ->

  controller = @

  decoratePosts = (posts) ->
    $.map(posts, (item) ->
      new models.BudgetPost(item)
    )

  refreshConnectedData = ->
    total = 0
    _.each($scope.posts, (post) -> total += post.amount || 0)
    $scope.totalAmount = total
    $scope.token = new Date()

  @getData = (clean) ->
    if clean
      $scope.posts = []

    $scope.loading = true
    budgetAPI.getRecords($scope.search, $scope.startDate, $scope.endDate).success((response) ->
      if response.posts
        $scope.posts = $scope.posts.concat(decoratePosts(response.posts))
        refreshConnectedData()
      $scope.loading = false
    )

  storeStartDate = ((date) -> $.cookie("startDate", date.toJSON(), { expires: 3650 }))
  getInitialStartDate = ->
    date = $route.current.params.start_date
    if !date
      dateCookie = $.cookie("startDate")
      if dateCookie
        date = new Date(dateCookie)
        setNextMonth = ((date) -> date.setMonth(date.getMonth() + 1))

        today = new Date()
        nextDate = new Date(date)
        setNextMonth(nextDate)

        while today > nextDate
          setNextMonth(date)
          setNextMonth(nextDate)

        storeStartDate(date)
      else
        date = new Date()
        date.setDate(1)
    date

  getInitialEndDate = ->
    $route.current.params.end_date || new Date()

  dateIntervalChanged = (newValue, oldValue) ->
    if newValue != oldValue
      storeStartDate($scope.startDate)
      controller.getData(true)

  getEstimatedSpending = ->
    cookie = $.cookie("estimatedSpending")
    if cookie
      parseInt(cookie, 10)
    else
      0
  storeEstimatedSpending = -> $.cookie("estimatedSpending", $scope.estimatedDaySpending, { expires: 3650 })

  $scope.search = $route.current.params.search || null
  $scope.loading = true
  $scope.posts = []
  $scope.startDate = getInitialStartDate()
  $scope.endDate = getInitialEndDate()
  $scope.totalAmount = 0
  $scope.token = null
  $scope.estimatedDaySpending = getEstimatedSpending()
  $scope.charts = [
    {
      id: "by_tag"
      name: "Spent by Tag"
    }
    {
      id: "by_day"
      name: "Spent by Day"
    }
  ]
  $scope.chart = $scope.charts[0]

  $scope.$watch("startDate", dateIntervalChanged)
  $scope.$watch("endDate", dateIntervalChanged)
  $scope.$watch("estimatedDaySpending", storeEstimatedSpending)

  $scope.showEstimated = ->
    $scope.chart.id == "by_day"

  $scope.noItems = ->
    !$scope.loading && (!$scope.posts || $scope.posts.length == 0)

  $scope.newSearch = ->
    search = $scope.search && $scope.search.trim() || undefined
    if $route.current.params["search"] != search
      $scope.posts = []
      $location.search("search", search)

  $scope.move = (post) ->
    $.each($scope.posts, (index, item) ->
      if item != post
        item.isMoved = false
        item.isEdited = false
      null
    )
    post.isMoved = !post.isMoved;

  $scope.new = ->
    budgetAPI.newRecord().success((response) ->
      post = new models.BudgetPost(response)
      $scope.posts.unshift(post)
      $scope.edit(post)
    ).error( ->
      $.message.error("An error has occured");
    )

  $scope.edit = (post) ->
    post.isEdited = true

  $scope.rollback = (post) ->
    if post.isNew()
      $scope.posts = _.without($scope.posts, post)
    else
      post.rollback()
      post.isEdited = false

  $scope.save = (post) ->
    budgetAPI.saveRecord(post).success((response) ->
      post.reassignAttributes(response)
      post.isEdited = false
      refreshConnectedData()
      $.message.success("Saved!");
    ).error( ->
      $.message.error("An error has occured");
    )

  $scope.delete = (post) ->
    if confirm("Are you sure you want to delete budget post?")
      budgetAPI.deleteRecord(post).success( ->
        $scope.posts = _.without($scope.posts, post)
        refreshConnectedData()
        $.message.success("Removed!");
      ).error( ->
        $.message.error("An error has occured");
      )

  builder = new controllers.ControllerBuilder(controller, $scope, $route)
  builder.extendWithFormats()
  builder.extendWithLocationChanged()

  controller.getData()
)
