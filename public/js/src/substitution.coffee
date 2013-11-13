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

					console.log("daat",data)

					#empty results repo
					$('#substitute-results').empty()
				
					for item in data
						
						#edit table headers
						$('#NonItem').text(item['non-vegan-item'])
						$('#NonQty').text(item['non-vegan-qty'])
						$('#NonUnits').text(item['non-vegan-units'])
						# console.log("loook here",item['vegan-substitute'])
				

						
						vegItems = item['vegan-substitute']
						vegUnits = item['substitute-units']
						vegQty = item['substitute-qty']
						vegDescription = item['substitute-description']
						
						# create new Array containing array with items, units, qty, descrition
						newArray = _.zip(vegItems, vegUnits, vegQty, vegDescription);
						console.log(newArray)
						
						for itemset in newArray
							console.log("itemset",itemset)

							
							dataItem = "<td>#{itemset[0]}</td>"
							dataUnits = "<td>#{itemset[1]}</td>"
							dataQty = "<td>#{itemset[2]}</td>"
							dataDescription = "<td>#{itemset[3]}</td>"
							dataForRow = dataItem+dataUnits+dataQty+dataDescription
							newRow = "<tr>#{dataForRow}</tr>"						
						$('#substitute-results').append(newRow)

					
					
					# $('#substitute-results').append(NonRepo+MatchingRepo)


					# $('#nonRepo').append(NonItems+NonUnits+NonQty)
					# $('#MatchingRepo').append(MatchingItems+MatchingUnits+MatchingQty+ MatchingDescription)

				# $(document).on 'click', '.substitution-submit', () ->
				# 	$('#substitute-results').append('<li class="substitute-results">Too Soon!</li>')
						# $('.subs').trigger("chosen:updated");

						# for item in data
						# 	console.log(item['substitute-units'])
						# 	console.log(item['substitute-qty'])
							# for units of item['substitute-units']

							# 	if units 
							# 		$('#substitute-params units').append("<option value=#{units}>#{units}</option>")
							# for qty of item['substitute-qty']
								
							# 	if qty 
							# 		$('#substitute-params qty').append("<option value=#{qty}>#{qty}</option>")
							# $('#substitute-params select').trigger("chosen:updated");



		
		
			
