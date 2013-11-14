
console.log("fire substitution!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')
_ = require 'underscore'

#access mongodb Substitute Model
Substitute = require('./../../models/lib/mongodb.js').Substitute


#export
module.exports = (io) ->
	objectToRender = {q: "sdf"}

	# take object from database. puts in a DOM-readable form
	getSubObj = (substitutes) ->
		substituteArray = []

		for substitute in substitutes
			# console.log("substitute",substitute)
			substitute['non-vegan-qty']
			mappedQty = _.map substitute['substitute-qty'], (num) -> 
				if typeof(num) == String
					return Number(num)
			# console.log("mappedQty",mappedQty)
			ratio = _.map mappedQty, (num) ->
				return num / substitute['non-vegan-qty']
			# console.log("ratio", ratio)
			uniqueUnits = _.uniq(substitute['non-vegan-units'])
			# console.log("UNIQUEUNIQUE",uniqueUnits)
			item = {
				nonVegan: {
					item: substitute['non-vegan-item']
					units: substitute['non-vegan-units']
					qty: substitute['non-vegan-qty']
				}
				vegan: {
					items: substitute['vegan-substitute']
					units: substitute['substitute-units']
					qty: mappedQty
					notes: substitute['substitute-description']
				}
				ratio: ratio
			}
			substituteArray.push(item)
			# console.log("obj",item)
		# console.log("substituteArray", substituteArray)
		pluckedNonVeganItems = _.pluck(substituteArray, 'nonVegan')
		# console.log("pluckedNonVeganItems",pluckedNonVeganItems)
		pluckedTwice = _.pluck(pluckedNonVeganItems, 'item')

		uniqueItems = _.uniq(pluckedTwice)
		# console.log("uniqueItems",uniqueItems)
		# console.log("pluckedTwice",pluckedTwice)
		# console.log("nonVeganItems",nonVeganItems)
		return {
			q: substituteArray
			uniqueItems: uniqueItems
		}
		# console.log(substitutionObject)

	#finds object in database
	findSubstitutes = (callback) ->
		Substitute.find {}, (err, substitutes) ->
			if(err)
				console.log('ERROR')
			else
				# console.log("substitution",substitutes)
				callback(getSubObj(substitutes))

	

	io.sockets.on 'connection', (socket) ->

		#receive form values from the client
		socket.on 'requestparams', (dataFromClient) ->
			console.log("HERRERERE")
			val = querystring.parse(dataFromClient)
			console.log("val::::", val)
			
			paramsForClient = {}
			if val.item
				
				paramsForClient['non-vegan-item'] = val.item
			if val.units
				paramsForClient['non-vegan-units'] = val.units
			if val.qty
				paramsForClient['non-vegan-qty'] = val.qty



			#request matching data substitues collection in database
			Substitute.find paramsForClient, (err, databaseItem) ->

				#send matching data to client
				socket.emit 'sendparams', databaseItem
				console.log(databaseItem)


		# socket.emit 'rendersubs', substitutionObject
	{
		index: (req, res) ->
			findSubstitutes (substitutionObject) ->
				res.render 'substitution.jade', substitutionObject
			# console.log(findSubstitutes())
			
	}

# substitutionObject = {
# 	q : [
# 		{
# 			nonVegan: {
# 				item: "egg"
# 				units: "medium"
# 				qty: 1
# 			},
# 			vegan: {
# 				items: ["banana", "tofu/silken tofu", "applesauce"]
# 				units: [null, "cup", "cup"]
# 				qty: [.5, .25, (1/3), .25]
# 				notes: ["stiffens things up", null, null, null]
# 			}
# 		},
# 		{
# 			nonVegan: {
# 				item: "butter"
# 				units: "tbsp"
# 				qty: 1
# 			},
# 			vegan: {
# 				items: ["vegetable oil", "olive oil", "cashew puree"]
# 				units: ["tbsp", "tbsp", "tbsp"]
# 				qty: [1, 1, 1]
# 				notes: [null, null, null]
# 				}
# 		}
# 	]
# }	
