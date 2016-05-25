# Author: Josh Bass

React = require("react");

module.exports = React.createClass

  getInitialState: ->
    {current_selection: ""};

  componentDidMount: ->
    @setState({current_selection: @props.nav_model.get("nav_selection")});
    @props.nav_model.on("change:nav_selection", () =>
      @setState({current_selection: @props.nav_model.get("nav_selection")});
    );

  render: ->

    <div style={{"width": "100%", "height": "100%"}} className={@getClasses()}>
      {@props.children}
    </div>

  getClasses: ->
    classes = "";
    if (@state.current_selection != @props.name)
      classes += " display-none";
