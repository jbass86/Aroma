# Author: Josh Bass
# Description: The React View for the Header bar at the top of the mast diagnostic display.
React = require("react");
mathjs = require("mathjs");

require("./res/styles/header_bar.scss")

module.exports = React.createClass

  getInitialState: ->
    {time: "00:00:00", export_data_alert: false};

  componentDidMount: ->
    window.setInterval(() =>
      date = new Date();
      @setState({time: date.toTimeString().split(' ')[0]});
    , mathjs.unit("1 s").toNumber("ms"));

  render: ->

    <div className="header-bar unselectable">
      <span className="glyphicon glyphicon-menu-hamburger menu-glyph nav-button" onClick={@menuButtonClicked} />
      <span className="user-name">{window.user_info.username}</span>
      <span className="glyphicon glyphicon-log-out menu-glyph logout-button" onClick={@logout}></span>
    </div>

  getAlertClasses: () ->
    classes = "alert alert-danger box-shadow export-data-alert";
    if (@state.export_data_alert)
      classes = classes + " fade-in";
    else
      classes = classes + " fade-out"

  menuButtonClicked: (ev) ->
    @props.nav_model.set("nav_visible", !@props.nav_model.get("nav_visible"));

  logout: (ev) ->
    window.sessionStorage.token = undefined;
    window.location.reload(true);
