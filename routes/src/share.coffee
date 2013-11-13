console.log("fire yummly!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')

#access mongodb Substitute Model
Substitute = require('./../../models/lib/mongodb.js').Substitute

console.log("Subsittute",Substitute)


module.exports = (io) ->
	io.sockets.on 'connection', (socket) ->

		socket.on 'substitute-form', (data) ->
			console.log(data)
			parsedData = querystring.parse(data)
			console.log("data::::", parsedData)
			
			substitute = new Substitute(parsedData)
			console.log(substitute)
			substitute.save (err,data) ->
				if err
					console.log(err)
				else
					console.log("sent to database:",data)
			return

	share = (req, res) ->

		
	
		#render jade file		
		res.render 'share'

	{
		share: share
	}

