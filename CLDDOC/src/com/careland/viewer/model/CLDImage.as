package com.careland.viewer.model
{
	import com.bit101.components.Component;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class CLDImage extends Component
	{
		public var index:int=0;
		
		public var clip:BitmapData;
		
		private var bitImg:Bitmap;
		
		
		
		public function CLDImage()
		{
			super();
			
		}
		override protected function addChildren():void
		{
			bitImg=new Bitmap();
			this.addChild(bitImg);
		}
		override public function draw():void
		{
			if(this.width>0&&this.height>0){
//				var bitdata:BitmapData=new BitmapData(this.width,this.height,true,0xff33322);
//				this.bitdata=bitdata;
			}
			
			
		}
		public function dispose():void
		{
			if(this.clip)this.clip.dispose();clip=null;
			this.bitImg=null;
		}
		public function disposeBit():void
		{
			if(this.clip)this.clip.dispose();
		}
		
		public function set bitdata(clip:BitmapData):void
		{
			if(this.clip)this.clip.dispose();
			this.clip=clip;
			this.bitImg.bitmapData=clip;
		}
		
		
		
		
		
		
	}
}