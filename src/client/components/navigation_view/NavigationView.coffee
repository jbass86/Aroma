# Author: Josh Bass

React = require("react");

module.exports = React.createClass

  getInitialState: ->
    {current_selection: []};

  componentDidMount: ->
    @setState({current_selection: @props.nav_model.get("nav_selection")});
    @props.nav_model.on("change:nav_selection", () =>
      @setState({current_selection: @props.nav_model.get("nav_selection")});
    );

  render: ->

    <div className={@getClasses()}>
      {@props.children}
    </div>

  getClasses: ->
    classes = "";
    if (!@state.current_selection.includes(@props.name))
      classes += " display-none";
