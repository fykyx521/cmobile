package com.careland.component.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.bit101.components.Component;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.win.CLDMapOverWin;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CLDRadar extends CLDBaseComponent
	{
		
		
		
		private var ui:CLDRadarUI;
		public var isFirstPage:Boolean=false;
		public function CLDRadar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent,xpos,ypos,autoLoad,timeInteval);
			//this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private var points:Sprite;
		
		private var over:CLDMapOverWin;
		
		public function getBitmap(key:String):Bitmap
		{
			var loader:BulkLoader=BulkLoader.getLoader("main");
			return loader.getBitmap(key);
			
		}
		override protected function addChildren():void
		{
			  ui=new CLDRadarUI();
			  
			  this.addChild(ui);
			  
		}
		override public function draw():void
		{
			super.draw();
			if(ui)
			{
				ui.isFirstPage=this.isFirstPage;
				ui.setSize(this.width,this.height);
				var num:Number=this.width>this.height?this.height:this.width;
				ui.x=(this.width-num)/2;
			}
			if(data&&ui)
			{
				ui.data=this.data;
			}
		
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			ui=null;
		
		}
		
		
		
	}
	
}
