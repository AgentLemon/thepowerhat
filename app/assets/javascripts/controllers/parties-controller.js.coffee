controllers.controller("partiesController", ($scope, $route, $location, partiesAPI) ->

  controller = @

  builder = new controllers.ControllerBuilder(controller, $scope, $route)
  builder.extendWithBase()
  builder.extendWithDecorator(models.Party)
  builder.extendWithInlineEdit()
  builder.extendWithAPI(partiesAPI, -> controller.reloadTotalDebts())
  builder.extendWithFormats()
  builder.extendWithLocationChanged()
  builder.extendWithDebtsProcessor()
  builder.extendWithPages()

  $scope.hasNewMember = false
  $scope.totalDebt = 0
  $scope.debts = []
  $scope.showDebts = false

  @getData = (clean) ->
    if clean
      $scope.collection = []

    $scope.loading = true
    partiesAPI.getRecords($scope.search, $scope.startDate, $scope.endDate, $scope.page).success((response) ->
      if response.parties
        $scope.collection = $scope.collection.concat(controller.decorateCollection(response.parties))
      $scope.totalDebt = parseFloat(response.total_debt)
      $scope.debts = controller.processDebts(response.debts, response.paids)
      $scope.remain_pages = response.remain_pages
      $scope.page = response.page
      $scope.loading = false
    )

  @reloadTotalDebts = ->
    $scope.loading = true
    partiesAPI.getTotalDebts().success((response) ->
      $scope.totalDebt = parseFloat(response.total_debt)
      $scope.debts = controller.processDebts(response.debts, response.paids)
      $scope.loading = false
    )

  $scope.newSearch = ->
    search = $scope.search && $scope.search.trim() || undefined
    if $route.current.params["search"] != search
      $scope.records = []
      $location.search("search", search)

  edit = $scope.edit
  $scope.edit = (party) ->
    $scope.hasNewMember = false
    edit(party)

  $scope.addMember = (party) ->
    member = { isNew: true }
    party.party_members_attributes.push(member)
    $scope.hasNewMember = true
    $scope.$watch(( -> member.isNew ), ( (newValue) -> $scope.hasNewMember = newValue ))

  $scope.deleteMember = (member) ->
    member._destroy = true

  $scope.restoreMember = (member) ->
    member._destroy = undefined

  @getData()
)
