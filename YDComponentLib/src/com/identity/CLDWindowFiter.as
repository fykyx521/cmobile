package com.identity
{
	import com.careland.component.CLDBaseComponent;
	public class CLDWindowFiter  extends CLDBaseComponent
	{
		public function CLDWindowFiter()
		{
		}
       /***
	    * 添加内容背景
	    * 
	    ***/
	    override protected function addChildren():void
	    {
	    }
	    
	      override public function draw():void
	    {
	    	super.draw();	
	    	 graphics.clear();
	    	 graphics.beginFill(0xFFFFFF,1);  			    
			 graphics.drawRoundRect(1,16,width-2,height-17,5,5);
			 graphics.endFill();	
	    }
	}
}