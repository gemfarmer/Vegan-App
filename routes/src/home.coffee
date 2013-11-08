# routes that handle the basic pages and user accounts

User = require('../../models/lib/user');
request = require('request')

# object
module.exports = {
	# app.get('/'...)
	index: (req, res) ->
		console.log "hey"
		res.render 'index.jade', {
			title: app.locals.config.name,
			user: req.user
		}
		return
 	# app.get('/login'...)
	login: (req, res) ->
		res.render 'login.jade', {
			title: 'Login to ' + app.locals.config.name,
			user: req.user
		}
		return

	# app.get('/about'...)
	about: (req, res) ->
		res.render 'about.jade', {
			title: 'About ' + app.locals.config.name,
			user: req.user
		}
		return

	# app.get('/about/tos'...)
	tos: (req, res) ->
		res.render 'tos.jade', {
			title: app.locals.config.name + ' Terms of Service',
			user: req.user
		}
		return

	# app.get('register'...)
	getRegister: (req, res) ->
		res.render 'register.jade', {
			title: 'Register for '+app.locals.config.name,
			user: req.user
		}
		return

	# app.get('/checkExists')
	checkExists: (req, res, next) ->
		data = req.query;
		query = {};
		if (data.username)
			query['username'] = data.username;
		else if (data.email)
			query['email'] = data.email;
		else
			res.send(400, {'message':'Invalid Request'})

		User.findOne query, (err, user) ->
			if (err)
				res.send(500, err)
				return
			else if (user)
				res.send(409, {'message':'User Exists'})
				return
			else
				res.send(200, {'message':'All Clear'})
				return
		return


	# app.post('/register'...)
	postRegister: (req, res, next) ->
		user = new User(req.body);
		user.save (err) ->
			if (err) 
				next(err);
			res.redirect('/profile');
			return
		return
	

	# app.get('/profile')
	profile: (req, res, next) ->
		User.findOne {'_id':req.user._id}, (err, user) ->
			if (err)
				next(err)
			res.render 'profile.jade', {
				title: user.name.first + '\'s Profile',
				user: user
			}
			return
		return

	# app.get('/logout'...)
	logout: (req, res) ->
		req.logout();
		res.redirect('/'); 
		return 
	# request http://veganizzm.wordpress.com/
	requestVeganizzm: (req, res) ->
		# res.render 'test.jade'
		veganizzm = 'http://veganizzm.wordpress.com/'
		request veganizzm, (error, response, body) ->	
			console.log(body)
			res.send(body)

		
};