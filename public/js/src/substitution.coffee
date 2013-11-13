socket = io.connect();
$ ->
	$('#substitute-params').hide()
	socket.on 'connect', () ->
		socket.on 'rendersubs', (data) ->
			objFromDataBase = data	
			console.log(objFromDataBase)


		$('#substitution-form').on 'click', '.substitution-submit', (e) ->
			console.log()
			e.preventDefault()
			formData = $(this).serialize()
			console.log("formData", formData)

			$('#substitute-results').append('<li class="substitute-results">Hi</li>')

		#receive item specific data from the server. update units and quantity accordingly
		

		$('#substitution-form').on 'change', (e) ->
			e.preventDefault()
			val = $(this).serialize()
			console.log("val",val)
			socket.emit 'requestparams', val
			$('#substitute-params').show()
			socket.on 'sendparams', (data) ->

				# $('#substitute-params select').empty
				console.log(data)
				for item in data
					if item['non-vegan-units'] or item['non-vegan-qty']
						$('#substitute-params #units').append("<option value=#{item['non-vegan-units']}>#{item['non-vegan-units']}</option>")
						$('#substitute-params #qty').append("<option value=#{item['non-vegan-qty']}>#{item['non-vegan-qty']}</option>")
				$('.subs').trigger("chosen:updated");
				# $('.subs').trigger("chosen:updated");

				# for item in data
				# 	console.log(item['substitute-units'])
				# 	console.log(item['substitute-qty'])
				# 	for units of item['substitute-units']

				# 		if units 
				# 			$('#substitute-params units').append("<option value=#{units}>#{units}</option>")
				# 	for qty of item['substitute-qty']
						
				# 		if qty 
				# 			$('#substitute-params qty').append("<option value=#{qty}>#{qty}</option>")
				# 	$('#substitute-params select').trigger("chosen:updated");



		
		
			
