package com.identity
{
	import com.careland.component.CLDBaseComponent;
	public class CLDWindowTitle  extends CLDBaseComponent
	{
		public function CLDWindowTitle()
		{
		}
       /***
	    * 添加子类
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
			 graphics.drawRoundRect(0,0,width-2,30,5,5);
			 graphics.endFill();	
	    }
	}
}