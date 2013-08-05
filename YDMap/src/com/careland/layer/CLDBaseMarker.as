package com.careland.layer
{
	import com.careland.events.MapEvent;
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDBaseMarker extends Sprite
	{
		private var _cldPoint:Point;
		private var _pointType:String;
		
		private var _text:String;
		private var _src:String;
		
		private var _data:*; 
		
		private var _layer:CLDLayer;
		public var offx:Number=0;
		public var offy:Number=0;
		
		public var _defaultTouch:Function;
		
		public var alterJS:String;//弹出窗口的js
		
//		public var alertInfo:String;//弹出框信息
		
		public var winID:String;//
		public var winWidth:Number;
		public var winHeight:Number;
		
		public var mouseOverData:String="";
		public var mouseClickData:String="";
		
		protected var isInit:Boolean=false;
		public function CLDBaseMarker()
		{
			super();
			
//			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			//this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			
			this.addEventListener("rightClick",rightClick);
			this.addEventListener(MouseEvent.CLICK,overHandler);
		}
		public function invalidate():void
		{
			this.addEventListener(Event.ENTER_FRAME,onInvalidate);
		}
		
		
		//因为这是 CLDEvent 但是不能引用 所以强转 
		protected  function rightClick(e:Event):void
		{
//			trace("rightClick");
			var me:MapEvent=new MapEvent(MapEvent.MapMouseRightClick);
			me.stageX=Object(e).stageX;
			me.stageY=Object(e).stageY;
			this.dispatchEvent(me);
//			throw new Error;
		}
		
		protected function overHandler(e:MouseEvent):void
		{
			
			var me:MapEvent=new MapEvent(MapEvent.MapMouseOver);
			me.stageX=e.stageX;
			me.stageY=e.stageY;
			this.dispatchEvent(me);
			
			
			
		}
		
		private function downHandler(e:TUIOEvent):void
		{
			if(_defaultTouch!=null){
				_defaultTouch.apply(this,[e]);
			}
			var me:MapEvent=new MapEvent(MapEvent.MapTouchMarker);
			this.dispatchEvent(me);
			e.stopPropagation();
		}
		
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		public function set cldPoint(p:Point):void
		{
			_cldPoint=p;
		}
		
		public function get cldPoint():Point
		{
			return _cldPoint;
		}
		
		public function set pointType(p:String):void
		{
			_pointType=p;
		}
		
		public function get pointType():String
		{
			return _pointType;
		}
		public function set text(p:String):void
		{
			_text=p;
		}
		
	
		
		public function get text():String
		{
			return _text;
		}
		public function set src(p:String):void
		{
			_src=p;
		}
		
		public function get src():String
		{
			return _src;
		}
		public function set data(value:*):void
		{
			this._data=value;
		}
		
		public function get data():String
		{
			return this._data;
		}
		public function set layer(value:CLDLayer):void
		{
			this._layer=value;
		}
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK,overHandler);
			this.removeEventListener("rightClick",rightClick);
		}
		
		//获取当前显示区域的坐标
		protected function getScreenPoint(cldPoint:Point,center:Point,vscale:Number,vw:Number,vh:Number,gl,mapConfig:MapConfig):Point
		{
			//触控获取

			var stagePoint:Point=CLDConfig.instance().toScreenPoint(cldPoint.x,cldPoint.y,vw,vh,vscale,center.x,
			center.y,mapConfig.tilemapindex,mapConfig.wscale,mapConfig.hscale);

			
			var sp:Point=this._layer.globalToLocal(stagePoint);
			 
			sp=sp.add(gl);
	
			return sp;
			
		//web获取
//			var stagePoint:Point=CLDConfig.toScreenPoint(cldPoint.x,cldPoint.y,vw,vh,vscale,center.x, center.y);
//
// 
//			var sp:Point=this.globalToLocal(stagePoint);
//			var layerGlobel:Point=new Point(0,0);
//			sp.x+=layerGlobel.x;
//			sp.y+=layerGlobel.y;
 
			return sp;
			
		}
		
		
		//获取当前careland的坐标
		protected function getCLDPoint(screenPoint:Point,center:Point,vscale:Number,vw:Number,vh:Number,mapConfig:MapConfig):Point
		{
			var stagePoint:Point=CLDConfig.instance().toMapPoint(screenPoint.x,screenPoint.y,vw,vh,center,mapConfig);
			
			return stagePoint;
		}
		public function draw():void
		{
			
		}
	}
}