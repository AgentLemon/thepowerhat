$( ->

  loadingFixed = false

  $(document).on("scroll", ->
    if window.scrollY > 40 && !loadingFixed
      $(".loading-global").addClass("fixed")
      loadingFixed = true
    else if window.scrollY < 40 && loadingFixed
      $(".loading-global").removeClass("fixed");
      loadingFixed = false;
  )

  turnOn = ->
    $(".loading-global-wrap, .loading-global").show()
    window.scrollBy(0, 20)

  turnOff = ->
    $(".loading-global-wrap, .loading-global").hide()
    window.scrollBy(0, -20)

  $.setGlobalLoading = (value) ->
    if value then turnOn() else turnOff()

)
