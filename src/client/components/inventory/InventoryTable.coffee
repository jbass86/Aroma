# Author: Josh Bass

React = require("react");

CreateInventory = require("./CreateInventory.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {};

  componentDidMount: ->
    console.log("mounted inventory table!!!");

  render: ->

    <div className="inventory-table">

    </div>
