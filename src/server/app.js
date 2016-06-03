// Aurhor: Josh Bass

var args = require('minimist')(process.argv.slice(2));
var port = args['port'] ? parseInt(args['port']) : 8080;

var token_pw = args['token-pw'] ? args['token-pw'] : "password";

var express = require('express');
var http = require('http');
var path = require('path');
var body_parser = require("body-parser");

var multer  = require('multer')
// var upload = multer({ dest: 'uploads/' })
var upload = multer();

var MongoCoordinator = require("./database/MongoCoordinator");
var Backbone = require("backbone");

var AuthRouter = require("./routes/authenticate/AuthenticateRouter");
var LoginRoute = require("./routes/login/LoginRoute");
var UserRoute = require("./routes/user/UserRoute");
var InventoryRoute = require("./routes/inventory/InventoryRoute");

var app = express();

app.use(express.static(__dirname + "/client/"));
app.use(body_parser.json());
app.use(body_parser.urlencoded({
  extended: true
}));

app.use(upload.single('file'));

app.get("/aroma", function(req, res){
  res.sendFile(path.join(__dirname + "/index.html"));
});

app.get("/no_image", function(req, res){
  res.sendFile(path.join(__dirname + "/client/assets/inventory/res/images/no_image.png"));
});

var auth_model = new Backbone.Model();
auth_model.set("token_pw", token_pw);
var mongo_coord = new MongoCoordinator({});

var auth_router = new AuthRouter(auth_model);
var login_route = new LoginRoute(mongo_coord, auth_model);
var user_route = new UserRoute(mongo_coord);
var inventory_route = new InventoryRoute(mongo_coord);

app.post("/aroma/create_user", user_route.httpPostCreateUser.bind(user_route));
app.post("/aroma/login", login_route.httpPostAuthUser.bind(login_route));

//Secure Routes...
auth_router.getRouter().post("/authenticate_token", login_route.httpValidateSession.bind(login_route));

auth_router.getRouter().post("/update_inventory", inventory_route.httpPostUpdateItem.bind(inventory_route));
auth_router.getRouter().get("/get_inventory", inventory_route.httpGetItems.bind(inventory_route));
auth_router.getRouter().get("/get_inventory_image", inventory_route.httpGetInventoryImage.bind(inventory_route));
/////////////////

app.use("/aroma/secure", auth_router.getRouter());


app.listen(port, '0.0.0.0');
console.log("Server Listening on port: " + port);
