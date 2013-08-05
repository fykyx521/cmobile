package com.careland.main.ui
{
	import com.bit101.components.Component;
	import com.careland.YDConfig;
	import com.careland.command.CLDCommandHandler;
	import com.careland.command.Message;
	import com.careland.remote.CLDRemoteEvent;
	import com.wf.CLDMobileLog;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CLDBaseUI extends Component
	{
		protected var cldConfig:YDConfig=YDConfig.instance();
		public var cmd:CLDCommandHandler=CLDCommandHandler.instance();
		protected var debug:Boolean=true;
		private var _data:*;
		private var urlLoader:URLLoader;
		public function CLDBaseUI()
		{
			super();
		}
		public function set data(value:*):void
		{
			this._data=value;
			this.dataChange();
			this.invalidate();
		}
		public function get data():*
		{
			return this._data;
		}
		protected function dataChange():void
		{
			
		}
		protected function command(type:String):void
		{
			var mes:Message=new Message(type);
			this.sendCommand(mes);
		}
		protected function getBitmap(key:String,clone:Boolean=true):Bitmap
		{
			var bitdata:Bitmap=this.cldConfig.getBitmap(key);
			if(clone)
			{
				var bit:Bitmap=new Bitmap(bitdata.bitmapData.clone());
				return bit;
			}
			return bitdata;
		}
		//发送命令
		public function sendCommand(mes:Message):void
		{
			var evt:CLDRemoteEvent=new CLDRemoteEvent(CLDRemoteEvent.SEND_COMMAND);
			evt.message=mes;
			cmd.dispatchEvent(evt);
		}
		public function disponse():void
		{
			
		}
		public function log(mes:*):void
		{
			CLDMobileLog.log(mes);
		}
		protected function disposeXML(xml:XML):void
		{
			this.cldConfig.disposeXML(xml);
		}
		public function loadProduce(resultFunction:Function,procedure:String,params:String="",isWeburl:Boolean=false):void
		{
			var pstr:String=encodeURI(procedure);
			var pparam:String=encodeURI(params);
			var url:String=cldConfig.produceurl;
			if(isWeburl){
				url=cldConfig.produceweburl;
			}
			var purl:String=url+"?SpName="+pstr+"&paramsString="+pparam+"&"+Math.random();
			var postRequest:URLRequest=new URLRequest(purl);
			postRequest.method="post";
			//postRequest.data="<params><param name='"+procedure+"' args='"+params+"'></param></params>";
			if(!this.urlLoader){
				urlLoader=new URLLoader();
			}
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			urlLoader.addEventListener(Event.COMPLETE,resultFunction);
			urlLoader.load(postRequest);
			
		}
		protected function ioError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(IOErrorEvent,ioError);
		}
	}
}