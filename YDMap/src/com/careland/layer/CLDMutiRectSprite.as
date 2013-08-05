package com.careland.layer
{
	import __AS3__.vec.Vector;
	
	import com.careland.events.MapDataEvent;
	import com.careland.util.StyleDraw;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CLDMutiRectSprite extends CLDRectSprite
	{
		
		private var points:Vector.<Point>=new Vector.<Point>();
		
		private var isDraw:Boolean=false;
		public function CLDMutiRectSprite()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
//			if(rect){
//				rect.addEventListener(MouseEvent.CLICK,rectDownHandler);
//			}
			this.addEventListener("rightClick",rightClick);
			this.rect.addEventListener("rightClick",rightClick);
		}
		
		override public function set IsIpad(value:Boolean):void
		{
			if(value)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				this.doubleClickEnabled=true;
				this.addEventListener(MouseEvent.DOUBLE_CLICK,rightClick);
			}
		}
		override protected function downHandler(e:MouseEvent):void
		{
			points.push(this.parent.globalToLocal(new Point(e.stageX,e.stageY)));
			if(this.points.length>2)
			{
				this.invalidate();
			}
		}
		
		private function rightClick(e:Event):void
		{
			if(this.points.length>2){
				
				this.removeEventListener("rightClick",rightClick);
				this.rect.removeEventListener("rightClick",rightClick);
				
				this.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
				this.rect.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
				
				this.removeEventListener(TUIOEvent.TUIO_DOWN,this.downEvent);
				this.removeEventListener(TUIOEvent.TUIO_UP,this.upEvent);
				
				
			}
		}
		private function clickHandler(e1:Event):void
		{
			    e1.target.removeEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			 	e1.stopPropagation();
			
			 	if(e1.target===this){
			 		
					var cle:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_MUTI_RECT_DATA);
					cle.isShow=false;
					dispatchEvent(cle);
			 		return;
			 	}
				this.rectDownHandler();
				
		}
		private function rectDownHandler():void
		{
			//e.target.removeEventListener(MouseEvent.CLICK,rectDownHandler);
			var cle:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_MUTI_RECT_DATA);
			cle.isShow=true;
			cle.points=this.points;
			this.dispatchEvent(cle);
			return;	
		}
		
		override public function downEvent(e:TUIOEvent):void
		{
			
			this.addBlob(e.ID,e.stageX,e.stageY);
			
			for(var i:int=0;i<this.blobs.length;i++){
				
				var tuio:TUIOObject=TUIO.getObjectById(blobs[i].id);
				if(!tuio){
					this.removeBlob(blobs[i].id);
				}
			}
			//如果大于2 则加载数据
			if(this.blobs.length>=2)
			{
				isDraw=true;
				
			}else{
				points.push(this.parent.globalToLocal(new Point(e.stageX,e.stageY)));
				if(this.points.length>2)
				{
					this.invalidate();
				}
			}
			
			e.stopPropagation();
		}
		
		override public function upEvent(e:TUIOEvent):void
		{
			this.removeBlob(e.ID);
			if(this.blobs.length==0&&this.isDraw)
			{
				//rectDownHandler(); //两个点点击的时候  设置 多矩形 
			}
		}
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0xffffff,.1);
			g.lineStyle(1,0x000000,1);
			g.drawRect(0,0,this.width,this.height);
			g.endFill();
			
			if(this.points.length<3)
			{
				return;
			}
			var g1:Graphics=super.rect.graphics;
			g1.clear();
			
			g1.lineStyle(2,StyleDraw.lineStyle,.3);
			g1.beginFill(StyleDraw.drawStyle,.2);
			if(this.points.length>1){
				g1.moveTo(points[0].x,points[0].y);
			}
			var num:int=0;
			while(num<points.length){
				var p1:Point=new Point(points[num].x,points[num].y);
				g1.lineTo(p1.x,p1.y);
				num++;
			}
			g1.endFill();
			
		}
		
		
		
		
	}
}