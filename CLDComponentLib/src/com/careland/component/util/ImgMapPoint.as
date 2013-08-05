package com.careland.component.util
{
	import flash.geom.Point;

	public class ImgMapPoint extends Point
	{
		
	public var mapWidth:Number;
	public var mapHeight:Number;
	public var mapX:Number;
	public var mapY:Number;
	public var scalewidth;
	public var scaleheight;
	public function ImgMapPoint(x:Number, y:Number,mx:Number, my:Number, imageWidth:Number, imageHeight:Number)
	{
			super(x, y);
			 this.mapWidth = imageWidth;
   			 this.mapHeight = imageHeight;
    //深大传递
   			 this.mapX = mx;  //113.9187972;  //莲花山传递：114.0265452
   			 this.mapY = my; //22.53606111;   //莲花山传递：22.55013
   			 this.scalewidth = 0.0000452;
   			 this.scaleheight = 0.0000375;
    		 this.x = Number(x);
  		     this.y = Number(y);
	}
		
	
	
	public function toScreenPoint(zoomPro:Number):Object
	{
		 var x = (this.x - this.mapX) / this.scalewidth;
  	  var y = (this.mapY - this.y) / this.scaleheight;

    // 算出角度
    var l = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
    var a = Math.atan(x / y) * 180 / Math.PI;
    var r = a;

    // 旋转45度角
    if (a >= 0) {
        a = (a - 46);
    }
    else {
        a = 180 + a - 47;
    }
    a = a * Math.PI / 180;
    x = l * Math.sin(a);
    y = l * Math.cos(a);

    //缩放比例
    //var zoomPro = 1.32;
    //var zoomPro = 2.048;

    //偏移量
    //    var offX = -85;
    //    var offY = 50;
    var offX = -5;
    var offY = 65;

    offX += x / 2 + 25;
    offY += 0.000543859649122807017543859649123 * y;

    // 加偏移量
    x = x * zoomPro + offX;
    y = y * zoomPro - offY;

    return { x: Math.floor(x), y: Math.floor(y), offX: Math.floor(offX), offY: Math.floor(offY) };
	};
	}

}