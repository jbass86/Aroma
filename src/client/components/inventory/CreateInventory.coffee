# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

DatePicker = require("react-datepicker")
require('react-datepicker/dist/react-datepicker.css');

Moment = require("moment");

css = require("./res/css/create_inventory.css");

module.exports = React.createClass

  getInitialState: ->
    @default_state = {name: "", type: "", acquire_location: "", acquire_date: Moment(), \
      cost: "0.00", receipt: "", receipt_files: undefined, item_alert: "", item_success: false};

  componentDidMount: ->

  render: ->

    <div className="add-inventory">

      {@createInputField("name", "Name:", "text")}
      {@createInputField("type", "Type:", "text")}

      <div className="inventory-input-field">
        <div className="inventory-input-label">
          Acquire Date:
        </div>
        <DatePicker className="inventory-date-field" selected={@state.acquire_date} onChange={@handleAcquireDate} todayButton={'Today'} />
        <div className="clear-both"></div>
      </div>

      {@createInputField("acquire_location", "Acquire Location:", "text")}
      {@createInputField("cost", "Cost:", "number")}
      {@createInputField("receipt", "Receipt:", "file")}

      {@getCreateItemAlert()}

      <div className="inventory-create-buttons">
        <button className="btn btn-success" onClick={@handleCreateItem}>Create Item</button>
        <button className="btn btn-danger" onClick={@handleClose}>Cancel</button>
      </div>
    </div>

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

    input_class = if (type == "file") then "inventory-file-input" else "inventory-input";

    <div className="inventory-input-field">
      <div className="inventory-input-label">
        {display_name}
      </div>
      <input className={input_class} type={type} accept="image/*" onChange={(event)=>@handleFieldUpdate(name, event)} />
      <div className="clear-both"></div>
    </div>

  handleFieldUpdate: (field_name, event) ->
    update = {};
    value = event.target.value;
    if (event.target.type == "number")
      value = mathjs.round(value, 2);
    if (event.target.type == "file")
      update.receipt_files = event.target.files;

    update[field_name] = value;
    @setState(update, () => console.log(@state));

  handleAcquireDate: (moment) ->
    @setState({acquire_date: moment});

  handleCreateItem: () ->

    form = new FormData();
    form.append("token", window.sessionStorage.token);
    form.append("name", @state.name);
    form.append("type", @state.type);
    form.append("acquire_location", @state.acquire_location);
    form.append("acquire_date", @state.acquire_date.toDate());
    form.append("cost", @state.cost);
    form.append("receipt_name", @state.receipt);

    if (@state.receipt)
      form.append("file", @state.receipt_files[0]);

    console.log("made form data");
    $.ajax({
      url: 'aroma/secure/single_image/update_inventory',
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
        console.log(response);
        @setState({item_alert: response.message, item_success: response.success});
        window.setTimeout(() =>
          @handleClose();
        , 2000);

    });

  handleClose: () ->
    @props.close_event(@state.item_success);
    window.setTimeout(() =>
      @setState(@default_state)
    , 1000);
