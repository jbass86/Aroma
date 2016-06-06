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
    @updateInventory();


  render: ->

    <div className="common-view inventory-view">
      <div className="section-title">
        Inventory
      </div>

      <CreateInventory inventoryUpdate={@updateInventory}/>

      <InventoryTable inventoryUpdate={@updateInventory} items={@state.inventory_items} />
    </div>

  updateInventory: () ->
    #this will eventually use the filters...
    $.get("aroma/secure/get_inventory", {token: window.sessionStorage.token}, (response) =>
      if (response.success)
        @setState(inventory_items: response.results);
    );
