package com.careland.mainwinui
{
	import com.careland.YDConfig;
	import com.careland.YDTouchComponent;
	import com.careland.event.CLDEvent;
	import com.identity.CLDFirstBground;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class BackSprite extends YDTouchComponent
	{
		
		private var isLoad:Boolean=false;
		
		private var swf:MovieClip;
		
		private var bitmap:Bitmap;
		public function BackSprite()
		{
			super();
			
		} 
		override protected function createUI():void{
//			if(!isLoad)
//				this.loadImage(backURL);
//			isLoad=true;
		
			var bit:Bitmap=cldConfig.getBitmap("back");
			this.addChildAt(bit,0);
//			if(item is MovieClip){
//				swf=MovieClip(item);
//				swf.stop();
//				this.addChild(swf);
//				stage.addEventListener("pointClick",swfClick,true);
//			}else{
//				bitmap=item as Bitmap;
//				this.addChild(bitmap);
//			}
			var cld:CLDFirstBground=new CLDFirstBground();
			this.addChild(cld);
			cld.addEventListener("pointClick",swfClick);
			cld.contentID="645";
			cld.autoLoad=true;
			//this.addChild( as MovieClip);
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
		
		override protected function loadComplete(e:Event):void
		{
			super.loadComplete(e);
			var bit:Bitmap=e.target.content as Bitmap;
			this.addChild(bit);
		}
	}
}