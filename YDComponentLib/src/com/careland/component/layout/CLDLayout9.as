package com.careland.component.layout
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDLayoutUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout9 extends CLDLayoutUI
	{
		public function CLDLayout9(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function layout():void
		{

			if(this.numChildren<3){
				return;
			}
			var realW:Number=this.width-this._spacing;//间隔
			var realH:Number=this.height-this._spacing;
			
			var sw:Number=realW/3;
			
			var c1:DisplayObject=this.getChildAt(0);
			c1.x=0;
			c1.y=0;
			c1.width=sw;
			c1.height=realH;
			
			
			var c2:DisplayObject=this.getChildAt(1);
			
			c2.width=realW-c1.width-this._spacing;
			c2.height=realH/3;
			
			var c3:DisplayObject=this.getChildAt(2);
			
			c3.width=realW-c1.width-this._spacing;
			c3.height=realH-c2.height-this._spacing;
			//c3.setSize(this.width-c1.width,height/2);
			
			c2.x=c1.width+this._spacing;
			
			c3.x=c1.width+this._spacing;
			
			c3.y=c2.height+this._spacing;
			
//			for(var i:int=0;i<this.numChildren;i++)
//			{
//				var dis:DisplayObject=this.getChildAt(i);
//				dis.width=this.width;
//				dis.height=this.height;
//			}
			
			
			
			
			
		}
		
	}
}