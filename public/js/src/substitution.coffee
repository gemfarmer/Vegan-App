socket = io.connect();
$ ->
	#activate chosen
	$(".chzn-select").chosen()


	$('#substitute-params').hide()
	socket.on 'connect', () ->

		# # receive 
		# socket.on 'rendersubs', (data) ->
		# 	objFromDataBase = data	
		# 	console.log(objFromDataBase)


		$('#substitution-form').on 'click', '.substitution-submit', (e) ->
			console.log()
			e.preventDefault()
			formData = $(this).serialize()
			console.log("formData", formData)

		
		

		$('#substitution-form').on 'change', (e) ->
			e.preventDefault()
			val = $(this).serialize()
			console.log("val",val)

			# send form values to server
			socket.emit 'requestparams', val
			$('#substitute-params').show()

			# receive matching data from server
			socket.on 'sendparams', (data) ->

				# $('#substitute-params select').empty
				console.log("sendparms:::",data)
				$('.subs').empty()
				for item in data

					if item['non-vegan-units'] or item['non-vegan-qty']

						$('#substitute-params #units').append("<option data-placeholder='units' value=#{item['non-vegan-units']}>#{item['non-vegan-units']}</option>")
						$('#substitute-params #qty').append("<option data-placeholder='qty' value=#{item['non-vegan-qty']}>#{item['non-vegan-qty']}</option>")
						$('#units').trigger("chosen:updated");
						$('#qty').trigger("chosen:updated");

				$(document).on 'click', '.substitution-submit', (e) ->
					e.preventDefault()
					for item in data
						NonItems = "<li>#{item['non-vegan-item']}</li>"
						NonUnits = "<li>#{item['non-vegan-units']}</li>"
						NonQty = "<li>#{item['non-vegan-qty']}</li>"

						NonRepo = "<ul class='col-xs-12' id='nonRepo'>NonVeganItem</ul>"
						for item of item['vegan-substitute']
							MatchingItems = "<li>#{item['vegan-substitute']}</li>"
							MatchingUnits = "<li>#{item['substitute-units']}</li>"
							MatchingQty = "<li>#{item['substitute-qty']}</li>"
							MatchingDescription = "<li>#{item['substitute-description']}</li>"

							MatchingRepo = "<ul class='col-xs-12' id='MatchingRepo'>Vegan Items</ul>"

					#empty results repo
					$('#substitute-results').empty()
					
					$('#substitute-results').append(NonRepo+MatchingRepo)


					$('#nonRepo').append(NonItems+NonUnits+NonQty)
					$('#MatchingRepo').append(MatchingItems+MatchingUnits+MatchingQty+ MatchingDescription)




		# $(document).on 'click', '.substitution-submit', () ->
		# 	$('#substitute-results').append('<li class="substitute-results">Too Soon!</li>')
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



		
		
			
