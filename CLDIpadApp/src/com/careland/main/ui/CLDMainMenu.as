package com.careland.main.ui
{
	
	import com.careland.YDConfig;
	import com.careland.component.CLDStateButton;
	import com.careland.main.events.CLDMainEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	public class CLDMainMenu extends CLDBaseUI
	{
		
		[Embed(source="../assets/menuback.png")]
		private var menuback:Class;//背景
		private var menuBit:Bitmap;
		[Embed(source="../2012113191345/trash.png")]
		private var trash:Class;
		
		[Embed(source="../2012113191345/showDesk.png")]
		private var showDesk:Class;
		
		[Embed(source="../2012113191345/showDeskA.png")]
		private var showDeskA:Class;
		
		private var deskBit:SimpleButton;
		
		private var menu:CLDMenu;
		
		private var maptool:CLDStateButton;
		private var maptype:CLDStateButton;
		public function CLDMainMenu()
		{
			super();
		}
		override protected function addChildren():void
		{
			menuBit=new menuback as Bitmap
			this.addChild(menuBit);
			this.addChild(new trash as Bitmap);
			deskBit=new SimpleButton(new showDesk,new showDeskA,new showDeskA);
			this.addChild(deskBit);
			
			//地图工具
			maptool=new CLDStateButton();
			var maptoolbit=this.cldConfig.getBitmap("maptool");
			var maptooldown=this.cldConfig.getBitmap("maptooldown");
			maptool.setBit(maptoolbit,maptooldown);
			this.addChild(maptool);
			
			maptool.addEventListener(MouseEvent.CLICK,maptoolClick);
			//地图类型
			maptype=new CLDStateButton();
			var maptypebit=this.cldConfig.getBitmap("maptype");
			var maptypedown=this.cldConfig.getBitmap("maptypedown");
			maptype.setBit(maptypebit,maptypedown);
			this.addChild(maptype);
			
			maptype.addEventListener(MouseEvent.CLICK,maptypeClick);
			this.initMapTypeUI();//因为打开地图后 maptype接受不到事件地图SetLocation事件 所以不能延迟实例化
			this.mapTypeUI.visible=false;
			menu=new CLDMenu();
			this.addChild(menu);
			menu.type=1;
			
			deskBit.addEventListener(MouseEvent.CLICK,deskHandler);

			this.loadProduce(loadXMLComplete,cldConfig.getProcedure("menuconfig"),
				"userid:"+this.cldConfig.userID);
		}
		private function deskHandler(e:Event):void
		{
			this.cldConfig.dispatchEvent(new CLDMainEvent(CLDMainEvent.SHOWDESK));
		}
	    protected function loadXMLComplete(e:Event):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,super.ioError);
			e.target.removeEventListener(Event.COMPLETE,loadXMLComplete);
			var result:XML=XML(e.target.data);
			data=result;
		}
		override protected function dataChange():void
		{
			var config:XMLList=this.data.data;
			this.menu.data=config;
		}
		
		private var mapToolUI:CLDMapTool;
		private var mapTypeUI:CLDMapType;
		
		private function initMapTypeUI():void
		{
			if(!mapTypeUI){
				mapTypeUI=new CLDMapType(); 
				mapTypeUI.pressSp=maptype;
				this.addChild(mapTypeUI);
				mapTypeUI.x=this.deskBit.x+60-360;//
				mapTypeUI.y=-140;
			}
		}
		
		private function maptoolClick(e:MouseEvent):void
		{
			this.maptool.press=!this.maptool.press;
			if(this.maptool.press)
			{
				if(!mapToolUI){
					mapToolUI=new CLDMapTool(); 
					mapToolUI.pressSp=maptool;
					this.addChild(mapToolUI);
					mapToolUI.x=maptool.x-150;//
					mapToolUI.y=-140;
				}
				mapToolUI.visible=true;
				if(this.mapTypeUI)
				{
					this.mapTypeUI.visible=false;
					this.maptype.press=false;
				}
			}else
			{
				if(this.mapToolUI)
					this.mapToolUI.visible=false;
			}
		}
		
		private function maptypeClick(e:MouseEvent):void
		{
			this.maptype.press=!this.maptype.press;
			if(this.maptype.press)
			{
				if(!mapTypeUI){
					initMapTypeUI();
				}
				mapTypeUI.visible=true;
				if(this.mapToolUI)
				{
					this.mapToolUI.visible=false;
					this.maptool.press=false;
				}
			}else
			{
				if(this.mapTypeUI)
					this.mapTypeUI.visible=false;
			}
		}
		override public function draw():void
		{
			 if(this.deskBit)
			 {
				 deskBit.x=this.width-60;
			 }
			 if(maptype)
			 {
				 maptype.x=this.deskBit.x-120;
			 }
			 if(mapTypeUI)
			 {
				 mapTypeUI.x=this.deskBit.x+60-360;//
			 }
			 if(maptool)
			 {
				 maptool.x=this.maptype.x-120;
			 }
			 if(menu)
			 {
				 menu.x=145;
				 menu.setSize(1455,135);
			 }
			 if(menuBit)
			 {
				 menuBit.width=this.width;
			 }
		}
		
	}
}