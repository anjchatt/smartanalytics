
function set_links(nlinks){
  // style
/*
  link = "<style>
  a.tooltip_own {outline:none; } 
  a.tooltip_own strong {line-height:30px;} 
  a.tooltip_own:hover {text-decoration:none;} 
  a.tooltip_own span { 
    z-index:10;
    display:none;
    padding:14px 20px;
    margin-top:-30px;
    margin-left:28px;
    width:300px;
    line-height:16px;} 
  
  a.tooltip_own:hover span{
    display:inline;
    position:absolute;
    color:#111;
    border:1px solid #DCA;
    background:#fffAF0;} 
  .callout {
    z-index:20;
    position:absolute;
    top:30px;
    border:0;
    left:-12px;} 

  a.tooltip_own span {
    border-radius:4px; 
    box-shadow: 5px 5px 8px #CCC; }
  </style>";
*/

  link = "<style>a.tooltip_own {outline:none; } a.tooltip_own strong {line-height:30px;} a.tooltip_own:hover {text-decoration:none;} a.tooltip_own span {z-index:10; display:none; padding:14px 20px 25px; margin-top:-30px; margin-left:-150px; width:300px; line-height:16px;} a.tooltip_own:hover span{ display:inline; position:absolute; color:#111; border:1px solid #DCA; background:#fffAF0;} .callout { z-index:20; position:absolute; top:30px; border:0; left:-12px;}  a.tooltip_own span { border-radius:4px; box-shadow: 5px 5px 8px #CCC; } </style>";

	// 720 CV
	link = link + '<a href="'+d3.selectAll('.nav').selectAll('a').attr()[0][2]['attributes']['href']['value']+'" ';
	link = link + 'data-toggle="'+d3.selectAll('.nav').selectAll('a').attr()[0][2]['attributes']['data-toggle']['value']+'" ';
	link = link + 'data-value="'+d3.selectAll('.nav').selectAll('a').attr()[0][2]['attributes']['data-value']['value']+'" ';
	link = link + 'class="tooltip_own"><img src="pic/pic01.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d01'] + '</span></a>';
	// Text
	link = link + '<a href="'+d3.selectAll('.nav').selectAll('a').attr()[0][4]['attributes']['href']['value']+'" ';
	link = link + 'data-toggle="'+d3.selectAll('.nav').selectAll('a').attr()[0][4]['attributes']['data-toggle']['value']+'" ';
	link = link + 'data-value="'+d3.selectAll('.nav').selectAll('a').attr()[0][4]['attributes']['data-value']['value']+'" ';
	link = link + 'class="tooltip_own"><img src="pic/pic02.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d02'] + '</span></a>';
	// Exploration
	link = link + '<a href="'+d3.selectAll('.nav').selectAll('a').attr()[0][1]['attributes']['href']['value']+'" ';
	link = link + 'data-toggle="'+d3.selectAll('.nav').selectAll('a').attr()[0][1]['attributes']['data-toggle']['value']+'" ';
	link = link + 'data-value="'+d3.selectAll('.nav').selectAll('a').attr()[0][1]['attributes']['data-value']['value']+'" ';
	link = link + 'class="tooltip_own"><img src="pic/pic03.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d03'] + '</span></a>';
	// Exploration
	link = link + '<a href="'+d3.selectAll('.nav').selectAll('a').attr()[0][3]['attributes']['href']['value']+'" ';
	link = link + 'data-toggle="'+d3.selectAll('.nav').selectAll('a').attr()[0][3]['attributes']['data-toggle']['value']+'" ';
	link = link + 'data-value="'+d3.selectAll('.nav').selectAll('a').attr()[0][3]['attributes']['data-value']['value']+'" ';
	link = link + 'class="tooltip_own"><img src="pic/pic04.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d04'] + '</span></a>';
	
	link = link + '<br>'
	
	// WM
	link = link + '<a href="http://10.170.9.216:8083" class="tooltip_own"><img src="pic/pic05.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d05'] + '</span></a>';
	link = link + '<a href="http://10.170.9.216:8082" class="tooltip_own"><img src="pic/pic06.png" width="25%"><span><img class="callout" src="raw/callout.gif" />';
  link = link + descriptions['d06'] + '</span></a>';
	link = link + '<img src="pic/pic07.png" width="25%">'
	link = link + '<img src="pic/pic08.png" width="25%">'
	
	d3.select("#set_links")
				.append("div")
				.html(link);
}

set_links(5)
