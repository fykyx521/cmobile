package com.careland.component.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.bit101.components.Component;
	
	import flash.display.Bitmap;

	class CLDRadarPoint extends Component
	{
		private var bit:Bitmap;
		//真实宽高
		private var xx:Number;
		private var yy:Number;
		private var content:Number;
		private var color:String;
		private var realNum:Number;
		public function  CLDRadarPoint(xx:Number,yy:Number,content:Number,color:String,realNum:Number){
			this.xx=xx;
			this.yy=yy;
			this.content=content;
			this.color=color;
			this.realNum=realNum;
			
			this.x=450*this.xx*(realNum/450)-30;
			this.y=450*this.yy*(realNum/450)-30;
		}
		override protected function addChildren():void
		{
			bit=new Bitmap();
			this.addChild(bit);
			
			var loader:BulkLoader=BulkLoader.getLoader("main");
			bit.bitmapData=loader.getBitmap("randarRed").bitmapData.clone();
		}
		public function dispose():void
		{
			if(bit)
			{
				bit.bitmapData.dispose();
				bit=null;
			}
		}
	}

}