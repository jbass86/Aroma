# Author: Josh Bass

React = require("react");

Moment = require("moment");

css = require("./res/styles/filters.scss");

module.exports = React.createClass

  getInitialState: ->
    {filters: []};

  componentDidMount: ->

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
    if (@state.filters.length > 0)
      <fieldset className="filters-list">
        <legend>
          Filters <span className="glyphicon glyphicon-menu-right"></span>
        </legend>
        {@state.filters.map(@renderFilter)}
      </fieldset>
    else
      <div></div>

  renderFilter: (filter, index) ->
    <div key={index} className="filter">
      {filter.name}
    </div>


  addFilter: (filter) ->
    console.log("add a filter");
    console.log(filter);
    @state.filters.push({key: filter.key, name: filter.name, type: filter.type, value: ""});
    @setState({filters: @state.filters});
