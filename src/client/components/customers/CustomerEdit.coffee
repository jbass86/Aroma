# Author: Josh Bass

mathjs = require("mathjs");
React = require("react");
DatePicker = require("react-datepicker");
Moment = require("moment");

module.exports = React.createClass

  getInitialState: ->
    @default_state = {_id: undefined, first_name: "", middle_name: "", last_name: "", address: "", \
      email: "", phone_number: "", social_media: "", birthday: undefined, \
      customer_alert: "", customer_success: false, update_from_props: true};

  componentDidMount: ->
    @checkInitialState();

  componentWillUnmount: ->
    if (@reset_default_timeout)
      window.clearTimeout(@reset_default_timeout);
      @reset_default_timeout = undefined;

  componentDidUpdate: ->
    @checkInitialState();

  checkInitialState: ->
    if (@props.initialState and @state.update_from_props)
      first_name = if @props.initialState.first_name then @props.initialState.first_name else @default_state.first_name;
      middle_name = if @props.initialState.middle_name then @props.initialState.middle_name else @default_state.middle_name;
      last_name = if @props.initialState.last_name then @props.initialState.last_name else @default_state.last_name;
      address = if @props.initialState.address then @props.initialState.address else @default_state.address;
      email = if @props.initialState.email then @props.initialState.email else @default_state.email;
      phone_number = if @props.initialState.phone_number then @props.initialState.phone_number else @default_state.phone_number;
      social_media = if @props.initialState.social_media then @props.initialState.social_media else @default_state.social_media;
      birthday = if @props.initialState.birthday then @props.initialState.birthday else @default_state.birthday;

      @setState({_id: @props.initialState._id, first_name: first_name, middle_name: middle_name, last_name: last_name, \
      email: email, phone_number: phone_number, social_media: social_media, address: address, birthday: birthday, update_from_props: false});

  render: ->

    <div className="add-item">

      {@createInputField("first_name", "First Name:", "text")}
      {@createInputField("middle_name", "Middle Name:", "text")}
      {@createInputField("last_name", "Last Name:", "text")}
      {@createInputField("address", "Address:", "text")}
      {@createInputField("email", "Email:", "text")}
      {@createInputField("phone_number", "Phone Number:", "text")}
      {@createInputField("social_media", "Social Media:", "text")}
      {@createInputField("birthday", "Birthday:", "date")}

      {@getCreateItemAlert()}

      <div className="row common-create-buttons">
        <button className="col-md-6 btn button-ok" onClick={@handleCreateItem}>{@getCreateButtonText()}</button>
        <button className="col-md-6 btn button-cancel" onClick={@handleCancel}>Cancel</button>
      </div>
    </div>

  getCreateButtonText: () ->
    if (@state._id)
      "Update Customer"
    else
      "Create Customer"

  getCreateItemAlert: () ->
    success = if (@state.customer_success) then " alert-success" else " alert-danger";
    if (@state.customer_alert)
      <div className={"general-alert alert alert-dismissible" + success} role="alert">
         <button type="button" className="close" aria-label="Close" onClick={@dismissAlert}><span aria-hidden="true">&times;</span></button>
         <strong>{if (@state.customer_success) then "Success!" else "Error!"}</strong> {@state.customer_alert}
      </div>
    else
      <div></div>

  dismissAlert: (event) ->
    @setState({customer_alert: ""});

  createInputField: (name, display_name, type) ->

    inputCreate = () =>

      if (type == "date")
        <DatePicker className="form-control common-input-field" selected={@state[name]} onChange={(moment) => @handleFieldUpdate(name, moment)} todayButton={'Today'} />
      else
        <div>
          <input type={type} className="form-control common-input-field" value={@state[name]} onChange={(event) => @handleFieldUpdate(name, event)} />
        </div>

    <div className="row common-create-row">
      <div className="col-md-4">
        {display_name}
      </div>
      <div className="col-md-8">
        {inputCreate()}
      </div>
    </div>

  handleFieldUpdate: (field_name, event) ->
    update = {};
    value = "";

    if (event._isAMomentObject)
      value = event;
    else if (event.target.type == "number")
      value = event.target.value;
      value = mathjs.round(value, 2);
    else if (event.target.type == "text")
      value = event.target.value;

    update[field_name] = value;
    @setState(update);

  handleCreateItem: () ->

    form = new FormData();
    form.append("token", window.sessionStorage.token);
    if (@state._id)
      form.append("_id", @state._id);
    form.append("first_name", @state.first_name);
    form.append("middle_name", @state.middle_name);
    form.append("last_name", @state.last_name);
    form.append("address", @state.address);
    form.append("email", @state.email);
    form.append("phone_number", @state.phone_number);
    form.append("social_media", @state.social_media);
    form.append("birthday", if @state.birthday then @state.birthday.toDate() else undefined);

    $.ajax({
      url: 'aroma/secure/update_customer',
      data: form,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      mimeType: 'multipart/form-data',
      fail: (data) =>
        response = JSON.parse(data);
        @setState({customer_alert: response.message, customer_success: response.success});
      success: (data) =>
        response = JSON.parse(data);
        @setState({customer_alert: response.message, customer_success: response.success});
        @props.updateCustomer(@state._id);
        window.setTimeout(() =>
          @reset_default_timeout = window.setTimeout(() =>
            @reset_default_timeout = undefined;
            @setState(@default_state);
          , 1000);
          @props.handleFinish();
        , 2000);
    });

  handleCancel: () ->
    @setState(@default_state);
    @props.handleFinish();
