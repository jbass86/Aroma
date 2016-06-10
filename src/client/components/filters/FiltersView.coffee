# Author: Josh Bass

React = require("react");

Moment = require("moment");

css = require("./res/css/filters.css");

module.exports = React.createClass

  getInitialState: ->
    {};

  componentDidMount: ->

  render: ->

    <div className="filters-view">
      <button type="button" className="add-filter-button btn btn-info" onClick={@addFilter}>Add Filter</button>
      <div className="clear-both"></div>
      <div>
      </div>
    </div>

  addFilter: ->
    console.log("add a filter");
