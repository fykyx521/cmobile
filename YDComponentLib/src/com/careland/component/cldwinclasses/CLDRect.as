package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Graphics;

	public class CLDRect extends CLDBaseComponent
	{
		protected var color:uint;
		protected var valpha:Number;
		public function CLDRect(color:uint=0xf8f8d8,alpha:Number=1)
		{
			super();
			this.color=color;
			this.valpha=alpha;
		}
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			try{
				g.beginFill(color,valpha);
				g.drawRoundRect(0,0,width,height,10,10);
				g.endFill();
			}catch(e:Error){
				
			}
			
		} 
		override public function dispose():void{
			this.graphics.clear();
		}
		
	}
}  