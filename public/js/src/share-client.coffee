socket = io.connect();
$ ->
	$shareForm = $('#share-form')
	socket.on 'connect', () ->
		console.log("socket connected in share client")
		# add form field
		$(document).on 'click', '#add-input-field', (e) ->


			e.preventDefault()

			inputFieldContainer = "<div class='form-group substitute-inputs current'></div>"
			removeFieldButton = "<button class='btn col-xs-2 remove-input-field'>-</button>"
			sizingDiv = "<div class='substitute-field col-xs-10'></div>"

			inputField = "<input class='form-control add' type='text' name='vegan-substitute' placeholder='Vegan Substitute'></input>"
			inputTextArea =	"<textarea class='form-control' type='text' name='substitute-description' placeholder='Notes'></textarea>"
			inputQty = "<input class ='form-control col-xs-3' type='text' name='substitute-qty' placeholder='Quantity'></input>"
			inputUnits = "<input class='form-control col-xs-3' type='text' name='substitute-units' placeholder='Units'></input>"

			$('#substitutes-repo').append(inputFieldContainer)
			$('.current').append(sizingDiv+removeFieldButton)
			$('.substitute-field').append(inputField+inputTextArea+inputQty+inputUnits)
			$('.substitute-field').removeClass('substitute-field')
			$('.current').removeClass('current')
		# remove  added field
		$(document).on 'click', '.remove-input-field', (e) ->
			e.preventDefault()
			$(this).parent('.substitute-inputs').remove()


		$shareForm.on 'click', '#submit-substitute', (e) ->

			e.preventDefault()
			console.log $(this)
			formData = $shareForm.serialize()

			console.log("hey",formData)
			
			socket.emit 'substitute-form', formData




