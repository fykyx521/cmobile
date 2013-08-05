package com.careland.util
{
	
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import mx.core.ByteArrayAsset;
	
	[Event(name="loadconfig", type="flash.event.Event")]
	public class CLDConfig extends EventDispatcher
	{
		
		private static var _instance:CLDConfig=null;
		
		
		public var configXML:XML;
		
		
		public var isLoad:Boolean=false;
		
		public var dzConfig:Object=new Object;
		
		
		[Embed("assets/mapdata.db", mimeType="application/octet-stream")]
		private static var configCLS:Class;
		
		
		public function CLDConfig(target:IEventDispatcher=null):void
		{
			
			if (_instance != this)
			{
				_instance=this;
				
				
				//initConfig();//只会加载一次
			}
		}
		
		public static function instance():CLDConfig
		{
			if (!_instance)
			{
				_instance=new CLDConfig();
				_instance.configXML=getConfig();
				
			}
			return _instance;
		}
		public static function getConfig() : XML
		{
			var ba:ByteArrayAsset = ByteArrayAsset( new configCLS()) ;
			var xml:XML = new XML( ba.readUTFBytes( ba.length ) );
			
			return xml;
		}
		
		
		
		public function initConfig():void
		{
			
			//			bulk=new BulkLoader("main-site");
			//			bulk.add("assets/mapdata.db", {id: "cldconfig"});
			//			bulk.addEventListener(BulkProgressEvent.COMPLETE, complete);
			//
			//			bulk.start(1);
		}
		
		private function complete(e:Event):void
		{
			//			var xml:XML=XML(bulk.getContent("cldconfig", true));
			//			configXML=xml;
			//			isLoad=true;
			//			this.dispatchEvent(new Event("loadconfig"));
		}
		
		
		/**
		 * 转屏幕坐标
		 */
		public function toScreenPoint(x, y,config0):Point {
			//	    var map = controls ? Careland.map.controls["eyemap"] : Careland.map;
			//	    var config = controls ? Careland.map.controls["eyemap"].config : _CLDGLOBALOBJ.config;
			
			var width:int = parseInt(String(config0.mapWidth));
			var height:int = parseInt(String(config0.mapHeight));
			
			var x:Number = Math.round(width / 2 + (CLDMercator.LonToProjectionX(x) - CLDMercator.LonToProjectionX(config0.center.x)) / config0.wscale);
			var y:Number = Math.round(height / 2 - (CLDMercator.LatToProjectionY(y) - CLDMercator.LatToProjectionY(config0.center.y)) / config0.hscale);
			
			return new Point(x,y);
			
			
			
		}  
		public function shapeAcreage(points:Vector.<Point>):Number{
			
			var the_area = 0;
			var size = points.length;
			if(size < 3){
				return 0;
			}
			
			var mypoints = [];
			// 作为WGS84经纬度处理 add by liyg 2010.12.16
			var dindex = points[0].x.toString().indexOf('.');
			if((dindex >= 0 && dindex <= 3) || (dindex == -1 && points[0].x.toString().length <= 3)){
				for(var k=0; k<size; k++){
					mypoints.push(new CLDPoint((points[k].x * 3600000), (points[k].y * 3600000)));
				}
			}
			else{
				mypoints = points.slice(0);
			}
			
			for (var i = 0; i != size; i++){
				the_area += (mypoints[i].y*30.9/1000 + mypoints[(i + 1) % size].y*30.9/1000) * (mypoints[i].x*23.6/1000 - mypoints[(i + 1) % size].x*23.6/1000);
			}
			the_area /= 2;
			
			return Math.abs(the_area);
		}
		/**
		 * 转地图坐标
		 */
		public function toMapPoint(x, y,config):Point {
			
			
			var width = parseInt(String(config.mapWidth));
			var height = parseInt(String(config.mapHeight));
			//lijian coord
			var projectionX = CLDMercator.ProjectionXToLon(CLDMercator.LonToProjectionX(config.center.x) + (x - width / 2) * config.wscale);
			var projectionY = CLDMercator.ProjectionYToLat(CLDMercator.LatToProjectionY(config.center.y) + (height / 2 - y) * config.hscale);
			
			// 作为WGS84经纬度处理 add by liyg 2010.12.16
			var dindex = projectionX.toString().indexOf('.');
			if((dindex >= 0 && dindex <= 3) || (dindex == -1 && projectionX.toString().length <= 3)){
				x = Number(projectionX);
				y = Number(projectionY);
			}
			else{
				x = Math.round(projectionX);
				y = Math.round(projectionY);
			}
			return new Point(x,y);
		}
		
		public function getMapPoint(x, y, point, zoom,config:MapConfig) {
			var data = config.getZoomConfig(zoom); // 读取配置
			// 新的屏幕坐标
			var offsetx = Math.round(Math.floor(config.mapWidth) / 2 + (CLDMercator.LonToProjectionX(x) - config.x) / data.wscale);
			var offsety = Math.round(Math.floor(config.mapHeight) / 2 - (CLDMercator.LatToProjectionY(y) - config.y) / data.hscale);
			
			var projectionX = CLDMercator.ProjectionXToLon(config.x + (offsetx -point.x) * data.wscale);
			var projectionY = CLDMercator.ProjectionYToLat(config.y + (point.y - offsety) * data.hscale);
			
			// 作为WGS84经纬度处理 add by liyg 2010.12.16
			var dindex = projectionX.toString().indexOf('.');
			if((dindex >= 0 && dindex <= 3) || (dindex == -1 && projectionX.toString().length <= 3)){
				x = Number(projectionX);
				y = Number(projectionY);
			}
			else{
				x = Math.round(projectionX);
				y = Math.round(projectionY);
			}
			
			return {
				"x" : x,
				"y" : y
			};
		}
		
		
		
		
		public function createCLDMaping(config,center,width:Number,height:Number){
			var images = [];
			var IW = parseInt(config.ImageWidth);
			var IH = parseInt(config.ImageHeight);
			//保存
			var push = function(x, y, row, col, src, id) {
				if (row < 0 || col < 0) {
					return;
				}
				images.push({ "id": id, "x": x, "row": row, "col": col, "y": y, "z": config.zoom, "src": src});
			};
			
			//加载数量
			var totalCols = Math.ceil((width + IW) / IW);
			var totalRows = Math.ceil((height + IH) / IH);
			
			//lijian coord
			var projectionX = CLDMercator.LonToProjectionX(center.x);
			var projectionY = CLDMercator.LatToProjectionY(center.y);
			
			//起点到中心点距离
			var disX = Number(projectionX - config.x);
			var disY = Number(config.y - projectionY);
			//图片偏移像素值
			var leftThen = Math.round(disX / config.wscale - Number(width / 2));
			var topThen = Math.round(disY / config.hscale - Number(height / 2));
			
			var startLeft = Math.floor(leftThen / IW) * IW;
			var startTop = Math.floor(topThen / IH) * IH;
			for (var rowIndex = 0; rowIndex < totalRows; rowIndex++) {
				var top = -topThen + startTop + rowIndex * IH;
				for (var colIndex = 0; colIndex < totalCols; colIndex++) {
					var left = -leftThen + startLeft + colIndex * IW;
					var row = rowIndex;
					var col = colIndex;
					var px = startLeft + colIndex * IW;
					var py = parseInt(config.pixelheight) - startTop - (rowIndex + 1) * IH;
					var tileNumber = CLDMercator.getTileNumber(px, py, config.zoom);
					var path = "m=" + tileNumber.toString();
					var id = "";
					if(config.zoom == 1){
						id = "cld_" + config.zoom + "_"+ rowIndex + "_"+ colIndex +"_" + tileNumber.toString();
					}
					else{
						id = "cld_" + config.zoom + "_" + tileNumber.toString();
					}
					push(left, top, row, col, path, id);
				}
			}
			
			//delete push;
			return images;
		}
		
		
		public function getScale(config:MapConfig):Object
		{
			var aPoint = new CLDPoint(config.mapWidth / 2 - 50, config.mapHeight / 2);
			var bPoint = new CLDPoint(config.mapWidth / 2 + 50, config.mapHeight / 2);
			
			aPoint = this.toMapPoint(aPoint.x,aPoint.y,config);
			bPoint = this.toMapPoint(bPoint.x,bPoint.y,config);
			
			var disX = "";
			var width = 0;
			
			//每个像素距离
			var perdis = this.getMapDistance(aPoint, bPoint) / 100;
			
			width = config.showscale / perdis;
			disX = config.showscale;
			
			if (disX < 1000) {
				disX = Math.round(disX) + "米";
			} else {
				var tm = disX / 1000;
				if(tm.toString().indexOf('.') != -1){
					disX = parseFloat(tm).toFixed(2) + "公里";
				}
				else{
					disX = tm + "公里";
				}
			}
			
			return {width:width,disX:disX};
			//disX是显示的值，width是显示的长度
		}
		
		
		//	 经纬度
		//	public function getMapDistance(p1, p2) {
		//		var tmpp1 = p1;
		//		var tmpp2 = p2;
		//		
		//		tmpp1 = new CLDPoint((p1.x * 3600000), (p1.y * 3600000));
		//		tmpp2 = new CLDPoint((p2.x * 3600000), (p2.y * 3600000));
		//		
		//		var x = tmpp2.x - tmpp1.x;
		//		var y = tmpp2.y - tmpp1.y;
		//		var cPoint = new CLDPoint(Math.abs(x / 2) + tmpp1.x, Math.abs(y / 2) + tmpp1.y);
		//		var arry = CLDMapPointConst(cPoint);
		//		var d = Math.sqrt(Math.pow(x * arry[0], 2) + Math.pow(y * arry[1], 2));
		//		return d;
		//	}
		//	
		public function getMapDistance(p1, p2):Number {
			var tmpp1 = p1;
			var tmpp2 = p2;
			
			//		tmpp1 = new CLDPoint((p1.x * 3600000), (p1.y * 3600000));
			//		tmpp2 = new CLDPoint((p2.x * 3600000), (p2.y * 3600000));
			
			var x = tmpp2.x - tmpp1.x;
			var y = tmpp2.y - tmpp1.y;
			var cPoint = new CLDPoint(Math.abs(x / 2) + tmpp1.x, Math.abs(y / 2) + tmpp1.y);
			var arry = CLDMapPointConst(cPoint);
			var d:Number = Math.sqrt(Math.pow(x * arry[0], 2) + Math.pow(y * arry[1], 2));
			return d;
		}
		
		
		var _cld_global_pointConst = null;
		public function CLDMapPointConst(point)
		{
			if(!_cld_global_pointConst){
				_cld_global_pointConst = [new CLDPoint(4053,4026),new CLDPoint(4053,4026),
					new CLDPoint(4052,4026),new CLDPoint(4052,4026),new CLDPoint(4051,4026),
					new CLDPoint(4049,4026),new CLDPoint(4047,4026),new CLDPoint(4045,4026),
					new CLDPoint(4043,4026),new CLDPoint(4041,4026),new CLDPoint(4038,4026),
					new CLDPoint(4034,4026),new CLDPoint(4031,4026),new CLDPoint(4027,4026),
					new CLDPoint(4023,4026),new CLDPoint(4018,4027),new CLDPoint(4014,4027),
					new CLDPoint(4009,4027),new CLDPoint(4003,4027),new CLDPoint(3998,4027),
					new CLDPoint(3992,4027),new CLDPoint(3985,4027),new CLDPoint(3979,4027),
					new CLDPoint(3972,4027),new CLDPoint(3965,4028),new CLDPoint(3957,4028),
					new CLDPoint(3950,4028),new CLDPoint(3942,4028),new CLDPoint(3933,4028),
					new CLDPoint(3925,4028),new CLDPoint(3916,4029),new CLDPoint(3906,4029),
					new CLDPoint(3897,4029),new CLDPoint(3887,4029),new CLDPoint(3877,4029),
					new CLDPoint(3866,4030),new CLDPoint(3856,4030),new CLDPoint(3845,4030),
					new CLDPoint(3833,4030),new CLDPoint(3822,4030),new CLDPoint(3810,4031),
					new CLDPoint(3798,4031),new CLDPoint(3785,4031),new CLDPoint(3772,4031),
					new CLDPoint(3759,4032),new CLDPoint(3746,4032),new CLDPoint(3732,4032),
					new CLDPoint(3718,4032),new CLDPoint(3704,4033),new CLDPoint(3690,4033),
					new CLDPoint(3675,4033),new CLDPoint(3660,4033),new CLDPoint(3645,4034),
					new CLDPoint(3629,4034),new CLDPoint(3613,4034),new CLDPoint(3597,4035),
					new CLDPoint(3581,4035),new CLDPoint(3564,4035),new CLDPoint(3547,4035),
					new CLDPoint(3530,4036),new CLDPoint(3512,4036),new CLDPoint(3495,4036),
					new CLDPoint(3477,4037),new CLDPoint(3458,4037),new CLDPoint(3440,4037),
					new CLDPoint(3421,4038),new CLDPoint(3402,4038),new CLDPoint(3383,4038),
					new CLDPoint(3363,4039),new CLDPoint(3343,4039),new CLDPoint(3323,4039),
					new CLDPoint(3303,4040),new CLDPoint(3282,4040),new CLDPoint(3261,4040),
					new CLDPoint(3240,4041),new CLDPoint(3219,4041),new CLDPoint(3197,4041),
					new CLDPoint(3175,4042),new CLDPoint(3153,4042),new CLDPoint(3131,4042),
					new CLDPoint(3108,4043),new CLDPoint(3086,4043),new CLDPoint(3063,4043),
					new CLDPoint(3039,4044),new CLDPoint(3016,4044),new CLDPoint(2992,4044),
					new CLDPoint(2968,4045),new CLDPoint(2944,4045),new CLDPoint(2920,4045),
					new CLDPoint(2895,4046),new CLDPoint(2870,4046),new CLDPoint(2845,4047),
					new CLDPoint(2820,4047),new CLDPoint(2794,4047),new CLDPoint(2768,4048),
					new CLDPoint(2742,4048),new CLDPoint(2716,4048),new CLDPoint(2690,4049),
					new CLDPoint(2663,4049),new CLDPoint(2637,4049),new CLDPoint(2610,4050),
					new CLDPoint(2582,4050),new CLDPoint(2555,4050),new CLDPoint(2527,4051),
					new CLDPoint(2500,4051),new CLDPoint(2472,4051),new CLDPoint(2444,4052),
					new CLDPoint(2415,4052),new CLDPoint(2387,4053),new CLDPoint(2358,4053),
					new CLDPoint(2329,4053),new CLDPoint(2300,4054),new CLDPoint(2271,4054),
					new CLDPoint(2241,4054),new CLDPoint(2212,4054),new CLDPoint(2182,4055),
					new CLDPoint(2152,4055),new CLDPoint(2122,4055),new CLDPoint(2092,4056),
					new CLDPoint(2061,4056),new CLDPoint(2031,4056),new CLDPoint(2000,4057),
					new CLDPoint(1969,4057),new CLDPoint(1938,4057),new CLDPoint(1907,4058),
					new CLDPoint(1876,4058),new CLDPoint(1844,4058),new CLDPoint(1812,4058),
					new CLDPoint(1781,4059),new CLDPoint(1749,4059),new CLDPoint(1717,4059),
					new CLDPoint(1685,4060),new CLDPoint(1652,4060),new CLDPoint(1620,4060),
					new CLDPoint(1587,4060),new CLDPoint(1555,4061),new CLDPoint(1522,4061),
					new CLDPoint(1489,4061),new CLDPoint(1456,4061),new CLDPoint(1423,4062),
					new CLDPoint(1389,4062),new CLDPoint(1356,4062),new CLDPoint(1323,4062),
					new CLDPoint(1289,4063),new CLDPoint(1255,4063),new CLDPoint(1222,4063),
					new CLDPoint(1188,4063),new CLDPoint(1154,4063),new CLDPoint(1120,4064),
					new CLDPoint(1086,4064),new CLDPoint(1051,4064),new CLDPoint(1017,4064),
					new CLDPoint(983,4064),new CLDPoint(948,4064),new CLDPoint(914,4065),
					new CLDPoint(879,4065),new CLDPoint(844,4065),new CLDPoint(810,4065),
					new CLDPoint(775,4065),new CLDPoint(740,4065),new CLDPoint(705,4065),
					new CLDPoint(670,4066),new CLDPoint(635,4066),new CLDPoint(600,4066),
					new CLDPoint(565,4066),new CLDPoint(530,4066),new CLDPoint(495,4066),
					new CLDPoint(459,4066),new CLDPoint(424,4066),new CLDPoint(389,4066),
					new CLDPoint(353,4066),new CLDPoint(318,4066),new CLDPoint(283,4066),
					new CLDPoint(247,4067),new CLDPoint(212,4067),new CLDPoint(176,4067),
					new CLDPoint(141,4067),new CLDPoint(105,4067),new CLDPoint(70,4067),
					new CLDPoint(35,4067),new CLDPoint(1,4067)];
			}
			var y = int((point.y + 900000) / 1800000);
			if(y < 0 || y > 180){y = 0;}
			var x = _cld_global_pointConst[y].x / (Math.pow(2,17));
			y = _cld_global_pointConst[y].y / (Math.pow(2,17));
			return [x,y];
		};
		
		
	}
	
	
}