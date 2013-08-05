package com.identity
{
		import com.careland.component.CLDBaseComponent;	
	/**
	 * 标签切换
	 * 
	 * author:chengbb
	 */ 
	public class CLDTabPage extends CLDBaseComponent
	{
		public function CLDTabPage()
		{
		}
		 
		 
         /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	    	
	    	 
	    }
	    /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{
			super.draw();	
			//设置上边宽
			graphics.beginFill(0x333333, 1);
			graphics.drawRoundRect(0,0,width,40,10,10);
			graphics.endFill();
			
		}
		 
	}
}