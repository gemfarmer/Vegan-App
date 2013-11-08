# routes that handle the basic pages and user accounts
console.log("fire yummly!")

User = require('../../models/lib/user')
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
		yummlyAppId : '48b32423'
		yummlyAppKey : "f801fe2eacf40c98299940e2824de106"
	}

	credentialKey = "_app_id=#{credentials.yummlyAppId}&_app_key=#{credentials.yummlyAppKey}"
	console.log("credentialKey", credentialKey)
	getMetaData = (param, callback) ->

		yummlyUrl = "http://api.yummly.com/v1/api/metadata/#{param}?#{credentialKey}"
		console.log("yummlyUrl", yummlyUrl)
		request yummlyUrl, (error, response, body) ->	
				data = body.replace("set_metadata('"+param+"',", '').replace(');', '')
				
				callback(null, JSON.parse(data)) 
	
	searchRecipes = () ->
		# console.log(app)
		# app.get '/searchRecipes', (req,res) ->

	getRecipeData = (callback) ->
		# console.log("searchRecipes",searchRecipes())
		yummlyQUrl = "http://api.yummly.com/v1/api/recipes?#{credentialKey}"
		console.log(yummlyQUrl)
		#Pull Yummly API
		request yummlyQUrl, (error, response, body) ->
			# console.log(body);
			yummlyObj = JSON.parse(body)
			# console.log("YUM", yummlyObj)

			callback(null, yummlyObj)

			return


	

	#define tasks for async waterfall
	tasks = [
		(cb) ->
			toRender = {
				title: 'Veganizzm App'
			}
			getMetaData searchMetaParam.cuisine, (err, data) ->
				toRender.allowedCuisine = data
				cb(null, toRender)
		,
		(toRender, cb) ->
			getMetaData searchMetaParam.course, (err, data) ->
				toRender.allowedCourse = data
				cb(null, toRender)
		,
		(toRender, cb) ->
			getMetaData searchMetaParam.allergy, (err, data) ->
				toRender.allowedAllergy = data
				cb(null, toRender)
		,
		(toRender, cb) ->
			getMetaData searchMetaParam.diet, (err, data) ->
				toRender.allowedDiet = data
				cb(null, toRender)
		,
		(toRender, cb) ->
			getRecipeData (err, data) ->
				toRender.q = data.matches
				cb(null, toRender)
	]

	#waterfall passes data to the next callback in the series
	async.waterfall tasks, (err, result) ->
		if err 
			console.log "you have an error in your waterfall"
		else
			console.log "result", result

			res.render 'yummly', result


