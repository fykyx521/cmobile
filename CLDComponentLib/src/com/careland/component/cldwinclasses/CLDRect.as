package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;

	public class CLDRect extends CLDBaseComponent
	{
		protected var color:uint;
		protected var valpha:Number;
		private var backBit:Bitmap;
		public function CLDRect(color:uint=0xf8f8d8,alpha:Number=1)
		{
			super();
			this.color=color;
			this.valpha=alpha;
		}
		override protected function addChildren():void
		{
			this.backBit=new Bitmap(this.config.getBitmap("w_back").bitmapData.clone());
			this.addChild(backBit);
		}
		
		override public function draw():void
		{
			/*
			var g:Graphics=this.graphics;
			g.clear();
			try{
				g.beginFill(color,valpha);
				g.drawRoundRect(0,0,width,height,10,10);
				g.endFill();
			}catch(e:Error){
				
			}
			*/
			if(this.backBit)
			{
				this.backBit.x=12;
				this.backBit.y=12;
				this.backBit.width=this.width-24;
				this.backBit.height=this.height-24;
			}
			
		} 
		override public function dispose():void{
			this.graphics.clear();
		}
		
	}
}  