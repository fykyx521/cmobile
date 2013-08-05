package com.identity.list.classes
{
	import com.careland.component.CLDBaseComponent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CLDListUI extends CLDBaseComponent
	{
		public function CLDListUI(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		private var leftBit:Bitmap;
		
		private var rightBit:Bitmap;
		
		private var centerBit:Bitmap;
		
		protected var listHeight:int=387;
		
		private var leftRight:Number=14
		
		private var shape:Shape;
		
		protected var maskBit:Bitmap;
		protected var centerMask:Sprite;
		
		
		
		
		override protected function addChildren():void
		{
			 leftBit=this.config.getBitmap("list_left");
			 rightBit=this.config.getBitmap("list_right");
			 centerBit=this.config.getBitmap("left_center");
			 
			 maskBit=this.config.getBitmap("list_centerMask");
			 
			 shape=new Shape();
			 this.addChild(shape);
			 
//			centerMask=new Sprite();
//			centerMask.addChild(maskBit);
//			this.addChild(centerMask);
			 
			// centerMask.addEventListener(MouseEvent.CLICK,clickHandler);
			 
			// centerMask.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
		}
		private function downHandler(e:TUIOEvent):void
		{
			this.dispatchEvent(new Event("cld_listui_down"));
		}

		private function clickHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("cld_listui_down"));
		}
		override public function draw():void
		{
			
			if(this._sizeChange&&this.width>0){
				
				var g:Graphics=this.graphics;
				g.clear();
				g.beginBitmapFill(leftBit.bitmapData,null,false);
				
				g.drawRect(0,0,leftRight,listHeight);
				g.endFill();
				//g.moveTo(leftRight,0);
				var centerWidth:Number=this.width-leftRight*2;
				g.beginBitmapFill(this.centerBit.bitmapData,null,true,false);
				g.drawRect(leftRight,0,centerWidth,this.listHeight);
				g.endFill();
				//g.moveTo(centerWidth+leftRight,0);
				
				shape.x=centerWidth+leftRight;
				if(shape){
					var sg:Graphics=this.shape.graphics;
					sg.beginBitmapFill(rightBit.bitmapData,null,false);
					sg.drawRect(0,0,leftRight,this.listHeight);
					sg.endFill();
				}
				
//				var cg:Graphics=this.centerMask.graphics;
//				cg.clear();
//				cg.beginBitmapFill(this.maskBit.bitmapData,null,true,false);
//				cg.drawRoundRect(0,0,this.width,54,0,0);
//				cg.endFill();
//				
//				centerMask.y=150;
				
				
				_sizeChange=false;
			}
			
		}
		
	}
}