// Aurhor: Josh Bass

var args = require('minimist')(process.argv.slice(2));
var port = args['port'] ? parseInt(args['port']) : 8080;

var express = require('express');
var http = require('http');
var path = require('path');
var body_parser = require("body-parser");

var app = express();

app.use(express.static(__dirname + "/client/"));
app.use(body_parser.json());
app.use(body_parser.urlencoded({
  extended: true
}));

app.get("/aroma", function(req, res){
  res.sendFile(path.join(__dirname + "/index.html"));
});

app.listen(port, '0.0.0.0');
console.log("Server Listening on port: " + port);
