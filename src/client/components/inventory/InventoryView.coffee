# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateInventory = require("./CreateInventory.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {};

  componentDidMount: ->
    console.log("mounted inventory component");

  render: ->

    <div className="common-view inventory-view">
      <div className="section-title">
        Inventory
      </div>

      <CreateInventory />

      <div className="filter-inventory">
        <button type="button" className="inventory-mod-button btn btn-info">Add Filter</button>
        <div className="clear-both"></div>
        <div>
        </div>
      </div>
    </div>
