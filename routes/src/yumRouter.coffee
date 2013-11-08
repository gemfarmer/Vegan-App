# routes that handle the basic pages and user accounts
console.log("fire yumRouter!")
User = require('../../models/lib/user');
console.log("fire yummly.js")
request = require 'request'
async = require 'async'
mongoose = require 'mongoose'



module.exports = {
	index: require('./yummly')
	yumyum: require('./yumControl')
}
