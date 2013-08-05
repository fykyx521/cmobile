package com.careland.util
{

	public class CLDMercator
	{

		private static var PI:Number=3.1415926535897932384626433832795;
		private static var HALFPI:Number=1.5707963267948966192313216916398;
		private static var QTRPI:Number=0.78539816339744830961566084581988;
		private static var DEG2RAD:Number=0.017453292519943295769236907684886;
		private static var RAD2DEG:Number=57.295779513082320876798154814105;
		private static var SPHEROID_R:Number=6378137.0;
		private static var EXP:Number=2.7182818284590452353602874713526625;
		private static var TileSize:Number=256;
		private static var InitialResolution:Number=156543.03392804062;
		private static var OriginShift:Number=20037508.342789244;

		public function CLDMercator()
		{

		}
		//		 /**
//    *add by lijian 2010.09.26
//    *通过像素值取得图片号
//    *px:像素X值
//    *py:像素Y值
//    *zoom:比例级别（0-19）
//    *返回值:图片号
//    **/
		public static function getTileNumber(px, py, zoom)
		{
			var digit;
			var quadKey=[];
			var tx=px / CLDMercator.TileSize;
			var ty=py / CLDMercator.TileSize;
			
			
			for (var i=zoom; i > 0; i--)
			{
				var mask=1 << (i - 1);
				if (ty & mask)
				{
					digit=2;
					if (tx & mask)
					{
						digit=1;
					}
				}
				else
				{
					digit=3;
					if (tx & mask)
					{
						digit=4;
					}
				}
				quadKey.push(digit);
			}
			return quadKey.join("");

		}
		   /**
    *add by lijian 2010.09.26
    *通过墨卡托投影坐标米值得到像素值
    *mx:墨卡托投影坐标X值
    *my:墨卡托投影坐标Y值
    *zoom:比例级别（0-19）
    *返回值:px像素X值，py像素Y值
    **/
		public static function MetersToPixels(mx, my, zoom):Object
		{
			 var res = CLDMercator.InitialResolution / (1 << zoom);
        	 var px = Math.floor((mx + CLDMercator.OriginShift) / res + 0.5);
        	 var py = Math.floor((my + CLDMercator.OriginShift) / res + 0.5);
        	 return { "x": px, "y": py };
		}





    /**
    *add by lijian 2010.09.26
    *通过像素值得到墨卡托投影坐标米值
    *px:像素值X值
    *py:像素值Y值
    *zoom:比例级别（0-19）
    *返回值:mx墨卡托投影坐标X值，my墨卡托投影坐标Y值
    **/
    public static function PixelsToMeters(px, py, zoom):Object {
        var res = CLDMercator.InitialResolution / (1 << zoom);
        var mx = px * res - CLDMercator.OriginShift;
        var my = py * res - CLDMercator.OriginShift;
        return { "x": mx, "y": my };
    }
//
    public static function Clip(n, minValue, maxValue) {
        return Math.min(Math.max(n, minValue), maxValue);
    }
//
    /**
    *add by lijian 2010.09.27
    *通过像素值得到WGS84坐标
    *px:像素值X值
    *py:像素值Y值
    *zoom:比例级别（0-19）
    *返回值:lon WGS84X值，lat WGS84Y值 (不准确)
    **/
    public static function PixelsToLonLat(px, py, zoom):Object{
        var mapSize = CLDMercator.TileSize << zoom;
        var x = (CLDMercator.Clip(px, 0, mapSize - 1) / mapSize) - 0.5;
        var y = (CLDMercator.Clip(py, 0, mapSize - 1) / mapSize) - 0.5;

        var lat = 90.0 - 360.0 * Math.atan(Math.exp(-y * 2 * CLDMercator.PI)) / CLDMercator.PI;
        var lon = 360.0 * x;

        return { "x": lon, "y": lat };
    }
//
    /**
    *add by lijian 2010.09.27
    *通过墨卡托投影坐标米值得到WGS84坐标
    *mx:墨卡托投影坐标X值
    *my:墨卡托投影坐标Y值
    *返回值:lon WGS84X值，lat WGS84Y值 (千分之一秒单位)
    **/
    public static function MetersToLonLat(mx, my) {
        var lon = (mx / CLDMercator.SPHEROID_R) * CLDMercator.RAD2DEG;
        var lat = (CLDMercator.HALFPI - 2.0 * Math.atan(Math.exp(-my / CLDMercator.SPHEROID_R))) * CLDMercator.RAD2DEG;
        lon = lon * 3600000.0;
        lat = lat * 3600000.0;
        return { "x": lon, "y": lat };
    }
//
    /**
    *add by lijian 2010.09.27
    *通过WGS84坐标得到墨卡托投影坐标米值
    *lon:WGS84X值 (千分之一秒单位)
    *lat:WGS84Y值 (千分之一秒单位)
    *返回值:lon 墨卡托投影坐标X值，lat 墨卡托投影坐标Y值
    **/
    public static function LonLatToMeters(lon, lat) {
        var dLon = lon / 3600000.0;
        var dLat = lat / 3600000.0;
        var x = CLDMercator.SPHEROID_R * dLon * CLDMercator.DEG2RAD;
        var y = CLDMercator.SPHEROID_R * Math.log(Math.tan(CLDMercator.QTRPI + dLat * (CLDMercator.DEG2RAD / 2.0)));
        return { "x": x, "y": y };
    }
//
    /**
    投影转X
    **/
    public static function ProjectionXToLon(x) {
        var lon = (x / CLDMercator.SPHEROID_R) * CLDMercator.RAD2DEG;
        return lon * 3600000.0;
    }
//
    /**
    投影转Y
    **/
     public static function ProjectionYToLat(y) {
        var lat = (CLDMercator.HALFPI - 2.0 * Math.atan(Math.exp(-y / CLDMercator.SPHEROID_R))) * CLDMercator.RAD2DEG;
        return lat * 3600000.0;
    }
//
	 
    /**
    X转投影
    **/
    public static function LonToProjectionX(lon) {
        var dLon = lon / 3600000.0;
        return CLDMercator.SPHEROID_R * dLon * CLDMercator.DEG2RAD;
    }
//
    /**
    Y转投影
    **/
    public static function LatToProjectionY(lat) {
        if (lat == 0) {
            return 0;
        }
        else {
            var dLat = lat / 3600000.0;
            return CLDMercator.SPHEROID_R * Math.log(Math.tan(CLDMercator.QTRPI + dLat * (CLDMercator.DEG2RAD / 2.0)));
        }
    }

	}
}