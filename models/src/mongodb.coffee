mongoose = require 'mongoose'

module.exports = {
	Substitute : mongoose.model('Substitute', {
			"non-vegan-item": String
			"non-vegan-qty": Number
			"non-vegan-units": String or Number
			"vegan-substitute": Array or String
			"substitute-qty": Array or Number
			"substitute-units": Array or String or Number
			"substitute-description": Array or String
		})
}