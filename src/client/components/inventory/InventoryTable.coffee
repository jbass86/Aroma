# Author: Josh Bass

React = require("react");
InventoryEdit = require("./InventoryEdit.coffee");
Moment = require("moment");

ObjectCache = require("utilities/ObjectCache.coffee");
DateUtils = require("utilities/DateUtils.coffee");

module.exports = React.createClass

  getInitialState: ->
    @image_cache = new ObjectCache();
    {expanded_rows: {}, editing_item: undefined, confirming_delete: {}, order_mode: false};

  componentDidMount: ->

    @props.order_model.on("change:order_mode", (model, data) =>
      @setState({order_mode: data})
    );

  render: ->

    if (@state.order_mode)

      <div style={{"margin": "auto"}} className="common-table">

        {@props.items.map((item, index) =>
          <div className="common-table-entry" key={item._id}>

            <div className="row">
              <div className="col-md-1">
                <button className="btn btn-primary" onClick={@editItem.bind(@, item)}>
                  <span className="glyphicon glyphicon-pushpin"></span>
                </button>
              </div>

              <div className="col-md-11">
                {@renderInventoryRow(item)}
              </div>
            </div>

            {@renderInfoSection(item)}
          </div>
        )}
      </div>
    else
      <div style={{"margin": "auto"}} className="common-table">
        {@props.items.map((item, index) =>
          <div className="common-table-entry" key={item._id}>
            {@renderInventoryRow(item)}
            {@renderInfoSection(item)}
          </div>
        )}
      </div>

  renderInventoryRow: (item) ->
    <div className="row common-row" onClick={@expandRow.bind(@, item)}>
      <div className="col-md-3">{item.name}</div>
      <div className="col-md-3">{item.type}</div>
      <div className="col-md-3">${item.cost}</div>
      <div className="col-md-3">{item.status}</div>
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
        <div className="delete-item-alert alert common-alert" role="alert">
           <span>Are you Sure?</span>
           <div className="row alert-panel">
             <button className="col-xs-6 btn button-ok" onClick={@deleteItem.bind(@, item)}>Yes</button>
             <button className="col-xs-6 btn button-cancel" onClick={@confirmDelete.bind(@, item)}>No</button>
           </div>
        </div>
      </div>
      {@renderDetailedInfo(item)}
    </div>

  renderDetailedInfo: (item) ->

    if (@state.editing_item == item._id)
      initial_state = {_id: item._id, name: item.name, type: item.type, acquire_date: Moment(new Date(item.acquire_date)), \
        acquire_location: item.acquire_location, cost: item.cost, receipt_image_ref: item.receipt_image_ref, item_image_ref: item.item_image_ref};
      <InventoryEdit initialState={initial_state} updateInventory={@finishEdit} handleFinish={@cancelEdit}/>
    else
      <div className="common-info-section">

        <div className="row">
          <div className="col-md-3">
            <img src={@getItemImage(item)} alt="No Image Available" height="285"></img>
          </div>
          <div className="col-md-3">
            <img src={@getReceiptImage(item)} alt="No Image Available" height="285"></img>
          </div>

          <div className="col-md-6">
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
                  <td>{DateUtils.getPrettyDate(item.acquire_date)}</td>
                </tr>
                <tr>
                  <td>Acquire Location:</td>
                  <td>{item.acquire_location}</td>
                </tr>
                <tr>
                  <td>Cost:</td>
                  <td>${item.cost}</td>
                </tr>
                <tr>
                  <td>Sale Price:</td>
                  <td>${item.sale_price}</td>
                </tr>
                <tr>
                  <td>Status:</td>
                  <td>{item.status}</td>
                </tr>
              </tbody>
            </table>
          </div>

        </div>
      </div>

  expandRow: (item) ->
    if(@state.expanded_rows[item._id])
      delete @state.expanded_rows[item._id]
    else
      @state.expanded_rows[item._id] = item;
      @handleImageFetch(item);

    @setState({expanded_rows: @state.expanded_rows});

  handleImageFetch: (item) ->
    if (item)
      if (item.receipt_image_ref)
        if (!@image_cache.get(item.receipt_image_ref))
          $.get("aroma/secure/get_inventory_image", {token: window.sessionStorage.token, image_ref: item.receipt_image_ref}, (response) =>
            if (response.success)
              @image_cache.put(item.receipt_image_ref, "data:" + response.image.mimetype + ";base64," + response.image.buffer);
              @setState({expanded_rows: @state.expanded_rows});
          );
      if (item.item_image_ref)
        if (!@image_cache.get(item.item_image_ref))
          $.get("aroma/secure/get_inventory_image", {token: window.sessionStorage.token, image_ref: item.item_image_ref}, (response) =>
            if (response.success)
              @image_cache.put(item.item_image_ref, "data:" + response.image.mimetype + ";base64," + response.image.buffer);
              @setState({expanded_rows: @state.expanded_rows});
          );


  confirmDelete: (item) ->
    if(@state.confirming_delete[item._id])
      delete @state.confirming_delete[item._id]
    else
      @state.confirming_delete[item._id] = item;
    @setState({confirming_delete: @state.confirming_delete})

  deleteItem: (item) ->
    $.post("aroma/secure/delete_inventory", {token: window.sessionStorage.token, items_to_delete: [item]}, (response) =>
      if (response.success)
        console.log("it worked....");
        @props.inventoryUpdate();
    )
    @confirmDelete(item);

  editItem: (item) ->
    @setState({editing_item: item._id});

  finishEdit: (id) ->
    @props.inventoryUpdate();

    #its possible this edit has new images so check everything in a second.
    window.setTimeout(() =>
      @handleImageFetch(@state.expanded_rows[id]);
    , 1000);

  cancelEdit: () ->
    @setState({editing_item: undefined});

  getReceiptImage: (item) ->
    if (@image_cache.get(item.receipt_image_ref))
      @image_cache.get(item.receipt_image_ref);
    else
      "/no_image";

  getItemImage: (item) ->
    if (@image_cache.get(item.item_image_ref))
      @image_cache.get(item.item_image_ref);
    else
      "/no_image";
