package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Graphics;

	public class CLDBorder extends CLDBaseComponent
	{
		
		public function CLDBorder()
		{
			super();
		}
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			try{
				g.lineStyle(1,0x000000,1);
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