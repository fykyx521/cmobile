package com.careland.component.layout
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDContent;
	import com.careland.component.CLDLayoutUI;
	import com.careland.component.CLDLineWindow;
	import com.careland.component.CLDWindow;
	import com.careland.component.CLDWindowAdapter;
	import com.careland.component.mapLayers.CLDContentLayer;
	import com.careland.component.mapLayers.CLDLinePlay;
	import com.careland.component.mapLayers.LineLayer;
	import com.careland.component.util.MapUtil;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	import com.careland.event.ColorEvent;
	import com.careland.event.ImgEvent;
	import com.careland.event.LineEvent;
	import com.careland.event.TimerEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDBaseMarker;
	import com.careland.layer.CLDLayer;
	import com.identity.CLDMap;
	import com.identity.map.CLDColorManageLayerAdapter;
	import com.identity.timer.CLDTimerGroup;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BlurFilter;
	import flash.geom.Point;

	public class CLDLayout12 extends CLDLayoutUI
	{
		private var map:CLDMap;
		//private var cldimg:CLDImgMap;
		
		private var cldw:CLDWindowAdapter;
		
		private var backWin:CLDWindowAdapter;//谈出背景窗体
		private var mapOver:CLDMapOverWin;
		private var color:CLDColorManageLayerAdapter;
		
		//private var layers:Vector.<CLDLayer>=null;
		
		private var timer:CLDTimerGroup;
		
		private var layers:Array=[];
		
		private var openLayerID:Array=[];
		
		public function CLDLayout12(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0, 
			isSwitchWin:Boolean=false)
		{
			
			super(parent, xpos, ypos, autoLoad, timeInteval, false);
			this.addEventListener(ImgEvent.mouseClick,itemClick,true);
			
			map=new CLDMap();
			this.addChild(map);
			map.visible=false;
//			cldimg=new CLDImgMap();
//			this.addChild(cldimg);
//			cldimg.visible=false;
			
			//timer.visible=false;
			
			mapOver=new CLDMapOverWin();
			mapOver.alpha=0;
			this.addChild(mapOver);
			
		
			//layers=new Vector.<CLDLayer>();
			
			this.config.addEventListener(CLDEvent.ALERTWIN,alertWin);
			

		}
		private function alertWin(e:CLDEvent):void
		{
			//this.winBoxData();
			 openMarkerWin(e.mouseClickData);
		}
		
		//当线路拖动的时候
		private function onTimer(e:TimerEvent):void
		{
			var tid:int=e.id;
			var layer:CLDLinePlay=this.getLayerByID(tid);
			if(layer){
				layer.updateLayerByRadio(e);
				this.map.updateSingleLayer(layer);
			}
			
		}
		
		private function getLayerByID(id:int):CLDLinePlay
		{
			for(var i:int=0;i<this.layers.length;i++){
				if(layers[i].id==id&&id!=-1){
					return layers[i];
				}
			}
			return null;
		}
		
		public function winBoxData(id:String,params:String,width:Number,height:Number,uuid:String):void
		{
			if(this.uuid==uuid){
				
				buildAlert(width,height,id,params);
			}
			
		}
		//因为有地图的自定义layout转到视图后，本身的点 还没有去除，所以需要pause一下
		override public function pause():void
		{
			super.pause();
			this.map.pause();
		}
		
		override public function startRender():void
		{
			super.startRender();
			this.map.startRender();
		}
		
		override protected function isImgMap():void
		{
			map.visible=false;
//			cldimg.visible=true;
//			cldimg.setSize(this.width,this.height);
		}
		
		private function mapClearLayer(e:MapEvent):void
		{
			this.openLayerID.splice(0,openLayerID.length);
			if(color){
				try{
					color.dispose();
					this.removeChild(color);
					this.color=null;	
				}catch(e:Error){
					
				}
			}
			
		}
		
		//param  是否是特殊视图
		override protected function isMap(dt:String,param:Boolean=false):void
		{
			map.visible=true;
			map.setSize(this.width,this.height);
			map.addEventListener(MapEvent.MapClearLayer,mapClearLayer);
			
			if(param){
				this.setMapType(dt);
			}else{
				MapUtil.setMapType(dt,this.map);
			}

		
		}
		//设置地图类型
		private function setMapType(dt:String):void
		{
			var mapTypeArray:Array=dt.split("^");
			if(mapTypeArray.length>0)
			{
				var pointSArr:Array=mapTypeArray[1].split(",");
				var point:Point=new Point(pointSArr[0],pointSArr[1]);
				var level:int=int(mapTypeArray[2]);
				var zoom:int=int(mapTypeArray[3]);
				
				map.setLocation(point,zoom,level);
			}
		}
		
		
		override protected function layout():void
		{
			
			super.layout();
			map.setSize(this.width,this.height);
			
		}
		private function itemClick(e:ImgEvent):void
		{
			e.stopPropagation();
			var bdata:Object=e.object;
			if(bdata.mapProp!=""){
				
				var prop:Array=bdata.mapProp.split(",");
			 	var point:Point=null
			 	if(prop.length==4){
			 		point=new Point(Number(prop[2]),Number(prop[3]));
			 	}
				var tileMap:int=int(prop[0])
				var zoom:int=int(prop[1]);
				
				this.map.setLocation(point,zoom,tileMap);
			}
			if(bdata){
				//bdata.@
				switch(bdata.eventChart){
					case "1": openNew(bdata);break; //弹出新窗体
					case "2": openInExitWin(bdata);break;
					case "3": openInMap(bdata);break; //在底层地图上打开 数据
					
					case "6": openTip(bdata,e.stageX,e.stageY);break; //在底层地图上打开 数据mouseOver数据
					case "7": openLine(bdata);break; //在底层地图上打开 数据
					
					case "8": openLineInMap(bdata);break;
					case "9": openNewContent(bdata);break; //直接显示指定的内容
					
					case "10": openNewInBack(bdata);break; //在底层 窗体打开内容，在地图底层
					//在已有窗体上更新数据
					// 11 相册功能
				}
				
			}

 			
		}
		private function openLine(bdata:Object):void
		{
			if(cldw)this.removeChild(cldw); 
			
			var line:CLDLineWindow=new CLDLineWindow();
			line.contentID=bdata.contentID;
			line.autoLoad=true;
			this.addChild(line);
			line.setSize(1024,768);			
			
		}
		//人员传送
		private function openLineInMap(bdata:Object):void
		{
			if(map){
				map.clearLayer();
				if(this.openLayerID){
					this.openLayerID.splice(0,openLayerID.length);
				}
				
			}
			if(cldw)
				try{
					cldw.dispose();
					this.removeChild(cldw); 
				}catch(e:Error)
				{
				
			}
			
			
			var lineID:Array=bdata.contentID.split(":");
			if(isContains(lineID[0]))
			{
				return;
			}

			var lineLayer:LineLayer=new LineLayer();
			this.map.addLayer(lineLayer);
			lineLayer.contentID=lineID[0];
			this.openLayerID.push(lineID[0]);
			lineLayer.autoLoad=true;
			
			//lineLayer.addEventListener(LineEvent.LINEINIT,lineInit);
			lineLayer.map=this.map;
			
		      	var ids:Array=String(lineID[1]).split(",");
				for(var i:int=0;i<ids.length;i++){
					
					var cline:CLDLinePlay=new CLDLinePlay();
					cline.contentID=ids[i];
					cline.autoLoad=true;
					this.map.addLayer(cline);
					//cline.map=this.map;
					cline.addEventListener(LineEvent.LINEINIT,lineInit);
					cline.addEventListener(MapEvent.MapAddLayer,layerChange,false,0,true);
					cline.addEventListener(MapEvent.MapMouseOver,markerOver,true,0,true);
					cline.addEventListener(MapEvent.MapMouseRightClick,this.markerRightClick,true,0,true);
					cline.addEventListener(LineEvent.MarkerChange,markerChange,false,0,true);
					if(i==0){
						cline.changeCenter=true;
					}
					//cline.addEventListener(MapEvent.MapAddLayer,layerChange,false,0,true);
					layers.push(cline);
				}
				
			
			
		}
		private function markerChange(e:LineEvent):void
		{
			var layer:CLDLayer=e.target as CLDLayer;
			if(layer&&map){
				this.map.updateSingleLayer(layer);
				if(e.radio!=-1&&this.timer){
					this.timer.setRadio(layer.id,e.radio);
				}
				if(e.center&&e.changeCenter){
					var zoomLevel:int=int(config.getProperties("mapSetCenterzoomLevel"));
					if(map.zoom>=zoomLevel){
						this.map.setCenter(e.center);
					}
					
				}
				
			}
		}
		
		private function lineInit(e:LineEvent):void
		{
			
			e.target.removeEventListener(LineEvent.LINEINIT,lineInit);
			//this.timer.visible=false;
			if(!timer){
				timer=new CLDTimerGroup();
				timer.addEventListener(TimerEvent.timerEvent,onTimer);
				this.addChild(timer);
			}
			this.timer.setSize(this.width-450,100);
			this.timer.timerModel=e.timerModel;
			this.timer.x=180;
			
		}
		private function layerChange(e:MapEvent):void
		{
			var line:CLDLayer=e.target as CLDLayer;
			if(line){
				this.map.updateSingleLayer(line);
			}
//			map.updateLayer();
		}
		
		
		private function openTip(bdata:Object,sx,sy):void
		{
			    var lp:Point=this.globalToLocal(new Point(sx,sy));
				//mapOver.x=lp.x;
				//mapOver.y=lp.y;
				mapOver.alpha=.1;
				Tweener.removeTweens(mapOver);
				this.setChildIndex(mapOver,this.numChildren-1);
				Tweener.addTween(this.mapOver,{x:lp.x,y:lp.y,alpha:1,time:.5});
				this.mapOver.data=bdata.contentID;//用内容ID来承载内容
				Tweener.addTween(this.mapOver,{alpha:0,time:.5,delay:3});
		}
		
		private function isContains(vid:String):Boolean
		{
			for each(var id:String in this.openLayerID){
				if(vid==id){
					return true;
				}
			}
			return false;
		}
		private function addLayer(contentID:String,param:String=""):void
		{
			var contentLayer:CLDContentLayer=new CLDContentLayer();
			//contentLayer.map=map;
			contentLayer.contentID=contentID;
			contentLayer.contentParam=param;
			contentLayer.autoLoad=true;
			this.map.addLayer(contentLayer);
			
			contentLayer.addEventListener(MapEvent.MapTouchMarker,touchMarker,true);
			contentLayer.addEventListener(MapEvent.MapMouseOver,markerOver,true);
			contentLayer.addEventListener(MapEvent.MapAddLayer,layerChange,true);
			contentLayer.addEventListener(MapEvent.MapMouseRightClick,markerRightClick,true);
			
			contentLayer.addEventListener(ColorEvent.colorState,colorState);
			openLayerID.push(contentLayer.contentID+contentLayer.contentParam);
		}
		
		private function colorState(e:ColorEvent):void
		{
			//e.target.removeEventListener(ColorEvent.colorState,colorState);
			if(this.color){
				try{
					color.dispose();
					this.removeChild(color);
					color=null;	
				} catch(e:Error)
				{
					
				}
          		     		
			}
			color=new CLDColorManageLayerAdapter();
          	color.setSize(500,10);
			var target:Object=e.target;
			color.data=e.target.configData.table[0];
			color.contentLayer=target as CLDContentLayer;
			color.x=(this.width-color.width)/2-200;
			color.y=10;
			this.addChildAt(color,this.numChildren-1);
		
			
			
		}
		
		
		
		private function markerRightClick(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target.mouseClickData!=""){
				
				this.openMarkerWin(target.mouseClickData);
			}
		}
		private function openMarkerWin(mouseClickData:String):void
		{
			//屏蔽 点击marker 弹出框 
				var winIDParams:Array=mouseClickData.split(",");
				if(winIDParams.length<5){
					return;
				}
				//if(winIDParams[4]=="1"){
				var winPoint:String="";
				if(winIDParams.length>6){
					winPoint=winIDParams[5];
				}
				this.buildAlert(winIDParams[2],winIDParams[3],winIDParams[0],winIDParams[1],
				false,false,null,winIDParams[4],winPoint);
				//}
		}
		
		private function openInMap(bdata:Object):void
		{
			if(bdata.clearLayer=="1"&&map){
				this.map.clearLayer();
			}
			//trace("openInMap");
			var str:String=bdata.contentID;
			if(isContains(bdata.contentID))
			{
				return;
			}
			var has:int=str.indexOf(":",0);
			if(has!=-1){
				var ids:Array=str.split(":");
				
				for(var i:int=0;i<ids.length;i++){
					if(!isContains(ids[i])){
						this.addLayer(ids[i],bdata.param);
					}
				}
				
			}else{
				this.addLayer(str,bdata.param);
			}
			
			
			
			
			
		}
		private function touchMarker(e:MapEvent):void
		{

			
		}
		
		private function markerClick(e:CLDEvent):void
		{
				var winIDParams:Array=e.mouseClickData.split(",");
				if(winIDParams.length<5){
					return;
				}
				if(winIDParams[4]=="1"){
					this.buildAlert(winIDParams[2],winIDParams[3],winIDParams[0],winIDParams[1]);
				}
		}
		
		private function markerOver(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target){
				map.showOver(target,e.stageX,e.stageY);
			}
			
			
		}
		private function buildAlertBack(w:Number,h:Number,winID:String,params:String=""):void
		{
			
			if(backWin)
			{
				try{
					backWin.removeEventListener(CLDEvent.WINUP,winUp);
					backWin.dispose();
					this.removeChild(backWin);//因为winUp方法 会导致窗口销毁 removeChild 会报错
					backWin=null;
				}catch(e:Error){
					
				}
				
			}
			backWin=new CLDWindowAdapter();
			backWin.constom=false;
			backWin.alpha=.5;
		
			backWin.setSize(this.width,this.height);
		
			backWin.contentIDParam=params;
			backWin.isBack=true;
			backWin.windowID=winID;//打开新窗口的ID
			
			backWin.autoLoad=true;
			this.addChild(backWin);
			if(this.numChildren>1){
				this.setChildIndex(backWin,1);
			}
			
			backWin.addEventListener(CLDEvent.WINUP,winUp);
			
			Tweener.addTween(backWin,{alpha:1,time:.5});
		}
		//winState 窗体状态 1 可拖动  2可拖动 
		//winPoint 窗体坐标
		private function buildAlert(w:Number,h:Number,winID:String,params:String="",content:Boolean=false,
			isBack:Boolean=false,backWin:CLDWindowAdapter=null,winState:String="",winPoint:String=""):void
		{
			
			if(cldw)
			{
				try{
					cldw.removeEventListener(CLDEvent.WINUP,winUp);
					cldw.dispose();
					this.removeChild(cldw);//因为winUp方法 会导致窗口销毁 removeChild 会报错
					cldw=null;
				}catch(e:Error){
					
				}
				
			}
			cldw=new CLDWindowAdapter();
			//cldw.constom=!isBack;
			cldw.alpha=.5;
			cldw.alertWin=true;
			//cldw.setSize(w,h);
			if(isBack){
				cldw.setSize(this.width,this.height);
			}else{
				cldw.setSize(w,h);
			}
			var vconstom:Boolean=true;
			if(winState!=""){
				switch(winState){
					case "1":vconstom=true;break;
					case "2":vconstom=false;break;
				}
			}
			cldw.constom=vconstom;
			cldw.contentIDParam=params;
//			cldw.isBack=isBack;
			if(!vconstom)
			{
				cldw.showClose();
			}
		
			
			cldw.windowID=winID;//打开新窗口的ID
			cldw.contentTxt=content;//是否直接显示指定的内容
			cldw.autoLoad=true;
			this.addChild(cldw);
			if(isBack&&this.numChildren>1){
				this.setChildIndex(cldw,1);
			}
			
			cldw.addEventListener(CLDEvent.WINUP,winUp);
			if(winPoint!=""){
				var winPArr:Array=winPoint.split(":");
				var winp:Point=new Point(winPArr[0],winPArr[1]);
				cldw.x=winp.x;
				cldw.y=winp.y;
			}else{
				cldw.x=(this.width-cldw.width)/2;
				cldw.y=(this.height-cldw.height)/2
			}
			Tweener.addTween(cldw,{alpha:1,time:.5});
		}
		
		
		
		//在已有窗口打开内容
		private function openInExitWin(bdata:Object):void
		{
			var win:CLDWindow=this.getChildByIndex(bdata.winID);
			if(win){
				
				
				
				var blur:BlurFilter=new BlurFilter(0,0);
				
				
				//var bit:Bitmap=this.drawCurrent();
				//this.addChild(bit);
				var bit:Bitmap=win.drawCurrent();
				this.addChild(bit);
				//this.setChildIndex(win,this.numChildren-1);
				bit.x=win.x;
				bit.y=win.y;
				bit.filters=[blur];
				
				Tweener.addTween(blur,{blurX:10,blurY:10,time:1,onCompleteParams:[bit,this],
					onComplete:complete,onUpdate:onUpdate,onUpdateParams:[bit,blur]});
				
				var blur1:BlurFilter=new BlurFilter(10,10);
				
				function complete(bit:Bitmap,obj:DisplayObject):void
				{
					bit.bitmapData.dispose();
					removeChild(bit);
					bit=null;
					
					
				}
				function onUpdate(bit:Bitmap,blur:BlurFilter):void
				{
					bit.alpha-=0.05;
					bit.filters=null;
					bit.filters=[blur];
				}	
				
				var cld:CLDContent=new CLDContent();
				cld.contentID=bdata.contentID;
				cld.autoLoad=true;
				win.addContent(cld);
				win.width=Number(bdata.width);
				win.height=Number(bdata.height);
				
				
				
				
			}
		}
		
		public function getChildByIndex(index:int):CLDWindow
		{
			for(var i:int=0;i<this.numChildren;i++){
				var cldw:CLDWindow=this.getChildAt(i) as CLDWindow;
				if(cldw&&index==cldw.index){
					return cldw;
				}
			}
			return null;
		}
		
		override public function disposeXML(xml:XML):void
		{
			super.disposeXML(xml);
		}
		
		override public function dispose():void
		{
			if(config){
				config.removeEventListener(CLDEvent.ALERTWIN,alertWin);
			}
			super.dispose();
			
			if(map){
				map.removeEventListener(MapEvent.MapClearLayer,mapClearLayer);
				map.dispose();
			}
			if(this.mapOver){
				mapOver.dispose();
			}
			this.removeEventListener(ImgEvent.mouseClick,itemClick,true);
			
			if(color){
				color.dispose();
			}
			if(this.timer){
				timer.dispose();
				timer.removeEventListener(TimerEvent.timerEvent,onTimer);
			}
			timer=null;
			
		}
		
		private function openNew(bdata:Object):void
		{
			
			buildAlert(bdata.width,bdata.height,bdata.contentID,bdata.param,false,false,null,
			bdata.winState,bdata.winPoint);

		}
		private function openNewContent(bdata:Object):void
		{
			
			buildAlert(bdata.width,bdata.height,bdata.contentID,"",true,false,null,bdata.winState,bdata.winPoint);

		}
		private function openNewInBack(bdata:Object):void
		{
			this.buildAlertBack(this.width,this.height,bdata.contentID,"");
			//buildAlert(700,350,bdata.contentID,"",false,true,this.backWin);

		}
		
		override public function draw():void
		{
			super.draw();
			if(this.timer){
				this.timer.x=180;
			}
			if(this.map){
				map.setSize(this.width,this.height);
			}
			if(this.backWin){
				backWin.setSize(this.width,this.height);
			}
			
		}
	}
}