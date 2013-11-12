socket = io.connect();
$ ->

	$('#substitution-form').on 'submit', '.substitution-submit', (e) ->
		console.log()
		e.preventDefault()
		formData = $(this).serialize()
		console.log("formData", formData)

		
		$('#substitute-results').append
