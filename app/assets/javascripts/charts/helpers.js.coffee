window.charts ||= {}

window.charts.helpers =
  colors: ["#4d4d4d", "#5da5da", "#faa43a", "#60bd68", "#f17cb0", "#b2912f", "#b276b2", "#decf3f", "#f15854"]
  getColorForPie: (index) ->
    if index < @colors.length
      @colors[index]
    else
      @colors[(index - 1) % (@colors.length - 1) + 1]
  getColor: (index) ->
    @colors[index % @colors.length]

  getTagByLabel: (tags, label) ->
    tag = null
    _.each(tags, (item) ->
      if item.label == label
        tag = item
        return false
    )
    unless tag
      tag = { label: label }
      tags.push(tag)
    tag

  months: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  formatDateDM: (date) ->
    date.getDate() + " " + @months[date.getMonth()]
