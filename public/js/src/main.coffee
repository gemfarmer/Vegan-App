console.log("fire main.js")

#connect client sockets
socket = io.connect();

$ ->
	console.log 'fire jQ'


	socket.on 'connect', () ->
		console.log("socket connected to yummly")


		#recieve data to append to the DOM
		socket.on 'yumKeyUpData', (data) ->
			console.log("data::::",data)
			console.log(data.matches)
			matched = data.matches
			console.log("matched::::",matched)
			
			#empty query field
			$('.querySearchSelect').empty()
			#empty dom
			$('#recipeRepo').empty()


			for item in matched
				# console.log(item.recipeName)
				# joinedRecipeItem = (item.recipeName).split(" ").join("+")
				$('.querySearchSelect').append("<option class='querySearchOptions' value=#{item.id}>#{item.recipeName}</option>")

				#update chosen fields
				$('.querySearchSelect').trigger("chosen:updated");

				#update matched recipe area
				recipeNameDom = "<div value='#{item.id}' class='recipeName'>#{item.recipeName}</div>"
				recipeSource = "<div class='recipeSource'>Source: #{item.sourceDisplayName}</div>"
				if item.smallImageUrls[0]
					recipeImg = "<img class='recipeImg' src=#{item.smallImageUrls[0]}></img>"
				else
					recipeImg = "<img class='recipeImg' src='img/default-recipe.png'></img>"
				$('#recipeRepo').append("<li class='matchedRecipe'>#{recipeImg}#{recipeNameDom}#{recipeSource}</li>")

			
			console.log("item::::", data)
			$('#matchedResults').text("#{data.totalMatchCount} Matched Results")
	

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

	$(document).on 'click', '#searchEngine', (e) ->
		e.preventDefault()
		console.log("click")
		$('#searchEngine').toggleClass('tuck')
