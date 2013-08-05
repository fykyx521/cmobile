package com.identity.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;

	public class CLDRound extends CLDBaseComponent
	{

		private var bulkLoader:BulkLoader;
         private var point:Bitmap;
		public function CLDRound()
		{

		}
          override public function dispose():void
		 {
		 	 super.dispose();
		 	 this.removeEventListener(Event.RESIZE,resize);
		 	 this.point=null;
		 	 this.bulkLoader=null;
		 }
		override protected function addChildren():void
		{
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
		  this.addEventListener(Event.RESIZE, resize);
		}

		public function getBitmap(key:*):Bitmap
		{
			return this.config.getBitmap(key);
		}
		private function build():void{
		    point=new Bitmap();
			point.bitmapData=getBitmap("randarPoint").bitmapData.clone();
			point.height=this.height;
			point.width=this.width;
			point.x=-(this.width)/2;
			point.y=-(this.height)/2;
			this.addChild(point);
		}
		private function resize(e:Event):void{
			 if(point){
			 	  reload();
			 }else{
			   build();
			 }
		       
		}
		private function reload():void{
		    point.height=this.height;
			point.width=this.width;
			point.x=-(this.width)/2;
			point.y=-(this.height)/2;
		}

		override public function draw():void
		{
			 
			
		}



	}
}