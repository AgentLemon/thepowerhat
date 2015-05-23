window.charts ||= {}

window.charts.SpentByDay = (posts, startDate, endDate, estimatedByDay, isMobile = false) ->
  self = this

  createAllDates = ->
    dates = []
    i = new Date(startDate)
    while i <= endDate
      tag = charts.helpers.getTagByLabel(dates, charts.helpers.formatDateDM(i))
      tag.amount = 0
      i.setDate(i.getDate() + 1)
    dates

  setSums = (dates) ->
    sum = 0
    est = 0
    _.each(dates, (item) ->
      sum += item.amount
      est += estimatedByDay || 0
      item.sum = sum
      item.estimated = est
    )
    dates

  groupByDate = ->
    result = createAllDates()
    _.each(posts, (post) ->
      label = charts.helpers.formatDateDM(post.date)
      tag = charts.helpers.getTagByLabel(result, label)
      tag.amount += post.amount
    )
    setSums(result)
    result

  getCategories = (data) ->
    _.map(data, (item) -> item.label)

  getSpentSerie = (data) ->
    name: "Day Spent"
    type: "column"
    yAxis: 0
    data: _.map(data, (item) -> item.amount)
    animation: false

  getSumSerie = (data) ->
    name: "Total Spent"
    type: "line"
    yAxis: 1
    data: _.map(data, (item) -> item.sum)
    animation: false

  getEstimatedSerie = (data) ->
    name: "Estimated"
    type: "line"
    yAxis: 1
    data: _.map(data, (item) -> item.estimated)
    animation: false

  getSeries = (data) ->
    series = []
    series.push(getSpentSerie(data))
    series.push(getSumSerie(data))
    if estimatedByDay
      series.push(getEstimatedSerie(data))
    series

  self.getData = ->
    data = groupByDate()

    chart:
      type: "column"
    title: null
    credits:
      enabled: false
    xAxis:
      categories: getCategories(data)
      labels:
        rotation: -90
    yAxis: [
      {
        min: 0
        title:
          text: "Day Spent"
      }
      {
        min: 0
        title:
          text: "Total Spent"
        opposite: true
      }
    ]
    tooltip:
      headerFormat: "{point.key}<br/>"
      pointFormat: "{point.y:,.2f}"
    series: getSeries(data)

  this
