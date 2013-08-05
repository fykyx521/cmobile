package com.careland.component.layout
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDLayoutUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CLDLayout2 extends CLDLayoutUI
	{
		public function CLDLayout2(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		
		
		
		override protected function layout():void
		{
		
			var realW:Number=this.width-this._spacing;//间隔
			var realH:Number=this.height-this._spacing;
			
			
			var sw:Number=realW/2;
			var sh:Number=realH/2;
			var xpos:Number = 0;
			var ypos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				
				child.y = ypos;
				child.width=sw;
				child.height=sh;
				
				
				//Tweener.addTween(child,{x:xpos,y:ypos,width:sw,height:sh,time:2});
				xpos += realW/2;
				xpos += _spacing;
				if(i==1){
					xpos=0;
					ypos=realH/2+this._spacing;
				}
			
			}
		
		}
		
	}
}