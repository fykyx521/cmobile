package
{
	import com.careland.*;
	import com.careland.component.*;
	import com.careland.component.util.*;
	import com.careland.event.*;
	import com.yahoo.astra.fl.controls.*;
	import com.yahoo.astra.fl.data.*;
	import com.yahoo.astra.fl.events.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
		
		public class CLDAppMouse extends Sprite
		{
			public function CLDAppMouse()
			{
				super();
				if (stage) 
				{
					this.init();
				}
				else 
				{
					this.addEventListener(flash.events.Event.ADDED_TO_STAGE, this.init);
				}
				return;
			}
			
			public function loadProduce(arg1:Function, arg2:String, arg3:String="", arg4:Boolean=false):void
			{
				var loc1:*=encodeURI(arg2);
				var loc2:*=encodeURI(arg3);
				var loc3:*=com.careland.YDConfig.instance().produceurl;
				var loc4:*=loc3 + "?SpName=" + loc1 + "&paramsString=" + loc2 + "&" + Math.random();
				var loc5:*=new flash.net.URLRequest(loc4);
				loc5.method = "post";
				if (!this.urlLoader) 
				{
					this.urlLoader = new flash.net.URLLoader();
				}
				this.urlLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
				this.urlLoader.addEventListener(flash.events.Event.COMPLETE, arg1);
				this.urlLoader.load(loc5);
				return;
			}
			
			protected function ioError(arg1:flash.events.IOErrorEvent):void
			{
				arg1.target.removeEventListener(flash.events.IOErrorEvent, this.ioError);
				return;
			}
			
			private function init(arg1:flash.events.Event=null):void
			{
				var loc1:*=null;
				if (com.careland.YDConfig.instance().fontLoaded) 
				{
					loc1 = com.careland.YDConfig.instance().getItem("font");
					flash.text.Font.registerFont(loc1.font);
				}
				if (flash.external.ExternalInterface.available) 
				{
					flash.external.ExternalInterface.addCallback("rightClick", this.rightClick);
				}
				this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.init);
				stage.align = flash.display.StageAlign.TOP_LEFT;
				stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
				stage.addEventListener(flash.events.Event.RESIZE, this.resizeHandler);
//				this.logo = new com.careland.component.CLDMLogo();
//				this.addChild(this.logo);
				this.loadProduce(this.loadXMLComplete, "P_多点界面读取");
				return;
			}
			
			private function rightClick(arg1:Number, arg2:Number):void
			{
				var loc4:*=null;
				var loc1:*=this.mouseX;
				var loc2:*=this.mouseY;
				var loc3:*=stage.getObjectsUnderPoint(new flash.geom.Point(loc1, loc2));
				if (loc3.length > 1) 
				{
					loc4 = new com.careland.event.CLDEvent(com.careland.event.CLDEvent.rightClick);
					loc4.stageX = loc1;
					loc4.stageY = loc2;
					loc3[loc3.length - 1].dispatchEvent(loc4);
				}
				return;
			}
			
			private function resizeHandler(arg1:flash.events.Event=null):void
			{
				
				if (this.content) 
				{
					this.content.setSize(stage.stageWidth, stage.stageHeight);
				}
				if (this.menu) 
				{
					this.menu.x = 317;
					this.menu.y = 69 - 30;
				}
				return;
			}
			 
			protected function loadXMLComplete(arg1:flash.events.Event):void
			{
				var e:flash.events.Event;
				var result:XML;
				var data:XML;
				var menus:Array;
				var f1:XMLList;
				var f1data:XML;
				var i:int;
				var newXML:XML;
				var item:XML;
				var itemid:*;
				var f2data:XMLList;
				var j:*;
				var item2:XML;
				var item2id:*;
				var f3data:XMLList;
				
				var loc1:*;
				result = null;
				data = null;
				menus = null;
				f1 = null;
				f1data = null;
				i = 0;
				newXML = null;
				item = null;
				itemid = undefined;
				f2data = null;
				j = undefined;
				item2 = null;
				item2id = undefined;
				f3data = null;
				e = arg1;
				e.target.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
				e.target.removeEventListener(flash.events.Event.COMPLETE, this.loadXMLComplete);
				result = XML(e.target.data);
				
				data = result;  
				menus = [];
				var loc3:*=0;  
				var loc4:*=data.data;
				var loc2:*=new XMLList("");
				for each (var loc5:* in loc4) 
				{
					var loc6:*;
					with (loc6 = loc5) 
					{
						if (@上级ID == 0) 
						{
							loc2[loc3] = loc5;
						}
					}
				}
				f1 = loc2;
				f1data = new XML("<menus></menus>");
				i = 0;
				while (i < f1.length()) 
				{
					item = f1[i];
					itemid = item.@ID;
					loc3 = 0;
					loc4 = data.data;
					loc2 = new XMLList("");
					for each (loc5 in loc4) 
					{
						with (loc6 = loc5) 
						{
							if (@上级ID == itemid) 
							{
								loc2[loc3] = loc5;
							}
						}
					}
					f2data = loc2;
					item.appendChild(f2data);
					j = 0;
					while (j < f2data.length()) 
					{
						item2 = f2data[j];
						item2id = item2.@ID;
						loc3 = 0;
						loc4 = data.data;
						loc2 = new XMLList("");
						for each (loc5 in loc4) 
						{
							with (loc6 = loc5) 
							{
								if (@上级ID == item2id) 
								{
									loc2[loc3] = loc5;
								}
							}
						}
						f3data = loc2;
						item2.appendChild(f3data);
						++j;
					}
					++i;
				}
				f1data.appendChild(f1);
				this.menu = new com.yahoo.astra.fl.controls.MenuBar(this);
				this.menu.labelField = "@菜单名称";
				newXML = XML("<menus>" + f1.toString() + "</menus>");
				this.menu.dataProvider = new com.yahoo.astra.fl.data.XMLDataProvider(f1data);
				this.menu.addEventListener(com.yahoo.astra.fl.events.MenuEvent.ITEM_CLICK, this.itemClick);
				this.content = new com.careland.component.CLDViewContent();
				this.content.setSize(stage.stageWidth, stage.stageHeight);
				this.addChildAt(this.content, 0);
				com.careland.component.util.Alert.init(stage);
				return;
			}
			
			private function itemClick(arg1:com.yahoo.astra.fl.events.MenuEvent):void
			{
				var loc1:*=undefined;
				var loc2:*=null;
				if (!arg1.item.children) 
				{
					loc1 = 1203;//arg1.item.ID;
					loc2 = "P_FT_根据菜单ID获取窗口信息_Interface";
					this.loadProduce(this.loadResult, loc2, "ID=" + loc1);
				}
				return;
			}
			
			private function loadResult(arg1:flash.events.Event):void
			{
				arg1.target.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
				arg1.target.removeEventListener(flash.events.Event.COMPLETE, this.loadResult);
				var loc1:*=XML(arg1.target.data);
				this.content.addView(loc1, "");  
				return;  
			}
			
			private var menu:com.yahoo.astra.fl.controls.MenuBar;
			
//			private var logo:com.careland.component.CLDMLogo;
			  
			private var urlLoader:flash.net.URLLoader;
			
			private var urlLoader1:flash.net.URLLoader;
			
			private var content:com.careland.component.CLDViewContent;
		
	

	}
}