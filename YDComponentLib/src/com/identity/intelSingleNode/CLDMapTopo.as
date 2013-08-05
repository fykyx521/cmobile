package com.identity.intelSingleNode
{
	import com.careland.layer.CLDLayer;
	import com.identity.CLDMap;
	import com.identity.map.CLDMapManage;
	
	import flash.display.DisplayObjectContainer;

	public class CLDMapTopo extends CLDMapManage
	{
		private var map:CLDMap;
		private var layer:CLDLayer;
		private var entity:Object;

		public function CLDMapTopo(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}

		override protected function addChildren():void
		{
			map=new CLDMap();
			//map.setSize(this.width,this.height);
			this.addChild(map);
			map.mouseEnb=true;

		}
       override public function dispose():void
		 {
		 	super.dispose();
		 	this.map=null;
		 	this.layer=null;
		 	this.entity=null;		 	
		 }
		override public function draw():void
		{
			map.setSize(this.width, this.height);
			if (data && dataChange)
			{
				this.dataChange=false;
				var xml=XML(this.data);
				var xmllist:XMLList=xml.table[1].data;
				for (var i:int=0; i < xmllist.length(); i++)
				{

					var dataXML:XML=xmllist[i];
					entity=initObject(dataXML);
					entity.point=dataXML.@["坐标"];
					entity.zoom=xml.table[0].data[0].@["地图级别"];
					entity.centerX=xml.table[0].data[0].@["centerX"];
					entity.centerY=xml.table[0].data[0].@["centerY"];
					var obj:Object=new Object();
					var value:String=xml.table[1].data[i].@类型;
					obj.pointType=value;
					obj.position=entity.point;
					obj.clikcData=entity.warnMouseClickData
					obj.overData=entity.mouseOverData.split("<br>").join("\n");
					if (entity.bground != "")
					{
						obj.imgpath=entity.bground;
					}
					else
					{
						obj.imgpath="20091201191926468.png";
					}
					switch (obj.pointType)
					{

						case "Point":
							this.addMarker(obj);
							break;
						case "Line":
							this.addPolyLine(obj);
							break;
						case "Broken":
							this.addPolyLine(obj);
							break;
						case "Rect":
							this.addPolygon(obj);
							break;
						case "Oval":
							//buildCircle();
							break;
					}
				}
			}
		}
        
		private function initObject(_xml:XML):Object
		{
			var object:Object=new Object();
			var dataXML:XML=_xml;
			object.nameID=dataXML.@["NameID"];
			object.title=dataXML.@["友好名称"];
			object.bground=dataXML.@["图片路径"];
			object.borderColor=dataXML.@["边框颜色"];
			object.bgroundColor=dataXML.@["填充颜色"];
			object.mouseOverData=dataXML.@["鼠标经过数据"];
			object.alpha=dataXML.@["透明度"];
			object.warnColor=dataXML.@["告警颜色"];
			object.warnMouseOverData=dataXML.@["告警Tips内容"];
			object.warnMouseClickData=dataXML.@["告警弹出窗信息"];
			object.windowID=dataXML.@["弹出窗信息"];
			object.width=dataXML.@["宽度"];
			object.height=dataXML.@["高度"];
			object.pointType=dataXML.@["坐标类型"];
			object.type=dataXML.@["类型"];
			return object;
		}
	}
}