package com.identity.map
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class CLDColorBround extends CLDBaseComponent
	{
		public function CLDColorBround(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		private var bulkLoader:BulkLoader;
		private var leftTopRange:Bitmap;
		private var rightTopRange:Bitmap;
		private var downLeftRange:Bitmap;
		private var downRightRange:Bitmap;
		private var bground:Bitmap;
		private var topBorder:Bitmap;
		private var downBorder:Bitmap;
		private var rightBorder:Bitmap;
		private var leftBorder:Bitmap;
		  override  public function dispose():void{
		  	 super.dispose();
		  	 this.bulkLoader=null;
		  	 this.leftTopRange=null;
		  	 this.rightTopRange=null;
		  	 this.downLeftRange=null;
		  	 this.downRightRange=null;
		  	 this.bground=null;
		  	 this.topBorder=null;
		  	 this.downBorder=null;
		  	 this.rightBorder=null;
		  	 this.leftBorder=null;
		  }
		override protected function addChildren():void
		{
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}		
			this.addEventListener(Event.RESIZE, resize);	
			build();	 
		}
        override public function draw():void
		{
			  
		}
		public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}
		private function resize(e:Event):void{
		   if(leftBorder){
		      	reload();
		   }
		}
		private function reload():void{		 
		  //左上角圆角
		   this.leftTopRange.width=11;
		   this.leftTopRange.height=10;	 
		   //上边框
		    topBorder.width=this.width-22;
		    topBorder.height=1;
		    topBorder.x=11;
		   //右上角圆角
		     rightTopRange.x=this.width-11;
		     rightTopRange.height=10;
		     rightTopRange.width=11;
		   //左边框
		      leftBorder.height=this.height-20;
		      leftBorder.width=10;
		      leftBorder.y=10;
		    //左下角圆角
		       downLeftRange.y=this.height-10;
		       downLeftRange.width=11;
		       downLeftRange.height=11;
		    //下边框
		      downBorder.y=this.height-1;
		      downBorder.height=1;
		      downBorder.width=this.width-22;
		      downBorder.x=11;
		     //右下角圆角 
		      downRightRange.y=this.height-11;
		      downRightRange.x=this.width-11;
		      downRightRange.width=11;
		      downRightRange.height=11; 
		      //右边框
		        rightBorder.x=this.width-11;
		        rightBorder.width=11;
		        rightBorder.height=this.height-21;
		        rightBorder.y=10;
		     //背景
		       bground.width=this.width-22;
		       bground.x=11;
		       bground.height=this.height-2;
		       bground.alpha=0.5;
		       bground.y=1; 
		   
		}
		private function build():void{
		   leftTopRange=new Bitmap();
		   leftTopRange.bitmapData=getBitmap("color_leftTopRange").bitmapData;	
	
		   this.addChild(leftTopRange);
		   
		   rightTopRange=new Bitmap();
		   rightTopRange.bitmapData=getBitmap("color_rightTopRange").bitmapData;
		   rightTopRange.width=11;
		   rightTopRange.height=10;
		   this.addChild(rightTopRange);
		   
		   downLeftRange=new Bitmap();
		   downLeftRange.bitmapData=getBitmap("color_downLeftRange").bitmapData;
		   downLeftRange.width=11;
		   downLeftRange.height=11;
		   this.addChild(downLeftRange);
		   
		   downRightRange=new Bitmap();
		   downRightRange.bitmapData=getBitmap("color_downRightRange").bitmapData;
		   downRightRange.width=11;
		   downRightRange.height=11;
		   this.addChild(downRightRange);
		   
		   topBorder=new Bitmap();
		   topBorder.bitmapData=getBitmap("color_topBorder").bitmapData;	
		   topBorder.height=1;	
		   topBorder.x=11;   
		   this.addChild(topBorder);
		   
		   rightBorder=new Bitmap();
		   rightBorder.bitmapData=getBitmap("color_rightBorder").bitmapData;
		   rightBorder.width=11;
		   rightBorder.y=10;
		   this.addChild(rightBorder);
		   
		   leftBorder=new Bitmap();
		   leftBorder.bitmapData=getBitmap("color_leftBorder").bitmapData;
		   leftBorder.width=11;
		   leftBorder.y=10;
		   this.addChild(leftBorder);
		   
		   downBorder=new Bitmap();
		   downBorder.bitmapData=getBitmap("color_downBorder").bitmapData;
		   this.addChild(downBorder);
		   
		   bground=new Bitmap();
		   bground.bitmapData=getBitmap("color_bground").bitmapData;
		   this.addChild(bground);
		}
	}
}