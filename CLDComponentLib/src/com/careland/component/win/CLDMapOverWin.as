package com.careland.component.win
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class CLDMapOverWin extends CLDBaseComponent
	{
		public var overText:TextField;
		public function CLDMapOverWin(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		private function clickHandler(e:MouseEvent):void
		{
			this.visible=false;	
		}
		override protected function addChildren():void
		{
			   overText=new TextField();
			   overText.selectable=false;
			   overText.multiline=true;
			   overText.wordWrap=false;
			   overText.embedFonts=true;
			  
		       this.addChild(overText);
		}
		
		override public function set data(value:*):void
		{
			super.data=value;
			
			this.overText.text=String(value).split("<br>").join("\n").split("<br/>").join("\n").split("<br />").join("\n");	
			overText.setTextFormat(Style.getTF());
			overText.width=this.overText.textWidth+15;
			overText.height=this.overText.textHeight+15;
			this.setSize(overText.width,overText.height);
			//this.invalidate();
		}
		
		override public function draw():void
		{
			if(overText){
				overText.width=this.overText.textWidth+15;
			}
			try{
				var g:Graphics=this.graphics;
			g.clear();
			g.lineStyle(2,0x000333,.2);
			g.beginFill(0xFFFFFF,.7);
		    g.drawRect(0,0,overText.width,overText.height);
		    g.endFill();	
			}catch(e:Error){
				
			}
			
		}
		override public function dispose():void
		{
			super.dispose();
			this.graphics.clear();
			overText=null;
		}
		
		
		
		
	}
}