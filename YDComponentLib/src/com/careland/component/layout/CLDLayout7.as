package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout7 extends CLDLayoutUI
	{
		public function CLDLayout7(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function layout():void
		{
			super.layout();
			if(this.numChildren<2){
				return;
			}
			var realW:Number=this.width-this._spacing;//间隔
			var realH:Number=this.height;
			
			
			
			//设置第一个元素的宽高
			var dis0:DisplayObject=this.getChildAt(0);
			dis0.x=0;
			
			dis0.width=realW/3;//
			dis0.height=this.height;
			
			
			var dis1:DisplayObject=this.getChildAt(1);
			dis1.x=this._spacing+dis0.width;
			dis1.width=realW-dis0.width;//
			dis1.height=this.height;

		}
		
		
		
		
		
		
	}
}