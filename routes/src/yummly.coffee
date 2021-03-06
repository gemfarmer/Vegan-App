console.log("fire yummly!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')
_ = require 'underscore'

RecipeSearch = mongoose.model('RecipeSearch', {
	q: String
	allowedCuisine: String
	allowedCourse: String
	allowedAllergy: String
	allowedDiet: String
	allowedIngredient: String
	excludedIngredient: String
})
module.exports = (io) ->
	
	yummlyExport = (req, res) ->

		searchMetaParam = {
			allergy: 'allergy'
			diet: 'diet'
			cuisine: 'cuisine'
			course: 'course'
			ingredient: 'ingredient'
		}
		# credentials = {
		# 	yummlyAppId : '48b32423'
		# 	yummlyAppKey : "f801fe2eacf40c98299940e2824de106"
		# }
		# credentials = {
		# 	yummlyAppId : '97e6abca'
		# 	yummlyAppKey : "d484870556711f7eaa34a88431fd1c84"
		# }
		# credentials = {
		# 	yummlyAppId : 'f7e932f4'
		# 	yummlyAppKey : "ea34523729835c47af535398733dcd28"
		# }
		# credentials = {
		# 	yummlyAppId : '362018bb'
		# 	yummlyAppKey : "1b0f50648976ca48b2d63c9b73784960"
		# }
		credentials = {
			yummlyAppId : '74f62b28'
			yummlyAppKey : "75d0c10b8bfdc42bf4f9bbed0c4f44c9"
		}
		
		credentialKey = "_app_id=#{credentials.yummlyAppId}&_app_key=#{credentials.yummlyAppKey}"


		io.sockets.on 'connection', (socket) ->
			console.log("SOCKET CONNECTED")

			#get specific recipe id from client
			socket.on 'sendRecipeId', (recipeId) ->

				recipeUrl = "http://api.yummly.com/v1/api/recipe/#{recipeId}?#{credentialKey}"
				console.log(recipeUrl)
				request recipeUrl, (error, response, body) ->

					console.log("body:::", body)
					newBody = body.replace('{"attribution":{"html":"<a href=\'', '')
					splitBody = newBody.split("'")
					urlToSend = splitBody[0]
					# consol.log("NEW BODY",newBody)
					
					socket.emit 'returnRecipeInfo', urlToSend

			#get form information
			joinedURL = ""
			socket.on 'yumForm', (formData) ->
				queryPrefix = {
					allowedCourse : "&allowedCourse[]="
					allowedAllergy : "&allowedAllergy[]="
					# allowedDiet : "&allowedDiet[]="
					allowedCuisine : "&allowedCuisine[]="
					allowedIngredient: "&allowedIngredient[]="
					excludedIngredient: "&excludedIngredient[]="
				}
				parsedFormData = querystring.parse(formData)
				console.log("formData::::::", parsedFormData)

				queryObj = {}
				for param of parsedFormData
					if typeof(parsedFormData[param]) == "object"
						# console.log("INSTANCE")
						queryArray = []
						prepend = () ->
							
							queryArray.push(queryPrefix[param] + j)
							queryObj[param] = queryArray.join("")
							# console.log("QUERY ARRAY",queryArray)
						prepend() for j in parsedFormData[param]
					else 
						queryObj[param] = queryPrefix[param] + parsedFormData[param]
				urlExtras = []

				if queryObj.allowedCourse != undefined
					urlExtras.push(queryObj.allowedCourse)
				if queryObj.allowedAllergy != undefined
					urlExtras.push(queryObj.allowedAllergy)
				# if queryObj.allowedDiet != undefined
				# 	urlExtras.push(queryObj.allowedDiet)
				if queryObj.allowedCuisine != undefined
					urlExtras.push(queryObj.allowedCuisine)
				if queryObj.allowedIngredient != undefined
					urlExtras.push(queryObj.allowedIngredient)
				if queryObj.excludedIngredient != undefined
					urlExtras.push(queryObj.excludedIngredient)

				console.log "urlExtras:", urlExtras
				joinedURL = urlExtras.join("")
				console.log("joinedURL", joinedURL)


			#get query from search field
			socket.on 'yumKeyUp', (query) ->
				
				#get query info
				console.log("keyupQuery::::::", query.q)

				yummlyUpdatedUrl = "http://api.yummly.com/v1/api/recipes?#{credentialKey}&q=#{query.q}&allowedDiet[]=386^Vegan#{joinedURL}"
				console.log("yummlyUpdatedUrl::::", yummlyUpdatedUrl)

				#Pull Yummly API
				request yummlyUpdatedUrl, (error, response, body) ->

					yummlyObj = JSON.parse(body)

					socket.emit('yumKeyUpData',yummlyObj)

		# console.log("credentialKey", credentialKey)
		getMetaData = (param, callback) ->

			yummlyUrl = "http://api.yummly.com/v1/api/metadata/#{param}?#{credentialKey}"
			console.log("yummlyUrl", yummlyUrl)
			request yummlyUrl, (error, response, body) ->	
				data = body.replace("set_metadata('"+param+"',", '').replace(');', '')
				# console.log("data:::::", data)
				callback(null, JSON.parse(data))
		

		getRecipeData = (callback) ->

			yummlyQUrl = "http://api.yummly.com/v1/api/recipes?#{credentialKey}"

			# console.log("finished URL",yummlyQUrl)
			#Pull Yummly API
			request yummlyQUrl, (error, response, body) ->
				# console.log(body);
				yummlyObj = JSON.parse(body)


				callback(null, yummlyObj)



		#define tasks for async waterfall
		tasks = [
			(cb) ->
				toRender = {
					title: 'Find Vegan Recipes'
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
				getMetaData searchMetaParam.ingredient, (err, data) ->
					# console.log("allowedIngredient",data)
					toRender.allowedIngredient = data
					cb(null, toRender)
			,
			(toRender, cb) ->
				getMetaData searchMetaParam.ingredient, (err, data) ->
					# console.log("excludedIngredient",data)

					toRender.excludedIngredient = data
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
				res.render 'yummly', result
	# export yumRouter.yummly
	return {
		yummly: yummlyExport
	}
