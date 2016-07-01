# Author: Josh Bass

React = require("react");

CustomerEdit = require("./CustomerEdit.coffee");
Moment = require("moment");

module.exports = React.createClass

  getInitialState: ->

    @default_state = {show_create_customer: false, first_name: "", middle_name: "", address: "", birthday: Moment(), \
      customer_alert: "", customer_success: false};

  render: ->

    <div className="create-item">
      <button type="button" className="mod-button btn btn-primary" onClick={@showCreateInventory}>Add Customer</button>
      <div className="clear-both"></div>
      <div className={@getCreateInventoryClasses()}>
        <CustomerEdit updateCustomer={@updateCustomer} handleFinish={@handleClose}/>
      </div>
    </div>

  getCreateInventoryClasses: ->

    classes = "collapsible"
    if (@state.show_create_customer)
      classes += " full-height-medium";
    else
      classes += " no-height";
    classes

  showCreateInventory: (ev) ->
    @setState({show_create_customer: true});

  handleClose: () ->
    @setState({show_create_customer: false});
    window.setTimeout(() =>
      @setState(@default_state);
    , 1000);

  updateCustomer: () ->
    @props.customerUpdate();
