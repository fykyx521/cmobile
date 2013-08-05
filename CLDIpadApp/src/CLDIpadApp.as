package
{
	import com.careland.YDConfig;
	import com.careland.event.ResouceEvent;
	import com.careland.main.ui.CLDMain;
	import com.careland.main.ui.CLDSetting;
	import com.careland.socket.SocketUtil;
	import com.wf.CLDMobileLog;
	
	import flash.desktop.NativeApplication;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.text.Font;
  
	[SWF(backgroundColor=0x053563)]
	public class CLDIpadApp extends Sprite  
	{  
		private  var main:CLDMain;
		private  var ydconfig:YDConfig=YDConfig.instance();
		private var setting:CLDSetting;
		private var sharedObj:SharedObject;
		public function CLDIpadApp()   
		{
			super();
			stage.align=flash.display.StageAlign.TOP_LEFT;
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			stage.quality=flash.display.StageQuality.HIGH;
			stage.addEventListener(Event.RESIZE,change);
			ydconfig.webConfig=false;
			SharedObject.defaultObjectEncoding=ObjectEncoding.AMF3;
			sharedObj=SharedObject.getLocal("air_setting");
		 	CLDMobileLog.init(this);
			
			this.log("test");
			this.showSetting();
			this.loadConfig();
		}
		public function log(mes:*):void
		{
			CLDMobileLog.log(mes);
		}
		
		private function showSetting():void
		{
			setting=new CLDSetting();
			setting.setSize(800,300);
			this.addChild(setting);
			setting.move((this.stage.fullScreenWidth-setting.width)/2,(this.stage.fullScreenHeight-setting.height)/2);
		}
		private function loadConfig():void
		{
			YDConfig.instance().addEventListener(ResouceEvent.RESOURCELOADED,resouceLoaded);
		}
		private function resouceLoaded(e:ResouceEvent):void
		{
			var data:XML=YDConfig.instance().config;
			SocketUtil.init(data.datacmd.@ip,Number(data.datacmd.@port),data.data.@debug);
			this.removeChild(setting);
			
			main=new  CLDMain();
			this.addChild(main);
			main.setSize(2048,1536); 
		}
		private function change(e:Event):void
		{  
			if(this.setting)
			{
				setting.move((this.stage.fullScreenWidth-setting.width)/2,(this.stage.fullScreenHeight-setting.height)/2);
			}
			//trace(stage.stageWidth+":"+stage.stageHeight);
			// e.afterOrientation=StageOrientationEvent.
		}
			
		
		
		
	}
}