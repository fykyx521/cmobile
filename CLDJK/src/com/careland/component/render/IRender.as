package com.careland.component.render
{
	import flash.geom.Point;

	public interface IRender
	{
		function set width(value:Number):void;
		function set height(value:Number):void;
		function set data(value:*):void;
		function set position(value:Point):void;
		function reflush():void;
		function setSize(w:Number,h:Number):void;
	}
}