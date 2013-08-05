package com.careland.component.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.bit101.components.Component;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CLDRadar extends Component
	{
		
		
		private var back:Bitmap;
		private var center:Sprite;
		private var centerBit:Bitmap;
		
		private var angle:int=1;
		public function CLDRadar()
		{
			super();
		}
		public var data:String;
		private var points:Sprite;
		
		public function getBitmap(key:String):Bitmap
		{
			var loader:BulkLoader=BulkLoader.getLoader("main");
			return loader.getBitmap(key);
			
		}
		override protected function addChildren():void
		{
			 back=new Bitmap;
			 back.bitmapData=this.getBitmap("randar").bitmapData.clone();
			 this.addChild(back);
			 
			 centerBit=new Bitmap;
			 centerBit.bitmapData=this.getBitmap("randarPoint").bitmapData.clone();
			 center=new Sprite();
			 center.addChild(centerBit);
			 this.addChild(center);
			 this.addEventListener(Event.ENTER_FRAME,update);
			 points=new Sprite();
			 this.addChild(points);
			 //0.5 0.29444444445
			 
		}
		override public function draw():void
		{
			super.draw();
			var num:Number=this.width>this.height?this.width:this.height;
			if(back)
			{
				back.width=num;
				back.height=num;
			}
			if(center)
			{
				centerBit.width=num;
				centerBit.height=num;
				center.x=num/2;
				center.y=num/2;
				centerBit.x=-center.x;
				centerBit.y=-center.y;
			}
			data="<config><data x='0.5' y='0.29444444445' content='提示信息'/></config>";
			if(data&&points)
			{
				disponsePoints();
			  
				var xml:XML=XML(this.data)
				{
					for (var i:int=0; i < xml.data.length(); i++)
					{
						 var item:XML=xml.data[i];
					    var cp:CLDRadarPoint=new CLDRadarPoint(item.@x,item.@y,item.@content,"",num);
    					 points.addChild(cp);
					}
				}
			}
		
		}
		private function update(e:Event):void
		{
			 if(center)
			 {
				 center.rotation=this.angle;
				 this.angle++;
				 if(this.angle>360)
				 {
					 this.angle=0;
				 }
			 }
		}
		public function dispose():void
		{
			if(back)
			{
				back.bitmapData.dispose();
				back=null;
			}
			if(centerBit)
			{
				centerBit.bitmapData.dispose();
				centerBit=null;
			}
			if(points)
			{
				disponsePoints();
				points=null;
			}
		
		}
		
		public function disponsePoints():void
		{
			while(points.numChildren>0)
			{
				var cp:CLDRadarPoint=points.getChildAt(0) as CLDRadarPoint;
				points.removeChildAt(0);
				cp.dispose();
			}
		}
		
	}
	
}
