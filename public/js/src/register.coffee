# check database to see if unique fields exist in the database
checkExists = (field, value) ->
	data = {};
	data[field] = value;
	helpContainer = $('#'+field).parent().find('span');
	thisDiv = $('#'+field).parents('.control-group');

	$.ajax({
		url: '/checkExists',
		type: 'GET',
		data: data
	})
	
	.done (reply) ->
		# decode the reply and act accordingly
		helpContainer.text('That '+field+' is available!');
		thisDiv.addClass('success');
		callback = () ->
			thisDiv.removeClass('success');
			helpContainer.text('');
			return
		setTimeout(callback, 1000);
		return true;
	
	.fail (xhr, err) ->
		# decode the error, clear out the field, display message accordingly
		if(xhr.status==409)
			thisDiv.addClass('error');
			helpContainer.text('Oops! That '+field+' is already taken!');
			$('#'+field).focus();
			
		else
			thisDiv.addClass('error');
			helpContainer.text('Something went wrong, please try again.');
			$('#'+field).focus();
			
		return false;
	
	return

$ ->

	# once form is completly filled out, registration button becomes clickable
	$(':input[required]').change () ->
		thisField = $(this).attr('name');
		console.log(thisField)
		readyToGo = true;
		if (thisField == 'username')
			$(this).parents('.control-group').removeClass('error');
			readyToGo = checkExists('username', $(this).val());
		else if (thisField == 'email')
			$(this).parents('.control-group').removeClass('error');
			readyToGo = checkExists('email', $(this).val());

		inputCount = $(':input[required]').length;
		$(':input[required]').each (i) ->
			if ($(this).val() == '')
				readyToGo = false;
			if ($(this).parents('.control-group').hasClass('error'))
				readyToGo = false;

			if (i == (inputCount-1))
				if (readyToGo)
					$(':submit').removeAttr('disabled').focus();
					return
				else
					$(':submit').attr('disabled', true);
					return
		return
	

	return
