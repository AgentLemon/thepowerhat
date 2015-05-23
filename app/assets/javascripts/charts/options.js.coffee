window.charts ||= {}
window.charts.options ||= {}

window.charts.options.desktop =
  donutInner: 0
  donutOuter: 100
  donutOuter1: 69
  donutInner2: 75
  donutMultiplier: 50
  donutLabelDistance: 50
  donutMarginH: 100
  donutMarginV: 0
  donutLabelSize: undefined

window.charts.options.mobile = $.extend({}, window.charts.options.desktop,
  donutOuter1: 49
  donutInner2: 60
  donutMultiplier: 50
  donutLabelDistance: 10
  donutMarginH: 30
  donutLabelSize: "0.75em"
)