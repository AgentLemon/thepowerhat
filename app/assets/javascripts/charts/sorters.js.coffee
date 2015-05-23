window.charts ||= {}
window.charts.sorters ||= {}

window.charts.sorters.alphabetical = (a, b) ->
  label1 = a.label.toUpperCase()
  label2 = b.label.toUpperCase()
  if label1 > label2 && label2 != "other"
    1
  else if label1 < label2 && label1 != "other"
    -1
  else
    0

window.charts.sorters.byDate = (a, b) ->
  a.date - b.date
