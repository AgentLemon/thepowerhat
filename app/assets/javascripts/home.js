$(function() {
  $(document).delegate("button, a", "focus", function() { $(this).blur(); });

  $.fn.selectText = function() {
    var doc = document;
    var element = this[0];
    if (doc.body.createTextRange) {
      var range = document.body.createTextRange();
      range.moveToElementText(element);
      range.select();
    } else if (window.getSelection) {
      var selection = window.getSelection();
      var range = document.createRange();
      range.selectNodeContents(element);
      selection.removeAllRanges();
      selection.addRange(range);
    }
  };

  $(document).delegate(".code-container .line-counter span", "click", function() {
    var $this = $(this);
    $this.closest(".code-container").find(".code-wrap .code :eq(" + $this.index() +")").selectText();
  });

  $(document).delegate(".btn-open-menu-left", "click", function() {
    $(".page-col, .menu-col").toggleClass("moved-right").removeClass("moved-left");
    return false;
  });

  $(document).delegate(".btn-open-menu-right", "click", function() {
    $(".page-col, .menu-col").toggleClass("moved-left").removeClass("moved-right");
    return false;
  });

  $(document).delegate(".menu-col a", "click", function() {
    $(".page-col, .menu-col").removeClass("moved-left").removeClass("moved-right");
  });

  $(document).delegate(".admin-enabled", "load", function() {
    console.log($(this));
  });

  FastClick.attach(document.body);
});