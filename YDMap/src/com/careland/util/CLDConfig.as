package com.careland.util
{
	import __AS3__.vec.Vector;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import mx.core.ByteArrayAsset;

	[Event(name="loadconfig", type="flash.event.Event")]
	public class CLDConfig extends EventDispatcher
	{

		private static var _instance:CLDConfig=null;

		private var bulk:BulkLoader;
		public var configXML:XML;


		public var isLoad:Boolean=false;

		public var dzConfig:Object=new Object;
		
		
		//不再嵌入地图配置，使用外部文件   
		
		//[Embed("mapdata1012.db", mimeType="application/octet-stream")]
		[Embed("mapdataNew.db", mimeType="application/octet-stream")]
		private static var configCLS:Class;
		
		public static var mapConfigXML:XML; 
		 
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
		
//		public static function getConfig() : XML
//		{
//			return mapConfigXML;
//		}



		public function initConfig():void
		{
			bulk=new BulkLoader("main-site");
			bulk.add("assets/mapdata.db", {id: "cldconfig"});
			bulk.addEventListener(BulkProgressEvent.COMPLETE, complete);

			bulk.start(1);
		}

		private function complete(e:Event):void
		{
			var xml:XML=XML(bulk.getContent("cldconfig", true));
			configXML=xml;
			isLoad=true;
			this.dispatchEvent(new Event("loadconfig"));
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

		
	public function pixelToPoint_3D_1(px, py, level):Point{
        var pixelW = 1064.25 * level;
		var pixelH = 698.5 * level;
		var minX = 113.9576;
		var maxX = 113.9953;
		var minY = 22.5275;
		var maxY = 22.5504;
        var x = ((px + level * 9) / Math.cos(0.62831853071795862) - (pixelH - py) / Math.sin(0.62831853071795862)) * (maxX - minX) / (2 * pixelW) + minX;
        var y = ((pixelH - py) / Math.sin(0.62831853071795862) + (px + level * 9) / Math.cos(0.62831853071795862)) * (maxY - minY) / (2 * pixelH) + minY;
        
        return new Point(x,y);
    }
    
    public function pixelToPoint_3D_2(px, py, level):Point{
        var pixelW = 917.25 * level;
		var pixelH = 690 * level;
		var minX = 113.9327;
		var maxX = 113.9967;
		var minY = 22.4878;
		var maxY = 22.5325;
        var x:Number = ((px + level * 9) / Math.cos(0.62831853071795862) - (pixelH - py - level * 287) / Math.sin(0.62831853071795862)) * (maxX - minX) / (2 * pixelW) + minX;
       	var y:Number = ((pixelH - py - level * 287) / Math.sin(0.62831853071795862) + (px + level * 9) / Math.cos(0.62831853071795862)) * (maxY - minY) / (2 * pixelH) + minY;
        
        return new Point(x,y);
    }
    
    public function pointToPixel_3D_1(x, y, level):Point{
        var pixelW = 1064.25 * level;
		var pixelH = 698.5 * level;
		var minX = 113.9576;
		var maxX = 113.9953;
		var minY = 22.5275;
		var maxY = 22.5504;
		var x1 = ((x - minX) / (maxX - minX)) * pixelW;
		var y1 = ((y - minY) / (maxY - minY)) * pixelH;
		var px:Number = (x1 + y1) * Math.cos(0.62831853071795862);
		var py:Number = (y1 - x1) * Math.sin(0.62831853071795862);
		px -= level * 9;
		py = pixelH - py;
		
		return new Point(Math.round(px),Math.round(py));
    }
    
    public function pointToPixel_3D_2(x, y, level):Point{
        var pixelW = 917.25 * level;
		var pixelH = 690 * level;
		var minX = 113.9327;
		var maxX = 113.9967;
		var minY = 22.4878;
		var maxY = 22.5325;
		var x1 = ((x - minX) / (maxX - minX)) * pixelW;
		var y1 = ((y - minY) / (maxY - minY)) * pixelH;
		var px:Number = (x1 + y1) * Math.cos(0.62831853071795862);
		var py:Number = (y1 - x1) * Math.sin(0.62831853071795862);
		py = pixelH - py;
		px -= level * 9;
        py -= level * 287;
		
		return new Point(Math.round(px), Math.round(py));
    }
    
     //PixelCoords坐标系中，各个level之间的坐标转换
	function converterPixelCoords(fromLevel, pixelPoint, toLevel){
		var returnPixel={Px:0,Py:0};
		//计算两个级别之间的差别数
		var n=Math.pow(2,Math.abs(toLevel-fromLevel));
		//判读是正差别还是复差别
		if(toLevel-fromLevel>0){
			//计算
			returnPixel.Px=Math.round(pixelPoint.Px/n);
			returnPixel.Py=Math.round(pixelPoint.Py/n);
		}else{
			returnPixel.Px=pixelPoint.Px*n;
			returnPixel.Py=pixelPoint.Py*n;
		}
		return returnPixel;
	}
	
	//获取point点的当前level级别像素坐标系坐标
	function converterM2P(mapPoint, level){
		var returnPixel={Px:0,Py:0};
		var pixelPoint:Object;
		var reducedRate=1;
		
		//将MapCoords转换成level=1的PixelCoords坐标系的坐标
		if(mapPoint){
		    pixelPoint={Px:parseInt(String(mapPoint.Mx/reducedRate)), Py:parseInt(String(mapPoint.My/reducedRate))};
		    //将level=1的Pixel坐标转换成指定的level的PixelCoords坐标
		    returnPixel=converterPixelCoords(1, pixelPoint, level);
		}
		return returnPixel;
	}
	
    //将PixelCoords转换成MapCoords
	function converterP2M(pixelPoint, level){
		var returnMapPoint;
		var pixelPoint;
		var reducedRate=1;
		
		//将当前level级别的pixelPoint点坐标转化为level=1级别的坐标
		pixelPoint=converterPixelCoords(level, pixelPoint, 1);
		//将level=1级别的pixelPoint点坐标转化成MapCoords坐标
		returnMapPoint={Mx:pixelPoint.Px*reducedRate, My:pixelPoint.Py*reducedRate};
		
		return returnMapPoint;
	}
	
	//获取mapPoint点的当前level级别的图块文件坐标系的坐标
	function getFileCoords(mapPoint, sliceSize, level){
		var pixelPoint;
		var returnFilePoint:Object;
		
		//此点的PixelCoords坐标系坐标
		pixelPoint=converterM2P(mapPoint, level);
		//PixelCoords坐标系坐标除以sliceSize切片尺寸即可获得FileCoords坐标系坐标
		returnFilePoint={Fx:parseInt(String(pixelPoint.Px/sliceSize)), Fy:parseInt(String(pixelPoint.Py/sliceSize))};
		
		return returnFilePoint;
	}
		
		//转屏幕坐标
		/**
		 * x,y 经纬度
		 * w,h 屏幕宽高
		 * centerX,centerY point 当前屏幕中心点(经纬度 )
		 * tilemapindex 地图级别
		 *  mapConfig
		 * */
		public function toScreenPoint(x:Number, y:Number, w:Number, h:Number, scale:Number, centerX:Number, centerY:Number,tilemapindex:int,wscale:Number,hscale:Number):Point
		{
			
			if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
            var x:Number = Math.round(w / 2 + (x - centerX) / wscale);
            var y:Number = Math.round(h / 2 - (y - centerY) / hscale);
       		 }
       	 	else if(tilemapindex == 2||tilemapindex == 8){
            var pixC = pointToPixel_3D_1(centerX, centerY, scale);
			var pixP = pointToPixel_3D_1(x, y, scale);
			x = Math.round(w / 2 + (pixP.x - pixC.x));
            y = Math.round(h / 2 - (pixC.y - pixP.y));
			}
			else if(tilemapindex==5|| tilemapindex == 6){
            var pixC = pointToPixel_3D_2(centerX, centerY, scale);
			var pixP = pointToPixel_3D_2(x, y, scale);
			x = Math.round(w / 2 + (pixP.x - pixC.x));
            y = Math.round(h / 2 - (pixC.y - pixP.y));
            
       		 } else if(tilemapindex == 7){
            var pixP = converterM2P({Mx:x, My:y}, scale);
            var pixC = converterM2P({Mx:centerX, My:centerY}, scale);
            
            x = Math.round(w / 2 + (pixP.Px - pixC.Px));
            y = Math.round(h / 2 + (pixP.Py - pixC.Py));
        }
       		 return new Point(x,y);
		}
		
//		public static function toCLDPoint_old(x:Number, y:Number, w:Number, h:Number, scale:Number, centerX:Number, centerY:Number):Point
//		{
//			var nx:Number=(x - w / 2) * scale + centerX;
//			var ny:Number=(h / 2 - y) * scale + centerY;
//			return new Point(nx, ny);
//		}
		private function LonToProjectionX(x):*
		{
			return x;
		}
		private function LatToProjectionY(y):*
		{
			return y;
		}
		public function getMapPoint(x, y, point,mw,mh,zoom,config:MapConfig) {
			var data={};
			config.loadZoomConfig(data,zoom); // 读取配置
			
			var projectionX = 0;
			var projectionY = 0;
			var tilemapindex=data.tilemapindex;
			if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
				// 新的屏幕坐标
				var offsetx = Math.round(Math.floor(mw) / 2 + (LonToProjectionX(x) - config.x) / data.wscale);
				var offsety = Math.round(Math.floor(mh) / 2 - (LatToProjectionY(y) - config.y) / data.hscale);
				
				projectionX = ProjectionXToLon(config.x + (offsetx -point.x) * data.wscale);
				projectionY = ProjectionYToLat(config.y + (point.y - offsety) * data.hscale);
			}
			else if(tilemapindex == 2 || tilemapindex == 8){
				var pixP = pointToPixel_3D_1(x, y, data.scale);
				var offsetx = Math.round(Math.floor(mw) / 2 + pixP.x);
				var offsety = Math.round(Math.floor(mh) / 2 + pixP.y);
				var ps = pixelToPoint_3D_1((offsetx - point.x), (offsety - point.y), data.scale);
				
				projectionX = ps.x;
				projectionY = ps.y;
			}
			else if(tilemapindex == 5 || tilemapindex == 6){
				var pixP = pointToPixel_3D_2(x, y, data.scale);
				var offsetx = Math.round(Math.floor(mw) / 2 + pixP.x);
				var offsety = Math.round(Math.floor(mh) / 2 + pixP.y);
				var ps = pixelToPoint_3D_2((offsetx - point.x), (offsety - point.y), data.scale);
				
				projectionX = ps.x;
				projectionY = ps.y;
			}
			else if(tilemapindex == 7){
				var pixP = converterM2P({Mx:x, My:y}, data.scale);
				var offsetx = Math.round(Math.floor(mw) / 2 + pixP.Px);
				var offsety = Math.round(Math.floor(mh) / 2 + pixP.Py);
				var ps = converterP2M({Px:(offsetx - point.x), Py:(offsety - point.y)}, data.scale);
				
				projectionX = Math.round(ps.Mx);
				projectionY = Math.round(ps.My);
			}
			
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
				
		};
		/**
		 * 用于缩放
		 * 获取地图坐标
		 *  x,y 屏幕坐标
		 *  w,h 屏幕宽高
		 *  point 当前屏幕中心点(经纬度 )
		 *  tilemapindex 地图级别
		 *  mapConfig
		 * 
		 * */
		
        public function getMapPoint0(x, y,w, h, point:Point,mapConfig:MapConfig):Point {
        	
        var data:MapConfig = mapConfig; // 读取配置
        var tilemapindex:int=data.tilemapindex;
        var projectionX:Number = 0;
        var projectionY:Number = 0;
        
        if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
            // 新的屏幕坐标
            var offsetx = Math.round(Math.floor(w) / 2 + (x - data.x) / data.wscale);
            var offsety = Math.round(Math.floor(h) / 2 - (y - data.y) / data.hscale);
            
            projectionX = data.x + (offsetx -point.x) * data.wscale;
            projectionY = data.y + (point.y - offsety) * data.hscale;
        }
        else if(tilemapindex == 2||tilemapindex == 8){
            var pixP = pointToPixel_3D_1(x, y, data.scale);
            var offsetx = Math.round(Math.floor(w) / 2 + pixP.x);
            var offsety = Math.round(Math.floor(h) / 2 + pixP.y);
            var ps = pixelToPoint_3D_1((offsetx - point.x), (offsety - point.y), data.scale);
            
            projectionX = ps.x;
            projectionY = ps.y;
        }
        else if(tilemapindex == 5 || tilemapindex == 6){
            var pixP = pointToPixel_3D_2(x, y, data.scale);
            var offsetx = Math.round(Math.floor(w) / 2 + pixP.x);
            var offsety = Math.round(Math.floor(h) / 2 + pixP.y);
            var ps = pixelToPoint_3D_2((offsetx - point.x), (offsety - point.y), data.scale);
            
            projectionX = ps.x;
            projectionY = ps.y;
        }
        
        // 作为WGS84经纬度处理 add by liyg 2010.12.16
       
//            x = Math.round(projectionX);
//            y = Math.round(projectionY);
//        
    	
        return new Point(projectionX,projectionY);
    };
    
     public function toMapPoint(x, y,w,h,center,config):Point {
        
        var width:int = int(w);
        var height:int = parseInt(h);
        var projectionX:Number = 0;
        var projectionY:Number = 0;
        var tilemapindex=config.tilemapindex;
        if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
            //lijian coord
            projectionX = center.x + (x - width / 2) * config.wscale;
            projectionY = center.y + (height / 2 - y) * config.hscale;
        }
        else if(tilemapindex == 2 ||tilemapindex == 8){
            var pixC = pointToPixel_3D_1(center.x, center.y, config.scale);
            var ps = pixelToPoint_3D_1((pixC.x+x-width/2), (pixC.y+y-height/2), config.scale);
            
            projectionX = ps.x;
            projectionY = ps.y;
        }
        else if(tilemapindex == 5 || tilemapindex == 6){
            var pixC = pointToPixel_3D_2(center.x, center.y, config.scale);
            var ps = pixelToPoint_3D_2((pixC.x+x-width/2), (pixC.y+y-height/2), config.scale);
            
            projectionX = ps.x;
            projectionY = ps.y;
        }else if(tilemapindex == 7){
            var pixC = converterM2P({Mx:center.x, My:center.y}, config.scale);
            var newC = converterP2M({Px:(pixC.Px+(x-width/2)), Py:(pixC.Py+(y-height/2))}, config.scale);
            
            projectionX = Math.round(newC.Mx);
            projectionY = Math.round(newC.My);
        }
//            x = Math.round(projectionX);
//            y = Math.round(projectionY);
        
    	
        return new Point(projectionX,projectionY);
    };
    
    
    	public function getMapImages(config,center,width,height,tilemapindex):Array
    	{
    			var images:Array=[];
    		    if(tilemapindex <= 1){
            	   images= createCLDMaping(config,center,width,height);
       		 	}
        		else if(tilemapindex >= 2 && tilemapindex <= 4){
        			 images= createCLDMaping0(config,center,width,height,tilemapindex);
        		
    			}else if(tilemapindex == 5 || tilemapindex == 6){
    				images =createCLDMaping1(config,center,width,height);
    			}else if(tilemapindex==7){
    				images =createCLDMaping2(config,center,width,height);
    			}else if(tilemapindex == 8){
    				images= createCLDMaping0(config,center,width,height,tilemapindex);
    			}
    			return images;
    	}
    	
    	public function createCLDMaping0(config:Object, center:Point, width:int, height:int,tilemapindex):Array
    	{
    		var images = [];
	        var IW = config.ImageWidth;
	        var IH = config.ImageHeight;
	        //保存
	        var push = function(x,y,row,col,src,id){
	            if(row < 0 || col < 0){
	                return;
	            }
	            row++;
	            col++;
		        images.push({"id":id,"x":x,"row" : row,"col" : col,"y":y,"z":config.zoom,"src":(src+ "T_" + col + "_" + row + "." + config.ImageFormat)});
            };
        	
        	if(tilemapindex == 2){
        	    var pixC = pointToPixel_3D_1(center.x, center.y, config.scale);
        	    var pixLT = {x: (pixC.x-Number(width)/2), y: (pixC.y-Number(height)/2)};
        	}
        	else{
        	    var pixLT = {x: ((center.x-config.x)/config.wscale-width/2), y: ((config.y-center.y)/config.hscale-height/2)};
        	}
        	
            //计算落在视图范围内的起始图片的行、列索引
            var startRowIndex = Math.floor(pixLT.y / IH);
            var startColIndex = Math.floor(pixLT.x / IW);
            //计算落在视图范围内的起始图片的Left和Bottom值
            var startLeft = Math.round(-(pixLT.x - startColIndex * IW));
            var startTop = Math.round(-(pixLT.y - startRowIndex * IH));

            //计算落在视图范围内的图片的行数和列数
            var rowsInView = Math.floor((height-startTop) / IH);
            if ((height - startTop) % IH != 0)
                rowsInView++;
            var colsInView = Math.floor((width - startLeft) / IW);
            if ((width - startLeft) % IW != 0)
                colsInView++;
            
            for (var rowIndex = 0; rowIndex < rowsInView; rowIndex++){
                var top = startTop + rowIndex * IH;
                for (var colIndex = 0; colIndex < colsInView; colIndex++){ 
                    var left = startLeft + colIndex * IW;
                    // 返回获取的图片
                    var row = (rowIndex + startRowIndex);
                    var col = (colIndex + startColIndex);
                    var aPath = config.MapFolder + "/";
                    
                   var id="cld_" + config.zoom + "_" + aPath.replace("/", "_") + "_" + row + "_" + col;
			        push(left,top,row,col,aPath,id);
                }
            }
            
	        return images;
    	}
    	
    	public function createCLDMaping1(config:Object, center:Point, width:int, height:int):Array
    	{
    		var images = [];
	        var IW = config.ImageWidth;
	        var IH = config.ImageHeight;
	        //保存
	        var push = function(x,y,row,col,src,id){
	            if(row < 0 || col < 0){
	                return;
	            }
	            row++;
	            col++;
		        images.push({"id":id,"x":x,"row" : row,"col" : col,"y":y,"z":config.zoom,"src":(src+ "T_" + col + "_" + row + "." + config.ImageFormat)});
            };
        	
        	var pixC = pointToPixel_3D_2(center.x, center.y, config.scale);
    	    var pixLT = {x: (pixC.x-Number(width)/2), y: (pixC.y-Number(height)/2)};
        	
            //计算落在视图范围内的起始图片的行、列索引
            var startRowIndex = Math.floor(pixLT.y / IH);
            var startColIndex = Math.floor(pixLT.x / IW);
            //计算落在视图范围内的起始图片的Left和Bottom值
            var startLeft = Math.round(-(pixLT.x - startColIndex * IW));
            var startTop = Math.round(-(pixLT.y - startRowIndex * IH));

            //计算落在视图范围内的图片的行数和列数
            var rowsInView = Math.floor((height-startTop) / IH);
            if ((height - startTop) % IH != 0)
                rowsInView++;
            var colsInView = Math.floor((width - startLeft) / IW);
            if ((width - startLeft) % IW != 0)
                colsInView++;
            
            for (var rowIndex = 0; rowIndex < rowsInView; rowIndex++){
                var top = startTop + rowIndex * IH;
                for (var colIndex = 0; colIndex < colsInView; colIndex++){ 
                    var left = startLeft + colIndex * IW;
                    // 返回获取的图片
                    var row = (rowIndex + startRowIndex);
                    var col = (colIndex + startColIndex);
                    var aPath = config.MapFolder + "/";
                    
                    var id="cld_" + config.zoom + "_" + aPath.replace("/", "_") + "_" + row + "_" + col;
                    
			        push(left,top,row,col,aPath,id);
                }
            }
            
	        return images;
    	}
		public function createCLDMaping2(config:Object, center:Point, width:int, height:int):Array
    	{
    		 var images = [];
            var IW = config.ImageWidth;
            var IH = config.ImageHeight;
            //保存
            var push = function(x,y,row,col,src,id){
                if(row < 0 || col < 0){
                    return;
                }
                row++;
                col++;
	            images.push({"id":id,"x":x,"row" : row,"col" : col,"y":y,"z":config.zoom,"src":(src + "." + config.ImageFormat)});
            };
        	
    	    var pixC = converterM2P({Mx:center.x, My:center.y}, config.scale);
    	    var pixLT = {x:(pixC.Px-width/2), y: (pixC.Py-height/2)};
    	    var viewLeftTop = getFileCoords(converterP2M({Px:pixLT.x, Py:pixLT.y}, config.scale), IW, config.scale);
        	
            //计算落在视图范围内的起始图片的行、列索引
            var startRowIndex = Math.floor(pixLT.y / IH);
            var startColIndex = Math.floor(pixLT.x / IW);
            //计算落在视图范围内的起始图片的Left和Bottom值
            var startLeft = Math.round(-(pixLT.x - startColIndex * IW));
            var startTop = Math.round(-(pixLT.y - startRowIndex * IH));

            //计算落在视图范围内的图片的行数和列数
            var rowsInView = Math.floor((height-startTop) / IH);
            if ((height - startTop) % IH != 0)
                rowsInView++;
            var colsInView = Math.floor((width - startLeft) / IW);
            if ((width - startLeft) % IW != 0)
                colsInView++;
            
            var tilePoint = null;
            for (var rowIndex = 0; rowIndex < rowsInView; rowIndex++){
                var top = startTop + rowIndex * IH;
                for (var colIndex = 0; colIndex < colsInView; colIndex++){ 
                    //计算其中某一图块的块坐标
                    tilePoint = {Fx:viewLeftTop.Fx+colIndex, Fy:viewLeftTop.Fy+rowIndex};
    				
                    var left = startLeft + colIndex * IW;
                    // 返回获取的图片
                    var row = (rowIndex + startRowIndex);
                    var col = (colIndex + startColIndex);
                    var aPath = config.MapFolder + "/" + tilePoint.Fx + "," + tilePoint.Fy;
                    
                     var id="cld_" + config.zoom + "_" + aPath.replace("/", "_") + "_" + row + "_" + col;
		            push(left,top,row,col,aPath,id);
                }
            }
            
            return images;
    	}

		public static function toScreenPoint_old(x:Number, y:Number, w:Number, h:Number, scale:Number, centerX:Number, centerY:Number):Point
		{
			var nx:Number=Math.round(w / 2 + (x - centerX) / scale);
			var ny:Number=Math.round(h / 2 - (y - centerY) / scale);
			return new Point(nx, ny);
		}

		//获取careland 坐标
		public static function toCLDPoint_old(x:Number, y:Number, w:Number, h:Number, scale:Number, centerX:Number, centerY:Number):Point
		{
			var nx:Number=(x - w / 2) * scale + centerX;
			var ny:Number=(h / 2 - y) * scale + centerY;
			return new Point(nx, ny);
		}

		  

		public static function getMapDistance(p1:Point, p2:Point)
		{
			var tmpp1=p1;
			var tmpp2=p2;

			tmpp1=new CLDPoint((p1.x * 3600000), (p1.y * 3600000));
			tmpp2=new CLDPoint((p2.x * 3600000), (p2.y * 3600000));

			var x=tmpp2.x - tmpp1.x;
			var y=tmpp2.y - tmpp1.y;
			var cPoint=new CLDPoint(Math.abs(x / 2) + tmpp1.x, Math.abs(y / 2) + tmpp1.y);
			var arry=CLDMapPointConst(cPoint);
			var d=Math.sqrt(Math.pow(x * arry[0], 2) + Math.pow(y * arry[1], 2));
			return d;
		}


		public static var _cld_global_pointConst=null;

		public static function CLDMapPointConst(point):Array
		{
			if (!_cld_global_pointConst)
			{
				_cld_global_pointConst=[new CLDPoint(4053, 4026), new CLDPoint(4053, 4026), new CLDPoint(4052, 4026), new CLDPoint(4052, 4026), new CLDPoint(4051, 4026), new CLDPoint(4049, 4026), new CLDPoint(4047, 4026), new CLDPoint(4045, 4026), new CLDPoint(4043, 4026), new CLDPoint(4041, 4026), new CLDPoint(4038, 4026), new CLDPoint(4034, 4026), new CLDPoint(4031, 4026), new CLDPoint(4027, 4026), new CLDPoint(4023, 4026), new CLDPoint(4018, 4027), new CLDPoint(4014, 4027), new CLDPoint(4009, 4027), new CLDPoint(4003, 4027), new CLDPoint(3998, 4027), new CLDPoint(3992, 4027), new CLDPoint(3985, 4027), new CLDPoint(3979, 4027), new CLDPoint(3972, 4027), new CLDPoint(3965, 4028), new CLDPoint(3957, 4028), new CLDPoint(3950, 4028), new CLDPoint(3942, 4028), new CLDPoint(3933, 4028), new CLDPoint(3925, 4028), new CLDPoint(3916, 4029), new CLDPoint(3906, 4029), new CLDPoint(3897, 4029), new CLDPoint(3887, 4029), new CLDPoint(3877, 4029), new CLDPoint(3866, 4030), new CLDPoint(3856, 4030), new CLDPoint(3845, 4030), new CLDPoint(3833, 4030), new CLDPoint(3822, 4030), new CLDPoint(3810, 4031), new CLDPoint(3798, 4031), new CLDPoint(3785, 4031), new CLDPoint(3772, 4031), new CLDPoint(3759, 4032), new CLDPoint(3746, 4032), new CLDPoint(3732, 4032), new CLDPoint(3718, 4032), new CLDPoint(3704, 4033), new CLDPoint(3690, 4033), new CLDPoint(3675, 4033), new CLDPoint(3660, 4033), new CLDPoint(3645, 4034), new CLDPoint(3629, 4034), new CLDPoint(3613, 4034), new CLDPoint(3597, 4035), new CLDPoint(3581, 4035), new CLDPoint(3564, 4035), new CLDPoint(3547, 4035), new CLDPoint(3530, 4036), new CLDPoint(3512, 4036), new CLDPoint(3495, 4036), new CLDPoint(3477, 4037), new CLDPoint(3458, 4037), new CLDPoint(3440, 4037), new CLDPoint(3421, 4038), new CLDPoint(3402, 4038), new CLDPoint(3383, 4038), new CLDPoint(3363, 4039), new CLDPoint(3343, 4039), new CLDPoint(3323, 4039), new CLDPoint(3303, 4040), new CLDPoint(3282, 4040), new CLDPoint(3261, 4040), new CLDPoint(3240, 4041), new CLDPoint(3219, 4041), new CLDPoint(3197, 4041), new CLDPoint(3175, 4042), new CLDPoint(3153, 4042), new CLDPoint(3131, 4042), new CLDPoint(3108, 4043), new CLDPoint(3086, 4043), new CLDPoint(3063, 4043), new CLDPoint(3039, 4044), new CLDPoint(3016, 4044), new CLDPoint(2992, 4044), new CLDPoint(2968, 4045), new CLDPoint(2944, 4045), new CLDPoint(2920, 4045), new CLDPoint(2895, 4046), new CLDPoint(2870, 4046), new CLDPoint(2845, 4047), new CLDPoint(2820, 4047), new CLDPoint(2794, 4047), new CLDPoint(2768, 4048), new CLDPoint(2742, 4048), new CLDPoint(2716, 4048), new CLDPoint(2690, 4049), new CLDPoint(2663, 4049), new CLDPoint(2637, 4049), new CLDPoint(2610, 4050), new CLDPoint(2582, 4050), new CLDPoint(2555, 4050), new CLDPoint(2527, 4051), new CLDPoint(2500, 4051), new CLDPoint(2472, 4051), new CLDPoint(2444, 4052), new CLDPoint(2415, 4052), new CLDPoint(2387, 4053), new CLDPoint(2358, 4053), new CLDPoint(2329, 4053), new CLDPoint(2300, 4054), new CLDPoint(2271, 4054), new CLDPoint(2241, 4054), new CLDPoint(2212, 4054), new CLDPoint(2182, 4055), new CLDPoint(2152, 4055), new CLDPoint(2122, 4055), new CLDPoint(2092, 4056), new CLDPoint(2061, 4056), new CLDPoint(2031, 4056), new CLDPoint(2000, 4057), new CLDPoint(1969, 4057), new CLDPoint(1938, 4057), new CLDPoint(1907, 4058), new CLDPoint(1876, 4058), new CLDPoint(1844, 4058), new CLDPoint(1812, 4058), new CLDPoint(1781, 4059), new CLDPoint(1749, 4059), new CLDPoint(1717, 4059), new CLDPoint(1685, 4060), new CLDPoint(1652, 4060), new CLDPoint(1620, 4060), new CLDPoint(1587, 4060), new CLDPoint(1555, 4061), new CLDPoint(1522, 4061), new CLDPoint(1489, 4061), new CLDPoint(1456, 4061), new CLDPoint(1423, 4062), new CLDPoint(1389, 4062), new CLDPoint(1356, 4062), new CLDPoint(1323, 4062), new CLDPoint(1289, 4063), new CLDPoint(1255, 4063), new CLDPoint(1222, 4063), new CLDPoint(1188, 4063), new CLDPoint(1154, 4063), new CLDPoint(1120, 4064), new CLDPoint(1086, 4064), new CLDPoint(1051, 4064), new CLDPoint(1017, 4064), new CLDPoint(983, 4064), new CLDPoint(948, 4064), new CLDPoint(914, 4065), new CLDPoint(879, 4065), new CLDPoint(844, 4065), new CLDPoint(810, 4065), new CLDPoint(775, 4065), new CLDPoint(740, 4065), new CLDPoint(705, 4065), new CLDPoint(670, 4066), new CLDPoint(635, 4066), new CLDPoint(600, 4066), new CLDPoint(565, 4066), new CLDPoint(530, 4066), new CLDPoint(495, 4066), new CLDPoint(459, 4066), new CLDPoint(424, 4066), new CLDPoint(389, 4066), new CLDPoint(353, 4066), new CLDPoint(318, 4066), new CLDPoint(283, 4066), new CLDPoint(247, 4067), new CLDPoint(212, 4067), new CLDPoint(176, 4067), new CLDPoint(141, 4067), new CLDPoint(105, 4067), new CLDPoint(70, 4067), new CLDPoint(35, 4067), new CLDPoint(1, 4067)];
			}
			var y=int((point.y + 900000) / 1800000);
			if (y < 0 || y > 180)
			{
				y=0;
			}
			var x=_cld_global_pointConst[y].x / (Math.pow(2, 17));
			y=_cld_global_pointConst[y].y / (Math.pow(2, 17));
			return [x, y];
		}
		;


		public function createCLDMaping(config:Object, center:Point, width:int, height:int):Array
		{
			var images:Array=[];
			var IW:int=config.ImageWidth;
			var IH:int=config.ImageHeight;
			var mapwidth:int=width;
			var mapheight:int=height;


			//保存
			var push:Function=function(x:Number, y:Number, row:int, col:int, src:String, id:String):void
			{
				if (row < 0 || col < 0)
				{
					return;
				}
				images.push({"id": id, "x": x, "row": row, "col": col, "y": y, "z": config.zoom, "src": (src + row + "_" + col + "." + config.ImageFormat), "lod": true});
			};

			var viewLeft:Number=center.x - Number(width / 2) * config.scale;
			var viewBottom:Number=center.y - Number(height / 2) * config.scale;
			var mapLeft:Number=center.x - Number(mapwidth / 2) * config.scale;
			var mapBottom:Number=center.y - Number(mapheight / 2) * config.scale;
			//计算落在视图范围内的起始图片的行、列索引
			var startRowIndex:int=Math.floor((mapBottom - config.viewBY) / (IH * config.scale));

			var startColIndex:int=Math.floor((mapLeft - config.x) / (IW * config.scale));


			//计算落在视图范围内的起始图片的Left和Bottom值
			var startLeft:Number=Math.round(-((viewLeft - config.x) / config.scale - startColIndex * IW));
			var startBottom:Number=Math.round(-((viewBottom - config.viewBY) / config.scale - startRowIndex * IH));

			//计算落在视图范围内的图片的行数和列数
			var rowsInView:int=Math.floor((mapheight - startBottom) / IH);
			if ((mapheight - startBottom) % IH != 0)
				rowsInView++;
			var colsInView:int=Math.floor((mapwidth - startLeft) / IW);
			if ((mapwidth - startLeft) % IW != 0)
				colsInView++;

			for (var rowIndex:int=0; rowIndex < rowsInView; rowIndex++)
			{
				var top:Number=height - (startBottom + (rowIndex + 1) * IH);
				for (var colIndex:int=0; colIndex < colsInView; colIndex++)
				{
					var left:Number=startLeft + colIndex * IW;
					// 返回获取的图片
					var row:int=(rowIndex + startRowIndex);
					var col:int=(colIndex + startColIndex);
					var index:int=Number(row * config.cols + col);
					var aPath:String=config.MapFolder + "/";
					var param:Array=config.LevelParam;
					for (var i=0; i < param.length; i++)
					{
						var n:int=index % param[i];
						aPath+=n + "/";

						index=index / config.MaxFilesPerFolder;
					}
					//var patten:RegExp=/\//g;
					var id="cld_" + config.zoom + "_" + aPath.replace("/", "_") + "_" + row + "_" + col;
					//var id="cldid";
					push(left, top, row, col, aPath, id);
				}
			}

			return images;
		}
		public function ProjectionXToLon(value:Number):Number
		{
			return value;
		}
		public function ProjectionYToLat(value:Number):Number
		{
			return value;
		}
		/**
		 *   point 要设置的中心点
		 *   mapConfig //地图配置文件
		 *   mw mh:地图宽度和高度
		 * **/
		public function setMapCenterPoint(point,mapConfig:MapConfig,mw:Number,mh:Number):Point{
			var config:MapConfig = mapConfig;//CLDGLOBALOBJ.config?_CLDGLOBALOBJ.config:(new CLDLoadConfig(Careland.map.zoom ? Careland.map.zoom:0));
			var tilemapindex:int=mapConfig.tilemapindex;
			var rp:Point=new Point(0,0);
			if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
				// 超出容器范围直接取中心点
				var mapWidth = mw / 2 * config.wscale;
				var mapHeight = mh / 2 * config.hscale;
				// 超出左边
				//lijian coord
				if (point.x <= (config.viewAX + mapWidth)) {
					point.x = (config.viewAX + mapWidth);
				}
					// 超出右边
				else if (point.x > (config.viewBX - mapWidth)) {
					point.x = (config.viewBX - mapWidth);
				}
				
				// 超出上边
				if (point.y >= (config.viewAY - mapHeight)) {
					point.y = (config.viewAY - mapHeight);
				}
					// 超出下边
				else if (point.y < (config.viewBY + mapHeight)) {
					point.y = (config.viewBY + mapHeight);
				}
				rp = new Point(point.x, point.y);
			}
			else if(tilemapindex == 2 || tilemapindex == 8){
				// 超出容器范围直接取中心点
				var pixRC = {x: (config.pixelwidth-mw/2), y: (config.pixelheight-mh/2)};
				var pixel = pointToPixel_3D_1(point.x, point.y, config.scale);
				
				// 超出左边
				//lijian coord
				if (pixel.x <= mw/2) {
					pixel.x = mw/2;
				}
					// 超出右边
				else if (pixel.x > pixRC.x) {
					pixel.x = pixRC.x;
				}
				
				// 超出上边
				if (pixel.y <= mh/2) {
					pixel.y = mh/2;
				}
					// 超出下边
				else if (pixel.y > pixRC.y) {
					pixel.y = pixRC.y;
				}
				
				var newC = pixelToPoint_3D_1(pixel.x, pixel.y, config.scale);
				rp = new Point(newC.x, newC.y);
			}
			else if(tilemapindex == 5 ||tilemapindex == 6){
				// 超出容器范围直接取中心点
				var pixRC = {x: (config.pixelwidth-mw/2), y: (config.pixelheight-mh/2)};
				var pixel = pointToPixel_3D_2(point.x, point.y, config.scale);
				
				// 超出左边
				//lijian coord
				if (pixel.x <= mw/2) {
					pixel.x = mw/2;
				}
					// 超出右边
				else if (pixel.x > pixRC.x) {
					pixel.x = pixRC.x;
				}
				
				// 超出下边
				if (pixel.y <= mh/2) {
					pixel.y = mh/2;
				}
					// 超出上边
				else if (pixel.y > pixRC.y) {
					pixel.y = pixRC.y;
				}
				
				var newC = pixelToPoint_3D_2(pixel.x, pixel.y, config.scale);
				rp = new Point(newC.x, newC.y);
			}
			else if(tilemapindex == 7){
				// 超出容器范围直接取中心点
				var pixLC = {x:(config.x+mw/2), y:(config.y+mh/2)};
				var pixRC = {x:(config.pixelwidth-mw/2), y:(config.pixelheight-mh/2)};
				var pixel = converterM2P({Mx:point.x, My:point.y}, config.scale);
				
				// 超出左边
				if (pixel.Px <= pixLC.x) {
					pixel.Px = pixLC.x;
				}
					// 超出右边
				else if (pixel.Px > pixRC.x) {
					pixel.Px = pixRC.x;
				}
				
				// 超出下边
				if (pixel.Py <= pixLC.y) {
					pixel.Py = pixLC.y;
				}
					// 超出上边
				else if (pixel.Py > pixRC.y) {
					pixel.Py = pixRC.y;
				}
				
				var newC = converterP2M(pixel, config.scale);
			    rp = new Point(newC.Mx, newC.My);
			}
			return rp;
		}
		
	}
}