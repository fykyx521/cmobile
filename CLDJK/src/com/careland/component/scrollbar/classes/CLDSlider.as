package com.careland.component.scrollbar.classes
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class CLDSlider extends CLDBaseComponent
	{
		
		[Embed(source="assets/滑块组/滑块条顶端.png")]
		private var splideCls:Class;
		private var splideupSp:Bitmap;
		
		[Embed(source="assets/滑块组/滑块条中.png")]
		private var splidecenter:Class;
		private var sc:Bitmap;
		
		[Embed(source="assets/滑块组/滑块条底端.png")]
		private var splidedownCls:Class;
		private var splidedownSp:Bitmap;
		
		
		private var defaultSlider:Sprite;
		
		public function CLDSlider(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
	 
	
		override protected function addChildren():void
		{
			 defaultSlider=new Sprite;
			 this.addChild(defaultSlider);
			 
			 splideupSp=new splideCls as Bitmap;
			 splidedownSp=new splidedownCls as Bitmap;
			 sc=new splidecenter as Bitmap;
			 
			 this.addChild(splideupSp);
			 this.addChild(splidedownSp);
			 this.addChild(sc);
			 sc.y=13;
			 
			 
		}
		override public function draw():void
		{
			  sc.height=this.height-13*2;
			  splidedownSp.y=13+sc.height;
		}
		
		
		
	}
}