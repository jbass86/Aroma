# Author: Josh Bass

css = require("./res/css/inventory_table.css");

React = require("react");

CreateInventory = require("./CreateInventory.coffee");

css = require("./res/css/inventory.css")

module.exports = React.createClass

  getInitialState: ->
    {expanded_rows: [], image_cache: {}, editing_item: undefined};

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

    <div className={info_classes}>
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

  getReceiptImage: (item) ->
    if (@state.image_cache[item.image_ref])
      @state.image_cache[item.image_ref];
    else
      "/no_image";

  getInfoSectionClasses: () ->
    console.log("do some stuff...");
