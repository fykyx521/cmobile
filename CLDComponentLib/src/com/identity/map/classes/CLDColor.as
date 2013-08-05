package com.identity.map.classes
{
	import com.careland.component.CLDBaseComponent;
	import com.identity.map.CLDColorBround;
	
	import flash.display.DisplayObjectContainer;

	public class CLDColor extends CLDBaseComponent
	{
		private var back:CLDColorBround;
		public function CLDColor(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			back=new CLDColorBround();
			this.addChild(back);
		
		}
		override public function draw():void
		{
			if(back){
				back.setSize(this.width,this.height);
			}
			if(data&&this.dataChange){
				pauseData();
				this.dataChange=false;
			}	
		}
		public function pauseData():void
		{
			
		}
		
		
	}
}