socket = io.connect();
$ ->
	$('#substitute-params').hide()
	socket.on 'connect', () ->
		socket.on 'rendersubs', (data) ->
			objFromDataBase = data	
			console.log(objFromDataBase)


		$('#substitution-form').on 'submit', '.substitution-submit', (e) ->
			console.log()
			e.preventDefault()
			formData = $(this).serialize()
			console.log("formData", formData)

			$('#substitute-results').append('<li class="substitute-results">Hi</li>')

		$('#substitution-form').on 'change', (e) ->
			e.preventDefault()
			val = $(this).serialize()
			console.log("val",val)
			socket.emit 'requestparams', val
			$('#substitute-params').show()
			#receive item specific data from the server. update units and quantity accordingly
			socket.on 'sendparams', (data) ->
				console.log(data)



		
		
			
