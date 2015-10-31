directives.directive("textarea", () ->
  restrict: 'E',
  link: (scope, element, attrs) ->
    $el = $(element)
    $el.on('keydown', (event) ->
      if (event.keyCode == 9)
        pos = $el.prop('selectionStart')
        val = $el.val()
        textBefore = val.substring(0,  pos )
        textAfter  = val.substring(pos, val.length)
        $el.val(textBefore + '    ' + textAfter)
        $el.prop('selectionStart', pos + 4)
        $el.prop('selectionEnd', pos + 4)

        event.stopPropagation()
        return false
    )
)
