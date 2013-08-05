package com.careland.layer
{
	import __AS3__.vec.Vector;
	
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class CLDLayer extends Sprite
	{
		
		protected var markers:Vector.<CLDMarker>=new Vector.<CLDMarker>;
		protected var polylines:Vector.<CLDPolyLine>=new Vector.<CLDPolyLine>;
		protected var polygons:Vector.<CLDPolygon>=new Vector.<CLDPolygon>;
		protected var circles:Vector.<CLDCircle>=new Vector.<CLDCircle>;
		
		private var baseMarkers:Vector.<CLDBaseMarker>=new Vector.<CLDBaseMarker>;
		
		public var id:int=-1;
		
		
		public function CLDLayer()
		{
			super();
		}
		
		
		public function add(bk:CLDBaseMarker):void
		{
			this.addChild(bk);
			bk.layer=this;
			baseMarkers.push(bk);
		}
		
	
		public function addMarker(m:CLDMarker):void
		{
			this.addChild(m);
			m.layer=this;
			markers.push(m);
		}
		public function addLine(polyline:CLDPolyLine):void
		{
			this.addChild(polyline);
			polyline.layer=this;
			polylines.push(polyline);
		}
		public function addgon(polygon:CLDPolygon):void
		{
			this.addChild(polygon);
			polygon.layer=this;
			polygons.push(polygon);
		}
		
		public function addCircle(circle:CLDCircle):void
		{
			this.addChild(circle);
			circle.layer=this;
			circles.push(circle);
		}
		
		public function removeRect(rect:CLDPolygon):void
		{
			this.removeChild(rect);
			rect.dispose();
			rect.layer=null;
			
			for(var i:int=0;i<this.polygons.length;i++)
			{
				
				if(polygons[i]===rect){
					this.polygons.splice(i,1);
					break;
				}
				
			}
		}
		public function removeCircle(circle:CLDCircle):void
		{
			this.removeChild(circle);
			circle.dispose();
			circle.layer=null;
			
			for(var i:int=0;i<this.circles.length;i++)
			{
				
				if(circles[i]===circle){
					this.circles.splice(i,1);
					break;
				}
				
			}
		}
		
		public function dispose():void
		{
			while(this.numChildren>0)
			{
				var dis:DisplayObject=this.getChildAt(0);
				CLDBaseMarker(dis).dispose();
				this.removeChild(dis);
			}
			this.markers.splice(0,markers.length);
			this.polylines.splice(0,polylines.length);
			this.polygons.splice(0,polygons.length);
			this.circles.splice(0,circles.length);
		}
		
		
		
		
		public function update(centerPoint:Point,vscale:Number,sw:Number,sh:Number,globel:Point,mapConfig:MapConfig):void
		{
			
			for each(var marker:CLDMarker in markers){
				//var stagePoint:Point=CLDConfig.instance().toScreenPoint(marker.cldPoint.x,marker.cldPoint.y,1024,768,CLDConfig.instance().scale,centerPoint.x, centerPoint.y);
//				var np:Point=getScreenPoint(marker.cldPoint,centerPoint,vscale,sw,sh);
//				marker.x=np.x;
//				marker.y=np.y;
				marker.change(centerPoint,globel,mapConfig);
			}
			
			for each(var line:CLDPolyLine in polylines){
				line.change(centerPoint,globel,mapConfig);
			}
			for each(var gon:CLDPolygon in polygons){
				gon.change(centerPoint,globel,mapConfig);
			}
			
			for each(var circle:CLDCircle in circles){
				circle.change(centerPoint,globel,mapConfig);
			}
			//changeLine(centerPoint);
		}
		//根据屏幕上相对坐标获取careland坐标
		protected function getCLDPoint(screenPoint:Point,mapConfig:MapConfig):Point
		{
			var stagePoint:Point=CLDConfig.instance().toMapPoint(screenPoint.x,screenPoint.y,mapConfig);
			
			return stagePoint;
		}
		
		public function getScreenPoint(cldPoint:Point,mapConfig:MapConfig):Point
		{
			var stagePoint:Point=CLDConfig.instance().toScreenPoint(cldPoint.x,cldPoint.y,mapConfig);
			var sp:Point=this.globalToLocal(stagePoint);
			var layerGlobel:Point=this.parent.localToGlobal(new Point(this.x,this.y));
			sp.x+=layerGlobel.x;
			sp.y+=layerGlobel.y;
			return sp;
		}
		
		
		
		
	}
}