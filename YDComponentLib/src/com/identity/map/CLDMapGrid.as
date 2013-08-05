package com.identity.map
{
	import com.careland.*;
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ColorEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.*;
	import com.identity.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDMapGrid extends CLDMap
	{			
		private var content:CLDBaseComponent;
		private var blobs:Array=[];				
		private var points:Array;
		private var scale:Number=1; //比例
		private var ear:CLDTextArea;
		private var count:int=0;
		private var LinePosition:String="";
		public var SquareWidth:Number=35;  //网格宽度 
		public var SquareHeight:Number=35;//网格高度
		private var sprite:Sprite;
		public var types:String="point";//点的类型
		public var type:int=0;//0点线面 1//网格  2 点线面和网格
		private var xml:XML;
		private var ifFinish:Boolean;
		private var colorList:Array=new Array();//色带
		private var polygonList:Array=[];
		private var buttonList:Array;
		private var lastClickBtnIndex:int=0;
        public var toolWidth:Number=650;
        private var ifMove:Boolean=false;
        private var newX:Number;
        private var newY:Number;
        private var oldX:Number;
        private var oldY:Number;
        private var dirsction:Number;
        private var dirsctionX:Number;
        private var colorSprite:CLDColorSprite;
        private var colorManage:CLDColorManage;
        
        private var gridLayer:CLDLayer;
		public function CLDMapGrid(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
			override public function dispose():void
		{
			super.dispose();
			if(cm){
				cm.dispose();
			}
			this.colorSprite=null;
			this.colorManage=null;
			this.gridLayer=null;
			this.toolWidth=null;
			this.lastClickBtnIndex=null;
		    this.buttonList=null;
			this.polygonList=null;
			this.colorList=null;
			this.ifFinish=null;
			this.xml=null;
			this.type=null;
			this.types=null;
			this.sprite=null;
			this.SquareHeight=null;
			this.SquareWidth=null;
			this.LinePosition=null;
			this.count=null;
			this.ear=null;
			this.content=null;
			this.blobs=null;
			this.points=null;
			this.scale=null;
		}
		override public function set data(value:*):void
		{
			
			 super.data=value;
			 
			 if(gridLayer){
			 	 gridLayer.dispose();//删除所有网格
			 	 drawSquareData();
			 }
			 
		     SquareColor(); //网格色带		
		     if(colorSprite){
                
		     	 colorSprite.data=XML(data).table[0];

		     }
		     		 			
		}		
		
		override public function draw():void
		{
			//super.draw();
			
			if(cm){
				cm.setSize(this.width,this.height);
				mapControl.x=this.width-450;
				
			}
			 
			
		}
		
		
		override protected function addChildren():void
		{
			super.addChildren();
			SquareColor();
			gridLayer=new CLDLayer();
			this.addLayer(gridLayer);
			gridLayer.addEventListener(MapEvent.MapMouseOver,markerOver,true,0,true);
			gridLayer.addEventListener(MapEvent.MapMouseRightClick,this.markerRightClick,true,0,true);
			
		}
		private function SquareColor():void{
			if(!colorSprite){
				 colorSprite=new CLDColorSprite();
//          		 colorSprite.setSize(500,100);
//            colorSprite.x=(this.width-500)/2;           
           // colorSprite.data=this.xml.table[0];
          		  colorSprite.setSize(500,10);
          		  colorSprite.autoLoad=true;   
           		 colorSprite.addEventListener(ColorEvent.colorClick,colorClick);        
          		 this.addChildAt(colorSprite,this.numChildren-1);
			}
           
        }
        
        
		protected function addMarker(obj:Object):void
		{
			var marker:CLDMarker=new CLDMarker();		 
			marker.cldPoint=new Point(obj.position.split(",")[0], obj.position.split(",")[1]);
//			marker.addEventListener(MouseEvent.CLICK,mouse_click);
//			marker.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
//			marker.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
			marker.mouseOverData= obj.overData;
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
			if(count==0){
				LinePosition+=pointArr[0];
			} 
			for each (var str:String in pointArr)
			{
				var sArr:Array=str.split(",");
				polyline.addPoint(new Point(Number(sArr[0]), Number(sArr[1])));
			}
			polyline.pointType=obj.pointType;
//			polyline.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
//			polyline.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
			polyline.mouseOverData= obj.overData;
			polyline.mouseClickData=obj.clikcData;
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
			if(obj.pointType=="point"||obj.pointType=="image"){
				lp=this.layer.localToGlobal(new Point(obj.x,obj.y));
			}else{
				lp=this.layer.localToGlobal(new Point(e.localX,e.localY));
			}
			ear=new CLDTextArea();
			ear.bground=true;
			ear.setSize(650, 350);			
			ear.x=(this.width-ear.width)/2;
			ear.y=(this.height-ear.height)/2;
			if(obj.mouseOverData==""){
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
			//this.removeChild(ear);
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
			win.setSize(500,500);
			win.x=(this.width-win.width)/2;
			win.y=(this.height-win.height)/2;
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
//			polygon.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
//			polygon.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
			polygon.addEventListener(MouseEvent.CLICK,mouse_click);
			polygon.mouseOverData= obj.overData;
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
		private function drawSquareData():void{		  
			xml=XML(this.data);
			var gonlayer:CLDLayer=this.gridLayer;
			var point:Point=new Point(0,0);
			
			var length:int=xml.table[1].data.length();
			var object:Object=xml.table[1].data;
		    polygonList=new Array(length);	
			for(var i:int=0;i<length;i++){										 
		    var polygon:CLDPolygon=new CLDPolygon();
		    polygon._border=1;		  
		    polygon.mouseOverData=object[i].@鼠标经过数据;		
//		    if(polygon.mouseOverData==""||polygon.mouseOverData==undefined){
//		    	polygon.mouseOverData=object[i].@鼠标经过数据;
//		    }    
		    polygon.mouseOverData= polygon.mouseOverData.split("<br>").join("\n");
		    polygon.mouseClickData=object[i].@弹出窗信息;
		//    polygon.addEventListener(MouseEvent.CLICK,mouse_click);
			var pointstr:String=object[i].@坐标;
			var pointArr:Array=pointstr.split(";");
			for each (var str:String in pointArr)
			{
				var sArr:Array=str.split(",");

				polygon.addPoint(new Point(Number(sArr[0]), Number(sArr[1])));
			}
				//this.addChild(polygon);					
				polygon.invalidate(); 
				polygonList[i]=polygon;
				gonlayer.addgon(polygon);
				//this.layer.addgon(polygon);				
			}
//			this.addLayer(gonlayer);
			this.updateSingleLayer(this.gridLayer);	  
		}
	     //网格色带
        private function drawColor(_name:String,index):void{
        	if(!xml.hasOwnProperty("table")){
        		return;
        	}
        	if(xml.table[2]==null){
        		return;
        	}
             for(var i:int=0;i<xml.table[2].data.length();i++){
             	 var range:Number=xml.table[2].data[i].@[_name];              	        	   
             	 var color:int=colorManage.checkColor(range);
             	 var  polygon:CLDPolygon=polygonList[i] as CLDPolygon;
             	   //  polygon.mouseOverData2="   颜色值:"+color; 
             	   polygon.bgColor=color;               	   	 
           } 
            	updateLayer();
        }       
        //网格色带数据加载      
        private function colorClick(e:ColorEvent):void{
           colorManage=e.colorManage;
           try{
           	 drawColor(e.color,e.index);
           }catch(e:Error){
           	
           }
          
        }
		
		
	}
}