
console.log("fire substitution!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')

#access mongodb Substitute Model
Substitute = require('./../../models/lib/mongodb.js').Substitute


substitutionObject = {
	q : [
		{
			nonVegan: {
				item: "egg"
				units: "medium"
				qty: 1
			},
			vegan: {
				items: ["banana", "tofu/silken tofu", "applesauce"]
				units: [null, "cup", "cup"]
				qty: [.5, .25, (1/3), .25]
				notes: ["stiffens things up", null, null, null]
			}
		},
		{
			nonVegan: {
				item: "butter"
				units: "tbsp"
				qty: 1
			},
			vegan: {
				items: ["vegetable oil", "olive oil", "cashew puree"]
				units: ["tbsp", "tbsp", "tbsp"]
				qty: [1, 1, 1]
				notes: [null, null, null]
				}
		}
	]
}

vard = [ 
	{ 
		'non-vegan-item': '',
		'non-vegan-qty': null,
		'non-vegan-units': 'a',
		'vegan-substitute': '',
		'substitute-qty': 5,
		'substitute-units': '',
		'substitute-description': '',
		'_id' : '5282d369d1caf26407000001'
		'__v': 0 
	}
]	
		

console.log(substitutionObject)

# console.log(substitutionObject)
module.exports = (io) ->

	Substitute.find (err, substitutes) ->
		if(err)
			console.log('ERROR')
		else
			console.log('substitutes', substitutes);
			substituteArray = []

			for substitute in substitutes
				# console.log("substitute",substitute)
				item = {
					nonVegan: {
						item: substitute['non-vegan-item']
						units: substitute['non-vegan-units']
						qty: substitute['non-vegan-qty']
					}
					vegan: {
						items: substitute['vegan-substitute']
						units: substitute['substitute-units']
						qty: substitute['substitute-qty']
						notes: substitute['substitute-description']
					}
				}
				substituteArray.push(item)
				console.log("obj",item)
			console.log("substituteArray", substituteArray)







	{
		index: (req, res) ->
			res.render 'substitution', substitutionObject
	}
	
