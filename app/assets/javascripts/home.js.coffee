# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	if $("page-header")
		$('#send').click (e) ->
			e.preventDefault()
			$.ajax '/contact_form/create',
				type: 'POST'
				dataType: 'json'
				data: $('form').serialize()
				error: (jqXHR, textStatus, errorThrown) ->
					setAlert($.parseJSON(jqXHR.responseText).message, "error")
				success: (data, textStatus, jqXHR) ->
					setAlert($.parseJSON(jqXHR.responseText).message, $.parseJSON(jqXHR.responseText).type)
			
		$(".close").click (e) ->
			e.preventDefault()
			$(".alert").hide()
	
		$(".alert").hide()

		setAlert = (text, type) ->
			alert = $("<div class='alert'></div>")
			close = $("<button type='button' class='close' data-dismiss='alert'>×</button>")
	
			alert.attr("class", "alert alert-" + type).html(text).append(close)
	
			$("#contact-form").find(".alert").remove()
			$("#contact-form").prepend(alert)