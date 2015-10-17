$( ->
  loadingFixed = false

  $(document).on('scroll', ->
    threshold = if screen.width > 480 then 40 else 0

    if window.scrollY > threshold && !loadingFixed
      $globalMessages = $('.global-messages')
      $stub = $globalMessages.clone().addClass('stub')
      $stub.prependTo($globalMessages.parent())
      $globalMessages.addClass('fixed')
      loadingFixed = true
    else if window.scrollY < threshold && loadingFixed
      $globalMessages = $('.global-messages')
      $globalMessages.removeClass('fixed')
      $globalMessages.parent().find('.stub').remove()
      loadingFixed = false;
  )

  loadingOn = ->
    $('.loading-global').show()
    if window.scrollY != 0
      window.scrollBy(0, -20)

  loadingOff = ->
    $('.loading-global').hide()
    if window.scrollY != 0
      window.scrollBy(0, 20)

  appendMessage = (type, message) ->
    $message = $('<div class="message"/>').addClass(type).html(message)
    $message.appendTo($('.global-messages'))
    $message.show().addClass('visible')
    $message.on('click', ->
      $message.closest('.global-messages-container').find('.stub .message:first').remove()
      $message.remove();
      window.scrollBy(0, 20)
    )
    window.scrollBy(0, -20)
    setTimeout(( -> $message.click()), 5000)

  $.setGlobalLoading = (value) ->
    if value then loadingOn() else loadingOff()

  $.message = {
    success: (text) ->
      appendMessage('success', text)
    error: (text) ->
      appendMessage('error', text)
    warning: (text) ->
      appendMessage('warning', text)
    info: (text) ->
      appendMessage('success', text)
  }

  null
)
