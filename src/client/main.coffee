# Author: Josh Bass
# Description: Purpose of main here is to create the main react component and lay out all of the
#              sub components
window.$ = window.jQuery = window.jquery = require("jquery");
require('bootstrap');

React = require("react");
ReactDOM = require("react-dom");
css = require ("css/main.css");


HeaderBar = require("components/header_bar/HeaderBarView.coffee");
LoginView = require("components/login/LoginView.coffee");


Backbone = require("backbone");

$(() ->

  a_model = new Backbone.Model();

  comp = React.createClass

    getInitialState: () ->
      return {authenticated: false, remove_login: false};


    componentDidMount: () ->
      console.log("mounted main comp");


    render: () ->
      <div>
        <div className={@getLoginClasses()}>
          <LoginView login_success={@handleLoginSuccess}/>
        </div>
        {@renderMain()}
      </div>

    renderMain: () ->
      if (@state.authenticated)
        <div>
          <div className={"header-area" + @getMainClasses()}>
            <HeaderBar nav_model={a_model}/>
          </div>
          <div className={"nav-area" + @getMainClasses()}></div>
          <div className={"main-area" + @getMainClasses()}>Hello World</div>
        </div>
      else
        <div></div>

    getLoginClasses: () ->
      console.log("get login classes!");
      classes = "";
      if (@state.authenticated)
        classes += " fade-out";
      if (@state.remove_login)
        classes += " display-none";
      classes;

    getMainClasses: () ->
      classes = "";
      if (@state.authenticated)
        classes += " fade-in";
      else
        classes += " fade-out"
      classes;

    handleLoginSuccess: (token) ->
      window.token = token;
      @setState({authenticated: true});
      window.setTimeout(()=>
        @setState({remove_login: true});
      , 1000);

  ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));

  # $.post("aroma/create_user", {username: "Josh", password: "Bass"}, (response) =>
  #   console.log(response);
  # );
);
