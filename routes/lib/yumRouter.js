// Generated by CoffeeScript 1.6.3
(function() {
  var User, async, mongoose, request;

  console.log("fire yumRouter!");

  User = require('../../models/lib/user');

  request = require('request');

  async = require('async');

  mongoose = require('mongoose');

  module.exports = {
    yummly: require('./yummly'),
    substitution: require('./substitution'),
    share: require('./share')
  };

}).call(this);
