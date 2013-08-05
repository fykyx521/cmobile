package com.careland.mainwinui
{
	import caurina.transitions.Tweener;
	
	import com.careland.YDTouchComponent;
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.MenuBase;
	import com.careland.component.YDBitmapTouchButton;
	import com.careland.component.YDMenu2Item;
	import com.careland.event.TipEvent;
	import com.careland.remote.CLDRemoteEvent;
	import com.careland.tuio.TUIOSwipeY;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Menu3Level extends YDTouchComponent
	{
		public function Menu3Level()
		{
			super();
		}
		
		public var menu2Tip:Bitmap;
		
		private var menu2Border:Bitmap;
		
		private var content:TUIOSwipeY;
		private var contentMask:Sprite;
		
		private var prePoint:Point;
		private var isMove:Boolean=false;//是否移动了
		
		
		private var leftDefaultBmp:Bitmap;
		
		
		private var leftDefaultDownBmp:Bitmap;
		
		private var leftBtn:YDBitmapTouchButton;
		
		private var _currentState:String="show";
		private var hideSprite:Sprite;//隐藏的sprite.用于菜单后显示时用
		private var current:Bitmap;
		
		private var blobs:Array=[]; 
		
		//默认宽高
		public var WIDTH:Number=250;
		public var HEIGHT:Number=818;
		
		private var txt:TextField;
		private var _tempMenuName:String=""; //菜单名称
		override protected function createUI():void{
			
			menu2Tip=new Bitmap(this.cldConfig.getBitmap("menu2tip").bitmapData.clone());
			
			menu2Tip.alpha=0;  
			menu2Tip.width=menu2Tip.width+20;
			
			menu2Border=new Bitmap(this.cldConfig.getBitmap("menu2border").bitmapData.clone());
			this.addChild(menu2Border);
			menu2Border.alpha=0;
			
			current=menu2Tip;
			
			this.addChild(current);
			
			txt=new TextField();
			txt.defaultTextFormat=new TextFormat("msyh",24,0xffffff);
			txt.embedFonts=true;
			txt.selectable=false;
			this.addChild(txt);
			txt.width=WIDTH;
			txt.height=50;
			
			var btn:Bitmap=this.cldConfig.getBitmap("menu3tipbutton");
			leftBtn=new YDBitmapTouchButton(btn,btn);
			leftBtn.visible=false;
			leftBtn.x=-53;
			leftBtn.y=this.HEIGHT-260;
			this.addChild(leftBtn);
			
			content=new TUIOSwipeY();
			var cg:Graphics=content.graphics;
			cg.beginFill(0x000000,0);
			cg.drawRect(0,50,WIDTH,HEIGHT-50);
			cg.endFill();
			content.x=8;
			content.y=50;
			this.addChild(content);
			
			contentMask=new Sprite();
			var g:Graphics=contentMask.graphics;
			g.beginFill(0xffffff,1);
			g.drawRect(0,0,WIDTH,HEIGHT-60);
			g.endFill();
			//			contentMask.x=20;
			contentMask.y=50; 
			content.mask=contentMask;
			this.addChild(contentMask);
			//this.addChild(leftBtn);
			initHideSprite();

			
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
			
			this.addEventListener(TipEvent.SHOW_BORDER,showBorderHandler);
			this.addEventListener(TipEvent.HIDE_BORDER,hideBorderHandler);
			this.addEventListener(TipEvent.SHOW_TIP,showTipHandler);
			this.addEventListener(TipEvent.HIDE_TIP,hideTipHandler);
			
			leftBtn.addEventListener(MouseEvent.CLICK,leftBtnClick);
			leftBtn.visible=false;
			
			this.cldConfig.addEventListener("menu2new",menu2New);
			//this.addEventListener(TUIOEvent.TUIO_DOWN,leftBtnClick);
			//this.addEventListener(TUIOEvent.TUIO_DOWN,leftBtnClick);
			
//			/this.hideBorder();
		//	this.menu2Border.alpha=0;
			
			//初始化不显示
		}
		
		private function menu2New(e:Event):void
		{
			 this.visible=false;
		}
		
		private function showBorderHandler(e:Event):void
		{
			this.current.alpha=1;
			
		}
		private function hideBorderHandler(e:Event):void
		{
			this.current.alpha=0;
		}
		private function showTipHandler(e:Event):void
		{
			if(menu2Tip.alpha!=1){
				menu2Tip.alpha=1;
			}
			this.setChildIndex(menu2Tip,this.numChildren-1);
		}
		private function hideTipHandler(e:Event):void
		{
			if(menu2Tip.alpha!=0){
				menu2Tip.alpha=0;
			}
			this.setChildIndex(menu2Tip,0);
		}
		
		
		private function initHideSprite():void
		{
			if(!this.hideSprite){
				hideSprite=new Sprite();
//				var g:Graphics=hideSprite.graphics;
//				g.beginFill(0xffffff,0);
//				g.drawRect(0,0,100,HEIGHT);
//				g.endFill();
				hideSprite.x=-100;
				hideSprite.y=100;
				this.addChild(hideSprite);
//				this.hideSprite.visible=false;
			}
		}
		public function getTargetPoint():void
		{
			
		}
		private function leftBtnClick(e:Event):void
		{
			leftBtn.visible=false;
			this.currentState="show";
		}
		private function menu2downHandler(e:TUIOEvent):void
		{
			for(var i:int=0;i<this.blobs.length;i++){
				if(blobs[i].id==e.ID){
					return;
				}
			}
			blobs.push({id:e.ID});
			prePoint=new Point(e.localX,e.localY);
			
			this.addEventListener(TUIOEvent.TUIO_MOVE,menu2moveHandler);
			this.addEventListener(TUIOEvent.TUIO_UP,menu2upHandler);
			
//			content.addEventListener(TUIOEvent.TUIO_MOVE,menu2moveHandler);
//			content.addEventListener(TUIOEvent.TUIO_UP,menu2upHandler);
			//因为2级菜单隐藏后 ，content 不能出发事件
			
		}
		
		
		private function menu2moveHandler(e:TUIOEvent):void
		{
			
			if(!prePoint){
				return;
			}
			var newPoint:Point=new Point(e.localX,e.localY);
			
			var disPoint:Point=newPoint.subtract(prePoint);
			if(Math.abs(disPoint.x)>100){
				isMove=true;
			}  
		}
		private function set currentState(value:String):void{
			this._currentState=value;
			if(value=="show"){
				Tweener.addTween(this,{x:sw-500,time:1,transition:"easeOutBounce"});
				this.dispatchEvent(new Event("menu3Show"));
				leftBtn.visible=false;
				Tweener.addTween(this.content,{y:50,time:.5});
				
			}else if(value=="hide"){
				Tweener.addTween(this,{x:this.sw,time:1,transition:"easeinback",onComplete:hideEnd});
				this.dispatchEvent(new Event("menu3Hide"));
				//hideEnd();
				
			}
		}
		
		//初始化 隐藏 第2级菜单 
		public function menu2Hide():void
		{
			this.currentState="hide";
		}
		private function hideEnd():void
		{
			hideSprite.visible=true;
			leftBtn.visible=true;
			if(content&&content.numChildren==0)
			{
				leftBtn.visible=false; 
			}
			//new
		
			//new
		}
		private function get currentState():String{
			return _currentState;
		}
		//只有2个手指才能触发事件
		private function menu2upHandler(e:TUIOEvent):void
		{
			
			content.removeEventListener(TUIOEvent.TUIO_MOVE,menu2moveHandler);
			content.removeEventListener(TUIOEvent.TUIO_UP,menu2upHandler);
			
			this.removeEventListener(TUIOEvent.TUIO_MOVE,menu2moveHandler);
			this.removeEventListener(TUIOEvent.TUIO_UP,menu2upHandler);
			
			if(!this.isMove&&this.blobs.length<2){
				return;
			}
			for(var i:int=0;i<this.blobs.length;i++){
				if(blobs[i].id==e.ID){
					blobs.splice(i,1);
				}
			}
			
			
			var newPoint:Point=new Point(e.localX,e.localY);
			var disPoint:Point=newPoint.subtract(prePoint);
			if(disPoint.x>100&&this.currentState=="show"){
				this.currentState="hide";
//				this.addEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
//				content.removeEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
				trace("add");
			}else if(disPoint.x<-40&&this.currentState=="hide"){
				this.currentState="show";
				this.hideSprite.visible=false;
//				this.removeEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
//				content.addEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
				trace("remove");
			}
			prePoint=new Point(e.localX,e.localY);
			this.isMove=false;
		}
		
		override protected function updateUI():void{
			
		}
		
		public function show():void
		{
			if(this.currentState!="show")
			{
				this.currentState="show";
			}
		}
		public function hide():void
		{
			if(this.currentState!="hide")
			{
				this.currentState="hide";
			}
		}
	
		public function addMenu(menuConfig:XML,menuName:String=""):void{
			if(!this.visible) this.visible=true;
			_tempMenuName=menuName;
			txt.text=_tempMenuName;
			txt.x=(WIDTH-txt.textWidth)/2;
			txt.y=10;
			while(this.content.numChildren>0){
				
				var dis:DisplayObject=content.removeChildAt(0);
				if(dis is Bitmap){
					Bitmap(dis).bitmapData.dispose();
					dis=null;
				}
			}
			this.menu2Border.alpha=1;
			var menus:XMLList=menuConfig.data;
			for(var i:int=0;i<menus.length();i++){
				var ydWin:YDMenu2Item=new YDMenu2Item();
				ydWin.menuID=menus[i].@ID;  
				ydWin.menuName=menus[i].@菜单名称;
				ydWin.url=menus[i].@菜单图片;  
				ydWin.level=3; 
				ydWin.alpha=0;
				ydWin.x=50;
				content.addChild(ydWin);
				
				ydWin.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
				ydWin.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			}
			
			showEffect();
		}
		
		
		public function showLogohandler():void
		{
//			var newbit:ScaleBitmap=new ScaleBitmap(this.current.bitmapData);
//			newbit.setSize(this.WIDTH,this.HEIGHT);
//			this.removeChild(current);
//			this.current=newbit;
//			this.addChildAt(current,0);
//			this.current.width=this.WIDTH;this.current.height=this.HEIGHT;
//			changeMask(this.HEIGHT);
//			this.setChildIndex(current,0);
			
		}
		
		public function hideLogohandler():void
		{
			
//			var newbit:ScaleBitmap=new ScaleBitmap(this.current.bitmapData);
//			newbit.setSize(WIDTH,HEIGHT+145);
//		
//			this.removeChild(current);
//		
//			this.current=newbit;
//			this.addChildAt(current,0);
//			current.width=WIDTH-105;
//			current.height=HEIGHT+105;
//			changeMask(HEIGHT+105);
//			this.setChildIndex(current,0);
		}
		public function menu1Hide():void
		{
			
			
//			current.width=WIDTH;
//			current.height=HEIGHT+145;
//			changeMask(HEIGHT+145);
//			this.setChildIndex(current,0);
//			this.current.alpha=0;
		}
		public function menu1SHow():void
		{
			
//			current.width=WIDTH;
//			current.height=HEIGHT;
//			this.setChildIndex(current,0);
//			changeMask(this.HEIGHT);
//			this.current.alpha=0;
			
		}
		
		
		
		public function changeMask(value:Number):void
		{
			var g:Graphics=contentMask.graphics;
			g.clear();
			g.beginFill(0xffffff,1);
			g.drawRect(0,0,WIDTH,value);
			g.endFill();
			
			var cg:Graphics=content.graphics;
			cg.clear();
			cg.beginFill(0x000000,0);
			cg.drawRect(0,0,WIDTH,value);
			cg.endFill();
			
		}
		
		private function downHandler(e:TUIOEvent):void
		{
			
		}
		private function upHandler(e:TUIOEvent):void
		{
			
		}
		
		private function showEffect():void
		{
			var h:Number=0;
			content.y=50;
			for(var i:int=0;i<content.numChildren;i++){
				var dis:DisplayObject=content.getChildAt(i);
				dis.alpha=1;
				dis.x=0;
				
			//	dis.width=330;
			//	dis.height=220;
				dis.y=i*135;
				h=dis.y;
			}
			var num:int=content.numChildren;
			var disY:int=num%4;
			content.top=-(h-disY);
			content.bottom=(225*4);
			Tweener.addTween(this.content,{alpha:1,time:2});
			
		}
		public function menuTouchDown():void
		{
			this.dispatchEvent(new TipEvent(TipEvent.SHOW_TIP));
			
			//Tweener.addTween(this.menu2Tip,{alpha:1,time:2});
		}
		public function menuTouchUP():void
		{
			this.dispatchEvent(new TipEvent(TipEvent.HIDE_TIP));
			
			//Tweener.addTween(this.menu2Tip,{alpha:0,time:1});
			
		}
		public function dragEnter(menuid:int):void
		{
			
			this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+menuid);
			//this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+menuid);
			//this.cldConfig.loadProduce(
			//var str:String="<params><param name='T_菜单查询' args='父ID="+menuid+"'></param></params>"
			//this.loadTxt("../AjaxServer.aspx",str,resultLoadMenu);
			//Tweener.addTween(this.menu2Border,{alpha:1,time:1});
			
			
		}
		private function resultLoadMenu(e:Event):void
		{
			
			e.target.removeEventListener(Event.COMPLETE,resultLoadMenu);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			var xml:XML=XML(e.target.data);
			this.addMenu(xml);
			this.disposeXML(xml);
		}
		public function showBorder():void
		{
			
			this.dispatchEvent(new TipEvent(TipEvent.SHOW_BORDER));//,showBorderHandler);
			
			//Tweener.addTween(this.menu2Border,{alpha:1,time:1});
		}
		public function hideBorder():void
		{
			this.dispatchEvent(new TipEvent(TipEvent.HIDE_BORDER));
			//Tweener.addTween(this.menu2Border,{alpha:0,time:1});
		}
		// 拖动菜单 是否进入活动区 目标对象
		public function get dragEnterTarget():DisplayObject{
			return this.menu2Tip;
		}
		public function resize(h:Number):void
		{
			
		}
		override public function register():void
		{
			this.registerCommand(CMD.OPENMENU3);
			this.registerCommand(CMD.MENUMOVE);
			this.registerCommand(CMD.HIDEMENU3);
			this.registerCommand(CMD.SHOWMENU3);
		}
		override public function remoteHandler(e:CLDRemoteEvent):void
		{
			//flash.external.ExternalInterface.call("console.log",e.message.type);
			
			if(e.message.type==CMD.OPENMENU3)
			{
				this.currentState="show";
				var mes:Message=e.message;
				var data:*=mes.data;
				this.addMenu(XML(data));
			}
			if(e.message.type==CMD.MENUMOVE)
			{
				if(e.message.data.type==3)
				{
					Tweener.addTween(this.content,{y:e.message.data.y,time:.5});
				}
			}
			if(e.message.type==CMD.HIDEMENU3)
			{
				this.hide();
			}
			if(e.message.type==CMD.SHOWMENU3)
			{
				this.show();
			}
		}
		
		
	}
}