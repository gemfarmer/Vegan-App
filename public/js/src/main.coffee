console.log("fire main.js")

#connect client sockets
socket = io.connect();

$ ->
	console.log 'fire jQ'
	socket.on 'connect', () ->
		socket.on 'yumKeyUpData', (data) ->
			console.log(data.matches)
			matched = data.matches
			console.log(matched)
		
			$('.querySearchSelect').empty()
			# $('.querySearchSelect').parents('chosen-results').empty()
			for item in matched
				console.log(item.recipeName)
				joinedRecipeItem = (item.recipeName).split(" ").join("+")
				$('.querySearchSelect').append("<option class='querySearchOptions' value=#{joinedRecipeItem}>#{item.recipeName}</option>")

				$('.querySearchSelect').trigger("chosen:updated");
		console.log("socket connected to yummly")
	

	$(document).on 'keyup', '.chosen-search input', (e) ->
		e.preventDefault()
		
		val = $(this).val()

		if val.length <= 4 
			return
		dataToYummly = {}

		dataToYummly.q = val
		console.log("dataToYummly:",dataToYummly)

		console.log(val)
		socket.emit('yumKeyUp', dataToYummly)



	# add chosen UI
	$(".chzn-select").chosen()

	$('#recipe-form').on 'change', (e) ->
		e.preventDefault()
		# console.log($(this))

		info = $(this).serialize()

		console.log("info",info)
		socket.emit 'yumForm', info
