"use strict";

var bcrypt = require("bcrypt-nodejs");

module.exports = class UserRoute {

  constructor(db_coord) {
    this.db_coord = db_coord;
  }

  httpPostCreateUser(req, res){

    var db = this.db_coord.getDatabaseInstance();

    if (db){
      var collection = db.collection("users");

      var user = collection.findOne({username: req.body.username}, (err, item) => {

        if (err){
          res.send({sucess: false, message: "Error Creating User"});
        }else{
          if (item){
            res.send({sucess: false, message: "User Already Exists..."});
          }else{

            var user = {_id: req.body.username,
              username: req.body.username,
              password: bcrypt.hashSync(req.body.password),
              email: req.body.email,
              group: (req.body.group) ? req.body.group : "default"};
            console.log("Creating a user");
            console.log(user);
            collection.insert(user, {w:1}, (err, result) => {
              if (err){
                res.send({sucess: false, message: "Error Creating User"});
              }else{
                console.log("it was a success!!!");
                res.send({success: true, message: "User Created Sucessfully"});
              }
            });
          }
        }
      });
    }else{
      res.send({sucess: success, message: "Error Creating User"});
    }
  }
}
