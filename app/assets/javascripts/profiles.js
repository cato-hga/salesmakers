//= require foundation_new/foundation.joyride

$(function() {
    $('body').on('click', '#start_tour_profile', function() {
        $(document).foundation('joyride', 'start');
    });
});