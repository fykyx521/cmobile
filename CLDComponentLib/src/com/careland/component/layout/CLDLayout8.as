package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout8 extends CLDLayoutUI
	{
		public function CLDLayout8(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function layout():void
		{
			super.layout();
			if(this.numChildren<3){
				return;
			}
			var realW:Number=this.width-this._spacing*2;//间隔
			var realH:Number=this.height;
			
			var xpos:Number = 0;
			var ypos:Number = 0;
			
			var sw:Number=realW/3;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				child.width=sw;
				child.height=realH;
				xpos += sw;
				xpos += _spacing;
				
			
			}

		}
	}
}