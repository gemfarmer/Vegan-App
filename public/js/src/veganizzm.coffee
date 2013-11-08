$ ->

	$('#veganButton').on 'click', () ->
			console.log('click')
			$.get '/veganizzm', (data) ->
				dataArray = []
				slicedData = data.slice(0,3)
				dataArray.push(slicedData)
				console.log(slicedData)

				$('#veganRepo').text(dataArray[0])
				# console.log(data)
				