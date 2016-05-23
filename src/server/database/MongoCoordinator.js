"use strict";

var mongodb = require("mongodb");


module.exports = class MongoCoordinator {

  constructor(config) {

    var _this = this;

    var MongoClient = mongodb.MongoClient;
    MongoClient.connect("mongodb://localhost:27017/aroma", (err, db) => {

      if (err){
        //gonna need some retry logic here...
        console.log("something bad happened!!!");
      }
      _this.db = db;
    })
  }

  getDatabaseInstance() {
    return this.db;
  }
}
