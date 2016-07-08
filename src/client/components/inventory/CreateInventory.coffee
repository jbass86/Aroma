# Author: Josh Bass

React = require("react");

InventoryEdit = require("./InventoryEdit.coffee");
Moment = require("moment");

module.exports = React.createClass


  getInitialState: ->

    @default_state = {show_create_inventory: false, name: "", type: "", acquire_location: "", acquire_date: Moment(), \
      cost: "0.00", receipt: "", receipt_files: undefined, item_image: "", item_image_files: undefined, item_alert: "", \
      item_success: false};

  componentDidMount: ->

  render: ->

    <div className="create-item">
      <button type="button" className="mod-button btn btn-primary" onClick={@showCreateInventory}>Add Item</button>
      <div className="clear-both"></div>
      <div className={@getCreateInventoryClasses()}>
        <InventoryEdit updateInventory={@updateInventory} handleFinish={@handleClose}/>
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
    @setState({show_create_inventory: true});

  handleClose: () ->
    @setState({show_create_inventory: false});
    window.setTimeout(() =>
      @setState(@default_state);
    , 1000);

  updateInventory: () ->
    @props.inventoryUpdate();
