# Author: Josh Bass

mathjs = require("mathjs");
React = require("react");
DatePicker = require("react-datepicker");
Moment = require("moment");

module.exports = React.createClass

  getInitialState: ->
    @default_state = {_id: undefined, name: "", type: "", acquire_location: "", acquire_date: Moment(), cost: "0.00", sale_price: "0.00", receipt_image: "", \
     receipt_files: undefined, item_image: "", item_image_files: undefined, item_alert: "", item_success: false, update_from_props: true, \
     receipt_image_ref: undefined, item_image_ref: undefined};

  componentDidMount: ->
    @checkInitialState();

  componentWillUnmount: ->
    if (@reset_default_timeout)
      window.clearTimeout(@reset_default_timeout);
      @reset_default_timeout = undefined;

  componentDidUpdate: ->
    @checkInitialState();

  checkInitialState: ->
    if (@props.initialState and @state.update_from_props)
      name = if @props.initialState.name then @props.initialState.name else @default_state.name;
      type = if @props.initialState.type then @props.initialState.type else @default_state.type;
      acquire_location = if @props.initialState.acquire_location then @props.initialState.acquire_location else @default_state.acquire_location;
      acquire_date = if @props.initialState.acquire_date then @props.initialState.acquire_date else @default_state.acquire_date;
      cost = if @props.initialState.cost then @props.initialState.cost else @default_state.cost;
      sale_price = if @props.initialState.sale_price then @props.initialState.sale_price else @default_state.sale_price;
      receipt_image_ref = if @props.initialState.receipt_image_ref then @props.initialState.receipt_image_ref else @default_state.receipt_image_ref;
      item_image_ref = if @props.initialState.item_image_ref then @props.initialState.item_image_ref else @default_state.item_image_ref;
      @setState({_id: @props.initialState._id, name: name, type: type, acquire_location: acquire_location, \
      acquire_date: acquire_date, cost: cost, update_from_props: false, receipt_image_ref: receipt_image_ref, item_image_ref: item_image_ref});

  render: ->

    <div className="add-inventory">

      {@createInputField("name", "Name:", "text")}
      {@createInputField("type", "Type:", "text")}

      <div className="row inventory-create-row">
        <div className="col-md-4">
          Acquire Date:
        </div>
        <div className="col-md-8">
          <DatePicker className="inventory-input-field" selected={@state.acquire_date} onChange={@handleAcquireDate} todayButton={'Today'} />
        </div>
      </div>

      {@createInputField("acquire_location", "Acquire Location:", "text")}
      {@createInputField("cost", "Cost:", "number")}
      {@createInputField("sale_price", "Sale Price:", "number")}
      {@createInputField("item_image", "Item Image:", "file")}
      {@createInputField("receipt_image", "Receipt:", "file")}

      {@getCreateItemAlert()}

      <div className="row inventory-create-buttons">
        <button className="col-md-6 btn btn-primary" onClick={@handleCreateItem}>{@getCreateButtonText()}</button>
        <button className="col-md-6 btn btn-danger" onClick={@handleCancel}>Cancel</button>
      </div>
    </div>

  getCreateButtonText: () ->
    if (@state._id)
      "Update Item"
    else
      "Create Item"

  getCreateItemAlert: () ->
    success = if (@state.item_success) then " alert-success" else " alert-danger";
    if (@state.item_alert)
      <div className={"general-alert alert alert-dismissible" + success} role="alert">
         <button type="button" className="close" aria-label="Close" onClick={@dismissAlert}><span aria-hidden="true">&times;</span></button>
         <strong>{if (@state.item_success) then "Success!" else "Error!"}</strong> {@state.item_alert}
      </div>
    else
      <div></div>

  dismissAlert: (event) ->
    @setState({item_alert: ""});

  createInputField: (name, display_name, type) ->

    input_class = if (type == "file") then "inventory-file-input" else "inventory-input-field";

    inputCreate = () =>
      if (type == "file")
        <div>
          <label style={{"float": "left"}} className="btn btn-primary">
            Select File <input type="file" style={{"display": "none"}} accept="image/*" onChange={(event)=>@handleFieldUpdate(name, event)} />
          </label>
          <input type="text" className="form-control inventory-input-field" style={{"float": "left", "width": "70%"}} value={@state[name]} readOnly="true" />
        </div>
      else
        <div>
          <input type={type} className={input_class} value={@state[name]} onChange={(event)=>@handleFieldUpdate(name, event)} />
        </div>

    <div className="row inventory-create-row">
      <div className="col-md-4">
        {display_name}
      </div>
      <div className="col-md-8">
        {inputCreate()}
      </div>
    </div>

  handleFieldUpdate: (field_name, event) ->
    update = {};
    value = event.target.value;
    if (event.target.type == "number")
      value = mathjs.round(value, 2);
    if (event.target.type == "file")
      paths = value.split("\\");
      value = paths[paths.length - 1];
      if (field_name == "receipt_image")
        update.receipt_files = event.target.files;
      else if (field_name == "item_image")
        update.item_image_files = event.target.files;

    update[field_name] = value;
    @setState(update);

  handleAcquireDate: (moment) ->
    @setState({acquire_date: moment});

  handleCreateItem: () ->

    form = new FormData();
    form.append("token", window.sessionStorage.token);
    if (@state._id)
      form.append("_id", @state._id);
    form.append("name", @state.name);
    form.append("type", @state.type);
    form.append("acquire_location", @state.acquire_location);
    form.append("acquire_date", @state.acquire_date.toDate());
    form.append("cost", @state.cost);
    form.append("sale_price", @state.sale_price);
    form.append("receipt_name", @state.receipt_image);
    form.append("item_name", @state.item_image);
    form.append("item_image_ref", @state.item_image_ref);
    form.append("receipt_image_ref", @state.receipt_image_ref);

    if (@state.item_image)
      form.append("item_image_file", @state.item_image_files[0]);

    if (@state.receipt_image)
      form.append("receipt_image_file", @state.receipt_files[0]);

    $.ajax({
      url: 'aroma/secure/update_inventory',
      data: form,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      mimeType: 'multipart/form-data',
      fail: (data) =>
        response = JSON.parse(data);
        @setState({item_alert: response.message, item_success: response.success});
      success: (data) =>
        response = JSON.parse(data);
        @setState({item_alert: response.message, item_success: response.success});
        @props.updateInventory(@state._id);
        window.setTimeout(() =>
          @reset_default_timeout = window.setTimeout(() =>
            @reset_default_timeout = undefined;
            @setState(@default_state);
          , 1000);
          @props.handleFinish();
        , 2000);
    });

  handleCancel: () ->
    @setState(@default_state);
    @props.handleFinish();
