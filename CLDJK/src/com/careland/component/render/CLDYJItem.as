package com.careland.component.render
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDYJItem extends CLDBaseComponent
	{
		public function CLDYJItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
		}
		
		
		
		public function setSelected(isSelected:Boolean):void
		{
			var tf:TextFormat=new TextFormat();
			//tf.color="black";
			if(isSelected)
			{
				tf.font="微软雅黑 常规";
				tf.size=12;
				tf.color=0x000fff;
				tf.underline=true;
			}else
			{
				tf.color=0x000000;
				tf.underline=false;  
			}
			for(var i:int=0;i<this.numChildren;i++)
			{
				var txt:TextField=this.getChildAt(i) as TextField;
				if(txt)
				{
					
//					txt.defaultTextFormat=tf;
					txt.setTextFormat(tf);
				}
			}
		}
		public var columnRealWidth:Array;
		
		public var truncateIndex:int;
		
		public var gap:Number=5;
		override public function draw():void
		{
			if(data)
			{
				while(this.numChildren>0)
				{
					this.removeChildAt(0);
				}
				
				for(var i:int=1;i<this.data.items.length;i++)  
				{
					var txt:TextField=new TextField();
					txt.multiline=false;
					txt.background=false;
					txt.selectable=false;
					txt.wordWrap=false;
					txt.defaultTextFormat=new TextFormat("msyh",12,0x000000);
					//txt.embedFonts=true;
					//txt.htmlText="<a href=''>"++"</a>"
					//txt.text=
					this.addChild(txt);
					txt.x=data.position[i];
					
					var txtWidth:Number=txt.textWidth+5;
					
					var colWidth:Number=columnRealWidth[i];
					
					//txt.width=colWidth;  
					var txtStr:String=data.items[i];
					
					
					if(truncateIndex==i)
					{
						if(txtWidth>colWidth-gap*2)
						{
							truncateToFit(txtStr,colWidth,txt);
						}
						
  
					}
					txt.width=colWidth;
					txt.text=txtStr;
				}
			}
		}
		
		public function tranfit(txt:String):String
		{
			if(txt.length>6)
			{
				txt=txt.substr(0,txt.length-20)+"..."; 
			}
			return txt;
		}
		
		private var _isTruncated:Boolean=true;
		
		public function truncateToFit(text:String,colWidth:Number,txt:TextField,truncationIndicator:String = "..."):String
		{
			
			
			var originalText:String = text;
			var oldIsTruncated:Boolean = _isTruncated;
			var w:Number = colWidth;
			
			
			_isTruncated = false;
			
			// Need to check if we should truncate, but it
			// could be due to rounding error.  Let's check that it's not.
			// Examples of rounding errors happen with "South Africa" and "Game"
			// with verdana.ttf.
			
			if (originalText != "" && txt.textWidth > w + 0.00000000000001)
			{
				// This should get us into the ballpark.
				var s:String = originalText;
				
				// TODO (rfrishbe): why is this here below...it does nothing (see SDK-26438)
				//originalText.slice(0,
				//    Math.floor((w / (textWidth + TEXT_WIDTH_PADDING)) * originalText.length));
				
				while (s.length > 1 && (txt.textWidth > w))
				{
					s = s.slice(0, -1);
					text = s + truncationIndicator;
					txt.text=text;
					
				}
				
				_isTruncated = true;
				
				
				// Make sure all text is visible
				
			}
			
			
			
			return text;
		}
		
		
	}
}