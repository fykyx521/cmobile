package com.careland.component.layout
{
	
	import com.careland.component.CLDLayoutUI;
		
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	public class CLDLayout6 extends CLDLayoutUI
	{
		public function CLDLayout6(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		
		override protected function layout():void
		{
			var realW:Number=this.width-this._spacing*2;//间隔
			var realH:Number=this.height-this._spacing;
			
			//设置第一个元素的宽高
			var dis0:DisplayObject=this.getChildAt(0);
			dis0.width=realW/3;//
			dis0.height=this.height;
			
			
			realW=realW-dis0.width-this._spacing;//去掉左边的
			
			var sw:Number=realW/2;
			var sh:Number=realH/2;
			
			
			var ypos:Number = 0;
			var xpos:Number = this._spacing+dis0.width;
			//因为i从1开始的 
			for(var i:int=1;i<this.numChildren;i++)
			{
				var dis:DisplayObject=this.getChildAt(i);
				dis.width=sw;
				dis.height=sh;
				if(i==3){
					xpos=this._spacing+dis0.width;
					//ypos=dis.height+this._spacing;
				}
				dis.x=xpos;
				if(i>2){
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