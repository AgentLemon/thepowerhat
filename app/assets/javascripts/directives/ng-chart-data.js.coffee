directives.directive("ngChartData", () ->
  (scope, element, attrs) ->

    getBuilder = (posts) ->
      isMobile = $(element).height() < 300
      chart = scope[attrs.ngChart].id
      if chart == "by_day"
        new charts.SpentByDay(posts, scope[attrs.ngStartDate], scope[attrs.ngEndDate], scope[attrs.ngDaySpending], isMobile)
      else if chart == "by_tag"
        new charts.DonutChartBuilder(posts, isMobile)

    redraw = (chartData) ->
      $(element).highcharts(chartData)

    checkRedraw = (newValue, oldValue) ->
      if newValue && newValue != oldValue
        redraw(getBuilder(scope[attrs.ngChartData]).getData())

    scope.$watch(attrs.ngReloadToken, checkRedraw)
    scope.$watch(attrs.ngChart, checkRedraw)
    scope.$watch(attrs.ngDaySpending, checkRedraw)
)
