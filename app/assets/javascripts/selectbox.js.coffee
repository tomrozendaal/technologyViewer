class @Selectbox
	constructor: (element, button) ->
		@element = element
		@button = button
		@selected = false
		@top = @button.offset().top + 30
		@left =  @button.offset().left
		@unselected = []

		@check checkbox for checkbox in @getCheckboxes()

	show: () => 
		@selected = true
		@element.addClass "selected"
		@element.css 'visibility', 'visible'
		@element.css 'top', @top + 'px'
		@element.css 'left', @left + 'px'


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

	getCheckboxes: () =>
    	id = @element.attr('id')
    	return $('#' + id + ' input')

    check: (checkbox) =>
    	checkbox.checked = true






