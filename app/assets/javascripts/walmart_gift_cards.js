//= require handsontable.full.min

var data = [
	['','','','','']
]

var container = document.getElementById('gift_card_grid');
var hot = new Handsontable(container, {
	data: data,
	minSpareRows: 1,
	colHeaders: [
		'Link',
		'Challenge Code',
		'Gift Card Number (Optional)',
		'PIN (Optional)',
		'Unique Code (Optional)'
	],
	contextMenu: true,
	stretchH: 'all'
});

$('#gift_card_form').submit(function(e) {
	$('#gift_card_json').val(JSON.stringify({data: hot.getData()}));
});