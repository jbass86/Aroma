# Author: Josh Bass
# Description: Purpose of main here is to create the main react component and lay out all of the
#              sub components
window.$ = window.jQuery = window.jquery = require("jquery");
require('bootstrap');

React = require("react");
ReactDOM = require("react-dom");
css = require ("css/main.css");


$(() ->

  comp = React.createClass

    getInitialState: () ->
      return {};


    componentDidMount: () ->
      console.log("mounted main comp");


    render: () ->
      <div>Hello World</div>

  ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));
);
