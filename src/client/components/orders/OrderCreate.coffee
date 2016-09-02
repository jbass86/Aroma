# Author: Josh Bass

React = require("react");

module.exports = React.createClass

  getInitialState: ->

    @default_state = {show_create_order: false};

  render: ->

    <div className="create-item">
      <button type="button" className="mod-button btn btn-primary" onClick={@showCreateOrder}>Create Order</button>
      <div className="clear-both"></div>
      <div className={@getClasses()}>
        <div>
          Create An order click on stuff below
        </div>
      </div>
    </div>

  getClasses: ->

    classes = "collapsible"
    if (@state.show_create_order)
      classes += " full-height-medium";
    else
      classes += " no-height";
    classes

  showCreateOrder: (ev) ->
    @props.order_model.set("order_mode", true);
    @setState({show_create_order: true});

  handleClose: () ->
    @setState({show_create_order: false});
    window.setTimeout(() =>
      @setState(@default_state);
    , 1000);

  updateOrder: () ->
    @props.orderUpdate();
