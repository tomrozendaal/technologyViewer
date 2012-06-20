// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require js-routes
$(function () {	
	$("table#example").tablesorter({ 
		sortList: [[6,1]],
		/*headers: { 0: 
			{
                sorter: false 
            }
        }*/
    });

  //console.log($('.help'));
  /*
  if($('.help').length >= 1){
  	var tooltip = new CustomTooltip("tooltip", 240);
  	$('.help').hover(function(){
  		content = "<h1>Test</h1>";
  		tooltip.showTooltip(content,$('.help'));
  	});
  }*/
 	$('.help').tipsy({
 		title: function() { return this.getAttribute('content'); }, 
 		gravity: 'e',
 		html: true 
 	});



	/*
	$('#myTab a').click(function (e) {
		e.preventDefault();
		$(this).tab('show');
	});

	var urlpath = window.location.pathname.split('/');
	if(urlpath[2]){
		$('#myTab a:last').tab('show');
	}
	*/
});