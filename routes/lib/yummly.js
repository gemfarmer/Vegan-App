// Generated by CoffeeScript 1.6.3
(function() {
  var User, async, mongoose, request;

  console.log("fire yummly!");

  User = require('../../models/lib/user');

  request = require('request');

  async = require('async');

  mongoose = require('mongoose');

  module.exports = function(req, res) {
    var credentialKey, credentials, getMetaData, getRecipeData, queryOnKeyup, searchMetaParam, tasks;
    console.log("req.query:", req.query);
    queryOnKeyup = req.query;
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
      var j, joinedURL, param, prepend, queryArray, queryObj, queryPrefix, urlExtras, yummlyQUrl, _i, _len, _ref;
      queryPrefix = {
        q: "&q=",
        allowedCourse: "&allowedCourse[]=",
        allowedAllergy: "&allowedAllergy[]=",
        allowedDiet: "&allowedDiet[]=",
        allowedCuisine: "&allowedCuisine[]="
      };
      queryObj = {};
      for (param in queryOnKeyup) {
        if (typeof queryOnKeyup[param] === "object") {
          queryArray = [];
          prepend = function() {
            queryArray.push(queryPrefix[param] + j);
            return queryObj[param] = queryArray.join("");
          };
          _ref = queryOnKeyup[param];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            j = _ref[_i];
            prepend();
          }
        } else {
          queryObj[param] = queryPrefix[param] + queryOnKeyup[param];
        }
      }
      urlExtras = [];
      if (queryObj.q !== void 0) {
        queryObj.q = queryObj.q.split(' ').join("+");
        urlExtras.push(queryObj.q);
      }
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
      yummlyQUrl = "http://api.yummly.com/v1/api/recipes?" + credentialKey + joinedURL;
      console.log("finished URL", yummlyQUrl);
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
          title: 'Veganizzm Apperoni'
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
