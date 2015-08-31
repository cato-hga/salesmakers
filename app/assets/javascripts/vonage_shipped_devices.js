//= require handsontable.full.min

var data = [
	['','','','','', '', '', '']
]

var container = document.getElementById('vonage_shipped_devices_grid');
var hot = new Handsontable(container, {
	data: data,
	minSpareRows: 1,
	colHeaders: [
		'Retailer',
		'PO Number',
		'Name',
		'Carrier',
		'Tracking Num',
		'Ship Date',
		'MAC',
		'Device'
	],
	contextMenu: true,
	stretchH: 'all'
});

$('#vonage_shipped_device_form').submit(function(e) {
	$('#vonage_shipped_devices_json').val(JSON.stringify({data: hot.getData()}));
});