// Generated by CoffeeScript 1.6.3
(function() {
  var RecipeSearch, User, async, io, mongoose, querystring, request, server, socketio;

  console.log("fire yummly!");

  User = require('../../models/lib/user');

  request = require('request');

  async = require('async');

  mongoose = require('mongoose');

  querystring = require('querystring');

  RecipeSearch = mongoose.model('RecipeSearch', {
    q: String,
    allowedCuisine: String,
    allowedCourse: String,
    allowedAllergy: String,
    allowedDiet: String
  });

  server = require('./../../lib/app.js').server;

  socketio = require('socket.io');

  io = socketio.listen(server);

  module.exports = function(req, res) {
    var credentialKey, credentials, getMetaData, getRecipeData, searchMetaParam, tasks;
    searchMetaParam = {
      allergy: 'allergy',
      diet: 'diet',
      cuisine: 'cuisine',
      course: 'course'
    };
    credentials = {
      yummlyAppId: 'f7e932f4',
      yummlyAppKey: "ea34523729835c47af535398733dcd28"
    };
    credentialKey = "_app_id=" + credentials.yummlyAppId + "&_app_key=" + credentials.yummlyAppKey;
    io.sockets.on('connection', function(socket) {
      var joinedURL;
      console.log("SOCKET CONNECTED");
      joinedURL = "";
      socket.on('yumForm', function(formData) {
        var j, param, parsedFormData, prepend, queryArray, queryObj, queryPrefix, urlExtras, _i, _len, _ref;
        queryPrefix = {
          allowedCourse: "&allowedCourse[]=",
          allowedAllergy: "&allowedAllergy[]=",
          allowedDiet: "&allowedDiet[]=",
          allowedCuisine: "&allowedCuisine[]="
        };
        parsedFormData = querystring.parse(formData);
        console.log("formData::::::", parsedFormData);
        queryObj = {};
        for (param in parsedFormData) {
          if (typeof parsedFormData[param] === "object") {
            queryArray = [];
            prepend = function() {
              queryArray.push(queryPrefix[param] + j);
              return queryObj[param] = queryArray.join("");
            };
            _ref = parsedFormData[param];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              j = _ref[_i];
              prepend();
            }
          } else {
            queryObj[param] = queryPrefix[param] + parsedFormData[param];
          }
        }
        urlExtras = [];
        if (queryObj.allowedCourse !== void 0) {
          urlExtras.push(queryObj.allowedCourse);
        }
        if (queryObj.allowedAllergy !== void 0) {
          urlExtras.push(queryObj.allowedAllergy);
        }
        if (queryObj.allowedDiet !== void 0) {
          urlExtras.push(queryObj.allowedDiet);
        }
        if (queryObj.allowedCuisine !== void 0) {
          urlExtras.push(queryObj.allowedCuisine);
        }
        console.log("urlExtras:", urlExtras);
        joinedURL = urlExtras.join("");
        return console.log("joinedURL", joinedURL);
      });
      return socket.on('yumKeyUp', function(query) {
        var yummlyUpdatedUrl;
        console.log("keyupQuery::::::", query.q);
        yummlyUpdatedUrl = "http://api.yummly.com/v1/api/recipes?" + credentialKey + "&q=" + query.q + joinedURL;
        console.log("yummlyUpdatedUrl::::", yummlyUpdatedUrl);
        return request(yummlyUpdatedUrl, function(error, response, body) {
          var yummlyObj;
          yummlyObj = JSON.parse(body);
          return socket.emit('yumKeyUpData', yummlyObj);
        });
      });
    });
    getMetaData = function(param, callback) {
      var yummlyUrl;
      yummlyUrl = "http://api.yummly.com/v1/api/metadata/" + param + "?" + credentialKey;
      console.log("yummlyUrl", yummlyUrl);
      return request(yummlyUrl, function(error, response, body) {
        var data;
        data = body.replace("set_metadata('" + param + "',", '').replace(');', '');
        return callback(null, JSON.parse(data));
      });
    };
    getRecipeData = function(callback) {
      var yummlyQUrl;
      yummlyQUrl = "http://api.yummly.com/v1/api/recipes?" + credentialKey;
      return request(yummlyQUrl, function(error, response, body) {
        var yummlyObj;
        yummlyObj = JSON.parse(body);
        return callback(null, yummlyObj);
      });
    };
    tasks = [
      function(cb) {
        var toRender;
        toRender = {
          title: 'Veganizzm App'
        };
        return getMetaData(searchMetaParam.cuisine, function(err, data) {
          toRender.allowedCuisine = data;
          return cb(null, toRender);
        });
      }, function(toRender, cb) {
        return getMetaData(searchMetaParam.course, function(err, data) {
          toRender.allowedCourse = data;
          return cb(null, toRender);
        });
      }, function(toRender, cb) {
        return getMetaData(searchMetaParam.allergy, function(err, data) {
          toRender.allowedAllergy = data;
          return cb(null, toRender);
        });
      }, function(toRender, cb) {
        return getMetaData(searchMetaParam.diet, function(err, data) {
          toRender.allowedDiet = data;
          return cb(null, toRender);
        });
      }, function(toRender, cb) {
        return getRecipeData(function(err, data) {
          toRender.q = data.matches;
          return cb(null, toRender);
        });
      }
    ];
    return async.waterfall(tasks, function(err, result) {
      if (err) {
        return console.log("you have an error in your waterfall");
      } else {
        return res.render('yummly', result);
      }
    });
  };

}).call(this);
