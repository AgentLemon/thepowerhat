window.helpers ||= {}

helpers.convertToDate = (date) ->
  if date
    (date.getYear() + 1900) + "-" + (date.getMonth() + 1) + "-" + date.getDate()
  else
    null