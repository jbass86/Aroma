# Author: Josh Bass
# Description: Purpose of main here is to create the main react component and lay out all of the
#              sub components
window.$ = window.jQuery = window.jquery = require("jquery");
require('bootstrap');

React = require("react");
ReactDOM = require("react-dom");
css = require ("css/main.css");


HeaderBar = require("components/header_bar/HeaderBarView.coffee");
NavigationBar = require("components/navigation_bar/NavigationBarview.coffee");
LoginView = require("components/login/LoginView.coffee");

NavView = require("components/navigation_view/NavigationView.coffee");
Inventory = require("components/inventory/InventoryView.coffee");
Customers = require("components/customers/CustomerView.coffee");
Orders = require("components/orders/OrderView.coffee");
Analytics = require("components/analytics/AnalyticsView.coffee");


Backbone = require("backbone");

$(() ->

  nav_model = new Backbone.Model();
  nav_model.set("authenticated", false);
  nav_model.set("remove_login", false);

  comp = React.createClass

    getInitialState: () ->
      {authenticated: nav_model.get("authenticated"), remove_login: nav_model.get("remove_login")};

    componentDidMount: () ->
      console.log("mounted main comp");

      # window.setTimeout(()=>
      #   console.log("get an image");
      #   $.get("aroma/secure/get_inventory_image", {token: window.sessionStorage.token}, (response) =>
      #
      #     console.log("got the response back!!!");
      #     console.log(response);
      #     @setState({"img_url": "data:" + response.mimetype + ";base64," + response.buffer});
      #   );
      # , 5000);

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

          <div className={"main-area" + @getMainClasses()}>

            <NavView nav_model={nav_model} name="inventory">
              <Inventory />
            </NavView>
            <NavView nav_model={nav_model} name="customers">
              <Customers nav_model={nav_model} />
            </NavView>
            <NavView nav_model={nav_model} name="orders">
              <Orders nav_model={nav_model} />
            </NavView>
            <NavView nav_model={nav_model} name="analytics">
              <Analytics nav_model={nav_model} />
            </NavView>
          </div>
        </div>

      else
        <div style={{"width": "100vw", "height": "100vh"}}></div>

    getLoginClasses: () ->
      console.log("get login classes!");
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

    handleLoginSuccess: (token) ->
      window.sessionStorage.token = token;
      @setState({authenticated: true});
      window.setTimeout(()=>
        @setState({remove_login: true});
      , 1000);

  if (window.sessionStorage.token)
    $.post("aroma/secure/authenticate_token", {token: window.sessionStorage.token}, (response) =>
      nav_model.set("authenticated", response.success);
      nav_model.set("remove_login", response.success);
      ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));
    );
  else
    ReactDOM.render(React.createElement(comp, null), $("#react-body").get(0));

);
