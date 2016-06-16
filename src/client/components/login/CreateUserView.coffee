# Author: Josh Bass

React = require("react");

module.exports = React.createClass

  getInitialState: ->
    @default_state = {username: "", password: "", confirm_pw: "", \
      passwords_match: true, email: "", group: "", user_alert: "", user_success: false};

  render: ->

    <div className="create-user-view">

      <div className="user-input-field">
        <div className="user-input-label">
          Username:
        </div>
        <input type="text" className="user-input" value={@state.username} onChange={(event)=>@handleFieldUpdate("username", event)}/>
        <div className="clear-both"></div>
      </div>

      <div className="user-input-field">
        <div className="user-input-label">
          Password:
        </div>
        <input type="password" className="user-input" value={@state.password} onChange={(event)=>@handleFieldUpdate("password", event)}/>
        <div className="clear-both"></div>
      </div>

      <div className="user-input-field">
        <div className="user-input-label">
          Confirm Password:
        </div>
        <input type="password" className={"user-input" + if (!@state.passwords_match) then " pw-mismatch" else ""}
          value={@state.confirm_pw} onChange={(event)=>@handleFieldUpdate("confirm_pw", event)}/>
        <div className="clear-both"></div>
      </div>

      <div className="user-input-field">
        <div className="user-input-label">
          Email:
        </div>
        <input type="text" className="user-input" value={@state.email}  onChange={(event)=>@handleFieldUpdate("email", event)}/>
        <div className="clear-both"></div>
      </div>

      <div className="user-input-field">
        <div className="user-input-label">
          Group Name:
        </div>
        <input type="text" className="user-input" value={@state.group} onChange={(event)=>@handleFieldUpdate("group", event)}/>
        <div className="clear-both"></div>
      </div>

      {@getUserAlert()}

      <div className="user-input-buttons">
        <button className="btn btn-success" onClick={@handleCreateUser}>Create User</button>
        <button className="btn btn-danger" onClick={@handleCloseEvent}>Cancel</button>
      </div>
    </div>

  getUserAlert: () ->
    success = if (@state.user_success) then " alert-success" else " alert-danger";
    if (@state.user_alert)
      <div className={"login-alert alert alert-dismissible" + success} role="alert">
         <button type="button" className="close" aria-label="Close" onClick={@dismissAlert}><span aria-hidden="true">&times;</span></button>
         <strong>{if (@state.user_success) then "Success!" else "Error!"}</strong> {@state.user_alert}
      </div>
    else
      <div></div>

  dismissAlert: (event) ->
    @setState({user_alert: ""});

  handleFieldUpdate: (field_name, event) ->
    update = {};
    update[field_name] = event.target.value
    @setState(update, () =>
      update = {};
      if (@state.password == @state.confirm_pw)
        update["passwords_match"] = true;
      else
        update["passwords_match"] = false;
      @setState(update);
    );

  handleCreateUser: (event) ->
    console.log("gonna do some stuff here to make a user");
    form_valid = @validateInfo();
    if (form_valid)
      console.log("create user request");
      user = {
        username: @state.username,
        password: @state.password,
        email: @state.email,
        group: @state.group
      };
      $.post("aroma/create_user", user, (response) =>
        if (!response.success)
          @setState(user_alert: response.message, user_success: response.success);
        else
          @setState({user_alert: response.message, user_success: response.success});
          window.setTimeout(() =>
            @handleCloseEvent();
          , 2000);
      );
    else
      @setState({user_alert: "Form not valid"});


  validateInfo: () ->
    info_valid = false;
    if (@state.username != "" and @state.password != "" and @state.passwords_match and @state.email != "")
      info_valid = true;
    info_valid;

  handleCloseEvent: (event) ->

    @props.close_event();
    window.setTimeout(() =>
      @setState(@default_state)
    , 1000)
