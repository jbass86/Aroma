# Author: Josh Bass
# Description: Purpose of main here is to create the main react component and lay out all of the
#              sub components
window.$ = window.jQuery = window.jquery = require("jquery");
require('bootstrap');

React = require("react");
ReactDOM = require("react-dom");
css = require ("css/main.css");

HeaderBar = require("components/header_bar/HeaderBarView.coffee");
Backbone = require("backbone");

$(() ->

  a_model = new Backbone.Model();

  comp = React.createClass

    getInitialState: () ->
      return {};


    componentDidMount: () ->
      console.log("mounted main comp");


    render: () ->
      <div>
        <div className="header-area">
          <HeaderBar nav_model={a_model}/>
        </div>
        <div className="nav-area"></div>
        <div className="main-area">Hello World</div>
      </div>
  ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));

  $.post("aroma/create_user", {username: "Bass", password: "Password"}, (response) =>
    console.log(response);
  );

  window.setTimeout(() =>
    $.post("aroma/authenticate", {username: "Bass", password: "Password"}, (response) =>
      console.log(response);
    );
  , 2000);
);
