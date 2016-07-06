"use strict";

var ObjectId = require("mongodb").ObjectId;

var query_utils = require("../../database/QueryUtils");

module.exports = class CustomerRoute {

  constructor(db_coord) {
    this.db_coord = db_coord;
  }

  httpPostUpdateItem(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".customers");

    var is_update = req.body._id ? true : false;

    var item = {
      _id: req.body._id ? ObjectId(req.body._id) : undefined,
      first_name: req.body.first_name,
      middle_name: req.body.middle_name,
      last_name: req.body.last_name,
      address: req.body.address,
      email: req.body.email,
      phone_number: req.body.phone_number,
      social_media: req.body.social_media,
      birthday: req.body.birthday,
    };

    var cb = (err, result) => {
      if (err){
        res.send({sucess: false, message: "Error Creating Customer"});
      }else{
        var message = is_update ? "Customer Updated Successfully" : "Customer Created Sucessfully";
        res.send({success: true, message: message});
      }
    }

    if (item._id){
      collection.update({_id: item._id}, item, {upsert: true}, cb);
    }else{
      collection.insert(item, cb);
    }
  }

  httpGetItems(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var mongo_query = query_utils.buildQuery(req.query.filters);

    var collection = db.collection(token.group + ".customers");

    var cursor = collection.find(mongo_query);
    cursor.toArray().then((items) => {
      res.send({success: true, results: items});
    });
  }

  httpDeleteItems(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".customers");

    var delete_filter = {_id: {$in: []}};

    var delete_items = req.body.items_to_delete;
    delete_items.forEach((item) => {
      delete_filter._id.$in.push(ObjectId(item._id));
    });

    var promise = collection.deleteMany(delete_filter);

    promise.then((arg) => {
      if (arg.result.ok){
        res.send({success: true});
      }else{
        res.send({success: false});
      }
    });
  }
}
