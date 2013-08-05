package com.identity
{
	import com.careland.component.CLDBaseComponent;
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.*;

	/**
	* Flex窗体封装类
	*
	* author: 程斌斌 (2011-3-29)
	**/
	public class MyWin extends CLDBaseComponent
	{

	     
		 private var sprite:Sprite
		 private var image:Bitmap;
         private var loader:Loader;
         private var text:TextField;
         private var closeGraphics:Graphics;
         private var closeText:TextField;
         /**
         * 标题内容
         */ 


		
		/**
		* 标题内容
		*/

		public var _title:String="";
		/**
		*是否可以关闭
		*/
		public var _ifclose:Boolean=true;
		/**
		* 是否可拖拽
		*/
		public var _ifMove:Boolean=true;
		/**
		* 是否可以最大化
		*/
		public var _ifMax:Boolean=false;
		/**
		* 是否可以最小化
		*/
		public var _ifMin:Boolean=false;

  		/**
		* 页面主体内容
		*/
		public var _content:Sprite=new Sprite();
		/**
		 * 构造函数  
		 */
		/**
		 * 判断图片是否加载完成
		 */
		private var isLoad:Boolean=false;
		/**
		 * 判断关闭文本是否加载完成
		 */
		private var ifCloseText:Boolean=false;

		public function MyWin()
		{
			super();
		}

	    /***
	    * 添加子类
	    * 
	    ***/
	    override protected function addChildren():void
	    {
	    	     setTitle();
		        //画关闭按钮  
		        setCloseBtn();	
		        //设置窗体内容     
		        this.addChild(_content);         
		 	    this.buttonMode=true;	
		 	    setColseBtnText();		 	    
		 	    sprite=new Sprite();
		 	    this.addChild(sprite);	
	    }
	    override public function draw():void
	    {
	    	super.draw();	 
	    	//判断标题是否加载   	
	    	if(this.text){
	    		text.text=_title;
	    		text.width=width-15;  	  
		    }
		    //判断关闭图片是否加载
	    	if(isLoad){
	    		loader.x=width-16;
	    		loader.y=-2;
	    		loader.visible=true;
	    	}
	    	//判断内容是否加载
	    	 if(sprite){
	    	 	  sprite.graphics.lineStyle(0.3,0x000000);		   	    			    
			      sprite.graphics.drawRect(width-28 , 24 , 27 , 15);  
			      sprite.graphics.endFill();	
			       sprite.visible=false;  	     	      
	    	 }
	    	 //判断关闭文本是否加载
	    	 if(ifCloseText){
	    	 	 closeText.x=width-29;
	    	 }	 
	    	     //画标题背景	     
			      graphics.beginFill(0x66FFFF,1);  			    
			      graphics.drawRoundRect(0,0,width,40,10,10);
			      graphics.endFill();			      			     
			     //画内容背景 
	    	      graphics.beginFill(0xFFFFFF,1);  			    
			      graphics.drawRect(0,15,width,height);
			      graphics.endFill();   	
	    }
	    
		


		

		
		/**
		* 画关闭按钮
		**/
		private function setCloseBtn():void
		{
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			var request:URLRequest=new URLRequest("../images/closeMouseover.png");
			loader.x=width - 8;
			//loader.load(request);
			loader.visible=false;
			this.addChild(loader);
		}

		/**
		* 图片加载完成
		**/
		private function completeHandler(event:Event):void
		{
			loader=Loader(event.target.loader);
			loader.addEventListener(MouseEvent.CLICK, closeBtnClick);
			loader.addEventListener(MouseEvent.MOUSE_OVER, closeBtn_mouseOver);
			loader.addEventListener(MouseEvent.MOUSE_OUT, closeBtn_mouseOut);
			isLoad=true;
			this.invalidate();
		}
		/**
		 *
		 * 关闭按钮点击事件
		 */
		private function closeBtnClick(ev:MouseEvent):void
		{
			graphics.clear(); //清理面板
			this.removeChild(_content);
			this.removeChild(text); //移除内容 
			this.removeChild(loader);
			this._content.graphics.clear();
		}

		/**
		*
		* 关闭按钮鼠标悬停事件
		*
		*/
		private function closeBtn_mouseOver(ev:MouseEvent):void
		{
			closeText.visible=true;
			sprite.visible=true;
		}

		/**
		*
		* 关闭按钮提示文本
		*/
		private function setColseBtnText():void
		{

			closeText=new TextField();
			closeText.text="关闭";
			closeText.selectable=false;
			closeText.height=20;
			closeText.defaultTextFormat=new TextFormat();
			closeText.defaultTextFormat.size=20;
			closeText.y=23;
			closeText.width=30;
			closeText.visible=false;
			this.addChild(closeText);
			ifCloseText=true;
		}

		/**
		* 关闭按钮鼠标离开事件
		*/
		private function closeBtn_mouseOut(ev:MouseEvent):void
		{
			closeText.visible=false;
			sprite.visible=false;
		}

		/**
		 *
		 * 填充标题
		 */
		private function setTitle():void
		{
			text=new TextField();
			text.text=_title;
			text.selectable=false;
			text.defaultTextFormat=new TextFormat();
			text.defaultTextFormat.size=20;
			text.x=0;
			text.addEventListener(MouseEvent.MOUSE_DOWN, title_mouseDown);
			text.addEventListener(MouseEvent.MOUSE_UP, title_mouseUp);
			this.addChild(text);
		}

		/**
		  * 标题鼠标mouseDown事件
		  */
		private function title_mouseDown(event:MouseEvent):void
		{
			if (_ifMove)
			{
				this.startDrag();
			}
		}

		private function title_mouseUp(event:MouseEvent):void
		{
			if (_ifMove)
			{
				this.stopDrag();
			}
		}

		/**
		* 标题的鼠标悬停事件
		*/
		public function title_mouseOver(event:MouseEvent):void
		{
			//Mouse.hide();	//这里改变鼠标样式 	        
		}

		/**
		*
		* 鼠标离开事件
		*/
		public function title_mouseOut(event:MouseEvent):void
		{
			//这里改变鼠标样式
		}

	}
}
