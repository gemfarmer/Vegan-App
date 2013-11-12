
$ ->

	$(document).on 'click', '#add-input-field', (e) ->
		e.preventDefault()


		inputField = "<input class='form-control add' type='text' name='vegan-substitute' placeholder='Vegan Substitute'></input>"
		# addFieldButton = "<button class='btn' id='#add-input-field'>+</button>"
		removeFieldButton = "<button class='btn col-xs-2 remove-input-field'>-</button>"
		inputTextArea =	"<textarea class='form-control' type='text' name='substitute-description' placeholder='Description'></textarea>"
		sizingDiv = "<div class='substitute-field col-xs-10'></div>"
		inputFieldContainer = "<div class='form-group substitute-inputs current'></div>"
		
		$('#substitutes-repo').append(inputFieldContainer)
		$('.current').append(sizingDiv+removeFieldButton)
		$('.substitute-field').append(inputField+inputTextArea)
		$('.substitute-field').removeClass('substitute-field')
		$('.current').removeClass('current')

	$(document).on 'click', '.remove-input-field', (e) ->
		e.preventDefault()
		$(this).parent('.substitute-inputs').remove()
