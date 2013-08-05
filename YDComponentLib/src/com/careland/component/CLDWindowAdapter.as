package com.careland.component
{
	import com.identity.CLDTextArea;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class CLDWindowAdapter extends CLDWindow
	{
		public var windowID:String;
		public var _params:String;
		public var contentTxt:Boolean=false;//是否直接显示指定的内容
		
		private var cldTxt:CLDTextArea;
		private var closeButton:CLDTouchButton;
		
		private var _isBack:Boolean=false;
		
		private var urlloader:URLLoader;
		public function CLDWindowAdapter(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			this.alertWin=true;
		}
		override protected function addChildren():void
		{
			super.addChildren();
			closeButton=new CLDTouchButton;
			var bit2:Bitmap=this.config.getBitmap("closed");
			var bit3:Bitmap=this.config.getBitmap("closec");
			closeButton.setBit(bit2,bit3); 
			this.addChild(closeButton);
			closeButton.visible=false;
			closeButton.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
		}
		
		public function loadProduce(resultFunction:Function,procedure:String,params:String="",isWeburl:Boolean=false):void
		{
		
			var pstr:String=encodeURI(procedure);
			var pparam:String=encodeURI(params);
			
			//var purl:String=this.produceurl+"?SpName="+pstr+"";
			var url:String=produceurl;
			if(isWeburl){
				url=this.config.produceweburl;
			}
			var purl:String=url+"?SpName="+pstr+"&paramsString="+pparam;
			
			
			var postRequest:URLRequest=new URLRequest(purl);
			
			postRequest.method="post";
			//postRequest.data="<params><param name='"+procedure+"' args='"+params+"'></param></params>";
			
			if(!this.urlloader){
				urlloader=new URLLoader();
			}
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,winIoError);
//			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityHandler);
		
			urlloader.addEventListener(Event.COMPLETE,resultFunction);
			
			urlloader.load(postRequest);
			
		
		}
		private function winIoError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,winIoError);
//			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityHandler);
		
			e.target.removeEventListener(Event.COMPLETE,loadComplete);
		}
		private function downHandler(e:TUIOEvent):void
		{
			this.dispose();
			if(parent){
				parent.removeChild(this);
			}
		}
		public function set isBack(value:Boolean):void
		{
			this._isBack=value;
			closeButton.visible=value;
			
		}
		public function get isBack():Boolean
		{
			return this._isBack;
		}
		public function showClose():void
		{
			closeButton.visible=true;
		}
		
		override public function set autoLoad(value:Boolean):void
		{
			super.autoLoad=value;
			
			if(!this.contentTxt){
				this.produceName=this.config.getProcedure("alterconfig");//弹出窗配置的存储过程
//				this.produceName="P_根据ID获取弹出窗口信息";
				//this.params=
				var param:String="@id:" + windowID;
			
				//this.loadData(
				this.loadProduce(loadComplete,produceName,param,true);
			}else{
				initTxt();
			}
			
			
			
		}
		private function initTxt():void
		{
			if(this.cldTxt){
				cldTxt=new CLDTextArea();
				this.content.addChild(cldTxt);
			}
		}
		override public function draw():void
		{
			super.draw();
			if(this.closeButton&&this.isBack){
				closeButton.x=this.width-200;
			}else{
				closeButton.x=this.width-39;
				closeButton.y=-39;
			}
		}
		
		
		private function loadComplete(e:Event):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,winIoError);
			e.target.removeEventListener(Event.COMPLETE,loadComplete);

			var dataXML:XML=XML(e.target.data);
			if(dataXML){
				
				try{
					this.title=dataXML.data[0].@窗口标题;
					this.winType=dataXML.data[0].@窗口类型;
					configWinType();
					this.data=String(dataXML.data[0].@窗口内容);
					this.invalidate();
				}catch(e:Error){
					
				}
				this.disposeXML(dataXML);
			}
		}
		private function configWinType():void
		{
			switch(this.winType)
			{
				case "6": this.rect.visible=false; this.border.visible=false;break;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			try{
				this.config.removeLoadedListener(loadComplete);
			}catch(e:Error){
				return;
			}
			cldTxt=null;
		}
		
		
		
		
		
	}
}