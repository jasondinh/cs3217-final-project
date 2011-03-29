
// MODE: ADD_MODE or TAG_MODE
var MODE = "ADD_MODE";

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
		if (MODE != 'ADD_MODE') return;
        console.log("remove line");
        view.remove();
        return false;
    });
} 

var Point = function(px, py, index){

    var view = $('<div>').attr('class', 'point'). css({position:'absolute', top:py-15, left:px-15, background:'green', width:30, height:30});
    view.data('p-index', index);

	view.click( function(evt){
		if (MODE!='TAG_MODE') return;	
		console.log('single click at point');
		var pos = view.position();
		AddShopForm.showAt(pos.top+5, pos.left+5 );
		return false;
	});
    
    view.dblclick( function(evt) {
		if (MODE!='ADD_MODE') return;
        console.log("point click, remove point");
		//@Hung: should remove all lines connected to this point as well
		view.remove();
        return false;
    });

    var copyView;

    var isDragging = false;

    // handle drag & drop using mousedown, mousemove and mouseup
	// TODO: disable draggable when MODE is TAG_MODE
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

	AddShopForm = function (){
		// either create on the fly when click on point
		// or create before hand and hide / show when a point is clicked (in TAG_MODE)
		
		// temporary do it the second way
		var form = $('#add_shop_form');
		var donebtn = $('#add_done');
		donebtn.click( function(){
			console.log('done clicked');	
			// handle ajax submit form here
			form.hide();
			return false;
		});
		// @Hung: for form blur when click outside, check out benalman's lib
		return {
			hide:function(){ 
				console.log(form);
				form.hide(); 
			},
			showAt: function(topPos, leftPos){ 
				form.css({top:topPos, left: leftPos}); 
				form.show();
			}		
		};
	}();


	var add_msg = "Double click to add point. Drag point to point to connect them. Double click on edge or point to remove";

	var tag_msg = "Click at point to add information to it";
	// set up information
	$('#instruction').html(add_msg);
	AddShopForm.hide();

	// set up tag point 
	$('#switch_btn').click( function(){
		if (MODE == 'ADD_MODE'){
			MODE = 'TAG_MODE';
			$('#instruction').html(tag_msg);
			$('#switch_btn').html('Done tagging');
		} else 
		if (MODE == 'TAG_MODE'){
			MODE = 'ADD_MODE';
			$('#instruction').html(add_msg);
			$('#switch_btn').html('Click here to tag points');
			AddShopForm.hide();
		}
	});
	
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
		if (MODE != 'ADD_MODE') return;
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

