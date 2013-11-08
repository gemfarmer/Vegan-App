# routes that handle the basic pages and user accounts
console.log("fire yummly.coffee!")
User = require('../../models/lib/user');
console.log("fire yummly.js")
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'



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

	getMetaData = (param, callback) ->

		yummlyUrl = 'http://api.yummly.com/v1/api/metadata/'+param+'?'+credentials.yummlyAppId+credentials.yummlyAppKey
		request yummlyUrl, (error, response, body) ->	
				data = body.replace("set_metadata('"+param+"',", '').replace(');', '')
				
				callback(null, JSON.parse(data)) 
	
	searchRecipes = () ->
		# console.log(app)
		# app.get '/searchRecipes', (req,res) ->

	getRecipeData = (callback) ->
		# console.log("searchRecipes",searchRecipes())
		yummlyQUrl = "http://api.yummly.com/v1/api/recipes?"+credentials.yummlyAppId+credentials.yummlyAppKey
		console.log(yummlyQUrl)
		#Pull Yummly API
		request yummlyQUrl, (error, response, body) ->
			# console.log(body);
			recipeObj = {}
			yummlyObj = JSON.parse(body)
			# console.log("YUM", yummlyObj)

			callback(null, yummlyObj)

			return


	toRender = {
		title: 'Veganizzm App'
	}

	#### make async functions pure. avoid making toRender global

	tasks = [
		(cb) ->
			getMetaData searchMetaParam.cuisine, (err, data) ->
				toRender.allowedCuisine = data
				cb()
		,
		(cb) ->
			getMetaData searchMetaParam.course, (err, data) ->
				toRender.allowedCourse = data
				cb()
		,
		(cb) ->
			getMetaData searchMetaParam.allergy, (err, data) ->
				toRender.allowedAllergy = data
				cb()
		,
		(cb) ->
			getMetaData searchMetaParam.diet, (err, data) ->
				toRender.allowedDiet = data
				cb()
		,
		(cb) ->
			getRecipeData (err, data) ->
				toRender.q = data.matches
				cb(data)
	]

	# use parallel instead of series because none of the tasks rely on one another
	# added query, changed to series
	async.series tasks, (data) ->
		console.log "data", data
		res.render 'yummly', toRender


