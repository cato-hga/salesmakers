//= require wall.js

$(function() {
	$('form#new_comcast_customer #submit_save_as_lead').click(function() {
		$('form#new_comcast_customer #save_as_lead').val('true');
		$('form#new_comcast_customer').submit();
	});
});