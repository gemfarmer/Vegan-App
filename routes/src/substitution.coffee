
console.log("fire substitution!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')

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
console.log(substitutionObject)

# console.log(substitutionObject)
module.exports = (io) ->
	{
		index: (req, res) ->
			res.render 'substitution', substitutionObject
	}
	# 	console.log("submittedInfo", submittedInfo)
	# recipeSearch = new RecipeSearch(submittedInfo)
	# recipeSearch.save (err,data) ->
	# 	console.log("sent to database:",data)
	# 	return
	# queryPrefix = {
	# 	# q : "&q="
	# 	allowedCourse : "&allowedCourse[]="
	# 	allowedAllergy : "&allowedAllergy[]="
	# 	allowedDiet : "&allowedDiet[]="
	# 	allowedCuisine : "&allowedCuisine[]="
	# }
	# console.log("hello")


