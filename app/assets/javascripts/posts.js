$(function() {

  $.fn.initCtrlEnterSubmit = function() {
    $("form input, form textarea").keydown(function(event) {
      if (event.keyCode === 13 && event.metaKey === true) {
        $(this).closest("form").submit();
      }
    });
  };

  $(document).initCtrlEnterSubmit();
  $(document).on("ajax-form-load", function(event, dom) {
    $(dom).initCtrlEnterSubmit();
  });

});