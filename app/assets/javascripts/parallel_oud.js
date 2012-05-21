function ParallelGraph(element, csv){
  var element = element
  var csv = csv
  var parallelwidth = $(window).width() * 0.75
  var height = 350

  var svgwidth = parallelwidth * 0.80
  var margin = {top: 30, right: -30, bottom: 30, left: -30},
  width = svgwidth * 0.75 - margin.right - margin.left,
  height = height - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
  .rangePoints([0, width], 1);

  var y = {};

  var line = d3.svg.line(),
  axis = d3.svg.axis().orient("left"),
  background,
  foreground;

  var svg;

  // Draw graph
  ParallelGraph.prototype.draw = function(unselectedAspects){

    svg = d3.select('#' + element.attr('id') + ' #parallelsvg').append("svg")
      .attr("width", width + margin.right + margin.left - 40)
      .attr("height", height + margin.top + margin.bottom)
      .attr("id", 'parallelsvg')
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.csv(csv, function(technologies) {
      // Extract the list of dimensions and create a scale for each.
      x.domain(dimensions = d3.keys(technologies[0]).filter(function(d) {
        if(d != "date" && d != "technology" && d != "category" && d != "parent" && jQuery.inArray(d, unselectedAspects) < 0 ){ 
          return y[d] = d3.scale.linear()
          .domain(d3.extent(technologies, function(p) { return +p[d]; }))
          .range([height, 0]);          
        }
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

      // Place Legenda
      var colors = ["#B0281A", '#164D71', '#7FA619', '#590C04', '#032439', '#3E5404', '#E9AAA3', '#9ABFD7', '#D3E6A1', '#B06E1A', '#593304', '#E9CAA3', '#861461', '#44032F', '#DD9BC8']
      element.append('<div id="legenda" style="width:' + svgwidth * 0.15 + 'px;"><ul></ul></div>');
      var i = 0;
      svg.selectAll(".foreground").selectAll("path").each(function() { 
        d3.select(this).attr("style", "stroke:" + colors[i] + ";");
        $('#legenda ul').append('<li tech="'+ technologies[i].technology +'"><div class="box" style="background-color:' + colors[i] + ';"></div><span class="box_text">' + technologies[i].technology + '</span></li>');
        i++;
      });

      $('#legenda ul li').each(function(){
        $(this).hover(
          function(){
            highlight(this);
            console.log(this);
          }
        )        
      });
      $('#legenda').hover(
        function(){
        },
        function(){
          highlight();
          brush();
        }
      );

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
  }

  // Redraws the graph with possibly filtered content
  ParallelGraph.prototype.update = function(unselectedAspects){
    $('#' + element.attr('id') + ' #parallelsvg').empty();
    $('#legenda').remove();
    window.parallelgraph.draw(unselectedAspects);
  }
  this.draw([]);

  function highlight(li){
    if(li){
      foreground.style("display", function(d) {
        if(d.technology == $(li).attr('tech')){
          return
        }else{
          return "none";
        }
        console.log(d.technology)
      });
    }else{
      foreground.style("display", function(d) {
        return "block"
      });
    }
  }

  // Returns the path for a given data point.
  function path(d) {
    return line(dimensions.map(function(p) { return [x(p), y[p](d[p])]; }));
  }

  // Handles a brush event, toggling the display of foreground lines.
  function brush() {
    var actives = dimensions.filter(function(p) { return !y[p].brush.empty(); }),
    extents = actives.map(function(p) { return y[p].brush.extent(); });
    foreground.style("display", function(d) {
      if(actives.every(function(p, i){return extents[i][0] <= d[p] && d[p] <= extents[i][1];})){
        $('#legenda ul li').each(function(){
          if(d.technology == $(this).attr('tech')){
            $(this).css({ opacity: 1.0 });
          }
        });
        return null;
      }else{
        $('#legenda ul li').each(function(){
          if(d.technology == $(this).attr('tech')){
            $(this).css({ opacity: 0.2 });
          }
        });
        return 'none';
      }
    });
  }
}







