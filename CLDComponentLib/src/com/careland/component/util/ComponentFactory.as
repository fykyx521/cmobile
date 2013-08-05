package com.careland.component.util
{
	import com.careland.YDConfig;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.radar.CLDRadar;
	import com.identity.CLDChart;
	import com.identity.CLDDoc;
	import com.identity.CLDFlash;
	import com.identity.CLDIframe;
	import com.identity.CLDImgMap;
	import com.identity.CLDMap;
	import com.identity.CLDTextArea;
	import com.identity.CldPicture;
	import com.identity.Grild.CLDCarelandTable;
	import com.identity.intelSingleNode.CLDMapTopo;
	import com.identity.intelSingleNode.CLDSingleNode;
	import com.identity.list.CLDListWrapper;
	import com.identity.list.CLDMouseList;
	import com.identity.list.CLDTouchList;
	import com.identity.map.CLDMapGrid;
	import com.identity.map.CLDMapSetting;
	import com.identity.picBox.CLDPhotoList;

//	import com.identity.radar.CLDRadar;
//	import com.identity.map.CLDMapGrid;


	
	public class ComponentFactory
	{
		public function ComponentFactory()
		{
			
		}
		CONFIG::MOUSE
		public static function getComponent(type:String,id:String,timeInteval:Number,autoLoad:Boolean=false):CLDBaseComponent
		{
			var cbase:CLDBaseComponent=null;
			//type="new";
			switch(type){
				case "文本":cbase=new CLDTextArea(null,0,0,autoLoad,timeInteval); break;
				case "图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "普通图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "列表":cbase=new CLDCarelandTable(null,0,0,autoLoad,timeInteval);break;
				case "IFrame":cbase=new CLDIframe(null,0,0,autoLoad,timeInteval);break;
				case "Flash":cbase=new CLDFlash(null,0,0,autoLoad,timeInteval); break;
				case "Map":cbase=new CLDMap(null,0,0,autoLoad,timeInteval); break;
				case "多点链接":cbase=new CLDMouseList(null,0,0,autoLoad,timeInteval);break;
				case "图片地图":cbase=new CLDImgMap(null,0,0,autoLoad,timeInteval); break;
				case "链接": 
				case "图片": cbase=new CldPicture(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图":cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "grids":cbase=new CLDMapGrid(null,0,0,autoLoad,timeInteval);break;
				case "图片轮换":cbase=new CLDPhotoList(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图": cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图(带经纬度)": cbase=new CLDMapTopo(null,0,0,autoLoad,timeInteval);break;
//				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;
				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;

				case "排班表":cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;
				case "文档":cbase=new CLDDoc(null,0,0,autoLoad,timeInteval); break;
				case "多点排班表": cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;

			//	case "轨迹回放(flash)": cbase=new CLDTransfer(null,0,0,autoLoad,timeInteval);break;
				// case "Map": cbase=new CLDMap(null,0,0,autoLoad,timeInteval);break;
				//default: cbase=new CLDBaseComponent(null,0,0,autoLoad,timeInteval);break;
			}	
			if(!cbase){
				cbase=YDConfig.instance().getPluginComponent(type,id,timeInteval,autoLoad);
			}
			if(!cbase){
				 cbase=new CLDBaseComponent(null,0,0,autoLoad,timeInteval);
			}
			cbase.contentID=id;
			
			return cbase;
		}
		CONFIG::TUIO
		public static function getComponent(type:String,id:String,timeInteval:Number,autoLoad:Boolean=false):CLDBaseComponent
		{
			var cbase:CLDBaseComponent=null;
			//type="new";
			switch(type){
				case "文本":cbase=new CLDTextArea(null,0,0,autoLoad,timeInteval); break;
				case "图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "普通图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "列表":cbase=new CLDCarelandTable(null,0,0,autoLoad,timeInteval);break;
				case "IFrame":cbase=new CLDIframe(null,0,0,autoLoad,timeInteval);break;
				case "Flash":cbase=new CLDFlash(null,0,0,autoLoad,timeInteval); break;
				case "Map":cbase=new CLDMap(null,0,0,autoLoad,timeInteval); break;
				case "多点链接":cbase=new CLDListWrapper(null,0,0,autoLoad,timeInteval);break;
				case "图片地图":cbase=new CLDImgMap(null,0,0,autoLoad,timeInteval); break;
				case "链接": 
				case "图片": cbase=new CldPicture(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图":cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "grids":cbase=new CLDMapGrid(null,0,0,autoLoad,timeInteval);break;
				case "图片轮换":cbase=new CLDPhotoList(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图": cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图(带经纬度)": cbase=new CLDMapTopo(null,0,0,autoLoad,timeInteval);break;
				//				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;
				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;
				
				case "排班表":cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;
				case "文档":cbase=new CLDDoc(null,0,0,autoLoad,timeInteval); break;
				case "多点排班表": cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;
			
			}	
			if(!cbase){
				cbase=YDConfig.instance().getPluginComponent(type,id,timeInteval,autoLoad);
			}
			if(!cbase){
				cbase=new CLDBaseComponent(null,0,0,autoLoad,timeInteval);
			}
			cbase.contentID=id;
			
			return cbase;
		}
		
		CONFIG::IPAD
		public static function getComponent(type:String,id:String,timeInteval:Number,autoLoad:Boolean=false):CLDBaseComponent
		{
			var cbase:CLDBaseComponent=null;
			//type="new";
			switch(type){
				case "文本":cbase=new CLDTextArea(null,0,0,autoLoad,timeInteval); break;
				case "图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "普通图表":cbase=new  CLDChart(null,0,0,autoLoad,timeInteval); break;
				case "列表":cbase=new CLDCarelandTable(null,0,0,autoLoad,timeInteval);break;
				case "IFrame":cbase=new CLDIframe(null,0,0,autoLoad,timeInteval);break;
				case "Flash":cbase=new CLDFlash(null,0,0,autoLoad,timeInteval); break;
				case "Map":cbase=new CLDMap(null,0,0,autoLoad,timeInteval); break;
				case "多点链接":cbase=new CLDTouchList(null,0,0,autoLoad,timeInteval);break;
				case "图片地图":cbase=new CLDImgMap(null,0,0,autoLoad,timeInteval); break;
				case "链接": 
				case "图片": cbase=new CldPicture(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图":cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "grids":cbase=new CLDMapGrid(null,0,0,autoLoad,timeInteval);break;
				case "图片轮换":cbase=new CLDPhotoList(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图": cbase=new CLDSingleNode(null,0,0,autoLoad,timeInteval);break;
				case "拓扑图(带经纬度)": cbase=new CLDMapTopo(null,0,0,autoLoad,timeInteval);break;
				//				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;
				case "雷达图":cbase=new CLDRadar(null,0,0,autoLoad,timeInteval);break;
				
				case "排班表":cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;
				case "文档":cbase=new CLDDoc(null,0,0,autoLoad,timeInteval); break;
				case "多点排班表": cbase=new CLDMapSetting(null,0,0,autoLoad,timeInteval);break;
				
			}	
			if(!cbase){
				cbase=YDConfig.instance().getPluginComponent(type,id,timeInteval,autoLoad);
			}
			if(!cbase){
				cbase=new CLDBaseComponent(null,0,0,autoLoad,timeInteval);
			}
			cbase.contentID=id;
			
			return cbase;
		}
	}
}