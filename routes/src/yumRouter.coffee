console.log("fire yumRouter!")

User = require('../../models/lib/user')
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'


# routes that handle the yummly api logic pages 
module.exports = {
	index: require('./yummly')
	yumyum: require('./yumControl')
}
