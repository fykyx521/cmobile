package
{
	import com.bit101.components.ProgressBar;
	import com.careland.YDConfig;
	import com.careland.event.ResouceEvent;
	import com.identity.CLDMap;
	import com.wf.CLDLog;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	//import org.ywx.component.LoadShow;
	  
    
	[SWF(backgroundColor=0x000000)] 
	public class PreLoader extends MovieClip
	{
		private var pre:ProgressBar;  
		//private var loadShow:LoadShow;    
		
		public function PreLoader()  
		{      
			super();                
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;     
			stage.align=flash.display.StageAlign.TOP_LEFT;
			CLDLog.init(this);
			Object(this.loaderInfo).uncaughtErrorEvents.addEventListener("uncaughtError", onError);
//			loadShow=new LoadShow(2,"r");
//			loadShow.FillColor=0x003322;
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);  
			this.loaderInfo.addEventListener(Event.COMPLETE, complete);  
 			
//			this.addChild(loadShow.UILoader);
//			loadShow.seatAutoCentre(stage);
		    pre=new ProgressBar(this, 700, 600); 
			pre.setSize(400, 10);  
			
			
			//loadShow.
		}       
		private function onError(e:*):void     
		{    
			trace("error" + e.message);        
			//throw new Error;
		} 
  
		private function progress(e:ProgressEvent):void   
		{ 
			
			pre.value=e.bytesLoaded / e.bytesTotal; 
//			var percent:int = int((e.bytesLoaded / e.bytesTotal) * 100);
//			loadShow.loadPercent=percent;
			
			
		}
  
		private function resouceProgress(e:ResouceEvent):void 
		{
			pre.value=e.byteLoad / e.byteTotal; 
//			var percent:int = int((e.byteLoad / e.byteTotal) * 100);
//			loadShow.loadPercent=percent;
		} 
		private function complete(e:Event):void
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(Event.COMPLETE, complete);
			YDConfig.instance().addEventListener(ResouceEvent.PROGRESS, resouceProgress);  
			YDConfig.instance().addEventListener(ResouceEvent.COMPLETE, configLoaded);
			YDConfig.instance().loadConfig();  
		}  
 
		private function configLoaded(e:ResouceEvent):void
		{ 
			YDConfig.instance().removeEventListener(ResouceEvent.COMPLETE, configLoaded);
			loadPolicyFiles();
			YDConfig.instance().addEventListener(ResouceEvent.RESOURCELOADED, resouceLoaded);
			//YDConfig.instance()
		}
		private function loadPolicyFiles():void   
		{
			var cross:XMLList=YDConfig.instance().config.crossdomain.url;
			for(var i:int=0;i<cross.length();i++){
				var xml:XML=cross[i];	  
				Security.loadPolicyFile(String(xml)); 
			}    
		}
		private function resouceLoaded(e:ResouceEvent):void  
		{   
			YDConfig.instance().removeEventListener(ResouceEvent.RESOURCELOADED, resouceLoaded);
 			if(flash.external.ExternalInterface.available){
				flash.external.ExternalInterface.call("Fkey");   
			}  
			gotoAndStop(2);    
			//加载登录框     
			  
			var mainClass:Class=Class(getDefinitionByName("App"));
			var main:DisplayObject=new mainClass() as DisplayObject; 
  
			stage.addChild(main);   
			parent.removeChild(this);   

		}    
		
		private function loginLoaded(e:Event):void
		{
			var target:Object=e.target.content;
			this.addChild(target as DisplayObject);
		}
	}
}