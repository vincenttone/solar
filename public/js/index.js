function set_code_taker(posx, posy)
{
	var d_height = $(document).height();
	var d_width = $(document).width();
	var c_height = $("#code-taker").height();
	var c_width = $("#code-taker").width();
	var s_height = d_height / 2  - c_height;
	var s_width = (d_width - c_width) /2;
	$("#code-taker").css("position", "absolute").css("z-index", "999");
	$("#code-taker").css("top", s_height-posx).css("left", s_width-posy);
}
function set_bg_img(posx, posy)
{
	var d_height = $(document).height();
	var d_width = $(document).width();
	$("#bg-img").height( d_height);
	$("#bg-img").width ( d_width);
	$("#bg-img").css("top", 0-posx).css("left", 0-posy);
}
$(document).ready(function(){
	set_code_taker(0, 0);
	set_bg_img(0, 0);
});
$(window).resize(function(){
	set_code_taker(0, 0);
	set_bg_img(0, 0);
});
$(document).mousemove(function(e){
	var x = e.pageX;
	var y = e.pageY;
	var mx = x /30;
	var my = y /30;
	set_code_taker(mx, my);
	set_bg_img(my/2, mx/2);
});
