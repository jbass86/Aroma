# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateInventory = require("./CreateInventory.coffee");
Filters = require("client/components/filters/FiltersView.coffee");
InventoryTable = require("./InventoryTable.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    @filter_types = [{key: "name", name: "Name", type: "text"}, {key: "type", name: "Type", type: "text"}];
    {inventory_items: []};

  componentDidMount: ->
    console.log("mounted inventory component");
    @updateInventory();


  render: ->

    <div className="common-view inventory-view">
      <div className="section-title">
        Inventory
      </div>
      <CreateInventory inventoryUpdate={@updateInventory} />
      <Filters filterTypes={@filter_types} />
      <InventoryTable inventoryUpdate={@updateInventory} items={@state.inventory_items} />
    </div>

  updateInventory: () ->
    #this will eventually use the filters...
    $.get("aroma/secure/get_inventory", {token: window.sessionStorage.token}, (response) =>
      if (response.success)
        @setState(inventory_items: response.results);
    );
