package com.identity
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDTouchButton;
	import com.careland.events.MapEvent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CLDMapControl extends CLDBaseComponent
	{
		
		private var zoom1:CLDTouchButton;
		private var zoom2:CLDTouchButton;
		private var zoom3:CLDTouchButton;
		private var zoom4:CLDTouchButton;
		private var zoom5:CLDTouchButton;
		private var zoom6:CLDTouchButton;
		private var _spacing:Number=10;
		public function CLDMapControl(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			zoom1=new CLDTouchButton();
			zoom1.setBit(config.getBitmap("cld_map_zoom1"),config.getBitmap("cld_map_zoom1_down"));
			
			zoom2=new CLDTouchButton();
			zoom2.setBit(config.getBitmap("cld_map_zoom2"),config.getBitmap("cld_map_zoom2_down"));
//			
			zoom3=new CLDTouchButton();
			zoom3.setBit(config.getBitmap("cld_map_zoom3"),config.getBitmap("cld_map_zoom3_down"));
//			
			zoom4=new CLDTouchButton();
			zoom4.setBit(config.getBitmap("cld_map_zoom4"),config.getBitmap("cld_map_zoom4_down"));
//			
//			zoom5=new CLDTouchButton();
//			zoom5.setBit(config.getBitmap("cld_map_zoom5"),config.getBitmap("cld_map_zoom5_down"));
//			
//			zoom6=new CLDTouchButton();
//			zoom6.setBit(config.getBitmap("cld_map_zoom6"),config.getBitmap("cld_map_zoom6_down"));
//		
			this.addChild(zoom1);
	   		this.addChild(zoom2);
			this.addChild(zoom3);
//			
			this.addChild(zoom4);
//			this.addChild(zoom5);
//			this.addChild(zoom6);
			
//			zoom1.visible=false;
//			zoom2.visible=false;
//			zoom3.visible=false;
			
			zoom1.addEventListener(MouseEvent.CLICK,downHandler);
			
			zoom2.addEventListener(MouseEvent.CLICK,down2Handler);
//			
			zoom3.addEventListener(MouseEvent.CLICK,down3Handler);
//			
			zoom4.addEventListener(MouseEvent.CLICK,down4Handler);
			
//			zoom1.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
//			
//			zoom2.addEventListener(TUIOEvent.TUIO_DOWN,down2Handler);
////			
//			zoom3.addEventListener(TUIOEvent.TUIO_DOWN,down3Handler);
////			
//			zoom4.addEventListener(TUIOEvent.TUIO_DOWN,down4Handler);
			
		}
		override public function get width():Number
		{
			return 76;	
		}
		private function downHandler(e:Event):void
		{
			this.dispatchEvent(new Event("drawRect"));
			
		}
		private function down2Handler(e:Event):void
		{
			this.dispatchEvent(new Event("drawCircle"));
		}
		private function down3Handler(e:Event):void
		{
			this.dispatchEvent(new Event("drawMutiRect"));
		}
		private function down4Handler(e:Event):void
		{
			var map:MapEvent=new MapEvent(MapEvent.MapClearLayer);
			map.mapType=1;
			this.dispatchEvent(map);
		}
//		private function down4Handler(e:Event):void
//		{
//			this.dispatchEvent(new Event("startLine"));
//		}
		override public function dispose():void
		{
		
			if(zoom3){
				zoom3.removeEventListener(TUIOEvent.TUIO_DOWN,down3Handler);
				
			}
			super.dispose();
			zoom3=null;
			
		}
		
		
		override public function draw():void
		{
			super.draw();
			
			var xpos:Number = 0;
			var ypos:Number = 0;
			
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				child.y = ypos;
				
				xpos += 76;
				xpos += _spacing;
			
			
			}
			
		}
		
	}
}