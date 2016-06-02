# Author: Josh Bass

React = require("react");

CreateUserView = require("./CreateUserView.coffee");

css = require("./res/css/login.css")

module.exports = React.createClass

  getInitialState: ->
    {username: "", password: "", login_alert: "", show_create_user: false};

  componentDidMount: ->

  render: ->

    <div className="login-view">
      <div className="login-container">
        <div className="login-title">
          <span>Aroma</span>
        </div>
        <div className="login-box">

          <div className="login-input">
            <div><b>Username</b></div>
            <input type="text" onChange={@handleUsername}/>
          </div>

          <div className="login-input">
            <div><b>Password</b></div>
            <input type="password" onChange={@handlePassword}/>
          </div>

          <div className="login-button">
            <button className="btn btn-success" onClick={@handleSignIn}>Sign in</button>
          </div>
          <div className="login-button">
            <button className="btn btn-primary"  onClick={@handleCreateUser}>Create an Account</button>
          </div>
          {@getLoginAlert()}
          <div className={@createUserClasses()}>
            <CreateUserView close_event={@closeCreateUser}/>
          </div>
        </div>
      </div>
    </div>

  getLoginAlert: () ->
    if (@state.login_alert)
      console.log("show failed stuff...");
      <div className="login-alert alert alert-danger alert-dismissible" role="alert">
         <button type="button" className="close" aria-label="Close" onClick={@dismissAlert}><span aria-hidden="true">&times;</span></button>
         <strong>Error!</strong>  {@state.login_alert}
      </div>
    else
      <div></div>

  createUserClasses: () ->
    classes = "collapsible"
    if (@state.show_create_user)
      classes += " full-height-small";
    else
      classes += " no-height";
    classes

  dismissAlert: (event) ->
    @setState(login_alert: "");

  handleUsername: (event) ->
    @setState(username: event.target.value);

  handlePassword: (event) ->
    @setState(password: event.target.value);

  handleSignIn: (event) ->
    $.post("aroma/login", {username: @state.username, password: @state.password}, (response) =>
      if (!response.success)
        @setState(login_alert: response.message);
      else
        @props.login_success({token: response.token, username: response.username, group: response.group});
    );

  handleCreateUser: (event) ->
    @setState({show_create_user: true});

  closeCreateUser: () ->
    @setState({show_create_user: false});
