package com.identity.intelSingleNode
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.CLDTouchMapContainer;
	import com.careland.component.CLDBaseComponent;
	import com.careland.layer.CLDLayer;
	import com.identity.CLDMapControl;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import org.bytearray.gif.player.GIFPlayer;


	/**
	 *
	 * @author Administrator
	 */
	public class CLDEntity extends CLDBaseComponent
	{

		public var nameID:String;
		public var centerY:int;
		public var centerX:int;
		public var zoom:int; //地图级别		  
		public var borderColor:String; //拓扑图背景		 
		public var point:String;
		public var point2:String;
		public var mouseOverData:String="";
		public var bground:String;
		private var bulkLoader:BulkLoader;
		public var title:String;
		public  var titleText:TextField;
		public var overText:TextField;
		public var _point1:Point;
		private var _point2:Point;
		private var bgroundColor:String;
		public var bit:Bitmap=new Bitmap();
		private var sprite:Sprite;
		private var warnColor:String;
		private var warnMouseOverData:String;
		private var warnMouseClickData:String;
		private var gif:GIFPlayer;
		public var windowID:String;
		private var pointType:String;
		private var type:String;
		private var _borderColor:int=0;
		private var _bgroundColor:int=0;
		private var points:Array;
        private var center:Point;
        private var cldMap:CLDTouchMapContainer;
        private var layer:CLDLayer=new CLDLayer();
		private var mapControl:CLDMapControl;
		public var defaultIMG:String="assets/20091201191926468.png";
		private var Xscale:Number=1;
		private var Yscale:Number=1;
		 override public function dispose():void
		 {
		 	super.dispose();
		 	this.warnMouseClickData=null;
		 	this.warnMouseOverData=null;
		 	this.gif=null;
		 	this.windowID=null;
		 	this.pointType=null;
		 	this.type=null;
		 	this._borderColor=null;
		 	this._bgroundColor=null;
		 	this.points=null;
		 	this.center=null;
		 	this.cldMap=null;
		 	this.layer=null;
		 	this.mapControl=null;
		 	this.defaultIMG=null;
		 	this.nameID=null;
		 	this.centerX=null;
		 	this.centerY=null;
		 	this.zoom=null;
		 	this.alpha=null;
		 	this.borderColor=null;
		 	this.mouseOverData=null;
		 	this.title=null;
		 	this.point=null;
		 	this.warnColor=null;
		 	this.warnMouseOverData=null;
		 	this.warnMouseClickData=null;
		    this.windowID=null;
		    this.pointType=null;
		    this.type=null;
		    this.Xscale=null;
		    this.Yscale=null;	 	
		 }
		public function CLDEntity(obj:Object)
		{
			variables(obj); //初始化变量
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			if (this.bgroundColor != "")
			{
				_bgroundColor=parseInt("0x" + this.bgroundColor.substr(1, bgroundColor.length));
			}
			if (borderColor != "")
			{
				_borderColor=parseInt("0x" + this.borderColor.substr(1, borderColor.length));
			}
			build();
		}
		public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}
		private function variables(obj:Object):void{
		    this.nameID=obj.nameID;
			this.centerX=obj.centerX;
			this.centerY=obj.centerY;
			this.zoom=obj.zoom;
			if(obj.alpha!=""){
				this.alpha=obj.alpha;
			}else{
			   this.alpha=50;
			}			
			this.borderColor=obj.borderColor;
			this.bgroundColor=obj.bgroundColor;
			this.mouseOverData=obj.mouseOverData;
			if(obj.bground!=""){
				 this.bground=obj.bground;
			}else{
			    this.bground=defaultIMG;
			}			
			this.title=obj.title;
			this.mouseOverData=obj.mouseOverData;
			this.point=obj.point;
			this.warnColor=obj.warnColor;
			this.warnMouseOverData=obj.warnMouseOverData;
			this.warnMouseClickData=obj.warnMouseClickData;
			this.width=obj.width;
			this.height=obj.height;
			this.windowID=obj.windowID;
			this.pointType=obj.pointType;
			this.type=obj.type;
			this.Xscale=obj.Xscale;
			this.Yscale=obj.Yscale;
		}
		
		protected function build():void
		{
			_point1=new Point(0, 0);
			_point2=new Point(0, 0);
			points=this.point.split(";");
			if (this.point != "")
			{
			
				_point1=new Point(points[0].split(",")[0]*this.Xscale, points[0].split(",")[1]*this.Yscale);
				if (points.length > 1)
				{
					var _x:Number=points[1].split(",")[0];
					var _y:Number=points[1].split(",")[1];
					_point2=new Point(_x*this.Xscale, _y*this.Yscale);
				}
			}		 	
			switch (type)
			{
				case "Point":
					buildPoint();
					break;
				case "Line":
					buildLine();
					break;
				case "Broken":
					buildBroken();
					break;
				case "Rect":
					buildRect();
					break;
				case "Oval":
					buildCircle();
					break;
			}			
		}
		private function complete(e:Event):void
		{
			bit=e.target.content;
			bit.x=this._point1.x;
			bit.y=this._point1.y;
			bit.width=this.Xscale*bit.width;
			bit.height=this.Yscale*bit.height;
			this.addChild(bit);
			//提示文本
			titleText=new TextField();
			titleText.text=this.title;
			titleText.x=_point1.x;
			titleText.height=20;
			titleText.y=_point1.y + bit.height;
			this.addChild(titleText);
			//告警
			if (this.warnColor != "")
			{
				gif=new GIFPlayer();
				var request:URLRequest=new URLRequest("assets/images/node/" + warnColor + ".gif");
				gif.load(request);
				gif.x=this._point1.x;
				gif.y=this._point1.y;
				this.addEventListener(MouseEvent.CLICK, mouse_click);
				this.addChildAt(gif, this.numChildren - 1);
			}
		}
		private function mouse_click(e:MouseEvent):void
		{
			this.dispatchEvent(new MouseEvent("mouseClick"));
		}
		private function buildPoint():void
		{
			var request:URLRequest=new URLRequest(this.bground);
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);	
			loader.load(request);
		}
		private function error(e:IOErrorEvent):void{
		}
		private function buildLine():void
		{
			graphics.lineStyle(this.alpha/100, _borderColor);
			graphics.moveTo(_point1.x, _point1.y);
			graphics.lineTo(_point2.x, _point2.y);
			graphics.endFill();
		}
		private function buildRect():void
		{
			graphics.beginFill(_bgroundColor, this.alpha / 100);
			graphics.drawRect(this._point1.x, this._point1.y, this.width, this.height);
			graphics.endFill();
		}
		private function buildCircle():void
		{
			graphics.beginFill(_bgroundColor, this.alpha / 100);
			graphics.drawCircle(this._point1.x, this._point1.y, this.width / 2);
			graphics.endFill();
		}
		private function buildBroken():void
		{
			for (var i:int=0; i < points.length - 1; i++)
			{
				graphics.lineStyle(this.alpha/100, _borderColor);
				graphics.moveTo(points[i].split(",")[0], points[i].split(",")[1]);
				graphics.lineTo(points[i + 1].split(",")[0], points[i + 1].split(",")[1]);
				graphics.endFill();
			}
		}
	   
	}
}