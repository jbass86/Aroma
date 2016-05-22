# Author: Josh Bass

React = require("react");


css = require("./res/css/login.css")

module.exports = React.createClass

  getInitialState: ->
    {username: "", password: "", login_alert: ""};

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
            <input type="text" onChange={@handlePassword}/>
          </div>

          <div className="login-button">
            <button className="btn btn-success" onClick={@handleSignIn}>Sign in</button>
          </div>
          <div className="login-button">
            <button className="btn btn-primary">Create an Account</button>
          </div>
          {@getLoginAlert()}
        </div>
      </div>
    </div>

  getLoginAlert: () ->
    if (@state.login_alert)
      console.log("show failed stuff...")
      <div className="login-alert alert alert-danger alert-dismissible" role="alert">
         <button type="button" className="close" aria-label="Close" onClick={@dismissAlert}><span aria-hidden="true">&times;</span></button>
         <strong>Error!</strong>  {@state.login_alert}
      </div>
    else
      <div></div>

  dismissAlert: (event) ->
    @setState(login_alert: "");

  handleUsername: (event) ->
    @setState(username: event.target.value);

  handlePassword: (event) ->
    @setState(password: event.target.value);

  handleSignIn: (event) ->
    console.log("Try to Sign in with these credentials...");
    console.log(@state.username + " " + @state.password);
    $.post("aroma/login", {username: @state.username, password: @state.password}, (response) =>
      console.log(response);
      if (!response.success)
        console.log("failed login setting state " + response.message);
        @setState(login_alert: response.message);
      else
        @props.login_success(response.token);

    );
