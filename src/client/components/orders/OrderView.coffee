# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateOrder = require("./OrderCreate.coffee");
Filters = require("client/components/filters/FiltersView.coffee");

require("./res/styles/orders.scss")

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
      <CreateOrder customerUpdate={@updateOrder} order_model={@props.order_model} />
      <Filters filterTypes={@filter_types} applyFilters={@applyFilters} name="order_filters" />
    </div>

  updateOrder: ->
