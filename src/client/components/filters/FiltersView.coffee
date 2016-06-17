# Author: Josh Bass

React = require("react");
Moment = require("moment");
mathjs = require("mathjs");

css = require("./res/styles/filters.scss");

module.exports = React.createClass

  getInitialState: ->
    {filters: [], show_filters: true};

  render: ->

    <div className="filters-view">
      <div className="btn-group add-filter-button">
        <button type="button" className="btn btn-primary dropdown-toggle" data-toggle="dropdown">
          Add Filter <span className="caret"></span>
        </button>
        {@renderFilterDropdown()}
      </div>
      <div className="clear-both"></div>

      {@renderFilterPanel()}
    </div>

  renderFilterDropdown: () ->
    <ul className="dropdown-menu">
      {@props.filterTypes.map((item) =>
        <li key={item.key} onClick={@addFilter.bind(@, item)}><a href="#">{item.name}</a></li>
      )}
    </ul>

  renderFilterPanel: () ->

    filters_classes = "";
    legend_glyph = "glyphicon";
    if (@state.show_filters)
      filters_classes += " full-height-medium";
      legend_glyph += " glyphicon-menu-down"
    else
      filters_classes += " no-height";
      legend_glyph += " glyphicon-menu-right"

    if (@state.filters.length > 0)
      <fieldset className="filters-list">
        <legend className="unselectable" onClick={@toggleShowFilters} data-toggle="collapse" data-target="#inventory-filters">
          Filters <span className={legend_glyph}></span>
        </legend>
        <div className="collapse in" id="inventory-filters">
          {@state.filters.map(@renderFilter)}
          <div>
            <button className="btn btn-primary apply-filters">Apply Filters</button>
          </div>
        </div>
      </fieldset>
    else
      <div></div>

  renderFilter: (filter, index) ->
    <div key={index} className="filter">
      <div className="row">
        <div className="col-md-2">
          <div className="filter-name">
            {filter.name}
          </div>
        </div>
        <div className="col-md-1">
          <div className="btn-group">
            <button type="button" className="btn btn-primary dropdown-toggle" data-toggle="dropdown">
              {filter.modifier} <span className="caret"></span>
            </button>
            {@renderModifierDropdown(filter)}
          </div>
        </div>
        <div className="col-md-6">
          {@renderFilterInput(filter)}
        </div>
        <div className="col-md-1">
          <button className="filter-delete btn btn-danger" onClick={@deleteFilter.bind(@, index)}>
            <span className="glyphicon glyphicon-trash"></span>
          </button>
        </div>
      </div>
    </div>

  renderFilterInput: (filter) ->
    if (filter.type == "text")
      <input className="filter-input" type="text" value={filter.value} onChange={@handleUpdate.bind(@, filter)}></input>
    else if (filter.type == "number")
      <input className="filter-input" type="number" value={filter.value} onChange={@handleUpdate.bind(@, filter)}></input>
    else
      <input className="filter-input"></input>

  renderModifierDropdown: (filter) ->
    if (filter.type == "text")
      <ul className="dropdown-menu">
        <li onClick={@changeModifier.bind(@, filter, "is")}><a href="#">is</a></li>
        <li onClick={@changeModifier.bind(@, filter, "is not")}><a href="#">is not</a></li>
        <li onClick={@changeModifier.bind(@, filter, "contains")}><a href="#">contains</a></li>
      </ul>
    else if (filter.type == "number")
      <ul className="dropdown-menu">
        <li onClick={@changeModifier.bind(@, filter, "equals")}><a href="#">equals</a></li>
        <li onClick={@changeModifier.bind(@, filter, "not_equals")}><a href="#">not equals</a></li>
        <li onClick={@changeModifier.bind(@, filter, "< lt")}><a href="#">{"< lt"}</a></li>
        <li onClick={@changeModifier.bind(@, filter, "> gt")}><a href="#">{"> gt"}</a></li>
      </ul>
    else
      <ul className="dropdown-menu"></ul>

  changeModifier: (filter, modifier) ->
    filter.modifier = modifier;
    @setState({filters: @state.filters});

  handleUpdate: (filter, event) ->
    update = {};
    value = event.target.value;
    if (filter.type == "number")
      value = mathjs.round(value, 2);
    filter.value = value;
    @setState({filters: @state.filters});


  toggleShowFilters: ->
    @setState({show_filters: !@state.show_filters});

  addFilter: (filter) ->
    modifier = "";
    if (filter.type == "text")
      modifier = "is";
    else if (filter.type == "number")
      modifier = "equals";

    @state.filters.push({key: filter.key, name: filter.name, type: filter.type, modifier: modifier, value: ""});
    @setState({filters: @state.filters});

  deleteFilter: (index) ->
    @state.filters.splice(index, 1);
    @setState({filters: @state.filters});
