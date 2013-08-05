package com.careland.component
{
	import com.identity.CLDTransfer;
	
	import flash.display.DisplayObjectContainer;

	public class CLDLineWindow extends CLDWindowAdapter
	{
		
		private var cld:CLDTransfer;
		public function CLDLineWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			cld=new CLDTransfer();
			this.content.addChild(cld);
		}
		
		override public function set autoLoad(value:Boolean):void
		{
			if(cld){
				cld.autoLoad=true;
			}			
		}

		override public function set contentID(value:String):void
		{
			if(cld){
				cld.contentID=value;
			}
		}
		
		
		
	}
}