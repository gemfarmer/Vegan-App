mongoose = require('mongoose');

module.exports = {
	# initialize DB
	startup: (dbToUse) ->
		mongoose.connect(dbToUse);
		# check connection to mongoDB
		mongoose.connection.on 'open', () ->
			console.log('We have connected to mongodb');
			return
		return

	# disconnect from database
	closeDB: () ->
		mongoose.disconnect();
		return
}