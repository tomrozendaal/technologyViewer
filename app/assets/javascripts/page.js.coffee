# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('#selectAspect').click ->
		animatebox $(this)
	$('#selectLang').click ->
		animatebox $(this)


	
		

animatebox = (element) -> 
	selectbox = $('#selectbox')
	top = element.offset().top + 31

	if selectbox.hasClass 'selected'
		options = 
			duration: 300
			complete: ->
				selectbox.css 'visibility', 'hidden'

		selectbox.removeClass "selected"
		selectbox.animate 
			height: '0px'
			options

		#selectbox.css('visibility', 'hidden');

	else
		selectbox.addClass "selected"
		selectbox.css 'visibility', 'visible'
		selectbox.css 'top', top + 'px'
		selectbox.css 'left', '525px'
		
		options = 
			duration: 300

		selectbox.animate 
			height: '300px'
			options
		
		
