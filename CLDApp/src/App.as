package {
	import com.careland.MainWin;
	import com.careland.YDConfig;
	import com.careland.component.util.Alert;
	import com.careland.event.CLDEvent;
	import com.careland.socket.SocketUtil;
	import com.touchlib.TUIO;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.Font;
	  
	import sinaappp.wwyx.Log;

	public class App extends Sprite 
	{
	
	  	private var loader:Loader;  
	  	
	  	private var txtSprite:Sprite;
		public function App()
		{
			trace("webapp");
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		private function onError(e:*):void
		{  
			trace("error"+e.message);
		}

		public function init(data:XML):void
		{
			TUIO.init(this,data.data.@ip,Number(data.data.@port),"",data.data.@debug);
			SocketUtil.init(data.datacmd.@ip,Number(data.datacmd.@port),data.data.@debug);
			//SocketUtil.init("192.168.68.41",11100,data.data.@debug);
		}
		
		
		protected function onAddToStage(e:Event):void
		{
			
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			stage.align=flash.display.StageAlign.TOP_LEFT;
			Alert.init(stage);
			Log.init();
			Object(this.loaderInfo).uncaughtErrorEvents.addEventListener("uncaughtError", onError);
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			stage.doubleClickEnabled=true;
			//stage.addEventListener(MouseEvent.CLICK,doubleClickHandler);
			//stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreen); 
			
			this.init(YDConfig.instance().config);
			if(YDConfig.instance().fontLoaded){
				var content:Object=YDConfig.instance().getItem("font");
				Font.registerFont(content.font);
			}
			var main:MainWin=new MainWin(); 
			this.addChild(main);
//			main.scaleX=0.56;
//			main.scaleY=0.36;   
		    
			main.updateDisplay();   
			
			if(flash.external.ExternalInterface.available)
			{
				flash.external.ExternalInterface.addCallback("rightClick",rightClick);
			}
		} 
		
		private function rightClick(x:Number,y:Number):void
		{
			var newX:Number=this.mouseX;
			var newY:Number=this.mouseY;
			var objs:Array=stage.getObjectsUnderPoint(new Point(newX,newY));
//			
			 
			if(objs.length>1){
				var clde:CLDEvent=new CLDEvent(CLDEvent.rightClick);
				clde.stageX=newX;
				clde.stageY=newY;
				objs[objs.length-1].dispatchEvent(clde);
			}      
  
		}
		    
		private function doubleClickHandler(e:Event):void
		{
			stage.removeEventListener(MouseEvent.CLICK,doubleClickHandler);
			stage.displayState=flash.display.StageDisplayState.FULL_SCREEN;
		}
		private function fullScreen(e:FullScreenEvent):void
		{
			if(!e.fullScreen){
				stage.addEventListener(MouseEvent.CLICK,doubleClickHandler);
			}else{
				stage.removeEventListener(MouseEvent.CLICK,doubleClickHandler);
			}
		}
	}
}
