# Author: Josh Bass

React = require("react");
CustomerEdit = require("./CustomerEdit.coffee");
Moment = require("moment");

DateUtils = require("utilities/DateUtils.coffee");

module.exports = React.createClass

  getInitialState: ->
    {expanded_rows: {}, editing_item: undefined, confirming_delete: {}};

  componentDidMount: ->

  render: ->

    <div style={{"margin": "auto"}} className="common-table">

      {@props.items.map((item, index) =>
        <div className="common-table-entry" key={item._id}>

          <div className="row common-row" onClick={@expandRow.bind(@, item)}>
            <div className="col-md-3">{item.first_name}</div>
            <div className="col-md-3">{item.last_name}</div>
            <div className="col-md-3">{item.email}</div>
            <div className="col-md-3">{item.social_media}</div>
          </div>
          {@renderInfoSection(item)}

        </div>
      )}
    </div>

  renderInfoSection: (item) ->

    info_classes = "collapsible";
    if (@state.expanded_rows[item._id])
      #make sure expanded row state has the most up to date item.
      @state.expanded_rows[item._id] = item;
      info_classes += " full-height-large";
    else
      info_classes += " no-height";

    delete_alert_classes = "collapsible"
    if (@state.confirming_delete[item._id])
      delete_alert_classes += " full-height-small";
    else
      delete_alert_classes += " no-height";

    <div className={info_classes}>

      <div className="row item-edit-buttons">
        <button className="col-xs-6 btn btn-primary" onClick={@editItem.bind(@, item)}>
          <span className="glyphicon glyphicon-edit"></span>
        </button>
        <button className="col-xs-6 btn btn-danger" onClick={@confirmDelete.bind(@, item)}>
          <span className="glyphicon glyphicon-trash"></span>
        </button>
      </div>

      <div className={delete_alert_classes}>
        <div className="delete-item-alert alert alert-danger" role="alert">
           <span>Are you Sure?</span>
           <div style={{"marginTop": "10px"}} className="row">
             <button className="col-xs-6 btn btn-success" onClick={@deleteItem.bind(@, item)}>Yes</button>
             <button className="col-xs-6 btn btn-danger" onClick={@confirmDelete.bind(@, item)}>No</button>
           </div>
        </div>
      </div>
      {@renderDetailedInfo(item)}
    </div>

  renderDetailedInfo: (item) ->

    if (@state.editing_item == item._id)
      initial_state = {_id: item._id, first_name: item.first_name, middle_name: item.middle_name, last_name: item.last_name, \
        address: item.address, email: item.email, phone_number: item.phone_number, social_media: item.social_media, birthday: Moment(new Date(item.birthday))};
      <CustomerEdit initialState={initial_state} updateCustomer={@finishEdit} handleFinish={@cancelEdit}/>
    else
      <div className="common-info-section">

        <div className="row">

          <div className="col-md-3 customer-label">
            First Name:
          </div>
          <div className="col-md-3 customer-info">
            {if item.first_name then item.first_name else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Middle Name:
          </div>
          <div className="col-md-3 customer-info">
            {if item.middle_name then item.middle_name else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Last Name:
          </div>
          <div className="col-md-3 customer-info">
            {if item.last_name then item.last_name else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Address:
          </div>
          <div className="col-md-3 customer-info">
            {if item.address then item.address else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Email:
          </div>
          <div className="col-md-3 customer-info">
            {if item.email then item.email else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Phone Number:
          </div>
          <div className="col-md-3 customer-info">
            {if item.phone_number then item.phone_number else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Social Media:
          </div>
          <div className="col-md-3 customer-info">
            {if item.social_media then item.social_media else "N/A"}
          </div>
          <div className="col-md-3 customer-label">
            Birthday:
          </div>
          <div className="col-md-3 customer-info">
            {if item.birthday != "undefined" then DateUtils.getPrettyDate(item.birthday) else "N/A"}
          </div>
        </div>

      </div>

  expandRow: (item) ->
    if(@state.expanded_rows[item._id])
      delete @state.expanded_rows[item._id]
    else
      @state.expanded_rows[item._id] = item;

    @setState({expanded_rows: @state.expanded_rows});

  confirmDelete: (item) ->
    if(@state.confirming_delete[item._id])
      delete @state.confirming_delete[item._id]
    else
      @state.confirming_delete[item._id] = item;
    @setState({confirming_delete: @state.confirming_delete})

  deleteItem: (item) ->
    $.post("aroma/secure/delete_customers", {token: window.sessionStorage.token, items_to_delete: [item]}, (response) =>
      if (response.success)
        @props.customerUpdate();
    )
    @confirmDelete(item);

  editItem: (item) ->
    @setState({editing_item: item._id});

  finishEdit: (id) ->
    @props.customerUpdate();

  cancelEdit: () ->
    @setState({editing_item: undefined});
