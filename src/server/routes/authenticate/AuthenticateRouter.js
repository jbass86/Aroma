"use strict";

var express = require('express');
var router = express.Router();

var jsonwebtoken = require("jsonwebtoken");

router.use((req, res, next) => {

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

module.exports = router;
