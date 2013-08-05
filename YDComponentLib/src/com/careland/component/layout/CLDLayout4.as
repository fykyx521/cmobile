package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	import com.careland.component.CLDWindow;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout4 extends CLDLayoutUI
	{
		public function CLDLayout4(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		
		override protected function layout():void
		{
			var realW:Number=this.width-this._spacing*3;//间隔
			var realH:Number=this.height-this._spacing;
			
			var sw:Number=realW/4;
			var sh:Number=realH/2;
			
			
			var ypos:Number = 0;
			var xpos:Number = 0;
			for(var i:int=0;i<this.numChildren;i++)
			{
				var dis:DisplayObject=this.getChildAt(i);
				dis.width=sw;
				dis.height=sh;
				if(i==4){
					xpos=0;
					//ypos=dis.height+this._spacing;
				}
				dis.x=xpos;
				if(i>3){
					ypos=dis.height+this._spacing;
				}
				
				dis.x=xpos;
				dis.y=ypos;
				xpos += dis.width;
				xpos += _spacing;
				
				
			}
			  
		}
		
	}
}