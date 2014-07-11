//= require google_jsapi
//= require chartkick


$(function () {
	$(document).foundation();

	$.get("/widgets/sales/people/692", function (data) { //TODO: Make sales chart show individual person
		$("#saleschart").append(data);
	});

	$.get("/widgets/hours/people/692", function (data) { //TODO: Make hours chart show individual person
		$("#hourschart").append(data);
	});
});