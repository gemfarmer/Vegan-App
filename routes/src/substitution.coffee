
console.log("fire substitution!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')

_ = require 'underscore'

#access mongodb Substitute Model
Substitute = require('./../../models/lib/mongodb.js').Substitute


substitutionObject = {}


#export
module.exports = (io) ->
	objectToRender = {q: "sdf"}
	getSubObj = (substitutes) ->
		substituteArray = []
		for substitute in substitutes
			# console.log("substitute",substitute)
			substitute['non-vegan-qty']
			mappedQty = _.map substitute['substitute-qty'], (num) -> 
				return Number(num)
			# console.log("mappedQty",mappedQty)
			ratio = _.map mappedQty, (num) ->
				return num / substitute['non-vegan-qty']
			# console.log("ratio", ratio)
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
			console.log("obj",item)
		substitutionObject = {
			q: substituteArray
		}
		console.log(substitutionObject)

	findSubstitutes = () ->
		Substitute.find {}, (err, substitutes) ->
			if(err)
				console.log('ERROR')
			else
				# console.log("substitution",substitutes)
				getSubObj(substitutes)

	findSubstitutes()
	{
		index: (req, res) ->
			console.log(findSubstitutes())
			res.render 'substitution.jade', substitutionObject
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
