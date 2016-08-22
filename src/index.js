require("./index.html");
require("bulma/bulma.sass");

var Elm = require("./elm/main.elm");

var Main = Elm.Main;

console.log(Main);

Main.embed(document.getElementById('main'));
