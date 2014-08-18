//= require google_jsapi
//= require chartkick


$(function () {
	$(document).foundation();

	$.get("/widgets/sales/people/692", function (data) { //TODO: Make sales chart show individual person
		$("#saleschart").append(data); resizeWidgets();
	});

	$.get("/widgets/hours/people/692", function (data) { //TODO: Make hours chart show individual person
		$("#hourschart").append(data); resizeWidgets();
	});

	$.get("/widgets/alerts/people/692", function (data) { //TODO: Make alerts show individual person
		$("#alerts_widget").append(data); resizeWidgets();
	});

	$.get("/widgets/tickets/people/692", function (data) { //TODO: Make tickets show individual person
		$("#tickets_widget").append(data); resizeWidgets();
	});

	$.get("/widgets/gift_cards/people/692", function (data) { //TODO: Make gift cards show individual person
		$("#gift_cards_widget").append(data); resizeWidgets();
	});

	$.get("/widgets/inventory/people/692", function (data) { //TODO: Make inventory show individual person
		$("#inventory_widget").append(data); resizeWidgets();
	});

	$.get("/widgets/pnl/people/692", function (data) { //TODO: Make pnl show individual person
		$("#pnlchart").append(data); resizeWidgets();
	});

	$.get("/widgets/hps/people/692", function (data) { //TODO: Make hps show individual person
		$("#hpschart").append(data); resizeWidgets();
	});

	$.get("/widgets/assets/people/3", function (data) { //TODO: Make assets show individual person
		$("#assets_widget").append(data); resizeWidgets();

	});

	resizeWidgets();
});