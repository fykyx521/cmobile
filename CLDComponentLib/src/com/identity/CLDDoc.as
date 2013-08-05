package com.identity
{
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.TimerEvent;
	import com.careland.viewer.CLDDocView;
	import com.careland.viewer.model.DOCData;
	import com.identity.timer.CLDSlider;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class CLDDoc extends CLDBaseComponent
	{
		private var docView:CLDDocView;
		private var timerGroup:CLDSlider;
		public function CLDDoc(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			docView=new CLDDocView();
			this.addChild(docView);
			timerGroup=new CLDSlider();
			this.addChild(timerGroup);
			timerGroup.addEventListener(TimerEvent.timerEvent,onTimeMoveEnd);
			docView.addEventListener("clddocinit",docInit);
		}
		private function docInit(e:Event):void
		{
			e.target.removeEventListener("clddocinit",docInit);
			this.invalidate();
		}
		private function onTimeMoveEnd(e:TimerEvent):void
		{
			var vdocScale:Number=e.ratio/100;
			if(vdocScale<1){
				vdocScale=1;
			}
			if(vdocScale>4){
				vdocScale=4;
			}
			this.docScale=vdocScale;
			this.sendScale(vdocScale);
			
		}
		override public function register():void
		{
			 this.registerCommand(CMD.DOCSCALE);
		}
		override public function unregister():void
		{
			this.unregisterCommand(CMD.DOCSCALE);
		}
		 public function sendScale(vdocScale:Number):void
		{
			var mes:Message=Message.buildMsg(CMD.DOCSCALE);
			mes.data={docScale:vdocScale,contentID:this.contentID};
			this.sendCommand(mes);
		}
		override protected function handlerRemote(e:Message):void
		{
			if(e.type==CMD.DOCSCALE)
			{
				if(this.contentID==e.data.contentID)
				{
					this.docScale=e.data.docScale;
					timerGroup.Ratio=e.data.docScale;
				}
			}
		}
		public function set docScale(value:Number):void
		{
			if(this.docView&&value>=1){
				docView.scale=value;
				docView.reflushContent();
			}	
		}
		
		override public function draw():void
		{
			if(data&&this.dataChange)
			{
				pauseData(this.data);
				this.dataChange=false;
			}
			if(timerGroup){
				timerGroup.setSize(Math.min(800,this.width),70);
				timerGroup.x=(this.width-timerGroup.width)/2
			}
			if(docView){
				docView.setSize(this.width,this.height);
			}
			
			
		}
		public function pauseData(data:*):void
		{
			
			var xml:XML=XML(data);
			var dataXML:XML=xml.data[0];
			
			var numPage:int=int(dataXML.@总页数);
			var folder:String=String(dataXML.@目录);
			//folder=encodeURI(folder);
			//folder="../DataServer/FileManage/类型1/深圳移动大运保障支撑数据采集文档";
			var dataArray:Array=[];
			for(var i:int=0;i<numPage;i++)
			{
				var docData:DOCData=new DOCData();
				docData.index=i;
				
				docData.url=encodeURI(folder+"/"+(i+1)+".swf");
				dataArray.push(docData);
			}
			docView.data=dataArray;
			
		}
		override public function dispose():void
		{
			super.dispose();
			if(this.docView){
				docView.dispose();
			}
			docView=null;
		}
		
	}
}