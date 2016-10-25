require("./index.html");
require("./layout.html");
require("./authorize_step_2.html");
require("bulma/bulma.sass");

var Elm = require("./elm/Main.elm");

var Main = Elm.Main;


const application = Main.embed(document.getElementById('main'));

let apiToken = null;


const lookForToken = function lookForToken(root) {
  try {
    return root.tokens.access;
  } catch(e) {
    console.error(e);
    return false;
  }
}

const initWithApiToken = function initWithApiToken(application) {
  let token = lookForToken(window.Kiva)

  if(!token) {
    console.log("No token yet");
    setTimeout(initWithApiToken, 1, application, window.Kiva);
    return false;
  } else {
    application.ports.kivaApiToken.send(token);
    return true;
  }
}

initWithApiToken(application, window.Kiva);
