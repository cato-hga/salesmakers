//= require jquery-ui.min

$(function() {
	$('.available_categories .column').draggable({

		cursor: 'move',
		zIndex: 200,
		containment: '.row-full_width',
		connectToSortable: '.chosen_categories',
		revert: 'invalid',
		helper: 'clone'
	});

	$('.chosen_categories').droppable({

		containment: '.chosen_categories'

	});

	$('.chosen_categories').sortable({

		containment: '.sort_container',
		handle: '.column',
		tolerance: 'pointer'

	});
});