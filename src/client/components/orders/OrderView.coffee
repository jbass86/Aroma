# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateOrder = require("./OrderCreate.coffee");
Filters = require("client/components/filters/FiltersView.coffee");

css = require("./res/css/orders.css")

module.exports = React.createClass

  getInitialState: ->
    @filter_types = [{key: "order_date", name: "Order Date", type: "date"}];
    {};

  componentDidMount: ->


  render: ->

    <div className="common-view">
      <div className="section-title">
        Orders
      </div>
      <CreateOrder customerUpdate={@updateOrder} />
      <Filters filterTypes={@filter_types} applyFilters={@applyFilters} />
    </div>

  updateOrder: ->
