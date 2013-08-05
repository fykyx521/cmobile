package com.careland
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Test extends Sprite
	{
		public var http:String="http://192.168.0.167/szmapdata/DZ/";
		private var bulk:BulkLoader=new BulkLoader("main-site"+Math.random());
		public function Test(url:String)
		{
			super();
			http=url;
			for(var i:int=4;i<=8;i++){
				for(var j:int=0;j<7;j++){
					bulk.add(http+"101/"+i+"_"+j+".png",{id:i+"+"+j});
				}
			}
			bulk.start(28);
			bulk.addEventListener(BulkProgressEvent.COMPLETE,complete);
		}
		function complete(e:BulkProgressEvent){
			for(var j:int=0;j<7;j++){
				for(var i:int=4;i<=8;i++){
					var bit:Bitmap=bulk.getBitmap(i+"+"+j);
					
					this.addChild(bit);
					bit.x=j*256;
					bit.y=(i-4)*256;
				}
			}
			trace("complete")
		}
	
			
		
	}
}