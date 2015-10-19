changeColor = function(element, textColor, fontStyle) {
  var links = document.getElementsByClassName("room-links");
  for (i = 0; i < links.length; i++) {
    links[i].style.color = "#777";
    links[i].style.textDecoration = "none"
    links[i].className = "room-links"
  }
  element.classList.add("selected-room");
  element.style.color = textColor;
  if (fontStyle != null) {
    return element.style.textDecoration = fontStyle;
  }
};

$(document).on("page:load ready", function() {
  $("a[data-text-color]").click(function(e) {
    var textColor, fontStyle;
    e.preventDefault();
    textColor = $(this).data("text-color");
    fontStyle = $(this).data("font-style");
    return changeColor(this, textColor, fontStyle);
  });
});