# Author: Josh Bass
# Description: The React View for the Header bar at the top of the mast diagnostic display.
React = require("react");
mathjs = require("mathjs");

css = require("./res/css/header_bar.css")

module.exports = React.createClass

  getInitialState: ->
    {time: "00:00:00", export_data_alert: false};

  componentDidMount: ->
    window.setInterval(() =>
      date = new Date();
      @setState({time: date.toString()});
    , mathjs.unit("1 s").toNumber("ms"));

  render: ->

    <div className="header-bar unselectable">
      <span className="glyphicon glyphicon-menu-hamburger menu-button" onClick={@menuButtonClicked} />
      <button type="button" className="btn btn-info export-data-button" onClick={@toggleExportDataAlert}>Export Data</button>
      <div className={@getAlertClasses()}>
        <div>
          Export Data and Save to MFOP?
        </div>
        <div className="alert-button-panel">
          <button className="btn btn-default alert-button" onClick={@alertButtonClicked.bind(@, true)}>Yes</button>
          <button className="btn btn-default alert-button" onClick={@alertButtonClicked.bind(@, false)}>No</button>
          <div className="clear-both"></div>
        </div>
      </div>
      <span className="time-readout">{@state.time}</span>
    </div>

  getAlertClasses: () ->
    classes = "alert alert-danger box-shadow export-data-alert";
    if (@state.export_data_alert)
      classes = classes + " fade-in";
    else
      classes = classes + " fade-out"

  menuButtonClicked: (ev) ->
    @props.nav_model.set("nav_visible", !@props.nav_model.get("nav_visible"));

  toggleExportDataAlert: (ev) ->
    @setState({export_data_alert: !@state.export_data_alert});

  alertButtonClicked: (action) ->

    if (action == true)
      $.post("export_diagnostic_data", {});
    @toggleExportDataAlert();
