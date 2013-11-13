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

module.exports = (io) ->
	io.sockets.on 'connection', (socket) ->

		socket.on 'substitute-form', (data) ->
			console.log(data)
			parsedData = querystring.parse(data)
			console.log("data::::", parsedData)

	share = (req, res) ->

		
	
		#render jade file		
		res.render 'share'

	{
		share: share
	}

