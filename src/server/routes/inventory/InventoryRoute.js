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

    var is_update = req.body._id ? true : false;

    var item = {
      _id: req.body._id ? ObjectId(req.body._id) : undefined,
      name: req.body.name,
      type: req.body.type,
      acquire_date: req.body.acquire_date,
      acquire_location: req.body.acquire_location,
      cost: req.body.cost,
      sale_price: req.body.sale_price,
      receipt_name: req.body.receipt_name,
      item_name: req.body.item_name,
      receipt_image_ref: req.body.receipt_image_ref,
      item_image_ref: req.body.item_image_ref,
      status: req.body.status ? req.body.status : "new"
    };

    if (req.files){
      for(var i = 0; i < req.files.length; i++){
        if (req.files[i].fieldname == "receipt_image_file"){
          if (item.receipt_image_ref){
            image_collection.deleteOne({_id: item.receipt_image_ref});
          }
          item.receipt_image_ref = uuid.v4();
          req.files[i]._id = item.receipt_image_ref;
          image_collection.update({_id: req.files[i]._id}, req.files[i], {upsert: true});
        }else if (req.files[i].fieldname == "item_image_file"){
          if (item.item_image_ref){
            image_collection.deleteOne({_id: item.item_image_ref});
          }
          item.item_image_ref = uuid.v4();
          req.files[i]._id = item.item_image_ref;
          image_collection.update({_id: req.files[i]._id}, req.files[i], {upsert: true});
        }
      }
    }

    var cb = (err, result) => {
      if (err){
        res.send({sucess: false, message: "Error Creating Item"});
      }else{
        var message = is_update ? "Item Updated Successfully" : "Item Created Sucessfully";
        res.send({success: true, message: message});
      }
    }

    if (item._id){
      collection.update({_id: item._id}, item, {upsert: true}, cb);
    }else{
      console.log("insert item");
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

    var db = this.db_coord.getDatabaseInstance();
    var token = req.decoded;

    var collection = db.collection(token.group + ".inventory");
    var image_collection = db.collection(token.group + ".inventory.images");

    var delete_filter = {_id: {$in: []}};
    var image_delete_filter = {_id: {$in: []}};

    var delete_items = req.body.items_to_delete;
    delete_items.forEach((item) => {
      delete_filter._id.$in.push(ObjectId(item._id));
      if (item.receipt_image_ref){
        image_delete_filter._id.$in.push(item.receipt_image_ref);
      }
      if (item.item_image_ref){
        image_delete_filter._id.$in.push(item.item_image_ref);
      }
    });

    var promise = collection.deleteMany(delete_filter);
    image_collection.deleteMany(image_delete_filter);

    promise.then((arg) => {
      if (arg.result.ok){
        res.send({success: true});
      }else{
        res.send({success: false});
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
