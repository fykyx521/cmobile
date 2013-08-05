package com.careland.mainwinui
{
	import caurina.transitions.Tweener;
	
	import com.careland.*;
	import com.careland.command.CMD;
	import com.careland.component.YDBitmapTouchButton;
	import com.careland.component.YDDateWeather;
	import com.careland.event.LogoEvent;
	import com.careland.remote.CLDRemoteEvent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class Logo extends YDTouchComponent
	{
		
		private var isLoad:Boolean=false;
//		[Embed(source='assets/title/hideTitle.png')]
//		private var hideTitleCls:Class;
		
		private var hideTitleBmp:Bitmap;
		
//		[Embed(source='assets/title/hideTitleDown.png')]
//		private var hideTitleDownCls:Class
		private var hideTitleDownBmp:Bitmap;
		
		private var showTitleBtn:YDBitmapTouchButton;
		
		private var hideTitleBtn:YDBitmapTouchButton;
	
		
//		[Embed(source='assets/title/showTitle.png')]
//		private var showTitleCls:Class;
		
		private var showTitleBmp:Bitmap;
		
//		[Embed(source='assets/title/showTitleDown.png')]
//		private var showTitleDownCls:Class
		private var showTitleDownBmp:Bitmap;
		
		//点击时的坐标
		private var preDownPoint:Point;
		private var isMove:Boolean=false;
		
		private var _currentState:String="show";
		
		private var hideSprite:Sprite;
		
		
		
		
		private var txt:TextField;
		  
		private var wtxt:YDDateWeather;
		
		public function Logo()
		{
			super();
		}
		override protected function createUI():void{
			//hideTitleBmp=new hideTitleCls() as Bitmap;
			//hideTitleDownBmp=new hideTitleDownCls as Bitmap;
			
			hideTitleBmp=this.cldConfig.getBitmap("logoshow");
			hideTitleDownBmp=hideTitleBmp;
			hideTitleBtn=new YDBitmapTouchButton(hideTitleBmp,hideTitleDownBmp);
			
			hideTitleBtn.visible=false;
			//showTitleBmp=new showTitleCls() as Bitmap;
			//showTitleDownBmp=new showTitleDownCls as Bitmap;
			
			showTitleBmp=this.cldConfig.getBitmap("logohide");
			showTitleDownBmp=showTitleBmp;
			
			showTitleBtn=new YDBitmapTouchButton(showTitleBmp,showTitleDownBmp);
			
			
			var logo:Bitmap=this.cldConfig.getBitmap("logo");
			var logoTxt:Bitmap=this.cldConfig.getBitmap("logoTxt");
			var logoImg:Bitmap=this.cldConfig.getBitmap("logoImg");
			this.addChild(logo);
			this.addChild(logoTxt);
			this.addChild(logoImg);
			//天气
			//weather=this.cldConfig.getBitmap("weather");
			wtxt=new YDDateWeather();  
			this.addChild(wtxt);
			//this.addChild(weather);
			
			this.addChild(hideTitleBtn);
			this.addChild(showTitleBtn);
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.showTitleBtn.visible=false;
			showTitleBtn.addEventListener(TUIOEvent.TUIO_DOWN, showTitleDown, false, 0, true);	
			
			
			
			this.layoutUI();
			
//			var rect:Rectangle=this.wtxt.getBounds(wtxt);
//			var g:Graphics=this.graphics;
//			g.beginFill(0xff2211,1);
//			g.drawRect(rect.x,rect.y,rect.width,rect.height);
//			g.endFill();
		}
		
//		override protected function loadComplete(e:Event):void
//		{
//			var bit:Bitmap=e.target.content;
//			this.addChildAt(bit,0);
//			
//		}
		
		override protected function layoutUI():void{
			hideTitleBtn.x=1550;
			hideTitleBtn.y=32;
			
			showTitleBtn.x=0;
			showTitleBtn.y=105;
//			showTitleBtn.x=1550;
//			showTitleBtn.y=105;
			
			
		}
		private function downHandler(e:TUIOEvent):void
		{
			Tweener.removeTweens(this);
			preDownPoint=new Point(e.localX,e.localY);
			this.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
		}
		private function moveHandler(e:TUIOEvent):void
		{
			var newPoint:Point=new Point(e.localX,e.localY);
			var disPoint:Point=newPoint.subtract(this.preDownPoint);
			if(Math.abs(disPoint.y)>20){
				this.isMove=true;
			}
		}
		
		private function set currentState(v:String):void
		{
			this._currentState=v;
			if(v=="show"){
				Tweener.addTween(this,{y:0,transition:"easeOutBounce",time:.5,onComplete:tshowEnd});
				//hideSprite.visible=false;
				//
				this.dispatchEvent(new LogoEvent(LogoEvent.SHOW));
				
				
			}else if(v=="hide"){
				Tweener.addTween(this,{y:-105,transition:"easeinoutback",time:.5,onComplete:thideEnd});
				this.removeEventListener(TUIOEvent.TUIO_DOWN,downHandler);
				this.dispatchEvent(new LogoEvent(LogoEvent.HIDE));
				hideEnd();
			}
		}
		//效果完成后
		private function tshowEnd():void
		{
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.showTitleBtn.visible=false;
		}
		private function thideEnd():void
		{
			this.showTitleBtn.visible=true;
		}
		private function get currentState():String
		{
			return this._currentState;
		}
		
		private function upHandler(e:TUIOEvent):void
		{
			this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			this.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
			if(!this.isMove){
				return;
			}
			
			var newPoint:Point=new Point(e.localX,e.localY);
			
			var disPoint:Point=newPoint.subtract(this.preDownPoint);
			if(disPoint.y<20&&this.currentState=="show"){
				this.currentState="hide";
				
			}
			if(disPoint.y>20&&this.currentState=="hide"){
				this.currentState="show";
			
			}
			preDownPoint=new Point(e.localX,e.localY);
			this.isMove=false;
		}
		
		private function hideEnd():void
		{
			if(!hideSprite){
//				hideSprite=new Sprite;
//				this.addChild(hideSprite);
//				
//				//hideSprite不再绘制
//				var g:Graphics=hideSprite.graphics;
//				g.beginFill(0xffffff,0);
//				g.drawRect(0,0,sw,100);
//				g.endFill();
//				hideSprite.y=140;
			}
//			hideSprite.visible=true;
			
			
			
		}
		
		
		
		
		private function hideOver():void
		{
			
		}
		private function showTitleDown(e:TUIOEvent):void
		{
			this.currentState="show";
		}
		
		public function hide():void
		{
			 if(this._currentState!="hide")
			 {
				 this.currentState="hide";
			 }
		}
		public function show():void
		{
			if(this._currentState!="show")
			{
				this.currentState="show";
			}
		}
		override public function register():void
		{
			this.registerCommand(CMD.LOGOHIDE);
			this.registerCommand(CMD.LOGOSHOW);
		}
		
		override public function remoteHandler(e:CLDRemoteEvent):void
		{
			  
			
			  switch(e.message.type)
			  {
				  case CMD.LOGOHIDE:this.hide();break;
				  case CMD.LOGOSHOW:this.show();break;
			  }
			 
		}
		
		
		
		
		
	}
}