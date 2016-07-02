"use strict";

var jsonwebtoken = require("jsonwebtoken");
var bcrypt = require("bcrypt-nodejs");

module.exports = class LoginRoute {

  constructor(db_coord, auth_model) {
    this.db_coord = db_coord;
    this.auth_model = auth_model;
  }


  httpPostAuthUser(req, res){

    var _this = this;

    var db = this.db_coord.getDatabaseInstance();

    if (db){
      var collection = db.collection("users");

      collection.findOne({username: req.body.username}, (err, item) => {

        if (err){
          res.send({sucess: false, message: "Username/Password Incorrect"});
        }else{
          if (item){
            if (bcrypt.compareSync(req.body.password, item.password)){
              var token = jsonwebtoken.sign({username: item.username, group: item.group}, _this.auth_model.get("token_pw"));
              res.send({success: true, message: "Authentication Sucess!!", token: token, username: item.username, group: item.group});
            }else{
              res.send({success: false, message: "Username/Password Incorrect", token});
            }
          }else{
            res.send({success: false, message: "Username/Password Incorrect"});
          }
        }
      });
    }else{
      res.send({success: false, message: "Error Creating User"});
    }
  }

  httpValidateSession(req, res){
    res.send({success: true, message: "Token Validated", username: req.decoded.username, group: req.decoded.group});
  }
}
