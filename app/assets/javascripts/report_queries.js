//= require "application"
//= require wall
//= require picker
//= require picker.date

$(function() {
	$('.date_picker').pickadate({
		format: 'mm/dd/yyyy'
	});
});