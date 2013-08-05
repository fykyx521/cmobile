package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.careland.YDConfig;
	import com.careland.component.CLDMapType;
	import com.careland.event.ResouceEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	public class TestApp extends Sprite
	{
		private var bulkLoader:BulkLoader;
		public function TestApp()
		{
			super();
			if(stage)
			{
				 init();
			}else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		private function init(e:Event=null):void
		{ 
			stage.align="tl";
			stage.scaleMode="noScale";
			bulkLoader = BulkLoader.getLoader("main");
			if (!(bulkLoader)){
				bulkLoader = new BulkLoader("main");
			};
			///bulkLoader.add("assets/config.xml", {id:"config"});
		   
			bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, complete);
			var cssFolder="../2012113191345";
			
			
//			bulkLoader.add((cssFolder + "/main/toolback.png"), {id:"maptoolback"}); 
//			bulkLoader.add((cssFolder + "/main/poly.png"), {id:"maptool_poly"});   
//			bulkLoader.add((cssFolder + "/main/polya.png"), {id:"maptool_polya"});  
//			bulkLoader.add((cssFolder + "/main/rect.png"), {id:"maptool_rect"});  
//			bulkLoader.add((cssFolder + "/main/recta.png"), {id:"maptool_recta"});  
//			bulkLoader.add((cssFolder + "/main/circle.png"), {id:"maptool_circle"});  
//			bulkLoader.add((cssFolder + "/main/circlea.png"), {id:"maptool_circlea"}); 
//			bulkLoader.add((cssFolder + "/main/clear.png"), {id:"maptool_clear"}); 
//			bulkLoader.add((cssFolder + "/main/cleara.png"), {id:"maptool_cleara"}); 
			bulkLoader.add("assets/config.xml", {id:"config"});
			//地图切换
			bulkLoader.add((cssFolder + "/main/maptypebottom.png"), {id:"maptypebottom"}); 
			bulkLoader.add((cssFolder + "/main/maptypetop.png"), {id:"maptypetop"});   
			bulkLoader.add((cssFolder + "/main/maptypecenter.png"), {id:"maptypecenter"});  
			bulkLoader.add((cssFolder + "/main/maptypea.png"), {id:"maptypea"});  
			bulkLoader.add((cssFolder + "/main/maptypeitem.png"), {id:"maptypeitem"});  
			
			bulkLoader.start();
		}
		
		private function complete(e:BulkProgressEvent):void 
		{
			   var map:CLDMapType=new CLDMapType();
			   this.addChild(map);
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
			//gotoAndStop(2);   
			//加载登录框   
			
			var app:App=new App();
			this.addChild(app);
			
		}
	}
}