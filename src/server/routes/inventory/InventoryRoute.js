"use strict";

var uuid = require("node-uuid");

module.exports = class InventoryRoute {

  constructor(db_coord) {
    this.db_coord = db_coord;
  }

  httpPostUpdateItem(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".inventory");
    var image_collection = db.collection(token.group + ".inventory.images");

    var item = {
      _id: req.body.db_id ? req.body.db_id : undefined,
      name: req.body.name,
      type: req.body.type,
      acquire_date: req.body.acquire_date,
      acquire_location: req.body.acquire_location,
      cost: req.body.cost,
      receipt: req.body.receipt_name,
      status: "new"
    };

    if (req.file){
      if (!item.image_ref){
        item.image_ref = uuid.v4();
      }
      req.file._id = item.image_ref;
      image_collection.update({_id: req.file._id}, req.file, {upsert: true});
    }

    var cb = (err, result) => {
      if (err){
        res.send({sucess: false, message: "Error Creating Item"});
      }else{
        console.log("it was a success!!!");
        res.send({success: true, message: "Item Created Sucessfully"});
      }
    }

    if (item._id){
      collection.update({_id: item._id}, item, {upsert: true}, cb);
    }else{
      console.log("insert item");
      console.log(item);
      collection.insert(item, cb);
    }
  }

  httpGetItems(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".inventory");

    var cursor = collection.find({});
    cursor.toArray().then((items) => {
      console.log(items);
      res.send({success: true, results: items});
    });


  }

  httpGetInventoryImage(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var image_collection = db.collection(token.group + ".inventory.images");
    image_collection.findOne((err, doc) => {
      res.send(doc);
    });
  }
}
