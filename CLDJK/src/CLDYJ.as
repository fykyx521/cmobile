package
{
	import com.careland.CLDBase;
	import com.careland.CLDWLYJ;
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class CLDYJ extends CLDBaseComponent
	{
		public function CLDYJ()
		{
			super();
			
			if(stage)
			{
				initObj();
			}else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,initObj);
			}
		}
	private var wlyj:CLDWLYJ;
	
	public function resize(e:Event):void
	{
		//		 if(jkstate)
		//		 {
		//			 jkstate.setSize(stage.stageWidth,stage.stageHeight);
		//			// flash.net.navigateToURL(new URLRequest("javascript:alert('resize')"));
		//		 }
		if(wlyj)
		{
			wlyj.setSize(stage.stageWidth,stage.stageHeight);
		}
		
	}
	public function initObj(e:Event=null):void
	{
		
		this.removeEventListener(Event.ADDED_TO_STAGE,initObj);
		this.stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
		this.stage.align=flash.display.StageAlign.TOP_LEFT;
		
		stage.addEventListener(Event.RESIZE,resize);  
		
		//		 var contentID:String=this.loaderInfo.parameters["contentId"];
		//		 var url:String=this.loaderInfo.parameters["url"];
		
		var contentID:String="2022";//this.loaderInfo.parameters["contentId"];
		var url:String="http://192.168.68.167/dyh/DataServer/AjaxPreView.aspx"
		CLDBaseComponent.contenturl=url;
		
//		this.contentID=contentID;
//		this.autoLoad=true;
		
		if(!wlyj)
		{
			wlyj=new CLDWLYJ();
			wlyj.setSize(800,600);
			wlyj.contentID=contentID;
			wlyj.autoLoad=true;
			this.addChild(wlyj);
		}
		
		
		
	}
	}
}