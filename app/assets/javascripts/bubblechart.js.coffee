class @BubbleChart
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
		@colors = []
		@colors["wf"] = "#B0281A"
		@colors["pl"] = "#2F5BB7"
		@colors["cms"] = "#2D6200"

		
		# use the max total_amount in the data as the max in the scale's domain
		max_amount = d3.max(@data, (d) -> parseInt(d.total))
		@radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2, @width / 9])

		this.create_nodes([])
		this.create_vis()
		this.highlight_bubble()

	# create node objects from original data
	# that will serve as the data behind each
	# bubble in the vis, then add each node
	# to @nodes to be used later
	create_nodes: (unselectedAspects) =>
		@data.forEach (d) =>
			radius = d.total
			total_rating = d.total
			unselectedAspects.forEach (aspect) =>
				if aspect == 'adoption'
					radius = radius - d.adoption
					total_rating = total_rating - d.adoption
				if aspect == 'knowledge'
					radius = radius - d.knowledge
					total_rating = total_rating - d.knowledge
				if aspect == 'sentiment'
					radius = radius - d.sentiment
					total_rating = total_rating - d.sentiment

			total_radius = @return_value(radius)
						
			if d.category == "wf"
				category = "Web Framework"
			else if d.category == "cms"
				category = "Content Management System"
			else if d.category == "pl"
				category = "Programming Language"

			node = {
				id: d.id
				radius: @radius_scale(parseInt(total_radius))
				rating: total_rating
				name: d.technology
				category: d.category
				category_long: category
				x: Math.random() * 900
				y: Math.random() * 800
				selected: false
			}

			@nodes.push node
		@nodes.sort (a,b) -> b.rating - a.rating


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
			.attr("fill", (d) => @colors[d.category])
			.attr("stroke-width", 2)
			.attr("stroke", (d) => d3.rgb(@colors[d.category]).darker())
			.attr("id", (d) -> "bubble_#{d.name}")
			.on("mouseover", (d,i) -> that.show_details(d,i,this))
			.on("mouseout", (d,i) -> that.hide_details(d,i,this))
			.on("click", (d,i) -> that.show_detail_tech(d,i,this))

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


	# Moves all circles towards the @center
	# of the visualization
	move_towards_center: (alpha) =>
		(d) =>
			d.x = d.x + (@center.x - d.x) * (@damper + 0.02) * alpha
			d.y = d.y + (@center.y - d.y) * (@damper + 0.02) * alpha

	reset_selected: () =>
		(d) =>
			d.selected = false

	update: (unselectedAspects) =>
		@vis = null
		@nodes = []
		@force = null
		@circles = null

		this.create_nodes(unselectedAspects)
		$(@element).empty()
		this.create_vis()
		this.start()
		this.display_group_all()
		this.highlight_bubble()


	return_value: (value) =>
		if value < 0
			return 2
		else
			return value

	show_detail_tech: (data,i,element) =>
		fullcategory
		switch data.category
			when "cms" then fullcategory = "content-management-systems"
			when "pl" then fullcategory = "programming-languages"
			when "wf" then fullcategory = "web-frameworks"

		technology = data.name
		window.location = "/#{fullcategory}/technology/#{technology}";

	highlight_bubble: () =>
		urlpath = window.location.pathname.split('/');
		@circles.each((d) ->			
			if d.name == urlpath[2]
				@colors = []
				@colors["wf"] = "#B0281A"
				@colors["pl"] = "#2F5BB7"
				@colors["cms"] = "#2D6200"
				console.log(@colors)
				d3.select(this).attr("fill", => d3.rgb(@colors[d.category]).darker())
		)


	show_details: (data, i, element) =>
		d3.select(element).attr("stroke", "black")
		content = "<span class=\"name\">Title:</span><span class=\"value\"> #{data.name}</span><br/>"
		content +="<span class=\"name\">Rating:</span><span class=\"value\"> #{data.rating}</span><br/>"
		content +="<span class=\"name\">Category:</span><span class=\"value\"> #{data.category_long}</span>"
		@tooltip.showTooltip(content,d3.event)



	hide_details: (data, i, element) =>
		d3.select(element).attr("stroke", (d) => d3.rgb(@colors[d.category]).darker())
		@tooltip.hideTooltip()
		
		
