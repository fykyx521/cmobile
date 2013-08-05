package com.careland.main.ui.item
{
	
	
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	
	import com.careland.component.util.Style;
	import com.careland.main.events.CLDMenuEvent;
	import com.careland.main.ui.CLDBaseUI;
	
	import flash.desktop.Icon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public class CLDMenuItem extends CLDBaseUI
	{
		private var text:TextField;
		private var loader:Loader;
		private var config:XML;
		public var menuId:int;
		public var menuName:String;
		public var type:int;
		[Embed(source="assets/qycx.png")]
		private var icon:Class;
		
		[Embed(source="assets/hjcd.png")]
		private var icon2:Class;
		
		private var iconImg:Bitmap;
		private var _direction:Boolean;//方向 true 是纵向
		public function CLDMenuItem()
		{
			super();
		}
		override protected function addChildren():void
		{
			text=new TextField();
			text.selectable=false;
			text.width=150;
			text.embedFonts=false;
			
			text.y=110;
			this.addChild(text);
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError0);
			iconImg=new Bitmap();
			this.addChild(iconImg);
			//this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			this.doubleClickEnabled=true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,this.clickHandler);
			
		}
		private var prePoint:Point;
		private function downHandler(e:Event):void
		{
			prePoint=new Point(this.mouseX,this.mouseY);
			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE,upHandler);
		}
		private function moveHandler(e:Event):void
		{
			var np:Point=new Point(this.mouseX,this.mouseY);
			if(this.direction)
			{
				  if(this.prePoint.x-this.mouseX>50)
				  {
					  this.clickHandler();
				  }
			}else
			{
				 if(this.prePoint.y-this.mouseY>50)
				 {
					 this.clickHandler();
				 }
			}
		}
		private function upHandler(e:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,upHandler);
		}
		
		private function clickHandler(e:MouseEvent=null):void
		{
			 var me:CLDMenuModel=new CLDMenuModel();
			 me.menuID=this.menuId;
			 me.menuName=this.menuName;
			 me.menuType=this.type;
			 var cme:CLDMenuEvent=new CLDMenuEvent(CLDMenuEvent.MENUCLICK);
			 cme.menuModel=me;
			 this.cldConfig.dispatchEvent(cme);
		}
		override public function draw():void
		{
			 
		}
		override protected function dataChange():void
		{   
			config=XML(this.data);
			var imgPath:String=config.@菜单图片;
			var imgPathSel:String=config.@点击菜单图片;  
			menuId=config.@ID;
			menuName=this.config.@菜单名称
			this.text.text=menuName;
			text.setTextFormat(Style.getTFF());
			//this.addChild(new icon as Bitmap);
			//loader.load(new URLRequest(imgPath));
		}
		
		override public function disponse():void
		{
			if(loader)
			{
				loader.unload();
				loader=null;
			}
			text=null;
		}
		
		
		//public function set direction(value:)
		//如果是纵向 显示纵向的图片
		public function changeIcon(bit:Boolean):void
		{
			  this.iconImg.bitmapData=(new icon as Bitmap).bitmapData;
			  text.width=150;
			  if(bit)
			  {
				  text.width=240;
				  text.setTextFormat(Style.getTFF());
				  this.iconImg.bitmapData=(new icon2 as Bitmap).bitmapData;
			  }
		}
		//图片加载完成
		private function complete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			this.addChild(e.target.content as Bitmap);
			
		}
		private function ioError0(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		}

		public function get direction():Boolean
		{
			return _direction;
		}

		public function set direction(value:Boolean):void
		{
			_direction = value;
			this.changeIcon(value);
		}

	}
}