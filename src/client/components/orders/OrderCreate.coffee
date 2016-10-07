# Author: Josh Bass

React = require("react");

module.exports = class OrderCreate extends React.Component

  constructor: (props) ->
    super(props);
    @state = {show_create_order: false};

    @props.order_model.on("change:customer", (model, value) =>
      console.log("order create got a customer update");
      console.log(value);
      if (@state.show_create_order)
        @setState({customer: value});
    );

    @props.order_model.on("change:inventory", (model, value) =>
      console.log("order create got a inventory update");
      console.log(value);
      if (@state.show_create_order)
        @setState({inventory: value});
    );


  render: ->

    <div className="create-item">
      <button type="button" className="mod-button btn btn-primary" onClick={@showCreateOrder.bind(@)}>Create Order</button>
      <div className="clear-both"></div>
      <div className={@getClasses()}>
        <div className="order-create">
          <span>
            Select Customer and Items for Order
          </span>
          <div>
            {@renderCustomerSelection()}
            {@renderInventorySelection()}
          </div>
          <div className="row common-create-buttons">
            <button className="col-md-6 btn button-ok">Submit Order</button>
            <button className="col-md-6 btn button-cancel">Cancel</button>
          </div>
        </div>

      </div>
    </div>

  renderCustomerSelection: () ->

    if (@state.customer)
      <div className="order-customer">
        <div className="order-customer-label">Customer</div>
        <div className="row">
          <span className="col-md-3">
            {@state.customer._id}
          </span>
          <span className="col-md-3">
            {@state.customer.first_name}
          </span>
          <span className="col-md-3">
            {@state.customer.last_name}
          </span>
          <span className="col-md-3">
            {@state.customer.email}
          </span>
        </div>
      </div>
    else
      <div></div>

  renderInventorySelection: () ->
    <div></div>

  getClasses: ->

    classes = "collapsible"
    if (@state.show_create_order)
      classes += " full-height-medium";
    else
      classes += " no-height";
    classes

  showCreateOrder: (ev) ->
    @props.order_model.set("order_mode", "create_order");
    @setState({show_create_order: true});

  handleClose: () ->
    @setState({show_create_order: false});
    window.setTimeout(() =>
      @setState(@default_state);
    , 1000);

  updateOrder: () ->
    @props.orderUpdate();
