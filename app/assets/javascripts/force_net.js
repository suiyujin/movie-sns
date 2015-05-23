$( function(){
  var movies_map = {
    size: 0
  };
  var relations_map = {
    size: 0
  };

  $('form#search_movies').bind("ajax:success", function(evt, data, status, xhr){
    $res_json = data;
    
    if( true ){
      var temp_data = {
        "result": true,
        "data": {
          movies: [
            {
              "id":     1,
              "title":        "【ラブライブ！】Printemps「Pure girls project」試聴動画",
              "description":  "『ラブライブ！』ユニットシングル 2nd session Pure girls project Printemps〜高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) ",
              "url":          "https://www.youtube.com/watch?v=gBVCa8rZmGg",
              "thumbnail_url":"https://i.ytimg.com/vi/gBVCa8rZmGg/mqdefault.jpg"
            },
            {
              "id":     2,
              "title":        "【ラブライブ！】Printemps「Pure girls project」試聴動画",
              "description":  "『ラブライブ！』ユニットシングル 2nd session Pure girls project Printemps〜高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) ",
              "url":          "https://www.youtube.com/watch?v=gBVCa8rZmGg",
              "thumbnail_url":"https://i.ytimg.com/vi/gBVCa8rZmGg/mqdefault.jpg"
            },
            {
              "id":     3,
              "title":        "【ラブライブ！】Printemps「Pure girls project」試聴動画",
              "description":  "『ラブライブ！』ユニットシングル 2nd session Pure girls project Printemps〜高坂穂乃果(新田恵海)、南ことり(内田 彩)、小泉花陽(久保ユリカ) ",
              "url":          "https://www.youtube.com/watch?v=gBVCa8rZmGg",
              "thumbnail_url":"https://i.ytimg.com/vi/gBVCa8rZmGg/mqdefault.jpg"
            }
          ],
          relations:[
            {
              "movie1_id":    1,
              "movie2_id":    2
            },
            {
              "movie1_id":    2,
              "movie2_id":    3
            },
            {
              "movie1_id":    3,
              "movie2_id":    1
            }
          ]
        }
      };

      temp_data.data.movies.forEach( function( movie, index ){
        movies_map[ movie.id ] = movies_map.size;
        movies_map.size ++;
      });

      var relations = [];

      temp_data.data.relations.forEach( function( relation, index ){
        relations_map[ relation.id ] = relations_map.size;
        relations_map.size ++;

        relations.push( {
          "source": movies_map[ relation.movie1_id ],
          "target": movies_map[ relation.movie2_id ]
        } );
      });

      temp_data.data.relations = relations;

      show_force( temp_data.data );
    }

    $( this ).remove();
  })

  function show_force( data ){
    var width = 500,
    height = 500,
    color = d3.scale.category20();

    var selected_node = null;
    var selected_link = null;
    var mousedown_link = null;
    var mousedown_node = null;
    var mouseup_node = null;

    var outer = d3.select( "#force_net_area" )
        .append( "svg:svg" )
        .attr( "width", width )
        .attr( "height", height )
        .attr( "pointer-events", "all" );

    var vis = outer
      .append( 'svg:g' )
        .call( d3.behavior.zoom().on( "zoom", rescale ) )
        .on( "dblclick.zoom", null )
      .append( 'svg:g' )
        .on( "mousemove", mousemove )
        .on( "mousedown", mousedown )
        .on( "mouseup", mouseup );

    vis.append( 'svg:rect' )
        .attr( 'width', width )
        .attr( 'height', height )
        .attr( 'fill', 'white' );

    var force = d3.layout.force()
        .size( [ width, height ] )
        .nodes( data.movies )
        .links( data.relations )
        .linkDistance( 50 )
        .charge( -200 )
        .on( "tick", tick );

    var drag_line = vis.append( "line" )
        .attr( "class", "drag_line" )
        .attr( "x1", 0 )
        .attr( "y1", 0 )
        .attr( "x2", 0 )
        .attr( "y2", 0 );

    var nodes = force.nodes(),
        links = force.links(),
        node = vis.selectAll( ".node" ),
        link = vis.selectAll( ".link" );

    d3.select(window)
        .on("keydown", keydown);

    redraw();

    function mousedown() {
      if ( !mousedown_node && !mousedown_link ) {
        // allow panning if nothing is selected
        vis.call( d3.behavior.zoom().on( "zoom" ), rescale );
        return;
      }
    }

    function mousemove() {
      if ( !mousedown_node ) return;

      drag_line
          .attr( "x1", mousedown_node.x )
          .attr( "y1", mousedown_node.y )
          .attr( "x2", d3.svg.mouse( this )[ 0 ] )
          .attr( "y2", d3.svg.mouse( this )[ 1 ] );
    }

    function mouseup() {
      if ( mousedown_node ) {
        drag_line
          .attr( "class", "drag_line_hidden" );

        if ( !mouseup_node ) {

          var point = d3.mouse(this),
            node1 = {x: point[0], y: point[1]},
            n = nodes.push(node1);
            node2 = {x: point[0], y: point[1]+1},
            n = nodes.push(node2);

          selected_node = node;
          selected_link = null;
          
          links.push({source: mousedown_node, target: node1});
          links.push({source: mousedown_node, target: node2});
        }

        redraw();
      }

      resetMouseVars();
    }

    function resetMouseVars() {
      mousedown_node = null;
      mouseup_node = null;
      mousedown_link = null;
    }

    function tick() {
      link.attr( "x1", function(d) { return d.source.x; } )
          .attr( "y1", function(d) { return d.source.y; } )
          .attr( "x2", function(d) { return d.target.x; } )
          .attr( "y2", function(d) { return d.target.y; } );

      node.attr( "cx", function(d) { return d.x; } )
          .attr( "cy", function(d) { return d.y; } );
    }

    function rescale() {
      trans=d3.event.translate;
      scale=d3.event.scale;

      // todo: scaleに上限下限を設定する

      vis.attr( "transform",
          "translate(" + trans + ")"
          + " scale(" + scale + ")" );
    }

    function redraw() {

      link = link.data( links );

      link.enter().insert( "line", ".node" )
          .attr( "class", "link" )
          .on( "mousedown", function(d){ 
              mousedown_link = d; 
              if (mousedown_link == selected_link) selected_link = null;
              else selected_link = mousedown_link; 
              selected_node = null; 
              redraw(); 
            } )
          .on( "mouseover", function(d){
            // todo: いいね、悪いねとかを表示する
          } );

      link.exit().remove();

      link
        .classed( "link_selected", function(d) { return d === selected_link; } );

      node = node.data( nodes );

      node.enter().insert( "circle" )
          .attr( "class", "node" )
          .attr( "r", 5 )
          .on( "mousedown", function(d) {
              vis.call( d3.behavior.zoom().on("zoom"), null );

              mousedown_node = d;
              if ( mousedown_node == selected_node ) selected_node = null;
              else selected_node = mousedown_node; 
              selected_link = null;

              drag_line
                  .attr( "class", "link" )
                  .attr( "x1", mousedown_node.x )
                  .attr( "y1", mousedown_node.y )
                  .attr( "x2", mousedown_node.x )
                  .attr( "y2", mousedown_node.y );

              redraw(); 
            })
          .on( "mousedrag", function(d) {
              // redraw();
            })
          .on( "mouseup", function(d) { 
              if ( mousedown_node ) {
                mouseup_node = d; 
                if ( mouseup_node == mousedown_node ) { resetMouseVars(); return; }

                // add link
                var link = { source: mousedown_node, target: mouseup_node };
                links.push( link );

                // select new link
                selected_link = link;
                selected_node = null;

                // enable zoom
                vis.call( d3.behavior.zoom().on( "zoom" ), rescale );
                redraw();
              } 
            })
        .transition()
          .duration( 750 )
          .ease( "elastic" )
          .attr( "r", 6.5 );

      node.exit().transition()
          .attr( "r", 0 )
        .remove();

      node
        .classed( "node_selected", function(d) { return d === selected_node; });

      

      if (d3.event) {
        // prevent browser's default behavior
        d3.event.preventDefault();
      }

      force.start();
    }

    function spliceLinksForNode( node ) {
      toSplice = links.filter( function(l) { 
        return ( l.source === node ) || ( l.target === node );
      });

      toSplice.map( function(l) {
        links.splice( links.indexOf( l ), 1 );
      });
    }

    function keydown() {
      if ( !selected_node && !selected_link ) return;

      switch ( d3.event.keyCode ){
        case 8: // backspace
        case 46: { // delete
          if ( selected_node) {
            nodes.splice( nodes.indexOf( selected_node ), 1 );
            spliceLinksForNode( selected_node );
          }
          else if ( selected_link ) {
            links.splice( links.indexOf( selected_link ), 1 );
          }
          selected_link = null;
          selected_node = null;
          redraw();
          break;
        }
      }
    }
  }
} );