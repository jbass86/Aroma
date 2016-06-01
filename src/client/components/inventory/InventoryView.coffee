# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateInventory = require("./CreateInventory.coffee");
InventoryTable = require("./InventoryTable.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {inventory_items: []};

  componentDidMount: ->
    console.log("mounted inventory component");
    $.get("aroma/secure/get_inventory", {token: window.sessionStorage.token}, (response) =>
      if (response.success)
        @setState(inventory_items: response.results);
    );

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

      <InventoryTable items={@state.inventory_items} />

    </div>
