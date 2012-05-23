# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	###
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
	$('#selectLang').click ->
		if langbox.selected
			langbox.hide()
		else if !langbox.selected && aspectbox.selected
			aspectbox.hide()
			delay 300, -> langbox.show()	
		else
			langbox.show()

	$('#main_view').click ->
		if langbox.selected
			langbox.hide()
		if aspectbox.selected
			aspectbox.hide()	


	#console.log($('#line').height())
	unselectedAspects = []

	getCheckbox = (checkbox) ->
		$(checkbox).change ->
			if checkbox.checked == true
				unselectedAspects.splice(jQuery.inArray(checkbox.id, unselectedAspects),1);
				#window.bubbleOverview.update(unselectedAspects)
				#window.bubbleDetail.update(unselectedAspects)
				window.parallelgraph.update(unselectedAspects)
			if checkbox.checked == false
				unselectedAspects.push(checkbox.id)
				#window.bubbleOverview.update(unselectedAspects)
				#window.bubbleDetail.update(unselectedAspects)
				window.parallelgraph.update(unselectedAspects)
				
	getCheckbox checkbox for checkbox in aspectbox.getCheckboxes()

	###







