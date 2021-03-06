/*function ParallelGraph(element, csv){
  var element = element
  var csv = csv
  var parent_width = $(window).width() * 0.75
  var height = 350

  var margin = {top: 30, right: 10, bottom: 30, left: 10},
      width = parent_width * 0.75 - margin.right - margin.left,
      height = height - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
      .rangePoints([0, width], 1);

  var y = {};

  var line = d3.svg.line(),
      axis = d3.svg.axis().orient("left"),
      background,
      foreground;

  var svg = d3.select('#' + element.attr('id')).append("svg")
      .attr("width", width + margin.right + margin.left)
      .attr("height", height + margin.top + margin.bottom)
      .attr("id", 'parallelsvg')
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var i = 0;
  d3.csv(csv, function(technologies) {

    // Extract the list of dimensions and create a scale for each.
    x.domain(dimensions = d3.keys(technologies[0]).filter(function(d) {
      return d != "date" && d != "technology" && d != "category" && d != "parent" && (y[d] = d3.scale.linear()
          .domain(d3.extent(technologies, function(p) { return +p[d]; }))
          .range([height, 0]));
    }));


    // Add grey background lines for context.
    background = svg.append("g")
        .attr("class", "background")
      .selectAll("path")
        .data(technologies)
      .enter().append("path")
        .attr("d", path);

    // Add blue foreground lines for focus.
    foreground = svg.append("g")
        .attr("class", "foreground")
        .attr("id", "foreground")
      .selectAll("path")
        .data(technologies)
      .enter().append("path")
        .attr("d", path)
        .attr('id', 'parallelline')
        //.attr("style", "stroke:steelblue;");

    // Add a group element for each dimension.
    var g = svg.selectAll(".dimension")
        .data(dimensions)
      .enter().append("g")
        .attr("class", "dimension")
        .attr("transform", function(d) { return "translate(" + x(d) + ")"; });

    // Add an axis and title.
    g.append("g")
        .attr("class", "axis")
        .each(function(d) { d3.select(this).call(axis.scale(y[d])); })
      .append("text")
        .attr("text-anchor", "middle")
        .attr("y", 310)
        .text(String);

    // Add and store a brush for each axis.
    g.append("g")
        .attr("class", "brush")
        .each(function(d) { d3.select(this).call(y[d].brush = d3.svg.brush().y(y[d]).on("brush", brush)); })
      .selectAll("rect")
        .attr("x", -8)
        .attr("width", 16);
  });

  // Returns the path for a given data point.
  function path(d) {
    return line(dimensions.map(function(p) { return [x(p), y[p](d[p])]; }));
  }

  // Handles a brush event, toggling the display of foreground lines.
  function brush() {
    var actives = dimensions.filter(function(p) { return !y[p].brush.empty(); }),
        extents = actives.map(function(p) { return y[p].brush.extent(); });
    foreground.style("display", function(d) {
      return actives.every(function(p, i) {
        return extents[i][0] <= d[p] && d[p] <= extents[i][1];
      }) ? null : "none";
    });
  }
}
*/
