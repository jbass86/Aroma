// Aurhor: Josh Bass

var args = require('minimist')(process.argv.slice(2));
var port = args['port'] ? parseInt(args['port']) : 8080;

var token_pw = args['token-pw'] ? args['token-pw'] : "password";

var express = require('express');
var http = require('http');
var path = require('path');
var body_parser = require("body-parser");

var MongoCoordinator = require("./database/MongoCoordinator");
var Backbone = require("backbone");

var AuthenticateRoute = require("./routes/authenticate/AuthenticateRoute");
var UserRoute = require("./routes/user/UserRoute");

var app = express();

app.use(express.static(__dirname + "/client/"));
app.use(body_parser.json());
app.use(body_parser.urlencoded({
  extended: true
}));

app.get("/aroma", function(req, res){
  res.sendFile(path.join(__dirname + "/index.html"));
});

var auth_model = new Backbone.Model();
auth_model.set("token_pw", token_pw);
var mongo_coord = new MongoCoordinator({});

var auth_route = new AuthenticateRoute(mongo_coord, auth_model);
var user_route = new UserRoute(mongo_coord);
app.post("/aroma/create_user", user_route.httpPostCreateUser.bind(user_route));
app.post("/aroma/authenticate", auth_route.httpPostAuthUser.bind(auth_route));

app.listen(port, '0.0.0.0');
console.log("Server Listening on port: " + port);
