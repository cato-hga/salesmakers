//= require masonry.min
//= require underscore.min
//= require 'handsontable.full.min'

var data = [
	['', '', '']
]

var container = document.getElementById('head_count_grid');
var hot = new Handsontable(container, {
	data: data,
	minSpareRows: 1,
	colHeaders: [
		'Store Number',
		'Store Openings',
		'Store Priority'
	],
	contextMenu: true,
	stretchH: 'all'
});

$('#head_count_form').submit(function (e) {
	$('#head_count_json').val(JSON.stringify({data: hot.getData()}));
});
