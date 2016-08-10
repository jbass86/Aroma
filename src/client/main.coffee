# Author: Josh Bass
# Description: Purpose of main here is to create the main react component and lay out all of the
#              sub components
window.$ = window.jQuery = window.jquery = require("jquery");
require('bootstrap');

React = require("react");
ReactDOM = require("react-dom");
#require ("css/main.css");
require("../../node_modules/bootstrap/dist/css/bootstrap.css");
require("../../node_modules/react-datepicker/dist/react-datepicker.css");
#require("../../node_modules/react-widgets/dist/css/react-widgets.css");
require("styles/main.scss");

HeaderBar = require("components/header_bar/HeaderBarView.coffee");
NavigationBar = require("components/navigation_bar/NavigationBarview.coffee");
LoginView = require("components/login/LoginView.coffee");

NavView = require("components/navigation_view/NavigationView.coffee");
Inventory = require("components/inventory/InventoryView.coffee");
Customers = require("components/customers/CustomerView.coffee");
Orders = require("components/orders/OrderView.coffee");
Analytics = require("components/analytics/AnalyticsView.coffee");

#DropdownList = require("react-widgets").DropdownList;

Backbone = require("backbone");

$(() ->

  nav_model = new Backbone.Model();
  nav_model.set("authenticated", false);
  nav_model.set("remove_login", false);

  order_model = new Backbone.Model();

  comp = React.createClass

    getInitialState: () ->
      {authenticated: nav_model.get("authenticated"), remove_login: nav_model.get("remove_login")};

    render: () ->
      <div>
        <div className={@getLoginClasses()}>
          <LoginView login_success={@handleLoginSuccess}/>
        </div>
        {@renderMain()}
      </div>

    renderMain: () ->

      if (@state.authenticated)
        <div>
          <NavigationBar nav_model={nav_model}/>

          <div className={"header-area" + @getMainClasses()}>
            <HeaderBar nav_model={nav_model}/>
          </div>

          <div className={"main-area" + @getMainClasses()} onClick={@closeNav}>

            <NavView nav_model={nav_model} name="orders">
              <Orders nav_model={nav_model} order_model={order_model} />
            </NavView>
            <NavView nav_model={nav_model} name="customers">
              <Customers nav_model={nav_model} order_model={order_model} />
            </NavView>
            <NavView nav_model={nav_model} name="inventory">
              <Inventory order_model={order_model} />
            </NavView>
            <NavView nav_model={nav_model} name="analytics">
              <Analytics nav_model={nav_model} />
            </NavView>
          </div>

        </div>

      else
        <div style={{"width": "100vw", "height": "100vh"}}></div>

    getLoginClasses: () ->
      classes = "";
      if (@state.authenticated)
        classes += " fade-out";
      if (@state.remove_login)
        classes += " display-none";
      classes;

    getMainClasses: () ->
      classes = "";
      if (@state.authenticated)
        classes += " fade-in";
      else
        classes += " fade-out"
      classes;

    handleLoginSuccess: (login_data) ->
      window.sessionStorage.token = login_data.token;
      window.user_info = {username: login_data.username, group: login_data.group};
      @setState({authenticated: true});
      window.setTimeout(()=>
        @setState({remove_login: true});
      , 1000);

    closeNav: () ->
      nav_model.set("nav_visible", false);

  if (window.sessionStorage.token)
    $.post("aroma/secure/authenticate_token", {token: window.sessionStorage.token}, (response) =>
      window.user_info = {username: response.username, group: response.group};
      nav_model.set("authenticated", response.success);
      nav_model.set("remove_login", response.success);
      ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));
    );
  else
    ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));

);
