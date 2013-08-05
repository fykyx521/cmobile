package com.touchlib
{
	import caurina.transitions.Tweener;
	
	
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class TUIOCursor extends Sprite
	{
		private var DEBUG_TEXT:TextField;	
		
		public function TUIOCursor(debugText:String)
		{
			super();
			if(TUIO.debugMode){
				// Draw us the lil' circle
				graphics.lineStyle(1,0x000000,0.6);
				//graphics.beginFill(0x000fff,0.6);
				graphics.drawCircle(0 , 0, 6);

					// Add textfield for debugging, shows the cursor id
					/*
				if (debugText != '' || debugText != null)
				{
					var format:TextFormat = new TextFormat();
					DEBUG_TEXT = new TextField();
		        	format.font = 'Verdana';
		     		format.color = 0xFFFFFF;
		       	 	format.size = 10;
					DEBUG_TEXT.defaultTextFormat = format; 
					DEBUG_TEXT.autoSize = TextFieldAutoSize.LEFT;
					DEBUG_TEXT.background = true;	
					DEBUG_TEXT.backgroundColor = 0x000000;	
					DEBUG_TEXT.border = true;	
					DEBUG_TEXT.text = '';
					DEBUG_TEXT.appendText(' '+debugText+'  ');
					
					DEBUG_TEXT.x = 8;
					DEBUG_TEXT.y = -13;  
					
					addChild(DEBUG_TEXT);
				}*/
		
			}
			else
			{
			// hide cursor
			}	
			//Tweener.addTween(this,{time:2,alpha:0,onComplete:onAlphaEnd});
		}	
		
		private function onAlphaEnd():void{
			if(this.alpha>0.5){
				Tweener.addTween(this,{time:2,alpha:0,onComplete:onAlphaEnd});
			}else{
				Tweener.addTween(this,{time:2,alpha:1,onComplete:onAlphaEnd});
			}
		}	
	}
}