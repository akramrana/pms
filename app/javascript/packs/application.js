// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('jquery')
require('moment')
require("custom/sparklines/sparkline")
require("custom/jquery-ui/jquery-ui")
require("custom/bootstrap/js/bootstrap.bundle")
require("custom/chart.js/Chart.min")
require("custom/jqvmap/jquery.vmap")
require("custom/jqvmap/maps/jquery.vmap.usa")
require("custom/jquery-knob/jquery.knob.min")
require("custom/daterangepicker/daterangepicker")
require("custom/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min")
require("custom/summernote/summernote-bs4.min")
require("custom/overlayScrollbars/js/jquery.overlayScrollbars.min")
require("custom/adminlte/js/adminlte")
require("custom/adminlte/js/pages/dashboard")
require("custom/adminlte/js/demo")
require("custom/bootstrap-datepicker/bootstrap-datepicker.min")
require("packs/app/site")

import site from './app/site'
import jquery from 'jquery';

window.$ = window.jquery = jquery;
window.site = site

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
jQuery(document).ready(function ($) {
    // here the $ function is jQuery's because it's an argument
    // to the ready handler
    $('.datepicker').datepicker({
        format: "yyyy-mm-dd",
        autoclose: true
    });
});