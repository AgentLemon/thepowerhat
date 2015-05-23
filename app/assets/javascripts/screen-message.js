$(function() {
  var $screenMessage = $(".screen-message");
  var timer;
  var closeScreenMessage = function() {
    $screenMessage.animate({ top: ($screenMessage.data("top") || 0) - 33 }, 250, function() { $(this).hide(); });
  };

  $screenMessage.find(".close").click(closeScreenMessage);
  $screenMessage.click(closeScreenMessage);
  $screenMessage.mouseenter(function() { clearTimeout(timer); });

  $.message = function(type, text, closeTimer) {
    if (closeTimer === undefined) {
      closeTimer = 3000;
    }

    $screenMessage.removeClass("alert-warning alert-success alert-info alert-danger");
    $screenMessage.addClass("alert-" + type);
    $screenMessage.find(".message").html(text);
    $screenMessage.show();
    $screenMessage.animate({ top: $screenMessage.data("top") || 0 }, 250);

    if (closeTimer && closeTimer > 0) {
      timer = window.setTimeout(closeScreenMessage, closeTimer);
    }
  };

  $.message.error = function(text) { $.message("danger", "<strong>Error!</strong> " + text); };
  $.message.info = function(text) { $.message("info", text); };
  $.message.success = function(text) { $.message("success", text); };
  $.message.warning = function(text) { $.message("warning", "<strong>Warning!</strong> " + text); }

  $.each($.find(".flash-message"), function() {
    var $this = $(this);
    $.message($this.data("type"), $this.text());
  })
});