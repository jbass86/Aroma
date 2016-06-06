"use strict";

var ObjectId = require("mongodb").ObjectId;
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

    if (req.files){
      for(var i = 0; i < req.files.length; i++){
        if (req.files[i].fieldname == "receipt_image_file"){
          if (!item.receipt_image_ref){
            item.receipt_image_ref = uuid.v4();
          }
          req.files[i]._id = item.receipt_image_ref;
          image_collection.update({_id: req.files[i]._id}, req.files[i], {upsert: true});
        }else if (req.files[i].fieldname == "item_image_file"){
          if (!item.item_image_ref){
            item.item_image_ref = uuid.v4();
          }
          req.files[i]._id = item.item_image_ref;
          image_collection.update({_id: req.files[i]._id}, req.files[i], {upsert: true});
        }
      }
    }

    var cb = (err, result) => {
      if (err){
        res.send({sucess: false, message: "Error Creating Item"});
      }else{
        res.send({success: true, message: "Item Created Sucessfully"});
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

    var collection = db.collection(token.group + ".inventory");

    var cursor = collection.find({});
    cursor.toArray().then((items) => {
      res.send({success: true, results: items});
    });
  }

  httpDeleteItems(req, res){

    console.log("got into the delete route...");

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".inventory");
    var image_collection = db.collection(token.group + ".inventory.images");

    var delete_filter = {$or: []};
    var image_delete_filter = {$or: []};

    var delete_items = req.body.items_to_delete;
    delete_items.forEach((item) => {
      delete_filter.$or.push({_id: ObjectId(item._id)});
      if (item.receipt_image_ref){
        image_delete_filter.$or.push({_id: ObjectId(item.receipt_image_ref)});
      }
      if (item.item_image_ref){
        image_delete_filter.$or.push({_id: ObjectId(item.item_image_ref)});
      }
    });

    console.log("my delete filters...")
    console.log(delete_filter);
    console.log(image_delete_filter);
    var promise = collection.deleteMany(delete_filter);
    image_collection.deleteMany(image_delete_filter);

    promise.then((arg) => {
      console.log("got the promise");
      console.log(arg);
      if (arg.result.ok){
        res.send({success: true});
      }else{
        res.send({success: true});
      }
    });
  }

  httpGetInventoryImage(req, res){

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var image_collection = db.collection(token.group + ".inventory.images");

    image_collection.findOne({_id: req.query.image_ref}, (err, doc) => {
      if (doc){
        res.send({success: true, image: doc});
      }else{
        res.send({success: false, message: "Could Not Find Image Ref"});
      }
    });
  }
}
