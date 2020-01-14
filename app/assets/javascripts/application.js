// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip().on('shown.bs.tooltip', function(e) {
        /**
         * If the item that triggered the event has class 'large-tooltip'
         * then also add it to the currently open tooltip
         */
        if ($(this).hasClass('large-tooltip')) {
            $('body').find('.tooltip[role="tooltip"].show').addClass('large-tooltip');
        }
    })
});