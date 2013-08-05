package com.identity.intelSingleNode
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDTextField;
	import com.careland.component.CLDWindowAdapter;
	import com.careland.component.util.Style;
	import com.careland.event.CLDEvent;
	import com.identity.CLDTextArea;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.*;

	public class CLDSingleNode extends CLDBaseComponent
	{
		//	private var loadURL:String="assets/paipai.xml";
		//	private var xmlLoader:URLLoader;
		private var ear:CLDTextArea;
		private var sprite:Sprite;
		private var xml:XML;
		private var bit:Bitmap;
		private var adpter:CLDWindowAdapter;
		private var Xscale:Number=1; //横向比例尺
		private var Yscale:Number=1; //纵向比例尺
		private var list:Array;
		private var object:Object;

		public function CLDSingleNode(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{

		}
        override  public function dispose():void{
          this.ear=null;
          this.sprite=null;
          this.xml=null;
          this.bit=null;
          this.adpter=null;
          this.Xscale=null;
          this.Yscale=null;
          this.list=null;
          this.object=null;
        }
		//给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
			build();
			loadBground();
		}



		private function build():void
		{

			// this.Xscale=this.width/1000;
			//  this.Yscale=this.height/600;
			var g:Graphics=this.graphics;
			xml=XML(this.data);
			var xmllist:XMLList=xml.table[1].data;
			list=new Array(xmllist.length());
			for (var i:int=0; i < xmllist.length(); i++)
			{
				
				var dataXML:XML=xmllist[i];
				object=initObject(dataXML);			
				object.zoom=xml.table[0].data[0].@["地图级别"];
				object.centerX=xml.table[0].data[0].@["centerX"];
				object.centerY=xml.table[0].data[0].@["centerY"];
				var entity:CLDEntity=new CLDEntity(object);
				if (object.mouseOverData != "")
				{
					entity.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
					entity.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				}if(object.windowID!=""){
					entity.addEventListener(MouseEvent.CLICK, mouseClick);
				}
				
				this.addChild(entity);
				list[i]=entity;
			}
		}

		private function initObject(_xml:XML):Object
		{
			var object=new Object();
			var dataXML:XML=_xml;
			object.nameID=dataXML.@["NameID"];
			object.title=dataXML.@["友好名称"];
			object.bground=dataXML.@["图片路径"];
			object.borderColor=dataXML.@["边框颜色"];
			object.bgroundColor=dataXML.@["填充颜色"];
			object.mouseOverData=dataXML.@["鼠标经过数据"];
			object.alpha=dataXML.@["透明度"];
			if(object.alpha==""){
				object.alpha="50";
			}
			object.warnColor=dataXML.@["告警颜色"];
			object.warnMouseOverData=dataXML.@["告警Tips内容"];
			object.warnMouseClickData=dataXML.@["告警弹出窗信息"];
			object.windowID=dataXML.@["弹出窗信息"];
			object.width=dataXML.@["宽度"];
			object.height=dataXML.@["高度"];
			object.pointType=dataXML.@["坐标类型"];
			object.type=dataXML.@["类型"];
			object.Xscale=this.Xscale;
			object.Yscale=this.Yscale;
			object.point=dataXML.@["坐标"];
			return object;
		}

		private function mouseClick(e:Event):void
		{
			var obj:CLDEntity=e.currentTarget as CLDEntity;
			var event:CLDEvent=new CLDEvent(CLDEvent.ALERTWIN);
			    event.mouseClickData=obj.windowID;
			   this.dispatchEvent(event);
//			var entity:CLDEntity=e.currentTarget as CLDEntity;
//			if (adpter)
//				this.removeChild(adpter);
//			adpter=new CLDWindowAdapter();
//			adpter.windowID=entity.windowID;
//			adpter.autoLoad=true;
//			adpter.setSize(500, 500);
//			adpter.x=(this.width - 500) / 2;
//			adpter.y=(this.height - 500) / 2;
//			this.addChild(adpter);
		}

		private function mouse_over(e:MouseEvent):void
		{
			var entity:CLDEntity=e.currentTarget as CLDEntity;
			sprite=new Sprite();
			sprite.alpha=.9;
			var overText:TextField=new CLDTextField();
			overText.embedFonts=true;
			overText.text=entity.mouseOverData.split("<br>").join("\n").split("<br/>").join("\n");
			if (entity.bit != null)
			{
				overText.x=entity.bit.x + entity.bit.width;
				overText.y=entity.bit.y + entity.bit.height;
			}
			else
			{
				overText.x=entity._point1.x;
				overText.y=entity._point1.y;
			}

			overText.setTextFormat(Style.getTF());
			overText.width=400;
			overText.height=200;
			sprite.addChild(overText);
			sprite.graphics.beginFill(0xFFFFFF, 1);
			sprite.graphics.drawRect(overText.x, overText.y, overText.width, overText.height);
			sprite.graphics.endFill();
			this.addChildAt(sprite, this.numChildren - 1);

		}

		private function mouseOut(e:MouseEvent):void
		{
			if (sprite && this.contains(sprite))
			{
				this.removeChild(sprite);
			}

			//graphics.clear();
		}

		private function loadBground():void
		{
			var xmllist:XMLList=xml.table[0].data;
			var imgPath:String=xmllist[0].@["拓扑图背景"];
			if (imgPath != "")
			{
				var request:URLRequest=new URLRequest(imgPath);
				var loader:Loader=new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error);
				loader.load(request);
			}
		}

		private function error(e:IOErrorEvent):void
		{

		}
          
		/**
		* 加载图片完成
		*/
		private function complete(e:Event):void
		{
			var bit:Bitmap=e.target.content;
			bit.x=0;
			bit.y=0;
			bit.width=bit.width * this.Xscale;
			bit.height=bit.height * this.Yscale;
			this.addChildAt(bit, 0);
			// this.addChild(bit);	     	 		
		}

	}
}