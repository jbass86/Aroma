"use strict";

var mongodb = require("mongodb");


module.exports = class MongoCoordinator {

  constructor(config) {

    var _this = this;

    var connectTask = function(){
      var MongoClient = mongodb.MongoClient;
      MongoClient.connect("mongodb://localhost:27017/aroma", (err, db) => {
        if (err){
          //gonna need some retry logic here...
          console.error("Something bad happened!!!");
          if (db){
            db.close();
          }
          setTimeout(connectTask, 5000);
        }else{
          console.log("Mongo Success!!!");
          _this.db = db;
        }
      });
    }
    connectTask();
  }

  getDatabaseInstance() {
    return this.db;
  }
}
