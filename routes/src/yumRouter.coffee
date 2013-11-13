console.log("fire yumRouter!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'


# routes that handle the yummly api logic pages 
module.exports = (io) ->
	# console.log("yummly",require("./yummly"))
	{
		yummly: require('./yummly')(io).yummly
		substitution: require('./substitution')(io).index
		share: require('./share')(io).share
	}
