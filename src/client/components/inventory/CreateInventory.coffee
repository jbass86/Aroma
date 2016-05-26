# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

DatePicker = require("react-datepicker")
require('react-datepicker/dist/react-datepicker.css');

Moment = require("moment");

css = require("./res/css/create_inventory.css");
console.log(css);

module.exports = React.createClass

  getInitialState: ->
    @default_state = {name: "", type: "", acquire_location: "", acquire_date: Moment(), cost: "0.00", recepit: "", recepit_files: undefined};

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
      {@createInputField("recepit", "Receipt:", "file")}

      <div className="inventory-create-buttons">
        <button className="btn btn-success" onClick={@handleCreateItem}>Create Item</button>
        <button className="btn btn-danger" onClick={@handleCancel}>Cancel</button>
      </div>
    </div>

  createInputField: (name, display_name, type) ->

    input_class = if (type == "file") then "inventory-file-input" else "inventory-input";

    <div className="inventory-input-field">
      <div className="inventory-input-label">
        {display_name}
      </div>
      <input className={input_class} type={type} value={@state[name]} onChange={(event)=>@handleFieldUpdate(name, event)} />
      <div className="clear-both"></div>
    </div>

  handleFieldUpdate: (field_name, event) ->
    update = {};
    value = event.target.value;
    if (event.target.type == "number")
      value = mathjs.round(value, 2);
    if (event.target.type == "file")
      update.recepit_files = event.target.files;

    update[field_name] = value;
    @setState(update, ()=>console.log(@state));

  handleAcquireDate: (moment) ->
    @setState({acquire_date: moment});

  handleCreateItem: () ->
    console.log("create item");

  handleCancel: () ->
    @setState(@default_state);
