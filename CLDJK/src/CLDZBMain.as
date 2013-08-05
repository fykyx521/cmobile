package
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDFontBase;
	import com.careland.component.render.CLDZBPhotoInfo;
	import com.identity.jk.CLDJKBack;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class CLDZBMain extends CLDFontBase
	{
		
		private var back:CLDJKBack;
		
		[Embed(source="assets/底图/值班信息.png")]
		private var zbxx:Class;
		  
		public var zbxxb:Bitmap; 
		public function CLDZBMain()
		{
			super();
		}
		
		override protected function addChildren():void
		{
			back=new CLDJKBack();
			this.addChild(back);
			zbxxb=new zbxx as Bitmap;
			zbxxb.x=70;
			zbxxb.y=56;
			this.addChild(zbxxb);
			initLoad0();
		}
		override public function get  width():Number
		{
			return 1920;
		}
		override public function get  height():Number
		{
			return 1080;
		}
		private var zb:CLDZBXX;
		 protected function initLoad0():void
		{
			if(!zb)
			{
				zb=new CLDZBXX();
				zb.setSize(this.width-104,this.height-175-42);
				this.addChild(zb);
     			zb.x=52;
			    zb.y=175;
				
				
			}
			 lwInit(zb);
		}
		 CONFIG::tuio
		 protected function lwInit(jk:CLDBaseComponent):void
		 {
			 //测试
//			 CLDBaseComponent.contenturl="http://192.168.68.133/Scheduling/DataServer/AjaxPreView.aspx";//url;//"http://192.168.68.133/Scheduling/DataServer/AjaxPreView.aspx?id=2213"
//			 zb.contentID="2213";//contentID;  
//			 zb.autoLoad=true;
//			 CLDZBPhotoInfo.baseURL="http://192.168.68.133/Scheduling/DataServer/UploadFile/duty/photo/";//"http://10.245.101.68/dyhNew/DataServer/UploadFile/duty/photo/";//"http://192.168.68.133/Scheduling/DataServer/UploadFile/duty/photo/"
			 
			 CLDZBPhotoInfo.baseURL="http://10.245.101.78/dyhNew/DataServer/UploadFile/duty/photo/";
			 var contentID:String="2439";//this.loaderInfo.parameters["contentId"];
			 //var url:String="http://localhost/chinamobileapp/DataServer/AjaxPreView.aspx";//
			 var url:String="http://10.245.101.78/dyhNew/DataServer/AjaxPreView.aspx";
			 //var url:String="http://localhost/chinamobileapp/DataServer/AjaxPreView.aspx"
			 CLDBaseComponent.contenturl=url; 
			 zb.contentID=contentID;  
			 zb.autoLoad=true;
			
			 //CLDZBPhotoInfo.baseURL="http://10.245.101.68/dyhnew/flash/menuIcons/值班信息图片管理/";
//			 jk.addEventListener(MouseEvent.MOUSE_DOWN,downhandler);
//			 stage.addEventListener(MouseEvent.MOUSE_UP,uphandler);
		 }
		 private function downhandler(e:MouseEvent):void
		 {
			 this.startDrag();
		 }
		 private function uphandler(e:MouseEvent):void
		 {
			 this.stopDrag();
		 }
		 CONFIG::web
		 protected function lwInit(jk:CLDBaseComponent):void
		 {
			 var obj:Object=this.loaderInfo.parameters;
			 var contentID:String=obj.id;
			 var url:String=obj.url;
			 CLDBaseComponent.contenturl=url;
			 CLDZBPhotoInfo.baseURL=obj.imgurl;  
			 zb.contentID=contentID;
			 zb.autoLoad=true;    
		 }
		  
	  
	
	}
}