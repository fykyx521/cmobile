package com.careland.layer
{
	import com.careland.events.MapDataEvent;
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CLDRectSprite extends CLDCircleSprite
	{
		
		
		
		protected var rect:Sprite;
		
		private var canDraw:Boolean=false;
		
		private var p1:Point=new Point(0,0);
		private var p2:Point=new Point(0,0);
		
		
		private var p3:Point=new Point(0,0);
		
		private var p4:Point=new Point(0,0);
		
		public var mapconfig:MapConfig;
		
		public function CLDRectSprite()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			rect=new Sprite;
			this.addChild(rect);
			this.addEventListener(TUIOEvent.TUIO_DOWN,downEvent);
			this.addEventListener(TUIOEvent.TUIO_UP,upEvent);
		}
		
		override public function downEvent(e:TUIOEvent):void
		{
			super.addBlob(e.ID,e.stageX,e.stageY);
			if(blobs.length==2)
			{
				var swap:Object={};
				p1=new Point(blobs[0].origX,blobs[0].origY);
				var np:Point=new Point(blobs[1].origX,blobs[1].origY);
				
				
				if(blobs[0].origX>blobs[1].origY){
					p1=new Point(blobs[1].origX,blobs[1].origY);
					np=new Point(blobs[0].origX,blobs[0].origY);
				}
				p2=np.subtract(p1);
				
				//点击后直接在地图上绘制，不再选择(不再添加click事件)
				var cle:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_RECT_DATA);
				cle.sourcepoint=parent.globalToLocal(p1);
				cle.toPoint=p2;
				cle.isShow=true;
				this.dispatchEvent(cle);
				
				
////				
//				var p1CLD:Object=this.screenPointToCLD(parent.globalToLocal(p1));
//				var p2CLD:Object=this.screenPointToCLD(np);
//				
//				var p3CLD:Point=new Point(p2CLD.x,p1CLD.y);
//				var p4CLD:Point=new Point(p1CLD.x,p2CLD.y);
//				
//				var p3p:Point=this.cldPointToScreen(p3CLD);
//				var p4p:Point=this.cldPointToScreen(p4CLD);
//				
//				this.p3=this.globalToLocal(p3p);
//				this.p4=this.globalToLocal(p4p);
////				
//				//矩形形状
//				// p1  p3
//				// p4  p2
//				this.canDraw=true;
//				this.addEventListener(MouseEvent.CLICK,clickHandler);
//				this.rect.addEventListener(MouseEvent.CLICK,clickHandler);
//				this.invalidate();
			}
			if(blobs.length==3)
			{
				
			}
		}
		
		public function cldPointToScreen(cld:Point):Point
		{
			
			return CLDConfig.instance().toScreenPoint(cld.x,cld.y,
			this.mapconfig);
		}
		public function screenPointToCLD(sreen:Point):Point
		{
			return CLDConfig.instance().toMapPoint(sreen.x,sreen.y,this.mapconfig);
		}
		

		private function clickHandler(e:Event):void
		{
			if(e.target===this)
			{
				var cle:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_RECT_DATA);
				this.removeEventListener(MouseEvent.CLICK,clickHandler);
				this.dispatchEvent(cle);
				return;
			}
			if(parent){
				var cle:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_RECT_DATA);
				cle.sourcepoint=parent.globalToLocal(p1);
				cle.toPoint=p2;
				cle.isShow=true;
				this.dispatchEvent(cle);
				rect.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
			
			
		}
		
		override public function upEvent(e:TUIOEvent):void
		{
			super.removeBlob(e.ID);
		}
		
		override public function draw():void
		{
			super.draw()
			if(canDraw&&rect){
				var g:Graphics=this.rect.graphics;
				g.clear();
				
				g.lineStyle(5,0xfff333,.5);
				
				g.beginFill(0x333fff,.5);
				
				
//				g.endFill();
//				if(parent){
//					var lp:Point=parent.globalToLocal(p1);
//					g.drawRect(lp.x,lp.y,p2.x,p2.y);
//					g.endFill();
//				}
				if(parent){
					var lp:Point=parent.globalToLocal(p1);
					g.moveTo(p1.x,p1.y);
					g.lineTo(p3.x,p3.y);
					g.lineTo(p2.x,p2.y);
					g.lineTo(p4.x,p4.y);
					g.endFill();
				}
				
			}
		}
		
		
		
	}
}