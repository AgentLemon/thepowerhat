controllers.ControllerBuilder = (controller, $scope, $route) ->
  builder = @

  builder.extendWithBase = () ->
    $scope.search = $route.current.params.search || null
    $scope.collection = []
    $scope.remain_pages = null
    $scope.page = null
    $scope.loading = true
    $scope.noItems = ->
      !$scope.loading && (!$scope.collection || $scope.collection.length == 0)

  builder.extendWithDecorator = (decorator) ->
    controller.decorate = (item) ->
      new decorator(item)
    controller.decorateCollection = (collection) ->
      $.map(collection, (item) ->
        controller.decorate(item)
      )

  builder.extendWithInlineEdit = () ->
    $scope.move = (record) ->
      $.each($scope.collection, (index, item) ->
        if item != record
          item.isMoved = false
          item.isEdited = false
        null
      )
      record.isMoved = !record.isMoved;
    $scope.edit = (record) ->
      record.isEdited = true

  builder.extendWithAPI = (api, editedCallback) ->
    $scope.new = ->
      api.newRecord().success((response) ->
        record = controller.decorate(response)
        $scope.collection.unshift(record)
        $scope.edit(record)
      ).error( ->
        $.message.error("An error has occured");
      )
    $scope.rollback = (record) ->
      if record.isNew()
        $scope.collection = _.without($scope.collection, record)
      else
        record.rollback()
        record.isEdited = false
    $scope.save = (record) ->
      api.saveRecord(record).success((response) ->
        record.reassignAttributes(response)
        record.isEdited = false
        $.message.success("Saved!");
        editedCallback() if editedCallback
      ).error( ->
        $.message.error("An error has occured");
      )
    $scope.delete = (record) ->
      if confirm("Are you sure you want to delete record?")
        api.deleteRecord(record).success( ->
          $scope.collection = _.without($scope.collection, record)
          $.message.success("Removed!");
          editedCallback() if editedCallback
        ).error( ->
          $.message.error("An error has occured");
        )

  builder.extendWithFormats = () ->
    $scope.formatCurrency = (amount, opts = {}) ->
      amount = Math.abs(amount) if opts.abs
      str = (amount || 0).toFixed(2).toString()
      [str.substring(0, str.length - 3), str.substring(str.length - 3)]
    $scope.formatDate = (date, opts = {}) ->
      months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      result = date.getDate() + " " + months[date.getMonth()]
      result += (if opts.lineBreak then "<br/>" else " ")
      result + (date.getYear() + 1900)
    $scope.formatPayment = (total) ->
      result = ""
      result = "▲" if total > 0
      result = "▼" if total < 0
      "#{result}#{Math.abs(total)}"
    $scope.getArrow = (total) ->
      if total > 0 then "→" else "←"

  builder.extendWithLocationChanged = (options = {}) ->
    $scope.$on("$locationChangeSuccess", (event, next, current) ->
      regexp = /([^\?]*)\??[^\?]*$/
      nextPath = next.match(regexp) || []
      currentPath = current.match(regexp) || []
      if currentPath[1] == nextPath[1]
        $scope.search = $route.current.params["search"] || null
        options.beforeLoad() if options.beforeLoad
        controller.getData(true)
    )

  builder.extendWithDebtsProcessor = () ->
    controller.processDebts = (debts, paids) ->
      result = {}
      _.each(paids, (p) ->
        p.amount = parseFloat(p.amount) || 0
        result[p.who_id] = p
      )
      _.each(debts, (d) ->
        d.amount = -(parseFloat(d.amount) || 0)
        if result[d.whom_id]
          result[d.whom_id].amount += d.amount
        else
          result[d.whom_id] = d
      )
      _.map(result, (i) -> i)

  builder.extendWithPages = () ->
    $scope.showMore = ->
      $scope.page += 1
      controller.getData()

  builder
