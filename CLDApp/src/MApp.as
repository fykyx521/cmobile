package
{
	import com.bit101.components.ProgressBar;
	import com.careland.YDConfig;
	import com.careland.event.ResouceEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;  
	
	public class MApp extends MovieClip
	{  
		public function MApp()
		{
			super();
			stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			stage.align = flash.display.StageAlign.TOP_LEFT;
			this.loaderInfo.addEventListener(flash.events.Event.COMPLETE, this.complete);
			return;
		}
		
		private function onError(arg1:*):void
		{
			trace("error" + arg1.message);
			return;
		}
		private function complete(arg1:Event):void
		{
			
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.complete);
			//com.careland.YDConfig.instance().addEventListener(com.careland.event.ResouceEvent.PROGRESS, this.resouceProgress);
			com.careland.YDConfig.instance().addEventListener(ResouceEvent.COMPLETE, this.configLoaded);
			com.careland.YDConfig.instance().loadConfig();
			  
		}
		
		private function configLoaded(arg1:ResouceEvent):void
		{
			YDConfig.instance().removeEventListener(ResouceEvent.COMPLETE, this.configLoaded);
			this.loadPolicyFiles();
			YDConfig.instance().addEventListener(ResouceEvent.RESOURCELOADED, this.resouceLoaded);
		}
		
		private function loadPolicyFiles():void
		{
			var loc3:*=null;
			var loc1:*=com.careland.YDConfig.instance().config.crossdomain.url;
			var loc2:*=0;
			while (loc2 < loc1.length()) 
			{
				loc3 = loc1[loc2];
				flash.system.Security.loadPolicyFile(String(loc3));
				++loc2;  
			}
			return;
		}
		
		private function resouceLoaded(arg1:com.careland.event.ResouceEvent):void
		{
			com.careland.YDConfig.instance().removeEventListener(com.careland.event.ResouceEvent.RESOURCELOADED, this.resouceLoaded);
			if (flash.external.ExternalInterface.available) 
			{
				flash.external.ExternalInterface.call("Fkey");
			}
			gotoAndStop(2);
			var loc1:*=Class(flash.utils.getDefinitionByName("CLDAppMouse"));
			var loc2:*=new loc1() as flash.display.DisplayObject;  
			stage.addChild(loc2);
			parent.removeChild(this);
			return;
		} 
		private function loginLoaded(arg1:flash.events.Event):void
		{
			var loc1:*=arg1.target.content;
			this.addChild(loc1 as flash.display.DisplayObject);
			return;
		}
		
		private var loadShow:ProgressBar;
	}
}