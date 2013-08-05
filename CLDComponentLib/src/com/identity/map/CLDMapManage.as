package com.identity.map
{
	import com.careland.*;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.layer.*;
	import com.careland.util.CLDConfig;
	import com.identity.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import uk.co.teethgrinder.string.StringUtils;


	public class CLDMapManage extends CLDBaseComponent
	{
		private var layer:CLDLayer=new CLDLayer();
		private var mapControl:CLDMapControl;
		private var content:CLDBaseComponent;
		private var blobs:Array=[];
		private var center:Point=new Point(114.05979, 22.543586);
		private var zoom:int=1;
		private var ID:int=2;
		private var cldMap:CLDMapContainer;
		private var points:Array;
		private var scale:Number=1; //比例
		private var ear:CLDTextArea;
		private var count:int=0;
		private var LinePosition:String="";
		public var SquareWidth:Number=35; //网格宽度 
		public var SquareHeight:Number=35; //网格高度
		private var sprite:Sprite;
		public var types:String="point"; //点的类型
		public var type:int=0; //0点线面 1//网格  2 点线面和网格
		private var xml:XML;
		private var ifFinish:Boolean;
		private var colorList:Array=new Array(); //色带
		private var polygonList:Array=[];
		private var buttonList:Array;
		private var lastClickBtnIndex:int=0;
		public var toolWidth:Number=650;
		public var timer:int=0;
		private var pointList:Array=[];
		private var pointList2:Array=[];
		private var point:CLDMarker=new CLDMarker();
		private var point2:CLDMarker=new CLDMarker();
		private var start:Boolean=false;
		private var oldPointList:String="";
		private var oldPointList2:String="";
        private var len:Number=0;
		public function CLDMapManage(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{

		}
        override public function dispose():void{
           super.dispose();
           this.layer=null;
           this.mapControl=null;
           this.content=null;
           this.blobs=null;
           this.center=null;
           this.zoom=null;
           this.ID=null;
           this.cldMap=null;
           this.points=null;
           this.scale=null;
           this.ear=null;
           this.count=null;
           this.LinePosition=null;
           this.SquareWidth=null;
           this.SquareHeight=null;
           this.sprite=null;
           this.types=null;
           this.type=null;
           this.xml=null;
           this.ifFinish=null;
           this.colorList=null;
           this.polygonList=null;
           this.buttonList=null;
           this.lastClickBtnIndex=null;
           this.toolWidth=null;
           this.timer=null;
           this.pointList=null;
           this.pointList2=null;
           this.point=null;
           this.start=null;
           this.point2=null;
           this.oldPointList=null;
           this.oldPointList2=null;
            this.len=null;
        }
		override protected function addChildren():void
		{
			layer=new CLDLayer();
			//mapControl=new CLDMapControl();
			loadConfig();
			this.addEventListener(Event.ENTER_FRAME, update);
		}

		override public function draw():void
		{
			super.draw();
			if (cldMap)
			{
				cldMap.setSize(this.width, this.height);
				//mapControl.x=(this.width - mapControl.width) / 2;
				//mapControl.y=this.height - 100;
			}
			if (!ifFinish)
			{
//				 layer=new CLDLayer();
//			     mapControl=new CLDMapControl();
//		    	 loadConfig();
			}
		}

		/**
		* 加载配置
		*/
		private function loadConfig():void
		{
			//CLDConfig.instance().configXML=XML(this.config.getItem("mapConfig"));
			configLoaded();
			ifFinish=true;
		}

		/**
		* 初始化地图
		*/
		private function configLoaded(e:Event=null):void
		{
			cldMap=new CLDTouchMapContainer(CLDConfig.instance(), center, zoom);
			cldMap.setSize(this.width, this.height);		 
			layer=cldMap.addLayer("mainLayer");
			this.addChild(cldMap);
			//this.addChild(this.mapControl);
			this.mapControl.visible=false;
			cldMap.contentEnabled=false;
			//mapControl.addEventListener("drawCircle", drawCircle);
		}

		private function drawCircle(e:Event):void
		{
			this.cldMap.dispatchEvent(e);
		}

		//给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
			switch (type)
			{
				case 1:
					loadCircleData();
					Colors(); //点线面色带
					break;
				case 2:
					drawSquareData();
					SquareColor(); //网格色带
					break;
				case 3:
					this.cldMap.zoom=1;
					drawtrack();
				default: //纯地图加载
					break;
			}
		}
      //定时加载最新点
		private function loadTrackData():void
		{

			this.loadTxt(contenturl + "?id=648", null, loadDatasComplete);

		}
		var preTime:Number=flash.utils.getTimer();
		private function loadDatasComplete(e:Event):void
		{
			var newTime:Number=flash.utils.getTimer();
			preTime=newTime;
			this.dataLoader.removeEventListener(Event.COMPLETE, loadDatasComplete);
			var url:URLLoader=e.target as URLLoader;
			if(url.data==null){
				return;
			}
			var xml:XML=XML(url.data);
			if(xml.table[1]==null){
				return;
			}
			if(xml.table[1].data[0]==null){
				return;
			
			}
			var poi:String=xml.table[1].data[0].@坐标;
			var _x:Number=poi.split(",")[0];
			var _y:Number=poi.split(",")[1];
			point.cldPoint=new Point(_x, _y);
			point.offx=-23;
			point.offy=-140;
			if(len>1){
			
			var poi2:String=xml.table[1].data[1].@坐标;
			var _x2:Number=poi2.split(",")[0];
			var _y2:Number=poi2.split(",")[1];
			point2.cldPoint=new Point(_x2, _y2);
			point2.offx=-23;
			point2.offy=-140;
			oldPointList+=_x + "," + _y + ";";
			oldPointList2+=_x2 + "," + _y2 + ";";
			}
			
			//画已经走过的线路
    
		}

		/**
		  * 画轨迹
	   */
		private function drawtrack():void
		{
			xml=XML(this.data);
			var count:int=0;
			var len:int=xml.table[2].data.length();			
			for (var i:int=0; i < len; i++)
			{
				var points:String=xml.table[0].data[i].@["坐标"];
				var obj:Object=new Object();
				obj.pointType="polyLine";
				obj.position=points;
				obj.color=xml.table[0].data[i].@["线颜色"];
				obj.width=xml.table[0].data[i].@["线宽度"];
				obj.overData="";
				obj.clikcData="";
				this.addPolyLine(obj);
			}
			len=xml.table[0].data.length();
			//第一条线
			var _points:Array=xml.table[2].data[0].@["坐标"].toString().split(";");
			for (var j:int=0; j < _points.length; j++)
			{
				if (j == 0)
				{
					point=new CLDMarker();
					point.cldPoint=new Point(_points[j].toString().split(",")[0], _points[j].toString().split(",")[1]);
					point.pointType="image";
					point.src="assets/img/torch.gif";
					point.invalidate();
					layer.addMarker(point);
				}
				this.pointList[count]=_points[j];
				count++;
			}
			//第二条线  
			if(xml.table[0].data.length()>1){
				_points=xml.table[2].data[1].@["坐标"].toString().split(";");
			  count=0;
			   for (var j:int=0; j < _points.length; j++)
			   {
				if (j == 0)
				{
					point2=new CLDMarker();
					point2.cldPoint=new Point(_points[j].toString().split(",")[0], _points[j].toString().split(",")[1]);
					point2.pointType="image";
					point2.src="assets/img/torch.gif";
					point2.invalidate();
					layer.addMarker(point2);
				}
				this.pointList2[count]=_points[j];
				count++;
			   }
			} 
			
			this.start=true;
			this.cldMap.updateLayer();
		}

		/**
		* 加载数据完成
		*/
		public function loadCircleData():void
		{
			xml=XML(this.data);
			for (var i:int=0; i < xml.table[1].data.length(); i++)
			{
				var obj:Object=new Object();
				var value:String=xml.table[1].data[i].@类型;
				obj.pointType=value;
				value=xml.table[1].data[i].@坐标;
				obj.position=value;
				value=xml.table[1].data[i].@点击时内容ID;
				obj.clikcData=value
				value=xml.table[1].data[i].@鼠标经过数据;
				var content:String=value;
				obj.overData=content.split("<br>").join("\n");
				value=xml.table[1].data[i].@标注图片;
				obj.imgpath="assets/img/basic/Site.gif"; //+value;
				switch (obj.pointType)
				{
					case "point":
						this.addMarker(obj);
						break;
					case "polyLine":
						this.addPolyLine(obj);
						break;
					case "polygon":
						this.addPolygon(obj);
						break;
				}

			}

			this.cldMap.updateLayer();

		}

		private function update(e:Event):void
		{
			timer++;
			if (this.start)
			{
				if (timer >= 100)
				{
					timer=0;
					loadTrackData();
				}
				
//			if (timer < pointList.length - 1)
//			   {	
//			   	var _x:Number=pointList[timer].split(",")[0];
//			   	var _y:Number=pointList[timer].split(",")[1];		 
//			 	    point.cldPoint=new Point(_x,_y );
//			 	    point.offx=-23;
//			 	    point.offy=-140;                
//			   }
//			   if (timer < pointList2.length - 1)
//			   {	
//			   	var _x:Number=pointList2[timer].split(",")[0];
//			   	var _y:Number=pointList2[timer].split(",")[1];		 
//			 	    point2.cldPoint=new Point(_x,_y );
//			 	    point2.offx=-23;
//			 	    point2.offy=-135;             
//			   }if(timer>=pointList.length - 1&&timer>=pointList2.length - 1){
//			   	  this.start=false;
//			   }
//			    this.cldMap.updateLayer();
//			   timer++;
			}

		}

		/**
		* 添加图层
		*/
		public function addLayer():void
		{
			var cldlayer:CLDLayer=new CLDLayer();
		}


		/**
		* 添加标注点
		*/
		protected function addMarker(obj:Object):void
		{
			var marker:CLDMarker=new CLDMarker();
			marker.cldPoint=new Point(obj.position.split(",")[0], obj.position.split(",")[1]);
			marker.addEventListener(MouseEvent.CLICK, mouse_click);
			marker.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
			marker.addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
			marker.mouseOverData=obj.overData;
			marker.mouseClickData=obj.clikcData;
			marker.pointType="image";
			marker.src=obj.imgpath;
			marker.invalidate();
			layer.addMarker(marker);
		}
		/**
		* 画线
		*/
		protected function addPolyLine(obj:Object):void
		{
			var polyline:CLDPolyLine=new CLDPolyLine();
			var pointstr:String=obj.position;
			var pointArr:Array=pointstr.split(";");
			if (count == 0)
			{
				LinePosition+=pointArr[0];
			}
			for each (var str:String in pointArr)
			{
				var sArr:Array=str.split(",");
				polyline.addPoint(new Point(Number(sArr[0]), Number(sArr[1])));
			}
			polyline.pointType=obj.pointType;
			if (obj.overData != "")
			{
				polyline.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
				polyline.addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
				polyline.mouseOverData=obj.overData;
			}
			if (obj.clikcData)
			{
				polyline.mouseClickData=obj.clikcData;
			}
			if (obj.color != "")
			{
				var color:String=obj.color;
				polyline.lineColor=parseInt("0x" + color.replace("#", ""));
			}
			if (obj.width != "")
			{
				var num:Number=obj.width;
				polyline.lineWidth=num;
			}
			polyline.invalidate();
			layer.addLine(polyline);
		}
		/**
		* 标注点鼠标悬停
		*/
		protected function mouse_over(e:MouseEvent):void
		{
			var obj:Object=e.currentTarget as Object;
			var lp:Point;
			if (obj.pointType == "point" || obj.pointType == "image")
			{
				lp=this.layer.localToGlobal(new Point(obj.x, obj.y));
			}
			else
			{
				lp=this.layer.localToGlobal(new Point(e.localX, e.localY));
			}
			ear=new CLDTextArea();
			ear.bground=true;
			ear.setSize(500, 300);

			if (ear.height < (this.height - lp.y - 30))
			{
				ear.y=lp.y + 30;
			}
			else
			{
				ear.y=lp.y - ear.height - 10;
				if (ear.y < 10)
				{
					ear.y=10;
				}
			}
			if (ear.width < (this.width - lp.x - 30))
			{
				ear.x=lp.x + 30;
			}
			else
			{
				ear.x=lp.x - ear.width - 10;
				if (ear.x < 10)
				{
					ear.x=10;
				}
			}
			if (obj.mouseOverData == "")
			{
				obj.mouseOverData="无数据可显示";
			}
			ear.data=obj.mouseOverData;
			ear.autoLoad=true;
			this.addChild(ear);
		}

		/**
		* 标注点鼠标离开
		*/
		protected function mouse_out(e:MouseEvent):void
		{
			this.removeChild(ear);
		}

		/**
		* 标注点鼠标点击
		*/
		protected function mouse_click(e:MouseEvent):void
		{
			var obj:Object=e.currentTarget as Object;
			var contentID:String=obj.mouseClickData;
			var win:CLDWindow=new CLDWindow();
			win._ifMove=true;
			var contents:Array=contentID.split(",");
			for (var i:int=0; i < contents.length; i++)
			{
				win.contentID=contents[i];
				win.autoLoad=true;
			}
			win.setSize(500, 500);
			win.x=(this.width - win.width) / 2;
			win.y=(this.height - win.height) / 2;
			this.addChild(win);
		}

		/**
		* 画面
		*/
		protected function addPolygon(obj:Object):void
		{
			var polygon:CLDPolygon=new CLDPolygon();
			var pointstr:String=obj.position;
			var pointArr:Array=pointstr.split(";");
			for each (var str:String in pointArr)
			{
				var sArr:Array=str.split(",");

				polygon.addPoint(new Point(Number(sArr[0]), Number(sArr[1])));
			}
			polygon.pointType=obj.pointType;
			polygon.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
			polygon.addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
			polygon.addEventListener(MouseEvent.CLICK, mouse_click);
			polygon.mouseOverData=obj.overData;
			polygon.mouseClickData=obj.clikcData;
			//polygon.text=dt.@text;
			//polygon.src=dt.@src;
			polygon.invalidate();
			polygonList.push(polygon);
			layer.addgon(polygon);
		}

		/**
		* 画网格
		*/
		private function drawSquareData():void
		{

			xml=XML(this.data);

			var point:Point=new Point(0, 0);
			var length:int=xml.table[1].data.length();
			var object:Object=xml.table[1].data;
			polygonList=new Array(length);
			for (var i:int=0; i < length; i++)
			{
				var polygon:CLDPolygon=new CLDPolygon();
				polygon._border=1;
				polygon.mouseOverData=object[i].@tips信息;
				polygon.mouseOverData=polygon.mouseOverData.split("<br>").join("\n").split("<br/>").join("\n");
				polygon.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				polygon.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				var pointstr:String=object[i].@坐标;
				var pointArr:Array=pointstr.split(";");
				for each (var str:String in pointArr)
				{
					var sArr:Array=str.split(",");

					polygon.addPoint(new Point(Number(sArr[0]), Number(sArr[1])));
				}
				this.addChild(polygon);
				polygon.invalidate();
				polygonList[i]=polygon;
				this.layer.addgon(polygon);
			}
			this.cldMap.updateLayer();
		}

		private function mouseOver(e:MouseEvent):void
		{
			var entity:CLDPolygon=e.currentTarget as CLDPolygon;
			entity.borderColor=0x0000FF;
			entity.invalidate();
			sprite=new Sprite();
			sprite.alpha=.9;
			var overText:TextField=new TextField();
			overText.embedFonts=true;
			overText.text=entity.mouseOverData.split("<br/>").join("\n");
			overText.x=e.stageX + 10;
			overText.y=e.stageY + 10;
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
			var entity:CLDPolygon=e.currentTarget as CLDPolygon;
			entity.borderColor=0xCCCCCC;
			entity.invalidate();
			this.removeChild(sprite);
		}

		//点线面色带数据加载       
		private function Colors():void
		{
			sprite=new Sprite();
			var _x:Number=(this.width - 300) / 2;
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xFFFFFF, 0.8);
			sprite.graphics.drawRect(_x, 0, toolWidth, 55);
			sprite.graphics.endFill();
			var text:TextField=new TextField();
			text.embedFonts=true;
			text.setTextFormat(Style.getTF());
			text.text="图例:";
			text.x=_x + 10;
			sprite.addChild(text);
			var buttonX:int=0;
			var buttonY:int=20;
			buttonList=new Array(xml.table[0].data.length());
			for (var i:int=0; i < xml.table[0].data.length(); i++)
			{
				var range:String=xml.table[0].data[i].@指标范围;
				var length:int=range.split(",").length;
				var color:CLDColorManage=new CLDColorManage(range, (toolWidth - 50) / length);
				color.colorName=xml.table[0].data[i].@指标名称;
				color.width=toolWidth - 50;
				color.height=20;
				color.x=_x + 50;
				if (i == 0)
				{
					color.visible=true;
				}
				else
				{
					color.visible=false;
				}
				var text:TextField=new TextField();
				text.text=color.colorName;
				var button:CLDButtons=new CLDButtons();
				button.setSize(text.textWidth + 30, 40);
				button.lable=color.colorName;
				button.x=_x + buttonX;
				button.dataIndex=i;
				button.y=buttonY;
				button.addEventListener(MouseEvent.CLICK, buttonClick2);
				if (buttonX >= toolWidth - 50)
				{
					buttonX=10;
					buttonY+=25;
					sprite.graphics.clear();
					sprite.graphics.beginFill(0xFFFFFF, 0.8);
					sprite.graphics.drawRect(_x, 0, toolWidth, buttonY);
					sprite.graphics.endFill();
				}
				colorList[i]=color;
				buttonList[i]=button;
				sprite.addChild(button);
				buttonX+=text.textWidth + 52;
				colorList[i]=color;
				sprite.addChild(color);

			}
			this.addChildAt(sprite, this.numChildren - 1);
		}

		//网格色带
		private function drawColor(_name:String, index):void
		{
			for (var i:int=0; i < xml.table[1].data.length(); i++)
			{
				var range:Number=xml.table[1].data[i].@[_name];
				var colorManage:CLDColorManage=colorList[index] as CLDColorManage;
				var color:int=colorManage.checkColor(range);
				var polygon:CLDPolygon=polygonList[i] as CLDPolygon;
				//  polygon.mouseOverData2="   颜色值:"+color;
				polygon.bgColor=color;

			}
			this.cldMap.updateLayer();
		}

		//点线面色带
		private function drawColor2(_name:String, index):void
		{
			for (var i:int=0; i < xml.table[2].data.length(); i++)
			{
				var range:Number=xml.table[2].data[i].@[_name];
				var colorManage:CLDColorManage=colorList[index] as CLDColorManage;
				var color:int=colorManage.checkColor(range);
				var polygon:CLDPolygon=polygonList[i] as CLDPolygon;
				polygon.bgColor=color;
			}
			this.cldMap.updateLayer();
		}

		private function buttonClick(e:MouseEvent):void
		{
			var btn:CLDButtons=buttonList[lastClickBtnIndex] as CLDButtons;
			btn.enabled=true;
			var colorManage:CLDColorManage=colorList[lastClickBtnIndex] as CLDColorManage;
			colorManage.visible=false;
			var button:CLDButtons=e.currentTarget as CLDButtons;
			button.enabled=false;
			lastClickBtnIndex=button.dataIndex;
			var colorManage2:CLDColorManage=colorList[button.dataIndex] as CLDColorManage;
			colorManage2.visible=true;
			drawColor(button.lable, button.dataIndex);
		}

		private function buttonClick2(e:MouseEvent):void
		{
			var btn:CLDButtons=buttonList[lastClickBtnIndex] as CLDButtons;
			btn.enabled=true;
			var colorManage:CLDColorManage=colorList[lastClickBtnIndex] as CLDColorManage;
			colorManage.visible=false;
			var button:CLDButtons=e.currentTarget as CLDButtons;
			button.enabled=false;
			lastClickBtnIndex=button.dataIndex;
			var colorManage2:CLDColorManage=colorList[button.dataIndex] as CLDColorManage;
			colorManage2.visible=true;
			drawColor2(button.lable, button.dataIndex);
		}

		//网格色带数据加载
		private function SquareColor():void
		{
			var sprite:Sprite=new Sprite();

			var _x:Number=(this.width - toolWidth) / 2;
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xFFFFFF, 0.8);
			sprite.graphics.drawRect(_x, 0, toolWidth - 50, 30);
			sprite.graphics.endFill();
			var text:TextField=new TextField();
			text.text="图例:";
			text.embedFonts=true;
			text.setTextFormat(Style.getTF());
			text.x=_x + 2;
			sprite.addChild(text);
			var buttonX:int=10;
			var buttonY:int=20;
			var colorName:String;
			buttonList=new Array(xml.table[0].data.length());
			for (var i:int=0; i < xml.table[0].data.length(); i++)
			{
				var range:String=xml.table[0].data[i].@指标范围;
				var length:int=range.split(",").length;
				var color:CLDColorManage=new CLDColorManage(range, (toolWidth - 100) / length);
				color.colorName=xml.table[0].data[i].@指标名称;
				color.width=toolWidth - 100;
				color.height=20;
				color.x=_x + 50;
				if (i == 0)
				{
					colorName=color.colorName;
					color.visible=true;
				}
				else
				{
					color.visible=false;
				}
				var text:TextField=new TextField();
				text.embedFonts=true;
				text.setTextFormat(Style.getTF());
				text.text=color.colorName;
				var button:CLDButtons=new CLDButtons();
				button.setSize(text.textWidth + 10, 20);
				button.lable=color.colorName;
				button.x=_x + buttonX;
				button.dataIndex=i;
				button.y=buttonY;
				button.addEventListener(MouseEvent.CLICK, buttonClick);
				sprite.addChild(button);

				buttonX+=text.textWidth + 15;
				if (buttonX >= toolWidth - 50)
				{
					buttonX=10;
					buttonY+=25;
					sprite.graphics.clear();
					sprite.graphics.beginFill(0xFFFFFF, 0.8);
					sprite.graphics.drawRect(_x, 0, toolWidth, buttonY);
					sprite.graphics.endFill();
				}
				colorList[i]=color;
				buttonList[i]=button;
				sprite.addChild(color);
			}
			drawColor(colorName, 0);
			this.addChildAt(sprite, this.numChildren - 1);
		}
	}
}

