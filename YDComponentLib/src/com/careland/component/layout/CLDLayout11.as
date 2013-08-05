package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout11 extends CLDLayoutUI
	{
		public function CLDLayout11(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function layout():void
		{
			if(this.numChildren<4){
				return;
			}
			
			var realW:Number=this.width-this._spacing;//间隔
			var realH:Number=this.height;
			
			var sw:Number=realW/3;
			
			var c1:DisplayObject=this.getChildAt(0);
			c1.x=0;
			c1.y=0;
			c1.width=sw;
			c1.height=realH;
			
			
			var c2:DisplayObject=this.getChildAt(1);
			
			c2.width=realW-c1.width-this._spacing;
			c2.height=realH/3;
			
			c2.x=c1.width+this._spacing;
			
			var nw:Number=realW-c1.width-this._spacing*3;
			var nh:Number=realH-c2.height-this._spacing;
			
			var ssw:Number=nw/3;
			var ssh:Number=realH-c2.height-_spacing;
			
			var xpos:Number = c1.width+this._spacing;
			var ypos:Number = c2.height+this._spacing;
			
			for(var i:int = 2; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				
				xpos+=ssw;
				xpos+=this._spacing;
				child.width=ssw;
				child.height=ssh;
				child.y = ypos;
			}

//			var c3:DisplayObject=this.getChildAt(2);
//			c3.x=xpos;
//			xpos+=ssw;
//			xpos+=this._spacing;
//			c3.width=ssw;
//			c3.height=ssh;
//			var c4:DisplayObject=this.getChildAt(3);
//			c4.x=xpos;
//			xpos+=ssw;
//			xpos+=this._spacing;
//			c4.width=ssw;
//			c4.height=ssh;
//			var c5:DisplayObject=this.getChildAt(4);
//			c5.x=xpos;
//			xpos+=this._spacing;
//			c5.width=ssw;
//			c5.height=ssh;
//			
//			
			

		}
		
	}
}