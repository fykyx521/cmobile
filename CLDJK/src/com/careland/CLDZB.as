package com.careland
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDZBPhotoInfo;
	
	import flash.display.DisplayObjectContainer;
	
	public class CLDZB extends CLDBaseComponent
	{
		public function CLDZB(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			for(var i:int=0;i<4;i++)
			{
				var zb:CLDZBPhotoInfo=new CLDZBPhotoInfo();
				this.addChild(zb);
			}
		}
		
		override public function draw():void
		{
			var base:Number=20;
			for(var i:int=0;i<4;i++)
			{
				this.getChildAt(i).x=base;
				base+=200;
			}
		}
		
		
		
		
	}
}