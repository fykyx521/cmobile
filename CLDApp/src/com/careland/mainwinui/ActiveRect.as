package com.careland.mainwinui
{
	import caurina.transitions.Tweener;
	
	import com.careland.YDTouchComponent;
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.MenuBase;
	import com.careland.component.YDViewContainer;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	import com.careland.events.DynamicEvent;
	import com.careland.remote.CLDRemoteEvent;
	import com.careland.util.ActiveRectMask;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;

	public class ActiveRect extends YDTouchComponent
	{
		

		public var menu3Tip:Bitmap;

		private var menu3Border:Bitmap;
		
		
		private var content:YDViewContainer;
		
		//public static var _WIDTH:Number=1628;//1668;  
		//public static var _HEIGHT:Number=818;
//		public static var _WIDTH:Number=1651;
//		public static var _HEIGHT:Number=830;
		
		public static var _WIDTH:Number=1920;
		public static var _HEIGHT:Number=834;//1080;
		
		private var current:Bitmap;  
	
		public var _currentW:Number=_WIDTH;
		public var _currentH:Number=_HEIGHT;
		private var over:CLDMapOverWin;
		private var contentMask:ActiveRectMask;
		public function ActiveRect() 
		{
			super();
		}
		override protected function createUI():void{
			menu3Tip=this.cldConfig.getBitmap("activetip");

			//this.addChild(menu3Tip);
			menu3Tip.alpha=0;
			menu3Tip.width=_WIDTH;
			menu3Tip.height=_HEIGHT;
		
//			menu3Tip.x=200;
//			menu3Tip.y=200;
			menu3Border=this.cldConfig.getBitmap("activeborder");
			var m3bh:Number=menu3Border.bitmapData.height;
			this.addChild(menu3Border);
//			menu3Border.height=_HEIGHT;
//			menu3Border.width=_WIDTH;
			//menu3Tip.visible=false;
			
			current=menu3Tip;
			this.addChild(current);
			
			menu3Border.alpha=0;
			content=new YDViewContainer();
			this.addChild(content);
			
			//content.x=10;
			content.x=0;
//			content.y=20;
			contentMask=new ActiveRectMask;
			contentMask.x=0;
			//this.width=1511;
			//this.height=911;
			
			content.yw=_WIDTH;
			content.yh=_HEIGHT;
			
			over=new CLDMapOverWin();
			this.addChild(over);
			over.visible=true;
			this.cldConfig.addEventListener("showDesk",showDeskHandler);
			
			this.cldConfig.addEventListener(CLDEvent.ALERTGLOBALWIN,showGlobalWin);
			this.cldConfig.addEventListener(CLDEvent.SWFCLICK,swfClick);
		}
		private function showGlobalWin(e:CLDEvent)
		{
			over.visible=true;
			over.data=e.obj.toString();
			over.x=(this.currentW-this.over.width)/2;
			over.y=(this.currentH-this.over.height)/2;
		}
		
		private function showDeskHandler(e:Event):void
		{
			this.visible=!this.visible;	
			
			this.dispatchEvent(new Event("ActiveRectVisible"));
			
		}
		private function swfClick(e:CLDEvent):void
		{
			this.visible=true;
			this.initByMenuID(e.id,String(e.obj));
		}
		
		override public function set height(value:Number):void{
			super.height=value;
			
			//Tweener.addTween(this.menu3Border,{alpha:1,time:2,onComplete:heightOver});
		}
		private function heightOver():void
		{
			//Tweener.addTween(this.menu3Border,{alpha:0,time:1});
		}
		override public function set width(value:Number):void{
			super.width=value;
		}
		
		
		public function set currentW(value:Number):void
		{
			this._currentW=value;
			this.content.yw=value;
		}
		
		public function set currentH(value:Number):void
		{
			this._currentH=value;
			this.content.yh=value;
		}
		
		public function get currentW():Number
		{
			return this._currentW;
		}
		
		public function get currentH():Number
		{
			return this._currentH;
		}
		
		public function menu1Hide():void
		{
			sizeChange(currentW,currentH+141,0);
			this.currentH=currentH+141;
			
			
		}
		public function menu1Show():void
		{
			sizeChange(currentW,currentH-141,0);
			this.currentH=currentH-141;
			
			
		}
		
		public function menu2Hide():void
		{
//			sizeChange(currentW+260,currentH);
//			this.currentW=currentW+260;
			
			
		}
		
		public function menu2Show():void
		{
			
//			sizeChange(currentW-260,currentH);
//			this.currentW=currentW-260; //260 二级菜单的宽度
		}
		
		public function hideLogohandler():void
		{
			
		 sizeChange(currentW,currentH+105);
		 this.currentH=currentH+105;
			
		}
		
		public function showLogohandler():void
		{
			sizeChange(currentW,currentH-105);
			this.currentH=currentH-105;
		}
		
		private function sizeChange(w:Number,h:Number,valpha:Number=1):void
		{
//			var newbit:ScaleBitmap=new ScaleBitmap(this.current.bitmapData);
//			newbit.setSize(w,h);
//			this.removeChild(current);
//			this.current=newbit;
//			this.addChildAt(current,0);
			current.width=w;current.height=h;
			current.alpha=valpha;
			this.menu3Border.width=current.width;
			this.menu3Border.height=current.height;
			this.setChildIndex(current,0);
		}
		
		
		
		
		public function menuTouchDown():void
		{
			if(menu3Tip.alpha!=1){
				menu3Tip.alpha=1;
				menu3Tip.visible=true;
				this.visible=true;
			}
			this.setChildIndex(menu3Tip,this.numChildren-1);
		}
		public function menuTouchUP():void
		{
			if(menu3Tip.alpha!=0){
				menu3Tip.alpha=0;
				menu3Tip.visible=false;
			}
			this.setChildIndex(menu3Tip,0);
			//Tweener.addTween(this.menu3Tip,{alpha:0,time:2});
		}
		public function dragEnter(p:Point,menu:MenuBase,isMenu1:Boolean=false):void
		{
			this.initByMenuID(menu.menuID,menu.menuName,"",isMenu1);
		}
		
		private function showEffect():void
		{
			this.content.mask=this.contentMask;
			this.addChild(this.contentMask);
			contentMask.width=this.content.width;
			contentMask.height=this.content.height;
			
			Tweener.addTween(contentMask,{x:this.content.width,onComplete:result,onCompleteParams:[false],time:3});
		}
		private function result(isEnd:Boolean):void
		{
			if(isEnd){
				this.content.mask=null;
				this.removeChild(this.contentMask);
			}else{
				contentMask.x=this.content.width;
				Tweener.addTween(contentMask,{x:10,width:this.content.width,onComplete:result,onCompleteParams:[true],time:3});
			}
			
		}
		override public function register():void
		{
			this.registerCommand(CMD.OPENCONTENT);
			this.registerCommand(CMD.SHOWDESK);
		}
		
		override public function remoteHandler(e:CLDRemoteEvent):void
		{
			var mes:Message=e.message;
		
			if(e.message.type==CMD.OPENCONTENT)
			{
				 this.initByMenuID(mes.data.menuID,mes.data.menuName,"",false);
			}
			if(e.message.type==CMD.SHOWDESK)
			{
				this.visible=e.message.data.visible;
				this.dispatchEvent(new Event("ActiveRectVisible"));
				
			}
		}
		
		//出现一个情况  一级菜单拖动没到二级菜单位置 时 可能 3级菜单代替2级 就出来了 
		//初始化 
		public function initByMenuID(menuID:int,menuName:String,param:String="",isMenu1:Boolean=false):void
		{
		     this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+menuID);

			 function resultLoadMenu(e:Event):void
			{
				
				e.target.removeEventListener(Event.COMPLETE,resultLoadMenu);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				var xml:XML=XML(e.target.data);
				var menus:XMLList=xml.data;
				if(isMenu1)
				{
					return;
				}
				if(menus.length()>0)
				{   
					var ne:CLDEvent=new CLDEvent("Menu3Show");
					ne.obj=new Object;
					ne.obj.xml=xml;
					ne.obj.menuName=menuName;
					dispatchEvent(ne);
					return;
				}else
				{
					var ne:CLDEvent=new CLDEvent("Menu3Hide");
					ne.obj=xml;
					dispatchEvent(ne);
					var procedure:String=cldConfig.getProcedure("viewconfig");
					loadProduce(loadResult,procedure,"ID="+menuID);
					
				}
			}
			
		    function loadResult(e:Event):void
			{
			    //this.cldConfig.removeLoadedListener(loadResult);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				e.target.removeEventListener(Event.COMPLETE,loadResult);
				var data:XML=XML(e.target.data);
				
				showBorder();
				content.addView(data,param);
			
			
			}
			//this.dispatchEvent(new Event("showMenu3"));
		}
		
		private function containsMenuId(menuID:String):String
		{
			return this.cldConfig.containsMenuId(menuID);
		}
		
		
		public function showBorder():void
		{
//			this.menu3Border.alpha=1;
//			this.menu3Border.visible=true;
			this.content.visible=true;
//			this.setChildIndex(menu3Border,0);
			
			
		}
		public function hideBorder():void
		{
//			this.menu3Border.alpha=0;
//			this.menu3Border.visible=false;
			this.content.visible=false;
			//Tweener.addTween(this.menu3Border,{alpha:0,time:1});
		}
		// 拖动菜单 是否进入活动区 目标对象
		public function get dragEnterTarget():DisplayObject{
			return this.menu3Tip;
		}
		
		public function resize(h:Number):void
		{
			
		}
	}
}


