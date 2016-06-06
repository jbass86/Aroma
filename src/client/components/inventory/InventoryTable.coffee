# Author: Josh Bass

css = require("./res/css/inventory_table.css");

React = require("react");
CreateInventory = require("./CreateInventory.coffee");

ObjectCache = require("utilities/ObjectCache.coffee");

module.exports = React.createClass

  getInitialState: ->
    {expanded_rows: {}, image_cache: {}, editing_item: undefined, confirming_delete: {}};

  componentDidMount: ->

  render: ->

    <div style={{"margin": "auto"}} className="inventory-table">

      {@props.items.map((item, index) =>
        <div className="inventory-table-entry" key={item._id}>

          <div className="row inventory-row" onClick={@expandRow.bind(@, item)}>
            <div className="col-md-4">{item.name}</div>
            <div className="col-md-4">{item.type}</div>
            <div className="col-md-4">{item.status}</div>
          </div>

          {@renderInfoSection(item)}

        </div>
      )}
    </div>

  renderInfoSection: (item) ->

    info_classes = "collapsible";
    if (@state.expanded_rows[item._id])
      info_classes += " full-height-medium";
    else
      info_classes += " no-height";

    delete_alert_classes = "collapsible"
    if (@state.confirming_delete[item._id])
      delete_alert_classes += " full-height-small";
    else
      delete_alert_classes += " no-height";

    <div className={info_classes}>

      <div className="row item-edit-buttons">
        <button className="col-xs-6 btn btn-info">
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


      <div className="inventory-info-section">

        <table>
          <tbody>
            <tr>
              <td><span>Database ID:</span></td>
              <td >{item._id}</td>
            </tr>
            <tr>
              <td>Name:</td>
              <td>{item.name}</td>
            </tr>
            <tr>
              <td>Type:</td>
              <td>{item.type}</td>
            </tr>
            <tr >
              <td>Acquire Date:</td>
              <td>{item.acquire_date}</td>
            </tr>
            <tr>
              <td>Acquire Location:</td>
              <td>{item.acquire_location}</td>
            </tr>
            <tr>
              <td>Status:</td>
              <td>{item.status}</td>
            </tr>
            <tr >
              <td>Receipt:</td>
              <td>
                <img src={@getReceiptImage(item)} alt="No Image Available" width="250" height="250"></img>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  expandRow: (item) ->
    if(@state.expanded_rows[item._id])
      delete @state.expanded_rows[item._id]
      if (item.image_ref and @state.image_cache[item.image_ref])
        window.setTimeout(() =>
          delete @state.image_cache[item.image_ref];
          @setState({image_cache: @state.image_cache});
        , 2000);
    else
      @state.expanded_rows[item._id] = item;
      if (item.image_ref)
        $.get("aroma/secure/get_inventory_image", {token: window.sessionStorage.token, image_ref: item.image_ref}, (response) =>
          if (response.success)
            @state.image_cache[item.image_ref] = "data:" + response.image.mimetype + ";base64," + response.image.buffer;
            @setState({image_cache: @state.image_cache});
        );
    @setState({expanded_rows: @state.expanded_rows, image_cache: @state.image_cache});

  confirmDelete: (item) ->
    if(@state.confirming_delete[item._id])
      delete @state.confirming_delete[item._id]
    else
      @state.confirming_delete[item._id] = item;
    @setState({confirming_delete: @state.confirming_delete})

  deleteItem: (item) ->
    console.log("here we need to delete the item...");
    $.post("aroma/secure/delete_inventory", {token: window.sessionStorage.token, items_to_delete: [item]}, (response) =>
      if (response.success)
        console.log("it worked....");
        @props.inventoryUpdate();
    )

    @confirmDelete(item);

  getReceiptImage: (item) ->
    if (@state.image_cache[item.image_ref])
      @state.image_cache[item.image_ref];
    else
      "/no_image";

  getInfoSectionClasses: () ->
    console.log("do some stuff...");
