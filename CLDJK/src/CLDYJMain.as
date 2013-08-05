package
{
	import com.careland.CLDWLYJ;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDInfo;
	import com.careland.component.render.CLDFontBase;
	import com.careland.events.CLDInfoEvent;
	import com.identity.jk.CLDJKBack;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class CLDYJMain extends CLDFontBase
	{
		private var back:CLDJKBack;
		
		[Embed(source="assets/底图/网络预警.png")]
		private var wlyjcls:Class;
		  
		public var wlyjb:Bitmap;   
		private var info:CLDInfo;
		
		private var titles:Sprite;
		public function CLDYJMain()
		{
			super();
		}
		override public function get  width():Number
		{
			return 1920;
		}
		override public function get  height():Number
		{
			return 1080;
		}
		override protected function addChildren():void
		{
			super.addChildren();
			back=new CLDJKBack();
			this.addChild(back);
			wlyjb=new wlyjcls as Bitmap;
			wlyjb.x=70;
			wlyjb.y=56;
			this.addChild(wlyjb);
			
			titles=new Sprite();
			this.addChild(titles);
			titles.x=52;
			titles.y=110;
			//initLoad0();
			
		}
		private var wlyj:CLDWLYJ;
	   override protected function initLoad():void
		{
			if(!wlyj)
			{
				wlyj=new CLDWLYJ();
				wlyj.setSize(this.width-104,this.height-175-42);
				wlyj.y=170;
				wlyj.x=52; 
				
				this.addChild(wlyj);
				
				wlyj.addEventListener(CLDInfoEvent.INFO,infoHandler,true);
				info=new CLDInfo();
				this.addChild(info);
				info.visible=false;  
				
			}
//			var obj:Object=this.loaderInfo.parameters; 
//			var contentID:String=obj.id;
//			var url:String=obj.url;   
//			CLDBaseComponent.contenturl=url;
			
			lwInit(wlyj);
			
		}
	   private var target:Object;
	   private function infoHandler(e:CLDInfoEvent):void
	   {
		   if(target)
		   {
			   target.hide();
		   }
		   if(e.isShow)
		   {
			   info.width=e.width;
			   info.data=e.data;
			   info.x=e.x;
			   info.y=e.y;
			   this.target=e.targetObj;
			   target.show();
			   info.visible=true;
		   }else
		   {
			   info.visible=false;
		   }
	   }
		CONFIG::tuio
		protected function lwInit(jk:CLDBaseComponent):void
		{
			var contentID:String="2431";//this.loaderInfo.parameters["contentId"];
			var url:String="http://10.245.101.68/dyhNew/DataServer/AjaxPreView.aspx";
			CLDBaseComponent.contenturl=url; 
			jk.contentID=contentID;
			jk.autoLoad=true;
		}
		CONFIG::web
		protected function lwInit(jk:CLDBaseComponent):void
		{
			var obj:Object=this.loaderInfo.parameters;
			var contentID:String=obj.id;
			var url:String=obj.url;
			CLDBaseComponent.contenturl=url;
			jk.contentID=contentID;
			jk.autoLoad=true;
		}
		
		
		
		
	}
}