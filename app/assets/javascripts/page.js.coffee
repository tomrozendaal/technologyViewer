# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	aspectbox = new Selectbox $('#selectboxAspect'),$('#selectAspect')
	langbox = new Selectbox $('#selectboxLang'),$('#selectLang')

	delay = (ms, func) -> setTimeout func, ms

	$('#selectAspect').click ->
		if aspectbox.selected
			aspectbox.hide()
		else if !aspectbox.selected && langbox.selected
			langbox.hide()
			delay 300, -> aspectbox.show()			
		else
			aspectbox.show()
		#animatebox $(this),$('#selectboxAspect')
	$('#selectLang').click ->
		if langbox.selected
			langbox.hide()
		else if !langbox.selected && aspectbox.selected
			aspectbox.hide()
			delay 300, -> langbox.show()	
		else
			langbox.show()
		#animatebox $(this),$('#selectboxLang')

	
	
class Selectbox
	constructor: (element, button) ->
		@element = element
		@button = button
		@selected = false
		@top = @button.offset().top + 31

	show: () => 
		@selected = true
		@element.addClass "selected"
		@element.css 'visibility', 'visible'
		@element.css 'top', @top + 'px'
		@element.css 'left', '525px'


		options = 
			duration: 300

		@element.animate 
			height: '194px'
			options

	hide: () =>
		@selected = false
		@element.removeClass "selected"
		box = @element
		options = 
			duration: 300
			complete: ->
				box.css 'visibility', 'hidden'
		
		@element.animate 
			height: '0px'
			options



		
		
