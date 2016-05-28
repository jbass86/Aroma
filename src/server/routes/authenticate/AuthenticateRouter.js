"use strict";

var express = require('express');
var jsonwebtoken = require("jsonwebtoken");

module.exports = class AuthenticateRouter {

  constructor(auth_model) {
    this.auth_model = auth_model;

    var _this = this;

    _this.router = express.Router();

    _this.router.use((req, res, next) => {

      // check header or url parameters or post parameters for token
      var token = req.body.token || req.query.token || req.headers['x-access-token'];

      // decode token
      if (token) {

        // verifies secret and checks exp
        jsonwebtoken.verify(token, _this.auth_model.get("token_pw"), function(err, decoded) {
          if (err) {
            return res.json({ success: false, message: 'Failed to authenticate token.' });
          } else {
            // if everything is good, save to request for use in other routes
            req.decoded = decoded;
            console.log("my decoded token");
            console.log(decoded);
            next();
          }
        });

      } else {
        return res.status(403).send({
            success: false,
            message: 'No token provided.'
        });
      }
    });
  }

  getRouter() {
    return this.router;
  }
}
