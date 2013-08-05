package com.careland.component.mapLayers
{
	import com.careland.layer.CLDMarker;
	
	import flash.geom.Point;
	
	
	public class CLDLpLayer extends CLDContentLayer
	{
		public function CLDLpLayer()
		{
			super();
		}
		public var url:String="";
		public function load():void
		{
			this.loadTxt(url,null,result);
		}
		override protected function loadComponentData(contentID:String,data:*):void
		{
			var xml:XML=XML(data);
			var marker:CLDMarker=new CLDMarker();
			marker.src=decodeURI(xml.data[0].@icon);
			marker.pointType="image";
			marker.cldPoint=new Point(xml.data[0].@X,xml.data[0].@Y);	
			
			this.addMarker(marker);
			marker.invalidate();
			this.mapAddLayer();				
		}
		
	}
}