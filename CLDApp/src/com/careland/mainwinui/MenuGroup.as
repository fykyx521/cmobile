


package com.careland.mainwinui
{
	import caurina.transitions.Tweener;
	
	import com.careland.YDConfig;
	import com.careland.YDTouchComponent;
	import com.careland.component.YDMenu;
	import com.careland.tuio.TUIOSwipe;
	import com.careland.tuio.TUIOSwipeX;
	import com.careland.tuio.TUIOSwipeY;
	import com.touchlib.TUIOEvent;
	import com.careland.remote.CLDRemoteEvent;
	import com.careland.command.CMD;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	
	

	public class MenuGroup extends YDTouchComponent
	{
		

		
//		private var leftDefaultBmp:Bitmap;
//		
//		private var leftDefaultDownBmp:Bitmap;
//		
//		private var leftBtn:YDBitmapTouchButton;
//		
//		private var rightBtn:YDBitmapTouchButton;
//	
//
////		
//		private var rightDefaultBmp:Bitmap;
//
//		private var rightDefaultDownBmp:Bitmap;
		
		private var backBitmap:Bitmap;//背景条
		
		private var _data:XML;
		
		private var _url:String;//dataURL;
		private var content:TUIOSwipe//中间菜单内容
		
		private var contentMask:Sprite;
		
		private var leftT:uint;
		private var rightT:uint;
		
		public var menuLocation:String;
		
		public function MenuGroup()
		{
			super();
			this.menuLocation=YDConfig.instance().uiConfig.@一级菜单位置;
//			leftDefaultBmp=this.cldConfig.getBitmap("menuleft0");
//			leftDefaultDownBmp=this.cldConfig.getBitmap("menuleftdown0");
//
//			rightDefaultBmp=this.cldConfig.getBitmap("menuright0");
//			rightDefaultDownBmp=this.cldConfig.getBitmap("menurightdown0");
	//		backBitmap=this.cldConfig.getBitmap("menuback");
			
			this.url=YDConfig.instance().ajaxURL;
		}
		public function set data(v:XML):void{
			this._data=v;
			this.createUI();  
			this.disposeXML(_data);
			layoutUI();
		}
		public function set url(v:String):void
		{
			this._url=v;
			this.loadProduce(loadXMLComplete,YDConfig.instance().getProcedure("menuconfig"),
				"userid:"+this.cldConfig.userID);
			//YDConfig.instance().loadProduce(loadXMLComplete,YDConfig.instance().getProcedure("menuconfig"),"&userid:"+this.cldConfig.userID)+"");
			
		}
		override protected function loadXMLComplete(e:Event):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,super.ioError);
			e.target.removeEventListener(Event.COMPLETE,loadXMLComplete);
			
			var result:XML=XML(e.target.data);
			data=result;
			
			if(flash.external.ExternalInterface.available)
			{
				//flash.external.ExternalInterface.call("test","存储过程"+result);
			}
			
			
		}
		override protected function createUI():void{
			if(!this._data){
				return;
			}
			
			
			
			
//			leftBtn=new YDBitmapTouchButton(leftDefaultBmp,leftDefaultDownBmp);
//			rightBtn=new YDBitmapTouchButton(rightDefaultBmp,rightDefaultDownBmp);
			
			
			
			//this.addChild(backBitmap);
			//this.addChild(leftBtn);
			//this.addChild(rightBtn);
			
			
			if(this.menuLocation=="下"){
				content=new TUIOSwipeX;
			}else{
				content=new TUIOSwipeY;
			}
			
			
			updateMask();
			content.mask=contentMask;
			
			this.addChild(content);
			
			this.addChild(contentMask);
			var config:XMLList=this._data.data;
			for(var i:int=0;i<config.length();i++){
				var imgPath:String=config[i].@菜单图片;
				var imgPathSel:String=config[i].@点击菜单图片;  
				//imgPath="assets/test/yw.png";  
				trace("---------------------------------------"+config[i].@ID);
				var ydMenu:YDMenu=new YDMenu(imgPath,imgPathSel,config[i].@ID,config[i].@菜单名称);
				content.addChild(ydMenu);
			}
import caurina.transitions.Tweener;

import com.careland.command.CMD;
import com.careland.remote.CLDRemoteEvent;
			
			
			this.updateContent(config.length());
			
			
//			leftBtn.addEventListener(TUIOEvent.TUIO_DOWN,leftTabHandler);
//			rightBtn.addEventListener(TUIOEvent.TUIO_DOWN,rightTabHandler);

		}
		
		protected function leftTabHandler(e:TUIOEvent):void
		{
			if(this.menuLocation=="下"){
				Tweener.addTween(content,{x:content.x-200,time:2});
			}else{
				Tweener.addTween(content,{y:content.y-200,time:2});
			}
			
		}
		protected function rightTabHandler(e:TUIOEvent):void
		{
			if(this.menuLocation=="下"){
				Tweener.addTween(content,{x:content.x+200,time:2});
			}else{
				Tweener.addTween(content,{y:content.y+200,time:2});
			}
		}
		
		private function updateMask():void
		{
			if(!contentMask){
				contentMask=new Sprite();
			}
			var cg:Graphics=contentMask.graphics;
			//cg.clear();
			cg.beginFill(0xfff000,1);
			if(this.menuLocation=="下"){
				cg.drawRect(0,0,1455,135);
//				cg.drawRect(0,0,1600,135);
			}else{
				cg.drawRect(0,0,135,1455);
			}
			cg.endFill();  
			
		}
		public function updateContent(menuNum:int):void
		{
			var ctg:Graphics=content.graphics;
			//ctg.clear();
			ctg.beginFill(0x000fff,0);
			if(this.menuLocation=="下"){
				ctg.drawRect(0,0,menuNum*200,135);
			}else{
				ctg.drawRect(0,0,135,menuNum*200);
			}
			
			ctg.endFill();
		}
	
		//获取菜单的全局坐标
		
		override protected function updateUI():void{
			super.updateUI();
		}
		override protected function layoutUI():void{
			super.layoutUI();
			
			if(this.menuLocation=="下"){
//				this.leftBtn.x=187;
//				leftBtn.y=5;
//			
//				this.rightBtn.x=1920-142;
//				this.rightBtn.y=5;
			
				content.x=0;
				contentMask.x=0;
			
			
				var j:int=0;
				for(var i:int=0;i<content.numChildren;i++){
					content.getChildAt(i).x=j;
					j+=145;
				}
				var num:int=content.numChildren;
			
				var dis:int=num%9;
				var ct:int=num/9;
				content.left=-(j-dis*145);
				content.right=145*(content.numChildren+1);
				
				
			//content.right=(j-dis*150);
			//content.left=(ct-1)*(8*150)+(dis-1)*150;
				trace(content.left+"left");
			//content.right=0;
			}else{
//				this.leftBtn.x=30;
//				leftBtn.y=5;
//			
//				this.rightBtn.x=30;
//				this.rightBtn.y=1080-142-70;
//				
				
				content.x=5;
				content.y=75;
				
				contentMask.x=5;
				contentMask.y=75;
				
				var j:int=0;
				for(var i:int=0;i<content.numChildren;i++){
					content.getChildAt(i).y=j;
					j+=150;
				}
				var dis:int=num%9;
				var ct:int=num/9;
				content.top=-(j-dis*150);
				content.bottom=15500;
				var num:int=content.numChildren;
			}
		}
		override public function register():void
		{
			this.registerCommand(CMD.MENUMOVE);
		}
		override public function remoteHandler(e:CLDRemoteEvent):void
		{
			if(e.message.type==CMD.MENUMOVE)
			{
				if(e.message.data.type==1)
				{
					Tweener.addTween(this.content,{x:e.message.data.x,time:.5});
				}
			}
		}
		
	}
}