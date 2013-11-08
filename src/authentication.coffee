# authentication 

passport = require('passport') 
LocalStrategy = require('passport-local').Strategy;

User = require('./../models/lib/user');

passport.use(new LocalStrategy(
	{
		usernameField: 'username'
	}, (username, password, done) ->
		console.log(username, password)

		User.authenticate username, password, (err, user, message) ->

			return done(err, user, message);
		return
))

passport.serializeUser (user, done) ->
  done(null, user.id);
  return


passport.deserializeUser (id, done) ->
	User.findById id, (err, user) ->
		done(err, user);
		return
	return

module.exports = passport;