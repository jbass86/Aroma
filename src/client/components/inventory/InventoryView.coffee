# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateInventory = require("./CreateInventory.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {show_create_inventory: false};

  componentDidMount: ->
    console.log("mounted inventory component");

  render: ->

    <div className="common-view inventory-view">
      <div className="section-title">
        Inventory
      </div>
      <div className="create-inventory">
        <button type="button" className="inventory-mod-button btn btn-info" onClick={@showCreateInventory}>Add Item</button>
        <div className="clear-both"></div>
        <div className={@getCreateInventoryClasses()}>
          <CreateInventory />
        </div>
      </div>

      <div className="filter-inventory">
        <button type="button" className="inventory-mod-button btn btn-info">Add Filter</button>
        <div className="clear-both"></div>
        <div>
        </div>
      </div>
    </div>

  getCreateInventoryClasses: ->

    classes = "collapsible"
    if (@state.show_create_inventory)
      classes += " full-height-medium";
    else
      classes += " no-height";
    classes

  showCreateInventory: (ev) ->
    console.log("show create inventory");
    @setState({show_create_inventory: true});
