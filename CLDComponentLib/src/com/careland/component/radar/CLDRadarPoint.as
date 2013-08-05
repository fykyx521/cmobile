package com.careland.component.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.bit101.components.Component;
	import com.careland.component.win.CLDMapOverWin;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;

	class CLDRadarPoint extends Component
	{
		private var bit:Bitmap;
		//真实宽高
		private var xx:Number;
		private var yy:Number;
		public  var content:String;
		private var color:String;
		private var realNum:Number;
		public var status:int;
		public function  CLDRadarPoint(xx:Number,yy:Number,content:String,realNum:Number,status:int){
			this.xx=xx;
			this.yy=yy;
			this.content=content;
			this.status=status;
			this.realNum=realNum;
			
			bit=new Bitmap();
			this.addChild(bit);
			
			var loader:BulkLoader=BulkLoader.getLoader("main");
			switch(status)
			{
				case 0: this.color="randarGreen";  break;
				case 1: this.color="randarYellow";  break;
				case 2: this.color="randarRed"; break;
				case 3: this.color="randarOrange"; break;
			}
			bit.bitmapData=loader.getBitmap(color).bitmapData.clone();
			
			this.x=450*this.xx*(realNum/450)-10;
			this.y=450*this.yy*(realNum/450)-10;
		}
		override protected function addChildren():void
		{
			
			
			//this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		
		private function clickHandler(e:Event):void
		{
			  //this.dispatchEvent(new Event(""));
		}
		public function dispose():void
		{
			this.graphics.clear();
			if(bit)
			{
				bit.bitmapData.dispose();
				bit=null;
				//this.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
	}

}