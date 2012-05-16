###class @ParallelGraph
	constructor: (element, csv) ->
		@element = element
		@csv = csv
		@parent_width = $(window).width() * 0.75
		@height = 350

		@margin = {top: 30, right: 10, bottom: 30, left: 10}
		@width = @parent_width * 0.75 - @margin.right - @margin.left
		@height = @height - @margin.top - @margin.bottom

		
		@x = d3.scale.ordinal()
		 	.rangePoints([0, @width], 1)
		@y = {}

		@line = d3.svg.line()
		@axis = d3.svg.axis().orient("left")
		@background
		@foreground

		@svg = d3.select('#' + @element.attr('id')).append("svg")
			.attr("width", @width + @margin.right + @margin.left)
			.attr("height", @height + @margin.top + @margin.bottom)
			.attr("id", 'parallelsvg')
		.append("g")
		  	.attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

		#@draw()


	draw: () =>
		d3.csv(@csv, (technologies) ->
			# Extract the list of dimensions and create a scale for each.			
			@x.domain(dimensions = d3.keys(technologies[0]).filter((d) ->
				if d != "date" && d != "technology" && d != "category" && d != "parent"
					@y[d] = d3.scale.linear()
						.domain(d3.extent(technologies, (p) -> return +p[d]))
						.range([@height, 0])
			))
			console.log(@svg)
			# Add grey background lines for context.
			background = @svg.append("g")
					.attr("class", "background")
				.selectAll("path")
					.data(technologies)
				.enter().append("path")
					.attr("d", path)

			# Add blue foreground lines for focus.
			foreground = svg.append("g")
				.attr("class", "foreground")
				.attr("id", "foreground")
				.selectAll("path")
				.data(technologies)
				.enter().append("path")
				.attr("d", path)
				.attr('id', 'parallelline')

			# Add a group element for each dimension.
			g = svg.selectAll(".dimension")
				.data(dimensions)
				.enter().append("g")
				.attr("class", "dimension")
				.attr("transform", (d) -> return "translate(" + x(d) + ")")

			# Add an axis and title.
			g.append("g")
				.attr("class", "axis")
				.each((d) -> d3.select(this).call(axis.scale(y[d])))
				.append("text")
				.attr("text-anchor", "middle")
				.attr("y", 310)
				.text(String)

			# Add and store a brush for each axis.
			g.append("g")
				.attr("class", "brush")
				.each((d) -> d3.select(this).call(y[d].brush = d3.svg.brush().y(y[d]).on("brush", brush)))
				.selectAll("rect")
				.attr("x", -8)
				.attr("width", 16)
		)
###
