$( function(){
  var movies_map = {
    size: 0
  };
  var relations_map = {
    size: 0
  };

  $( "#detail_area" ).hide();
  $( "#detail_area>button" )
    .click( function(){
      $( "#detail_area" ).hide( 500 );
    } );

  $( 'form#search_movies' ).bind( "ajax:success", function( evt, data, status, xhr ){
    if( data.result ){
      $( "#force_net_area>svg" ).remove();

      movies_map = {
        size: 0
      };
      relations_map = {
        size: 0
      };

      data.data.movies.forEach( function( movie, index ){
        movies_map[ movie.id ] = movies_map.size;
        movies_map.size ++;
      });

      var relations = [];

      data.data.relations.forEach( function( relation, index ){
        relations_map[ relation.id ] = relations_map.size;
        relations_map.size ++;

        relations.push( {
          "source": movies_map[ relation.movie1_id ],
          "target": movies_map[ relation.movie2_id ],
          "comments": relation.comments
        } );
      });

      data.data.relations = relations;

      show_force( data.data );
    }
  })

  function show_force( graph ){
    var width = 1000;
    var height = 600;
    var color = d3.scale.category20();
    var pic_width = 120;
    var pic_height = 60;

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
        .nodes( graph.movies )
        .links( graph.relations )
        .linkDistance( 200 )
        .charge( -800 )
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
          var result = prompt( "登録したい動画のURLを入力してください", "http://" );
          var node = mousedown_node;

          if( result ){

            $.ajax({
              type: "POST",
              url: "/movies",
              data: {
                movie:{
                  "url":        result,
                  "source_id":  mousedown_node.id
                }
              },
              success: function( json ){
                console.log( json.data.movies[0] );
                /*

                if (!mouseup_node) {
                  // add node
                  var point = d3.mouse(this),
                    node = {x: point[0], y: point[1]},
                    n = nodes.push(node);

                  // select new node
                  selected_node = node;
                  selected_link = null;
                  
                  // add link to mousedown node
                  links.push({source: mousedown_node, target: node});
                }
                */

                nodes.push( json.data.movies[0] );

                movies_map[ json.data.movies[0].id ] = movies_map.size;
                movies_map.size ++;


                redraw();
              }
            });

          }else{
            console.log(" CANCEL が押された");
          }
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

      node.attr( "x", function(d) { return d.x-pic_width/2; } )
          .attr( "y", function(d) { return d.y-pic_height/2; } );
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
          .style( "stroke-width", function(d){
            if( d.comments.length > 0 )
              return 20;
            return 5;
          } )
          .on( "mousedown", function(d){ 
              mousedown_link = d; 
              if (mousedown_link == selected_link) selected_link = null;
              else selected_link = mousedown_link; 
              selected_node = null; 
              redraw(); 
            } )
          .on( "mouseover", function(d){
            // todo: いいね、悪いねとかを表示する
          } )
          .on( "click", function(d){
            var detail_dom = d3.select( "#detail_area" )
              .style( "top", ( d.source.y + d.target.y )/2  + "px" )
              .style( "left", ( d.source.x + d.target.x )/2 + "px" );

            detail_dom.selectAll( "div" ).remove();

            d.comments.forEach( function( comment ){
              detail_dom.append( "div" )
                .text( comment.comment );
            } );

            $( "#detail_area" ).show( 500 );
          } );

      link.exit().remove();

      link
        .classed( "link_selected", function(d) { return d === selected_link; } );

      node = node.data( nodes );

      node.enter().insert( "image" )
          .attr( "xlink:href", function(d){
            return d.thumbnail_url;
          } )
          .attr( "class", "node" )
          .attr( "width", pic_width )
          .attr( "height", pic_height )
          .on( "click", function(d){
            var detail_dom = d3.select( "#detail_area" )
              .style( "top", d.y + "px" )
              .style( "left", d.x + "px" );

            detail_dom.selectAll( "a,div" ).remove();
            detail_dom.append( "a" )
              .text( d.title )
              .attr( "href", d.url );

            detail_dom.append( "div" )
              .text( d.description );

            $( "#detail_area" ).show( 500 );
          } )
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