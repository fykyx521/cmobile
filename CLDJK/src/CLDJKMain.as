package
{
	import com.careland.CLDBase;
	import com.careland.CLDJKState;
	import com.careland.CLDWLYJ;
	import com.careland.CLDYJList;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDInfo;
	import com.careland.component.render.CLDFontBase;
	import com.careland.component.render.CLDScrollBar;
	import com.careland.component.render.CLDTextRender;
	import com.careland.events.CLDInfoEvent;
	import com.identity.jk.CLDJKBack;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	
	public class CLDJKMain extends CLDFontBase
	{
		
		private var back:CLDJKBack;
		[Embed(source="assets/底图/监控动态.png")]
		private var jkdt:Class;
		
		public var jkdtb:Bitmap;
		
		public function CLDJKMain()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			back=new CLDJKBack();
			this.addChild(back);
			jkdtb=new jkdt as Bitmap;
			jkdtb.x=70;
			jkdtb.y=56;
			this.addChild(jkdtb);
			//initLoad0();
			
		}
		override public function get  width():Number
		{
			return 1920;
		}
		override public function get  height():Number
		{
			return 1080;
		}
	   private var jk:CLDJK;
	   private var info:CLDInfo;
	   override protected function initLoad():void
		{
			if(!jk)
			{
				jk=new CLDJK();
				jk.setSize(this.width-104,this.height-175-42);
				this.addChild(jk);
				jk.x=52;
				jk.y=175;
				jk.addEventListener(CLDInfoEvent.INFO,infoHandler,true);
				info=new CLDInfo();
				this.addChild(info);
				info.visible=false;
			}
			lwInit(jk);    
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
			var contentID:String="2435";//this.loaderInfo.parameters["contentId"];
			var url:String="http://10.245.101.68/dyhNew/DataServer/AjaxPreView.aspx";
			CLDBaseComponent.contenturl=url;
			jk.contentID=contentID;
			jk.autoLoad=true;
			trace("jk");  
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