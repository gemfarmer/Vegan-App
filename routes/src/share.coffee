console.log("fire yummly!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')


# #include server module from app.js
# server = require('./../../lib/app.js').server

# #require socket.io module
# socketio = require 'socket.io'

# #Start the web socket server
# io = socketio.listen(server);


module.exports = (req, res) ->
	res.render 'share'