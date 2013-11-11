console.log("fire yummly!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'
querystring = require('querystring')

RecipeSearch = mongoose.model('RecipeSearch', {
	q: String
	allowedCuisine: String
	allowedCourse: String
	allowedAllergy: String
	allowedDiet: String
})

#include server module from app.js
server = require('./../../lib/app.js').server

#require socket.io module
socketio = require 'socket.io'

#Start the web socket server
io = socketio.listen(server);


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
	# credentials = {
	# 	yummlyAppId : '97e6abca'
	# 	yummlyAppKey : "d484870556711f7eaa34a88431fd1c84"
	# }
	# credentials = {
	# 	yummlyAppId : 'f7e932f4'
	# 	yummlyAppKey : "ea34523729835c47af535398733dcd28"
	# }
	
	credentialKey = "_app_id=#{credentials.yummlyAppId}&_app_key=#{credentials.yummlyAppKey}"


	io.sockets.on 'connection', (socket) ->
		console.log("SOCKET CONNECTED")

		#get form information
		joinedURL = ""
		socket.on 'yumForm', (formData) ->
			queryPrefix = {
				allowedCourse : "&allowedCourse[]="
				allowedAllergy : "&allowedAllergy[]="
				allowedDiet : "&allowedDiet[]="
				allowedCuisine : "&allowedCuisine[]="
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
			if queryObj.allowedDiet != undefined
				urlExtras.push(queryObj.allowedDiet)
			if queryObj.allowedCuisine != undefined
				urlExtras.push(queryObj.allowedCuisine)

			console.log "urlExtras:", urlExtras
			joinedURL = urlExtras.join("")
			console.log("joinedURL", joinedURL)


		#get query from search field
		socket.on 'yumKeyUp', (query) ->
			
			#get query info
			console.log("keyupQuery::::::", query.q)

			yummlyUpdatedUrl = "http://api.yummly.com/v1/api/recipes?#{credentialKey}&q=#{query.q}#{joinedURL}"
			console.log("yummlyUpdatedUrl::::", yummlyUpdatedUrl)
			# console.log("finished URL",yummlyQUrl)
			#Pull Yummly API
			request yummlyUpdatedUrl, (error, response, body) ->
				# console.log(body);
				# data.object = yummlyObj = JSON.parse(body)
				# data.query = query.q
				# console.log("YUM", yummlyObj)
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
			# console.log "result", result
			res.render 'yummly', result


