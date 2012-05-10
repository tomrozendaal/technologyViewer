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
	$('#selectLang').click ->
		if langbox.selected
			langbox.hide()
		else if !langbox.selected && aspectbox.selected
			aspectbox.hide()
			delay 300, -> langbox.show()	
		else
			langbox.show()


	chart = null
	chart2 = null


	#if Routes.programmingLanguages_path() == window.location.pathname
		#alert "test"
	
	# Overview
	render_overview = (csv) ->
		chart = new BubbleChart csv, $(window).width(), $('#container').height(), "#vis"
		chart.start()
		chart.display_group_all()
	d3.csv "data/total_data.csv", render_overview

	
	# Programming languages
	render_proglang = (csv) ->
		width = $(window).width() / 100 * $('.span3').width()

		chart2 = new BubbleChart csv, width, width / 2, ".sidebar-nav"
		chart2.start()
		chart2.display_group_all()

	#alert d3.csv "data/gates_money.csv"
	d3.csv "data/webframeworks_data.csv", render_proglang
	

class BubbleChart
	constructor: (data, width, height, element) ->
		@data = data
		@element = element
		@width = width
		@height = height - @width / 22

		@tooltip = CustomTooltip("tooltip", 240)

		# locations the nodes will move towards
		# depending on which view is currently being
		# used
		@center = {x: @width / 2, y: @height / 2}


		# used when setting up force and
		# moving around nodes
		@layout_gravity = -0.01
		@damper = 0.1

		# these will be set in create_nodes and create_vis
		@vis = null
		@nodes = []
		@force = null
		@circles = null

		# nice looking colors - no reason to buck the trend
		@fill_color = d3.scale.ordinal()
			.domain(["low", "medium", "high"])
			.range(["#B0281A", "#2F5BB7", "#2D6200"])

		# use the max total_amount in the data as the max in the scale's domain
		max_amount = d3.max(@data, (d) -> parseInt(d.total_amount))
		@radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2, @width / 18])

		this.create_nodes()
		this.create_vis()

	# create node objects from original data
	# that will serve as the data behind each
	# bubble in the vis, then add each node
	# to @nodes to be used later
	create_nodes: () =>
		@data.forEach (d) =>
			node = {
				id: d.id
				radius: @radius_scale(parseInt(d.total_amount))
				value: d.total_amount
				name: d.grant_title
				org: d.organization
				group: d.group
				year: d.start_year
				x: Math.random() * 900
				y: Math.random() * 800
			}
			@nodes.push node

		@nodes.sort (a,b) -> b.value - a.value


	# create svg at #vis and then 
	# create circle representation for each node
	create_vis: () =>
		@vis = d3.select(@element).append("svg")
			.attr("width", @width)
			.attr("height", @height)
			.attr("id", "svg_vis")

		@circles = @vis.selectAll("circle")
			.data(@nodes, (d) -> d.id)

		# used because we need 'this' in the 
		# mouse callbacks
		that = this

		# radius will be set to 0 initially.
		# see transition below
		@circles.enter().append("circle")
			.attr("r", 0)
			.attr("fill", (d) => @fill_color(d.year))
			.attr("stroke-width", 2)
			.attr("stroke", (d) => d3.rgb(@fill_color(d.year)).darker())
			.attr("id", (d) -> "bubble_#{d.id}")
			.on("mouseover", (d,i) -> that.show_details(d,i,this))
			.on("mouseout", (d,i) -> that.hide_details(d,i,this))

		# Fancy transition to make bubbles appear, ending with the
		# correct radius
		@circles.transition().duration(2000).attr("r", (d) -> d.radius)


	# Charge function that is called for each node.
	# Charge is proportional to the diameter of the
	# circle (which is stored in the radius attribute
	# of the circle's associated data.
	# This is done to allow for accurate collision 
	# detection with nodes of different sizes.
	# Charge is negative because we want nodes to 
	# repel.
	# Dividing by 8 scales down the charge to be
	# appropriate for the visualization dimensions.
	charge: (d) ->
		-Math.pow(d.radius, 2.0) / 8

	# Starts up the force layout with
	# the default values
	start: () =>
		@force = d3.layout.force()
			.nodes(@nodes)
			.size([@width, @height])

	# Sets up force layout to display
	# all nodes in one circle.
	display_group_all: () =>
		@force.gravity(@layout_gravity)
			.charge(this.charge)
			.friction(0.9)
			.on "tick", (e) =>
				@circles.each(this.move_towards_center(e.alpha))
					.attr("cx", (d) -> d.x)
					.attr("cy", (d) -> d.y)
		@force.start()

		this.hide_years()

	# Moves all circles towards the @center
	# of the visualization
	move_towards_center: (alpha) =>
		(d) =>
			d.x = d.x + (@center.x - d.x) * (@damper + 0.02) * alpha
			d.y = d.y + (@center.y - d.y) * (@damper + 0.02) * alpha


	show_details: (data, i, element) =>
		d3.select(element).attr("stroke", "black")
		content = "<span class=\"name\">Title:</span><span class=\"value\"> #{data.name}</span><br/>"
		content +="<span class=\"name\">Amount:</span><span class=\"value\"> #{data.value}</span><br/>"
		content +="<span class=\"name\">Year:</span><span class=\"value\"> #{data.year}</span>"
		@tooltip.showTooltip(content,d3.event)


	hide_details: (data, i, element) =>
		d3.select(element).attr("stroke", (d) => d3.rgb(@fill_color(d.year)).darker())
		@tooltip.hideTooltip()
		
		

	
	
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
		@element.css 'left', '585px'


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


