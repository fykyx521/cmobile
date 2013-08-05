package com.careland.component
{
	import com.careland.component.util.Style;
	import com.careland.event.YDMenuDownEvent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import org.bytearray.display.ScaleBitmap;
	
	
	
	public class YDMenu2Item extends YDComponentBase implements IMenu,IDisponse
	{
		
		
		public var itemBorder:Bitmap;  
		
		
		
		public var itemClickBorder:Bitmap;
		
		private var dragBit:Bitmap;
		
		private var preTime:Number;//点击时的时间
		
		private var prePoint:Point;
		
		private var itemBorderBit:Bitmap;
		private var itemClickBorderBit:Bitmap;
		
		private var _menuID:Number;
		
		private var _menuName:String;
		public function YDMenu2Item()
		{
			super();
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			
		}
		override protected function createUI():void{
			this.itemBorderBit=this.cldConfig.getBitmap("menu2singleborder");
		
			this.itemClickBorderBit=this.cldConfig.getBitmap("menu2singleclick");
			this.itemBorder=new Bitmap(itemBorderBit.bitmapData.clone());
			this.itemClickBorder=new Bitmap(itemClickBorderBit.bitmapData.clone());
			this.addChild(itemBorder);
			itemBorder.visible=false;
			this.addChild(itemClickBorder);
			itemClickBorder.visible=false;
			
		}
		public function set url(v:String):void
		{
			v="assets/hjcd.png";
			this.loadImage(v);
		}
		override protected function loadComplete(e:Event):void{
			super.loadComplete(e);
			var bit:Bitmap=e.target.content as Bitmap;
			bitmap=bit;
		}
		public function downHandler(e:TUIOEvent):void{
			this.preTime=getTimer();
			itemClickBorder.visible=false;
			this.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			prePoint=new Point(e.localX,e.localY);
		}
		public function upHandler(evt:TUIOEvent):void{
			itemClickBorder.visible=false;
			this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			preTime=getTimer();
			
			var yd:YDMenuDownEvent=new YDMenuDownEvent(YDMenuDownEvent.YDMENU_UP,true,true);
				yd.stageX=evt.stageX;
				yd.stageY=evt.stageY;
				yd.localX=evt.localX;
				yd.localY=evt.localY;
				yd.touchID=evt.ID;
				this.dispatchEvent(yd);
			
		}
		
		public function setSelected(value:Boolean):void
		{
			 if(value)
			 {
				 this.itemBorder.visible=false;
				 this.itemClickBorder.visible=false;
			 }else
			 {
				 this.itemBorder.visible=false;
				 this.itemClickBorder.visible=false;
			 }
		}
		
		
		
		public function  moveHandler(evt:TUIOEvent):void{
			var current:Number=getTimer();
			var dis:Number=current-preTime;
			
			var curPoint:Point=new Point(evt.localX,evt.localY);
			
			var disPoint:Point=curPoint.subtract(prePoint);
			
			itemClickBorder.visible=false;
			if(dis>300&&Math.abs(disPoint.y)<20&&Math.abs(disPoint.x)>80&&curPoint.x<prePoint.x){
				var yd:YDMenuDownEvent=new YDMenuDownEvent(YDMenuDownEvent.YDMENU_DOWN,true,true);
				yd.stageX=evt.stageX;
				yd.stageY=evt.stageY;
				yd.localX=evt.localX;
				yd.localY=evt.localY;
				yd.touchID=evt.ID;
				this.dispatchEvent(yd);
				evt.stopPropagation();
				this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
				
				
				
			}

			this.preTime=dis;
		}
		//获取全局坐标系
		public function getTargetPoint():Point{
			if(!parent){
				return null;
			}
			var mp:Point=new Point(this.x,this.y);
			var contentP:Point=parent.localToGlobal(mp);
			
			return contentP;
		}
		public function set bitmap(v:Bitmap):void{
			
			dragBit=v;
			var scale:ScaleBitmap=new ScaleBitmap(v.bitmapData);
			//scale.setSize(300,190);
			this.addChild(scale);
			//scale.x=15;
			//scale.y=5;
			
			var txt:TextField=new TextField();
			txt.width=240;
			txt.selectable=false;
			txt.text=this._menuName;
			txt.embedFonts=true;
			txt.y=110;
			
			txt.setTextFormat(Style.getTFMenu());
			
		//	txt.visible=false;
			this.addChild(txt);
			
		}
		
		public function set menuID(value:Number):void
		{
			this._menuID=value;
		}
		
		public function set menuName(value:String):void
		{
			this._menuName=value;
		}
		
		public function dispose():void
		{
			if(this.dragBit){
				this.dragBit.bitmapData.dispose();
				this.dragBit=null;
			}
			
		}
		
		
		public function cloneImg():MenuBase
		{
			var scale:Bitmap=new Bitmap(this.dragBit.bitmapData);
			var menuBase:MenuBase=new MenuBase();
			menuBase.level=this.getLevel();
			menuBase.addChild(scale);
			menuBase.menuID=this._menuID;
			menuBase.menuName=_menuName;
			return menuBase;
		}
		public var level:int=2;
		public function getLevel():int
		{
			return level;
		}
		
	}
}