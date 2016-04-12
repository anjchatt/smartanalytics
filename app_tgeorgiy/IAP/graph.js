<style>
	.background {
		fill: none;
		pointer-events: all;
	}

	#states {
		fill: #aaa;
	}

	#states .notactive {
		fill: #aaa;
	}

	#states .active {
#		fill: orange;
#		fill: #aaa;
		stroke: #333;
		stroke-width: 1px;
		stroke-linejoin: round;
		stroke-linecap: round;
	}

	#states .hidestate {
		fill: white;
		visibility: hidden;
	}

	#state-borders {
		fill: none;
		stroke: #333;
		stroke-width: 0.25px;
		stroke-linejoin: round;
		stroke-linecap: round;
		pointer-events: none;
	}
</style>

<script src="/js/d3.v3.min.js"></script>
<script src="/js/topojson.v1.min.js"></script>
<script src="/js/dimple.v2.1.2.min.js"></script>

<script type="text/javascript">
	var networkOutputBinding = new Shiny.OutputBinding();
  $.extend(networkOutputBinding, {
    find: function(scope) {
      return $(scope).find('.draw-map');
    },
    renderValue: function(el, data) {
			$(el).html("");
			
/* 			var width = 960/2,
			height = 500/2, */
			w = d3.select(el)
						.node()
						.getBoundingClientRect()
						.width
			var width = 250,
			height = 500,
			centered;

			var projection = d3.geo.albersUsa()
					.scale(1300/2)
					.translate([width / 2, height / 2]);

			var path = d3.geo.path()
					.projection(projection);

			var svg = d3.select(el).append("svg")
					.attr("width", "100%")
					.attr("height", height);

			svg.append("rect")
					.attr("class", "background")
					.attr("width", width)
					.attr("height", height)
					.on("click", clicked);

			var g = svg.append("g");

			d3.json("/raw/us.json", function(us) {
				g.append("g")
						.attr("id", "states")
					.selectAll("path")
						.data(topojson.feature(us, us.objects.states).features)
					.enter().append("path")
						.attr("d", path)
						.on("click", clicked);

				g.append("path")
						.datum(topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; }))
						.attr("id", "state-borders")
						.attr("d", path);

//				state_ids = [undefined × 9, true, true, undefined × 1, true, true, undefined × 10, true, true, undefined × 7, false, true,
				
				state_ids = [];
				state_ids[9] = true;
				state_ids[10] = true;
				state_ids[12] = true;
				state_ids[13] = true;
				state_ids[24] = true;
				state_ids[25] = true;
				state_ids[34] = true;
				state_ids[36] = true;
				state_ids[37] = true;
				state_ids[42] = true;
				state_ids[45] = true;
				state_ids[51] = true;

				g.selectAll("path")
						.classed('hidestate', function(p){
							return !state_ids[p.id];
						})
				
				x = width;
				y = height*0.54;
				k = 1.7;
 				g.transition()
						.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
						.style("stroke-width", 1.5 / k + "px");
			});

			var clicked = (function(d) {
				var sel = [],
						sx = width,
						sy = height*0.54,
						n = 1;
				return function(d){
					var centroid = path.centroid(d);
					if(typeof(sel[d.id]) == "undefined"){
						sel[d.id] = true
						d3.select(this)
							.classed('active', true);
						sx = sx+centroid[0];
						sy = sy+centroid[1];
						n = n+1;
					}else if(sel[d.id]){
						sel[d.id] = false
						d3.select(this)
							.classed('active', false);
						sx = sx-centroid[0];
						sy = sy-centroid[1];
						n = n-1;
					}else{
						sel[d.id] = true
						d3.select(this)
							.classed('active', true);
						sx = sx+centroid[0];
						sy = sy+centroid[1];
						n = n+1;
					}
					
					sel2 = []
					for (i=0; i<sel.length; i++){
						if(sel[i]){
							sel2[sel2.length] = i;
						}
					}
										
					Shiny.onInputChange("selstates", sel2);
					
					x = sx/n;
					y = sy/n;
					
					if (n>1){
						k = 2.3;
					}else{
						k = 1.7;
					}
					
					g.transition()
						.duration(1500)
						.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
						.style("stroke-width", 1.5 / k + "px");
				}
				/*
				if (d && centered !== d) {
					var centroid = path.centroid(d);
					x = centroid[0];
					y = centroid[1];
					k = 1;
					centered = d;
/*				} else {
					x = width / 2;
					y = height / 2;
					k = 1;
					centered = null;
				}
*//*
				g.selectAll("path")
						.classed("active", centered && function(d) {
							return d == centered; });
//						.classed("active");
/**/
/*
				g.transition()
						.duration(750)
						.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
						.style("stroke-width", 1.5 / k + "px");
/**/		})();
/**/
		}
  });
Shiny.outputBindings.register(networkOutputBinding, 'timelyportfolio.networkbinding');

</script>
