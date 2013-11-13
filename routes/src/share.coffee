console.log("fire yummly!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')
_ = require 'underscore'

#access mongodb Substitute Model
Substitute = require('./../../models/lib/mongodb.js').Substitute

console.log("Subsittute",Substitute)


module.exports = (io) ->
	io.sockets.on 'connection', (socket) ->

		socket.on 'substitute-form', (data) ->
			# console.log(data)
			parsedData = querystring.parse(data)
			# console.log("data::::", parsedData)
			
			# addRatio = (parsedData, callback) ->
			# 	# console.log("first",parsedData)
			
			# 	# console.log("second",callbackData)
				
			# 	console.log("substitute",parsedData['substitute-qty'])
				
			# 	mappedQty = _.map parsedData['substitute-qty'], (num) -> 
			# 		if typeof(num) == String
			# 			return Number(num)
			# 		else
			# 			return num
			# 	console.log("mappedQty",mappedQty)
			# 	ratio = _.map mappedQty, (num) ->
			# 		return num / data['non-vegan-qty']
			# 	parsedData.ratio = ratio
			# 	return callback(parsedData)
					

			# addRatio parsedData, (data) ->
			# 	console.log("click")
			# 	substitute = new Substitute(data)
			# 	substitute.save (err,data) ->
			# 		console.log("save")
			# 		if err
			# 			console.log(err)
			# 		else
			# 			console.log("sent to database:",data)

			substitute = new Substitute(parsedData)
			substitute.save (err,data) ->
				console.log("save")
				if err
					console.log(err)
				else
					console.log("sent to database:",data)	

	objectToRender = {
		units: ["cups", "tbsp", "tsp", "pinch", "links", "patty","stick", "lbs"]
		qty: [.5,.75,1,2,3,4,5,6]
	}

	share = (req, res) ->
		#render jade file		
		res.render 'share', objectToRender

	return {
		share: share
	}

