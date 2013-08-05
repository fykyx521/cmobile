package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.careland.component.radar.CLDRadar;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class CLDTest extends Sprite
	{
		
			public function CLDTest() {
				
				this.addEventListener(Event.ADDED_TO_STAGE,addtostage);
			}
			var bulkLoader:BulkLoader;
			private function addtostage(e:Event)
			{
				
				//stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;				
				
				bulkLoader = BulkLoader.getLoader("main");
				if (!(bulkLoader)){
					bulkLoader = new BulkLoader("main");
				};
				bulkLoader.add("../assets/randar.png", {id:"randar"});
				bulkLoader.add("../assets/point.png", {id:"randarPoint"});
				bulkLoader.add("../assets/red.png", {id:"randarRed"});
				
				bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, complete);
				bulkLoader.start();
			
				
			//	TUIO.init(this,"127.0.0.1",3000,null,true);
			
				
				
			}
			private function complete(e:Event)//监听处理函数可使用switch进行判断
			{
				var radar:CLDRadar=new CLDRadar();
				radar.setSize(450,450);
				this.addChild(radar);
				//throw new Error;
			}
		
	}
}