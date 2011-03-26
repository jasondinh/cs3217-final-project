
var Line = function(x1, y1, x2, y2){
    console.log(x1,y1,x2,y2);
    var dx = x2-x1;
    var dy = y2-y1;
    var len = Math.sqrt( dx * dx + dy * dy );
    var deg = Math.atan2(dy, dx) / Math.PI * 180;
    console.log('deg',deg);
    var view = $('<div>').attr('class', 'line').css({position:'absolute', top: y1, left: x1, background: 'blue', width: len, height: 5,
          '-webkit-transform':'rotate('+deg+'deg)', '-webkit-transform-origin': '0% 0%'});
    this.view = view;

    view.dblclick( function(){
        console.log("remove line");
        view.remove();
        return false;
    });
} 

var Point = function(px, py, index){

    var view = $('<div>').attr('class', 'point'). css({position:'absolute', top:py-15, left:px-15, background:'gray', width:30, height:30});
    view.data('p-index', index);
    
    view.dblclick( function(evt) {
        console.log("point click");
        return false;
    });

    var copyView;

    var isDragging = false;

    // handle drag & drop using mousedown, mousemove and mouseup
    view.draggable({
        start: function(evt, ui){
            // create copy of point at its initial position
            copyView = $('<div>').css({position:'absolute', 'top':py-15, 'left':px-15, 'background':'red', 'width':30, 'height':30});
            view.parent().append(copyView);
            view.data('pos', view.position());
        },
        stop: function(evt, ui){
            // remove the copy
            copyView.remove();
        },
        drag: function(evt, ui){
            // draw the line connect initial position and current position (or smt like that)
        },
        revert: true,
    });

    view.droppable({
        // handle when two points are connected
        accept:'.point',    // only accept point
        hoverClass: 'drophover',
        drop: function(evt, ui){
            console.log(' dropped ', evt, ui, this);
            console.log(view.data('p-index'), ui.draggable.data('p-index'));
            var p1 = $(this).position();
            console.log(p1.left, p1.top);
            var p2 = ui.draggable.data('pos');
            console.log(p2.left, p2.top);
            var newLine = new Line(p1.left+15, p1.top+15, p2.left+15, p2.top+15);
            $(this).parent().append(newLine.view);
        },
    });

    this.view = view;
}

$(function(){

    var pindex=0;

	$('#map_img').load(function(){
		var top = $('#map_container').offset().top;
		var left = $('#map_container').offset().left;
		var dx = $('#map_img').width() - $('#map_container').width();
		var dy = $('#map_img').height() - $('#map_container').height();
        console.log(top, left, dx, dy);
		$('#map_img_box').draggable({'cursor': 'move', 'containment': [left-dx, top-dy, left, top]});
    });

	$('#map_img_box').dblclick( function(evt){
        console.log('double click on map');
        var top = evt.pageY;
        var left = evt.pageX;
        var top_img = $('#map_img').offset().top;
        var left_img = $('#map_img').offset().left;
        console.log(top, left, top_img, left_img);
        
        var py = top-top_img;
        var px = left-left_img;
        
        var newPoint = new Point(px, py, pindex++);
        $('#map_img_box').append(newPoint.view);
	});
    /*
    // cant use live / delegate because they are bound to the root of the DOM tree
    // and cant cancel event from being handled at map_img_box
    // have to bind click to every new point created

    $('.point').live('dblclick', function(){
        console.log("point click");
        // return false to cancel bubling
        return false;
    });
   */ 
});

