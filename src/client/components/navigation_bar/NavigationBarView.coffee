# Author: Josh Bass

React = require("react");
css = require("./res/css/navigation_bar.css");

module.exports = React.createClass

  getInitialState: ->
    {nav_visible: false, nav_selection: "inventory"};

  componentDidMount: ->

    @props.nav_model.set("nav_selection", @state.nav_selection);
    @props.nav_model.on("change:nav_visible", () =>
      @setState({"nav_visible": @props.nav_model.get("nav_visible")});
    );

  render: ->

    <div className={"nav-bar-view collapsible" + if @state.nav_visible then " full-width-med" else " no-width"}>
      <h2 className="nav-header">
        <span>Aroma</span>
      </h2>

      <div className="nav-selections unselectable">
        <div className={@getNavSelectionClasses("inventory")} onClick={@selectNavView.bind(@, "inventory")}>Inventory</div>
        <div className={@getNavSelectionClasses("customers")} onClick={@selectNavView.bind(@, "customers")}>Customers</div>
        <div className={@getNavSelectionClasses("orders")} onClick={@selectNavView.bind(@, "orders")}>Orders</div>
        <div className={@getNavSelectionClasses("analytics")} onClick={@selectNavView.bind(@, "analytics")}>Analytics</div>
      </div>
    </div>

  getNavSelectionClasses: (name) ->
    console.log("get nav selections");
    console.log(name);
    classes = "nav-selection label";
    if (@state.nav_selection == name)
      classes += " label-success";
    else
      classes += " label-default";
    classes;

  selectNavView: (name, event) ->

    @setState({nav_selection: name}, () =>
      @props.nav_model.set("nav_selection", @state.nav_selection);
    );
