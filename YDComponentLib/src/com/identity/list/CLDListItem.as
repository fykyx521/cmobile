package com.identity.list
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.CLDEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class CLDListItem extends CLDBaseComponent
	{
		
		
		public var imgPath:String;
		public var content:String;
		public var id:int;
		public var param:String;
		
		public var rowHeight:int=40;
		public var object:Object;
		
		public var _id:int;
		private var contentText:TextField;
		private var finished:Boolean=true;	
		
		private var preTime:int=0;
		private var prePoint:Point=new Point(0,0);
		public function CLDListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			contentText=new TextField;
			contentText.selectable=false;
			contentText.width=this.width;
		    contentText.height=this.rowHeight;
		    contentText.x=20;
		    contentText.y=10;	
		    contentText.selectable=false;
		    contentText.embedFonts=true;
		  
		//	txt.embedFonts=true;
			//txt.wordWrap=false;
			this.addChild(contentText);
			
			//this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			
		}
		private function downHandler(e:MouseEvent):void
		{
			preTime=flash.utils.getTimer();
			prePoint=new Point(e.stageX,e.stageY);
			this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			e.stopPropagation();
		}
		private function outHandler(e:MouseEvent):void
		{
			preTime=flash.utils.getTimer();
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		private function upHandler(e:MouseEvent):void
		{
			
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			var newPoint:Point=new Point(e.stageX,e.stageY);
			var disPoint:Point=newPoint.subtract(this.prePoint);
			var dis:Number=Math.abs(disPoint.x*disPoint.x+disPoint.y*disPoint.y);
			
			var newTime:int=flash.utils.getTimer();
			
			if(dis<10&&newTime-this.preTime<0.5){
				
				var cld:CLDEvent=new CLDEvent(CLDEvent.ITEMCLICK);
				cld.stageX=e.stageX;
				cld.stageY=e.stageY;
				
				this.dispatchEvent(cld);
			}
			prePoint=newPoint;
			preTime=flash.utils.getTimer();
		}
		
		
	
		override public function draw():void
		{
			super.draw();
			if(this.contentText){
				 contentText.width=this.width;
				 contentText.height=this.height;
				 contentText.text=this.content;
				 contentText.setTextFormat(Style.getTF());
			}

		}
		override public function dispose():void
		{
			super.dispose();
			this.contentText=null;
		}
		
	}
}