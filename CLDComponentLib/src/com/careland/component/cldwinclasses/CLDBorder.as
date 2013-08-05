package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;

	public class CLDBorder extends CLDBaseComponent
	{
		
		private var leftTop:Bitmap;
		private var leftBottom:Bitmap;
		private var rightTop:Bitmap;
		private var rightBottom:Bitmap;
		
		private var left:Bitmap;
		private var right:Bitmap;
		private var top:Bitmap;
		private var bottom:Bitmap;
		
		private var gap:int=20;
		private var lineGap:int=12;
		public function CLDBorder()
		{
			super();
		}
		override protected function addChildren():void
		{
			  this.leftTop=new Bitmap(this.config.getBitmap("w_lefttop").bitmapData.clone());
			  this.leftBottom=new Bitmap(this.config.getBitmap("w_leftbottom").bitmapData.clone());
			  this.rightTop=new Bitmap(this.config.getBitmap("w_righttop").bitmapData.clone());
			  this.rightBottom=new Bitmap(this.config.getBitmap("w_rightbottom").bitmapData.clone());
			  
			  
			  this.left=new Bitmap(this.config.getBitmap("w_left").bitmapData.clone());
			  this.right=new Bitmap(this.config.getBitmap("w_right").bitmapData.clone());
			  this.top=new Bitmap(this.config.getBitmap("w_top").bitmapData.clone());
			  this.bottom=new Bitmap(this.config.getBitmap("w_bottom").bitmapData.clone());
			  
			  
			  this.addChild(leftTop);
			  this.addChild(leftBottom);
			  this.addChild(rightTop);
			  this.addChild(rightBottom);
			  
			  this.addChild(left);
			  this.addChild(right);
			  this.addChild(top);
			  this.addChild(bottom);
		}
		
		override public function draw():void
		{
			/*
			var g:Graphics=this.graphics;
			g.clear();
			try{
				g.lineStyle(1,0x000000,1);
				g.drawRoundRect(0,0,width,height,10,10);
				g.endFill();	
			}catch(e:Error){
				
			}
			
			*/
			if(left)
			{
				left.y=lineGap;
				left.height=this.height-lineGap*2;
			}
			if(right)
			{
				right.x=this.width-lineGap;
				right.y=lineGap;
				right.height=this.height-lineGap*2;
			}
			if(top)
			{
				top.x=lineGap;
				top.width=this.width-lineGap*2;
			}
			if(bottom)
			{
				bottom.x=lineGap;
				bottom.y=this.height-lineGap;
				bottom.width=this.width-lineGap*2;
			}
			if(this.leftBottom)
			{
				this.leftBottom.y=this.height-20;
			}
			if(this.rightTop)
			{
				this.rightTop.x=this.width-20;
			}
			if(this.rightBottom)
			{
				this.rightBottom.x=this.width-20;
				this.rightBottom.y=this.height-20;
			}
			
			
		} 
		
		override public function dispose():void{
			super.dispose();
			this.graphics.clear();
			if(this.leftTop)
			{
				this.leftTop.bitmapData.dispose();
				leftTop=null;
			}
			if(this.leftBottom)
			{
				this.leftBottom.bitmapData.dispose();
				leftBottom=null;
			}
			if(this.rightTop)
			{
				this.rightTop.bitmapData.dispose();
				rightTop=null;
			}
			if(this.rightBottom)
			{
				this.rightBottom.bitmapData.dispose();
				rightBottom=null;
				
			}
		}
	}
}