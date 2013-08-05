package com.careland.util
{
	import flash.text.TextField;

	public class CLDUtil
	{
		public function CLDUtil()
		{
			
		}
		
		public static function truncateToFit(text:TextField,truncationIndicator:String,
											 truncateWidth:Number,measuredTextSize:Number):Boolean
		{
			
			var originalText:String = text.text;
			
			var w:Number = truncateWidth;
			
			var _isTruncated:Boolean = false;
			
			// Need to check if we should truncate, but it
			// could be due to rounding error.  Let's check that it's not.
			// Examples of rounding errors happen with "South Africa" and "Game"
			// with verdana.ttf.
			
			//if (originalText != "")
			if (originalText != "")
			{
				// This should get us into the ballpark.
				var s:String = originalText;
				
				// TODO (rfrishbe): why is this here below...it does nothing (see SDK-26438)
				//originalText.slice(0,
				//    Math.floor((w / (textWidth + TEXT_WIDTH_PADDING)) * originalText.length));
				
				while (s.length > 1)
				
				{
					s = s.slice(0, -1);
					text.text = s + truncationIndicator;
					
				}
				
				_isTruncated = true;
				text.scrollH = 0;
			}
			
			return _isTruncated;
		}
	}
}