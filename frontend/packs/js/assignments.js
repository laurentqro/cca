// Run this example by adding <%= javascript_pack_tag "hello_elm" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
// It will render "Hello Elm!" within the page.

import Elm from "../elm/Assignments.elm";

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("assignments-elm-app");
  const data = JSON.parse(node.getAttribute("data"));
  Elm.Assignments.embed(node, data);
});
