//Author: Josh Bass

var gulp = require("gulp");
var del = require("del");
var browserify = require("browserify");
var browserify_css = require("browserify-css");
var watchify = require("watchify");
var source = require("vinyl-source-stream");
var path = require("path");

var browserify_client = function(debug){
  var b = browserify({
    catche: {},
    packageCache: {},
    fullPaths: true,
    entries: ["./src/client/main.coffee"],
    paths: ["./node_modules", "./src/client", "./src"],
    transform: [
      "reactify",
      ["coffee-reactify", {"coffeeout": true}],
      "coffeeify",
      "cssify",
      ["browserify-css", {"global": true}],
      ["reactify", {"es6": true, "everything": true}]
    ],
    debug: debug})
  .transform(browserify_css, {
    processRelativeUrl: function(url){
      var parsed = path.basename(url);
      return "./assets/" + parsed;
    }
  });

  if (!debug){
    b.transform({global: true}, "uglifyify");
  }
  return b;
}

var compile_client = function(b, debug){
  b.bundle()
  .on("error", function(error){
    console.error(error);
    this.emit("end");
  })
  .pipe(source("client_bundle.js"))
  .pipe(gulp.dest("dist/client"));
}

gulp.task("clean", function(cb){
  del("dist", {force: true}, cb);
  cb();
});

gulp.task("build-client-dev", function(cb){
  var b = browserify_client(true);
  compile_client(b, true);
  gulp.src("./node_modules/bootstrap/fonts/*")
    .pipe(gulp.dest("dist/client/assets"));
  cb();
});

gulp.task("build-client", function(cb){
  var b = browserify_client(false);
  compile_client(b, false);
  gulp.src("./node_modules/bootstrap/fonts/*")
    .pipe(gulp.dest("dist/client/assets"));
    cb();
});

gulp.task("watchify-client", ["build-client-dev"], function(cb){
  var b = browserify_client(true);
  b = watchify(b).on("update", function(ids){
    console.log("Recompile");
    console.log(ids);
    compile_client(b, true);
  });
  compile_client(b, true);
});

gulp.task("build-server", function(cb){
  gulp.src("./src/server/**")
    .pipe(gulp.dest("dist"));
});

gulp.task("watch-server", function(cb){
  gulp.start("build-server");
  gulp.watch("./src/server/**", ['build-server']);
});

gulp.task("watch-all", function(cb){

  gulp.start("watch-server");
  gulp.start("watchify-client");
  cb();
});

gulp.task("build-dev", [], function(cb){
  gulp.start("build-client-dev");
  gulp.start("build-server");
});

gulp.task("build", [], function(cb){
  gulp.start("build-client");
  gulp.start("build-server");
});

gulp.task("default", ["build"]);
