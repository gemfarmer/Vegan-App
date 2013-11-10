


console.log("fire substitution!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'




module.exports = (req, res) ->

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



	# res.render 'substitution.jade', {
	# 		title: app.locals.config.name + ' Terms of Service',
	# 		user: req.user
	# 		# q : [
	# 		# 	{
	# 		# 		nonVegan: {
	# 		# 			item: "egg"
	# 		# 			units: "medium"
	# 		# 		}
	# 		# 		vegan: [
	# 		# 			{

	# 		# 			}
	# 		# 		]
	# 		# 		{
	# 		# 			items: ["banana", "tofu/silken tofu", "applesauce"]
	# 		# 			units: [null, "cup", "cup"]
	# 		# 			ratio: [.5, .25, (1/3), .25]
	# 		# 			notes: [null, null]
	# 		# 		}
	# 		# 		nonVeganUnits: "medium egg"
	# 		# 		substitute: "banana"
	# 		# 		substituteUnits: 
	# 		# 		ratio: 1
	# 		# 	}
	# 		# 	{
	# 		# 		nonVegan: "butter"
	# 		# 		nonVeganUnits: "medium egg"
	# 		# 		substitute: "banana"
	# 		# 		substituteUnits: 
	# 		# 		ratio: 1
	# 		# 		nonVegan: "butter"
	# 		# 		substitute: "cashew puree"
	# 		# 	}
	# 		# ]
	# }