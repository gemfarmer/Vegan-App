// Generated by CoffeeScript 1.6.3
(function() {
  var DB, app, async, config, db, express, home, http, io, moment, mongoStore, mongoose, passport, request, server, socketio, storeConf;

  express = require('express');

  home = require('./../routes/lib/home');

  mongoose = require('mongoose');

  passport = require('./authentication');

  mongoStore = require('connect-mongo')(express);

  moment = require('moment');

  request = require('request');

  async = require('async');

  http = require('http');

  app = module.exports = express();

  global.app = app;

  config = require('./config.js');

  app.locals.config = config;

  socketio = require('socket.io');

  server = http.createServer(app);

  io = socketio.listen(server);

  DB = require('./database');

  db = new DB.startup(process.env.MONGOHQ_URL || 'mongodb://localhost/' + config.dbname);

  storeConf = {
    db: {
      db: config.dbname,
      host: process.env.MONGOHQ_URL || 'mongodb://localhost/' + config.dbname
    },
    secret: config.sessionSecret
  };

  app.locals.links = require('./navigation');

  app.locals.moment = moment;

  app.configure(function() {
    app.set('views', __dirname + '/../views');
    app.set('port', process.env.PORT || 3000);
    app.set('view engine', 'jade');
    app.use(function(req, res, next) {
      var current;
      current = req.path.split('/');
      res.locals.current = '/' + current[1];
      res.locals.url = 'http://' + req.get('host') + req.url;
      next();
    });
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.methodOverride());
    app.use(express.session({
      secret: storeConf.secret,
      maxAge: new Date(Date.now() + 3600000)
    }));
    app.use(passport.initialize());
    app.use(passport.session());
    app.use(app.router);
    app.use(express["static"]('./public'));
  });

  app.configure('development', function() {
    app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  app.configure('production', function() {
    app.use(express.errorHandler());
  });

  require(__dirname + '/routes')(app, request, io);

  server.listen(app.get('port'), function() {
    return console.log("Listening on " + app.get('port'));
  });

}).call(this);
