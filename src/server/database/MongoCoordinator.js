"use strict";

var mongodb = require("mongodb");


module.exports = class MongoCoordinator {

  constructor(config) {

    var _this = this;

    var MongoClient = mongodb.MongoClient;
    MongoClient.connect("mongodb://localhost:27017", (err, db)=>{

      if (err){
        console.log("something bad happened!!!");
      }

      console.log("we connected!!!");
      _this.db = db;
    })
  }

  getDatabaseInstance() {
    return this.db;
  }
}
