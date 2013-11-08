
User = require('../../models/lib/user');
console.log("fire yummly.js")
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'

RecipeSearch = mongoose.model('RecipeSearch', {
	q: String
	allowedCuisine: String
	allowedCourse: String
	allowedAllergy: String
	allowedDiet: String
})


module.exports = (req, res) ->
		

	searchMetaParam = {
		allergy: 'allergy'
		diet: 'diet'
		cuisine: 'cuisine'
		course: 'course'
	}
	 
	credentials = {
		yummlyAppId : '_app_id=48b32423'
		yummlyAppKey : "&_app_key=f801fe2eacf40c98299940e2824de106"
	}
	
	submittedInfo = req.body
	console.log("submittedInfo", submittedInfo)
	recipeSearch = new RecipeSearch(submittedInfo)
	recipeSearch.save (err,data) ->
		console.log("sent to database:",data)
		return
	queryPrefix = {
		# q : "&q="
		allowedCourse : "&allowedCourse[]="
		allowedAllergy : "&allowedAllergy[]="
		allowedDiet : "&allowedDiet[]="
		allowedCuisine : "&allowedCuisine[]="
	}

	##### create helper function to append string prefixes and suffixes

	##### clean up logic dealing with multi-fill forms
	queryObj = {}
	for i of submittedInfo
		if typeof(submittedInfo[i]) == "object"
			# console.log("INSTANCE")
			queryArray = []
			prepend = () ->
				
				queryArray.push(queryPrefix[i] + j)
				queryObj[i] = queryArray.join("")
				# console.log("QUERY ARRAY",queryArray)
			prepend() for j in submittedInfo[i]
		else 
			queryObj[i] = queryPrefix[i] + submittedInfo[i]

	urlExtras = []

	# if queryObj.q != false
	# 	urlExtras.push(queryObj.q)
	if queryObj.allowedCourse != false
		urlExtras.push(queryObj.allowedCourse)
	if queryObj.allowedAllergy != false
		urlExtras.push(queryObj.allowedAllergy)
	if queryObj.allowedDiet != false
		urlExtras.push(queryObj.allowedDiet)
	if queryObj.allowedCuisine != false
		urlExtras.push(queryObj.allowedCuisine)
	# for i of queryObj
	# 	urlExtras.push queryObj[i]

	
	console.log('urlExtras',urlExtras)
	joinedURL = urlExtras.join("")

	requestYummlyUrl = "http://api.yummly.com/v1/api/recipes?"+credentials.yummlyAppId+credentials.yummlyAppKey+joinedURL
	console.log(requestYummlyUrl)
	#Pull Yummly API
	request requestYummlyUrl, (error, response, body) ->

		# console.log(body);
		recipeObj = {}
		yummlyObj = JSON.parse(body)

		recipeObj.totalMatchCount = yummlyObj['totalMatchCount']
		recipeObj.criteria = yummlyObj['criteria']
		recipeObj.matches = yummlyObj['matches']
		recipeObj.attribution = yummlyObj['attribution']
		
		# console.log("totalMatchCount",totalMatchCount)
		res.send(recipeObj)
		res.send(yummlyObj)
		return

