# Author: Josh Bass

React = require("react");
mathjs = require("mathjs");

CreateCustomer = require("./CustomerCreate.coffee");
Filters = require("client/components/filters/FiltersView.coffee");

css = require("./res/styles/customers.scss")

module.exports = React.createClass

  getInitialState: ->
    @filter_types = [{key: "first_name", name: "First Name", type: "text"}, {key: "middle_name", name: "Middle Name", type: "text"}, \
      {key: "last_name", name: "Last Name", type: "text"}, {key: "address", name: "Address", type: "text"},  \
      {key: "email", name: "Email", type: "text"}, {key: "phone_number", name: "Phone Number", type: "text"}, \
      {key: "social_media", name: "Social Media", type: "text"}, {key: "birthday", name: "Birthday", type: "date"}];
    {customers: [], filters: {}};

  componentDidMount: ->
    @updateCustomers();


  render: ->

    <div className="common-view customer-view">
      <div className="section-title">
        Customers
      </div>
      <CreateCustomer inventoryUpdate={@updateInventory} />
      <Filters filterTypes={@filter_types} applyFilters={@applyFilters} />
    </div>

  applyFilters: (filters) ->
    @setState({filters: filters}, () =>
      @updateCustomers();
    );

  updateCustomers: () ->
    $.get("aroma/secure/get_customers", {token: window.sessionStorage.token, filters: @state.filters}, (response) =>
      if (response.success)
        @setState(customers: response.results);
    );
