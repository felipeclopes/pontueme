# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.urlFilter = {}
window.urlFilter.user_dashboard = ->
		$('#add-card').click (e) ->
			e.preventDefault()
			$.ajax '/cards/create',
				type: 'POST'
				dataType: 'json'
				data: { code: $("#code").val() }
				error: (jqXHR, textStatus, errorThrown) ->
					setAlert(textStatus + ": " + errorThrown + " - " + $.parseJSON(jqXHR.responseText).message, "error")
				success: (data, textStatus, jqXHR) ->
					console.log "Card name: " + data.card.code + "\nPoints: " + data.points
					$('#card-list > tbody:last').prev().append('<tr><td>' + data.card.code + '</td><td>' + data.points + '</td></tr>')
					setAlert("O cartão foi adicionado com sucesso!", "success")
					
		$(".close").click (e) ->
			e.preventDefault()
			console.log e.parent()
			$(".alert").hide()
			
		$(".alert").hide()
		
		setAlert = (text, type) ->
			alert = $("<div class='alert'></div>")
			close = $("<button type='button' class='close' data-dismiss='alert'>×</button>")
			
			alert.attr("class", "alert alert-" + type).html(text).append(close)
			
			$("#add-card-region").find(".alert").remove()
			$("#add-card-region").prepend(alert)
			