// Generated by CoffeeScript 1.6.3
(function() {
  var User, async, mongoose, request;

  console.log("fire substitution!");

  User = require('../../models/lib/user');

  request = require('request');

  async = require('async');

  mongoose = require('mongoose');

  module.exports = function(req, res) {
    return res.render('substitution');
  };

}).call(this);
