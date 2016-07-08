# Author: Josh Bass

React = require("react");

CreateInventory = require("./CreateInventory.coffee");
Filters = require("client/components/filters/FiltersView.coffee");
InventoryTable = require("./InventoryTable.coffee");

require("./res/styles/inventory.scss");

module.exports = React.createClass

  getInitialState: ->
    @filter_types = [{key: "name", name: "Name", type: "text"}, {key: "type", name: "Type", type: "text"}, \
      {key: "acquire_date", name: "Acquire Date", type: "date"}, {key: "cost", name: "Cost", type: "number"},  \
      {key: "sale_price", name: "Sale Price", type: "number"}, \
      {key: "acquire_location", name: "Acquire Location", type: "text"}];
    {inventory_items: [], filters: {}};

  componentDidMount: ->
    @updateInventory();


  render: ->

    <div className="common-view">
      <div className="section-title">
        Inventory
      </div>
      <CreateInventory inventoryUpdate={@updateInventory} />
      <Filters filterTypes={@filter_types} applyFilters={@applyFilters} />
      <InventoryTable inventoryUpdate={@updateInventory} items={@state.inventory_items} />
    </div>

  applyFilters: (filters) ->
    @setState({filters: filters}, () =>
      @updateInventory();
    );

  updateInventory: () ->
    $.get("aroma/secure/get_inventory", {token: window.sessionStorage.token, filters: @state.filters}, (response) =>
      if (response.success)
        @setState(inventory_items: response.results);
    );
