#$(document).ready(function(){
#	var pathname = window.location.pathname.split('/');
#	var controller = pathname[pathname.length - 2]; //Parses the controller from the url
#	var action = pathname[pathname.length - 1].split('?')[0]; //Parses the action from the url
#	if (window.urlFilter[controller] != null)
#		window.urlFilter[controller]();//[action]();
#});

$(document).ready ->
	pathname = window.location.pathname.split('/')
	
	controller = pathname[1] 				#Parses the controller from the url
		
	if window.urlFilter[controller] && controller != ""
		window.urlFilter[controller]()								#Executes function created in the child page