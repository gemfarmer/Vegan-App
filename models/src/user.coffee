mongoose = require('mongoose');
Schema = mongoose.Schema;

passport = require('passport');
bcrypt = require('bcrypt');

# user schema
UserSchema = new Schema {
	username : {type: String, required: true, unique: true },
	name : {
		first: { type: String, required: true },
		last: { type: String, required: true }
	},
	email: { type: String, unique: true },
	role: { type: String, required: true, default: 'std' },
	salt: { type: String, required: true },
	hash: { type: String, required: true },
	pwdKey: { type: String, required: false}
},
{collection : 'users'};

UserSchema
.virtual('password')
.get () ->
	return @._password;

.set (password) ->
	@._password = password;
	salt = @.salt = bcrypt.genSaltSync(10);
	@.hash = bcrypt.hashSync(password, salt);
	return

UserSchema.method 'verifyPassword', (password, callback) ->
	bcrypt.compare(password, @.hash, callback);


UserSchema.static 'authenticate', (username, password, callback) ->
	@.findOne { username: username }, (err, user) ->
		if (err)
			return callback(err);
		if (!user)
			return callback(null, false, { message: 'Unknown user: ' + username} );
		user.verifyPassword password, (err, passwordCorrect) ->
			if (err) 
				return callback(err);
			if (!passwordCorrect) 
				return callback(null, false, { message: 'Invalid password'}); 
			return callback(null, user);
		return
	return
module.exports = mongoose.model('User', UserSchema);