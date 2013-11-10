console.log("fire main.js")

#connect client sockets
socket = io.connect();

$ ->
	console.log("fire jQ")
	socket.on 'connect', () ->
		$(document).on 'keyup', '.chosen-search input', (e) ->
			e.preventDefault()
				
			val = $(this).val()
			dataToYummly = {}

			dataToYummly.q = val
			console.log("dataToYummly:",dataToYummly)

			console.log(val)
			$.get '/yummly', dataToYummly, (data) ->
				console.log("data:", data)
				
				# send data to yummly.coffee
				# res.send(data)

			socket.on 'yummly', () ->


		$(".chzn-select").chosen()

		$('#recipe-form').on 'change', (e) ->
			e.preventDefault()
			# console.log($(this))

			info = $(this).serialize()

			console.log("info",info)

			$.get '/yummly', info, (data) ->
				# console.log(data)
				for i of data.matches
					recipe = data.matches[i]
					console.log(recipe)
				
