package com.careland.component.win
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class CLDTrashWin extends CLDBaseComponent
	{
		
		public var closeSprite:Sprite
		public function CLDTrashWin(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			closeSprite=new Sprite;
			this.addChild(closeSprite);
		}
		
		override public function draw():void
		{
			var g:Graphics=this.closeSprite.graphics;
			g.clear();
			g.lineStyle(2,0xfff333,.8);
			g.moveTo(this.x+this.width/2/2,y+this.height/2/2);
			g.lineTo(this.x+this.width/2,this.y+this.height/2);
			
			g.moveTo(this.x+this.width/2,y+this.height/2/2);
			g.lineTo(this.x+this.width/2/2,this.y+this.height/2);
			
			g.endFill();
		}
		
		
		
	}
}