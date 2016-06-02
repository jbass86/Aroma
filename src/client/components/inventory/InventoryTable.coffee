# Author: Josh Bass

css = require("./res/css/inventory_table.css");

React = require("react");

CreateInventory = require("./CreateInventory.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {};

  componentDidMount: ->
    console.log("mounted stuff")

  render: ->

    <div style={{"margin": "auto"}} className="inventory-table">

      {@props.items.map((item, index) =>
        <div className="inventory-table-entry" key={item._id}>

          <div className="row inventory-row">
            <div className="col-md-4">{item.name}</div>
            <div className="col-md-4">{item.type}</div>
            <div className="col-md-4">{item.status}</div>
          </div>

          {@renderInfoSection()}

        </div>
      )}
    </div>

  renderInfoSection: () ->
    <div className="inventory-info-section display-none">
      <div className="row">
        <div className="col-md-6">Info</div>
        <div className="col-md-6">Results</div>
      </div>
      <div className="row">
        <div className="col-md-6">Info</div>
        <div className="col-md-6">Results</div>
      </div>
      <div className="row">
        <div className="col-md-6">Info</div>
        <div className="col-md-6">Results</div>
      </div>
      <div className="row">
        <div className="col-md-6">Info</div>
        <div className="col-md-6">Results</div>
      </div>
    </div>

  getInfoSectionClasses: () ->
    console.log("do some stuff...");
