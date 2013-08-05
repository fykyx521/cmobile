package com.careland.main.ui
{
	import com.careland.event.CLDEvent;
	import com.identity.CLDFirstBground;
	
	import flash.display.Bitmap;
	import flash.events.Event;

	public class CLDBack extends CLDBaseUI
	{
		
		
		[Embed(source="../assets/back.png")]
		private var back:Class;
		private var cld:CLDFirstBground;
		public function CLDBack()
		{
			super();
		}
		override protected function addChildren():void
		{
			this.addChild(new back as Bitmap);
			var cld:CLDFirstBground=new CLDFirstBground();
			this.addChild(cld);
			cld.addEventListener("pointClick",swfClick);
			cld.contentID="645";
			cld.autoLoad=true;
		}
		private function swfClick(e:Event):void
		{
			var obj:Object=e;
			if(obj.eventType=="0"){
				var bk:CLDEvent=new CLDEvent(CLDEvent.SWFCLICK);
				bk.id=obj.id;
				bk.obj="";    
				this.cldConfig.dispatchEvent(bk);
			}else{
				//<data Column1="2011-08-11 00:00:00" 集合名称="深圳市宝安区游泳馆" 热点级别="二级场馆"
				// 视图ID="192" 地图类型="5" 地图级别="2" 经度="113.8806" 纬度="22.56407" 
				//鼠标经过数据="名称:深圳市宝安区游泳馆" 
				//标注图片="12" 坐标="113.881,22.5641" 地址="宝城84区裕安西路" 赛事状况="2"/>
				var bk:CLDEvent=new CLDEvent(CLDEvent.SWFCLICK);
				
				var xml:XML=XML(obj.obj);
				bk.id=xml.@视图ID;
				bk.obj="集合名称:"+xml.@集合名称+"^"+xml.@经度+","+xml.@纬度+"^"+xml.@地图类型+"^"+xml.@地图级别;
				this.cldConfig.dispatchEvent(bk);
			}
			
			//throw new Error;
		}
	}
}