package com.careland.component.util
{
	import com.careland.component.CLDBaseComponent;
	import com.identity.CLDMap;
	
	import flash.geom.Point;
	
	public class MapUtil extends CLDBaseComponent
	{
		
		public var map:CLDMap;
		public function MapUtil()
		{
				
		}
		
		public static function setMapType(dt:String,map:CLDMap):void
		{
			if(dt==""){
				return;
			}
			//设置地图类型
			var contents:Array=dt.split("#");
			var title:String=contents[0];
			if(contents[1]){
				var ids:Array=contents[1].split("§")
					var mapUtil:MapUtil=new MapUtil();
					mapUtil.map=map;
					mapUtil.contentID=ids[0];
					mapUtil.autoLoad=true;
			}
		}
		
		override public function set data(value:*):void
		{
			try
			{
				var xml:XML=XML(value);
				var sdata:XML=xml.data[0];
				var point:Point=new Point(Number(sdata.@经度),Number(sdata.@纬度));
				var zoom:int=int(sdata.@级别);
				var level:int=int(sdata.@地图类型);
				map.setLocation(point,zoom,level);
				map.updateLayer();
			}catch(e:Error)
			{
				
			}
			
		}

	}
}