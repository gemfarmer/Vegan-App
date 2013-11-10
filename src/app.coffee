# dependencies
express = require('express');
home = require('./../routes/lib/home');
mongoose = require('mongoose');
mongo = require('mongodb');
passport = require('./authentication');
mongoStore = require('connect-mongo')(express);
moment = require('moment');
request = require('request')
async = require 'async'
socketio = require('socket.io');
http = require('http');
app = module.exports = express();
global.app = app;

# configuration file
config = require('./config.js');
app.locals.config = config;


# Create the server
server = http.createServer(app);

#Start the web socket server
io = socketio.listen(server);


# connect to the database
DB = require('./database');

db = new DB.startup( process.env.MONGOHQ_URL or 'mongodb://localhost/'+config.dbname);

# sessions
storeConf = {
	db: {db: config.dbname,host: 'localhost'},
	secret: config.sessionSecret
};

# import navigation links
app.locals.links = require('./navigation');

# date manipulation tool
app.locals.moment = moment;

# app config
app.configure () ->
	app.set('views', __dirname + '/../views');
	app.set('view engine', 'jade');
	# highlights top level path
	app.use (req, res, next) ->
		current = req.path.split('/');
		res.locals.current = '/' + current[1];
		res.locals.url = 'http://' + req.get('host') + req.url;
		next();
		return

	app.use(express.bodyParser());
	app.use(express.cookieParser());
	app.use(express.methodOverride());
	app.use(express.session({
		secret: storeConf.secret,
		maxAge: new Date(Date.now() + 3600000),
		store: new mongoStore(storeConf.db)
	}));
	app.use(passport.initialize());
	app.use(passport.session());
	app.use(app.router);
	app.use(express.static('./public'));
	return

# environment specific config
app.configure 'development', () ->
	app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
	return

app.configure 'production', () ->
	app.use(express.errorHandler());
	return

# load the router
require(__dirname+'/routes')(app, request, io);

port = config.port;
server.listen port, () ->
	console.log("Listening on " + port);
	return
