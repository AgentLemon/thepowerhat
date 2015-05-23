window.charts ||= {}

window.charts.DonutChartBuilder = (posts, isMobile = false) ->
  self = this

  options = charts.options[if isMobile then "mobile" else "desktop"]

  getLevelsCount = ->
    levels = 0
    _.each(posts, (post) ->
      if post.tags.length > levels
        levels = post.tags.length
    )
    levels

  normalizeTags = (tags, level, maxLevel) ->
    level ||= 0
    maxLevel ||= getLevelsCount()
    index = 0

    tags = tags.sort(charts.sorters.alphabetical)

    _.each(tags, (node) ->
      if level < maxLevel
        node.drilldown ||= []
      if level > 0
        node.brightness = index++ / tags.length * 0.2 + 0.08 + 0.2 * (level - 1)
      if node.drilldown
        sum = 0
        _.each(node.drilldown, (obj) ->
          sum += obj.amount
        )
        if sum != node.amount
          node.drilldown.push({ label: "other", amount: node.amount - sum, color: "transparent" })
        normalizeTags(node.drilldown, level + 1, maxLevel)
    )

  setColors = (tags, color, level = 0, parent_index = 0) ->
    _.each(tags, (node, index) ->
      unless node.color
        nodeColor = color || charts.helpers.getColorForPie(index)
        if level == 0
          parent_index = 0
        else
          nodeColor = Highcharts.Color(nodeColor).brighten(0.05 + (index + parent_index) / tags.length * 0.05).get()
        node.color = nodeColor
        if node.drilldown
          setColors(node.drilldown, nodeColor, level + 1, parent_index++)
    )

  setPercentage = (tags) ->
    total = 0
    _.each(tags, (node) -> total += node.amount)
    _.each(tags, (node) ->
      node.label += " (" + Math.round(100 * node.amount / total) + "%)"
    )

  getTags = ->
    tags = []
    cursor = null

    _.each(posts, (post) ->
      cursor = tags
      _.each(post.tags, (tag, level) ->
        tagCursor = charts.helpers.getTagByLabel(cursor, tag)
        unless tagCursor.amount
          tagCursor.amount = 0
        tagCursor.amount += post.amount

        if level < post.tags.length - 1
          tagCursor.drilldown ||= []
          cursor = tagCursor.drilldown
      )
    )
    normalizeTags(tags)
    setColors(tags)
    setPercentage(tags)
    tags

  getTagsLevel = (tags, level) ->
    array = []
    _.each(tags, (tag) ->
      if level == 0
        array.push(tag)
      else
        array = array.concat(getTagsLevel(tag.drilldown, level - 1))
    )
    array

  getDonutSize = (serie, series) ->
    inner = options.donutInner
    outer = options.donutOuter
    if serie != 0
      inner = options.donutInner2 + (serie - 1) * options.donutMultiplier / (series - 1)
      outer = options.donutOuter1 + (serie) * options.donutMultiplier / (series - 1)
    else if series > 1
      outer = options.donutOuter1
    [inner, outer]

  getSerie = (tags, tag_no, totalSeries) ->
    data = []
    array = getTagsLevel(tags, tag_no)
    _.each(array, (tag) ->
      data.push(
        name: tag.label
        y: tag.amount
        color: tag.color
        borderColor: tag.color
      )
    )

    size = getDonutSize(tag_no, totalSeries)
    distance = options.donutLabelDistance + (tag_no) * 30

    name: "Tag " + (tag_no + 1)
    animation: false
    data: data
    innerSize: size[0] + "%"
    size: size[1] + "%"
    tooltip:
      pointFormat: "{point.y:,.2f}"
    dataLabels:
      formatter: ->
        if tag_no > 0 || @key == "other"
          null
        else
          @key
      distance: distance
      style:
        fontSize: options.donutLabelSize

  getSeries = (tags) ->
    series = []
    for i in [0, 1, 2]
      series.push(getSerie(tags, i, 3))
    series

  self.getData = ->
    chart:
      type: "pie"
      marginLeft: options.donutMarginH
      marginRight: options.donutMarginH
      marginTop: options.donutMarginV
      marginBottom: options.donutMarginV
    title: null
    credits:
      enabled: false
    yAxis: {}
    plotOptions:
      pie:
        shadow: false
        center: ["50%", "50%"]
    tooltip:
      valueSuffix: ""
    series: getSeries(getTags(posts))

  this