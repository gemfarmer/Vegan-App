// Generated by CoffeeScript 1.6.3
(function() {
  var Schema, UserSchema, bcrypt, mongoose, passport;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  passport = require('passport');

  bcrypt = require('bcrypt');

  UserSchema = new Schema({
    username: {
      type: String,
      required: true,
      unique: true
    },
    name: {
      first: {
        type: String,
        required: true
      },
      last: {
        type: String,
        required: true
      }
    },
    email: {
      type: String,
      unique: true
    },
    role: {
      type: String,
      required: true,
      "default": 'std'
    },
    salt: {
      type: String,
      required: true
    },
    hash: {
      type: String,
      required: true
    },
    pwdKey: {
      type: String,
      required: false
    }
  }, {
    collection: 'users'
  });

  UserSchema.virtual('password').get(function() {
    return this._password;
  }).set(function(password) {
    var salt;
    this._password = password;
    salt = this.salt = bcrypt.genSaltSync(10);
    this.hash = bcrypt.hashSync(password, salt);
  });

  UserSchema.method('verifyPassword', function(password, callback) {
    return bcrypt.compare(password, this.hash, callback);
  });

  UserSchema["static"]('authenticate', function(username, password, callback) {
    this.findOne({
      username: username
    }, function(err, user) {
      if (err) {
        return callback(err);
      }
      if (!user) {
        return callback(null, false, {
          message: 'Unknown user: ' + username
        });
      }
      user.verifyPassword(password, function(err, passwordCorrect) {
        if (err) {
          return callback(err);
        }
        if (!passwordCorrect) {
          return callback(null, false, {
            message: 'Invalid password'
          });
        }
        return callback(null, user);
      });
    });
  });

  module.exports = mongoose.model('User', UserSchema);

}).call(this);
