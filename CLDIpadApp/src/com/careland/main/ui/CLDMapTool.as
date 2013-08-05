package com.careland.main.ui
{
	
	import com.careland.component.CLDStateButton;
	import com.careland.events.MapEvent;
	import com.careland.main.ui.CLDBaseUI;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CLDMapTool extends CLDBaseUI
	{
		
		private var back:Bitmap;
		
		private var juxing:CLDStateButton;
		private var yuan:CLDStateButton;
		private var duobian:CLDStateButton;
		private var qingchu:CLDStateButton;
		
		private var current:CLDStateButton;
		
		public var pressSp:CLDStateButton;
		public function CLDMapTool()
		{
			super();
			
		}
		override protected function addChildren():void
		{
			back=getBitmap("maptoolback");
			this.addChild(back);
			
			juxing=new CLDStateButton();
			juxing.setBit(getBitmap("maptool_rect"),getBitmap("maptool_recta"));
			
			yuan=new CLDStateButton();
			yuan.setBit(getBitmap("maptool_circle"),getBitmap("maptool_circlea"));
			
			duobian=new CLDStateButton();
			duobian.setBit(getBitmap("maptool_poly"),getBitmap("maptool_polya"));
			
			qingchu=new CLDStateButton();
			qingchu.setBit(getBitmap("maptool_clear"),getBitmap("maptool_cleara"));
			
			this.addChild(juxing);
			this.addChild(yuan);
			this.addChild(duobian);
			this.addChild(qingchu);
			
			juxing.x=33;
			yuan.x=33+96;
			duobian.x=33+96*2;
			qingchu.x=33+96*3;
			
			juxing.y=yuan.y=duobian.y=qingchu.y=15;
			
			juxing.addEventListener(MouseEvent.CLICK,juxingClick);
			yuan.addEventListener(MouseEvent.CLICK,yuanClick);
			duobian.addEventListener(MouseEvent.CLICK,duobianClick);
			qingchu.addEventListener(MouseEvent.CLICK,qingchuClick);
			
			cldConfig.addEventListener("drawEnd",drawEnd);
			
		}
		
		private function drawEnd(e:Event):void
		{
			this.current.press=false;
		}
		//			mapControl.addEventListener("startLine",startLine);
		
		private function juxingClick(e:MouseEvent)
		{
			setClickMode(e);
			if(juxing.press)
			{
				this.cldConfig.dispatchEvent(new Event("drawRect"));
			}
			
		}
		private function yuanClick(e:MouseEvent)
		{
			setClickMode(e);
			if(this.yuan.press)
			{
				this.cldConfig.dispatchEvent(new Event("drawCircle"));
			}
		}
		private function duobianClick(e:MouseEvent)
		{
			setClickMode(e);
			if(this.duobian.press)
			{
				this.cldConfig.dispatchEvent(new Event("drawMutiRect"));
			}
		}
		private function qingchuClick(e:MouseEvent)
		{
			setClickMode(e);
			if(this.qingchu.press)
			{
				var mape:MapEvent=new MapEvent(MapEvent.MapClearLayer);
				this.cldConfig.dispatchEvent(mape);
			}
		}
		private function setClickMode(e:MouseEvent):void
		{
			
			if(this.current)
			{
				this.current.press=false;
			}
			var target:CLDStateButton=e.target as CLDStateButton;
			target.press=true;
			current=target;
			this.visible=false;
			if(pressSp)
			{
				pressSp.press=false;
			}
		}
		
		private function disCurrent():void
		{
			if(this.current)
			{
				this.current.press=false;
			}
		}
		
		
	}
}