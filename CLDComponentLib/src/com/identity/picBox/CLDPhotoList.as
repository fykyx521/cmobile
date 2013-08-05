package com.identity.picBox
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	import com.identity.list.CLDListWrapper;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class CLDPhotoList extends CLDBaseComponent
	{
		
		private var picBox:CLDPicBox;
		
		private var list:CLDListWrapper;
		private var photoContentID:String;
		public function CLDPhotoList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, 
			autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			picBox=new CLDPicBox();
			this.addChild(picBox);
			list=new CLDListWrapper();
			this.addChild(list);
//			list.visible=false;
			list.addEventListener(ImgEvent.listItemClick,this.mouseClick);
			
		}
		override public function dispose():void{
			super.dispose();
			if(list){
				list.removeEventListener(ImgEvent.listItemClick,this.mouseClick);
			}
			
			picBox=null;
			list=null;
		}
		private function mouseClick(e:ImgEvent):void
		{
			e.stopPropagation();	
			var bdata:Object=e.object;
			if(bdata.eventChart=="11")
			{
				var photoParam:String=bdata.param;
				this.loadTxt(contenturl+"?id="+this.photoContentID+"&P="+encodeURI(photoParam)+"&"+Math.random(),null,photoLoaded);
			}
		}
		private function photoLoaded(e:Event):void
		{
			if(dataLoader){
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
				dataLoader.removeEventListener(Event.COMPLETE,photoLoaded);
				this.picBox.data=XML(e.target.data);
			}		
		}
		override public function set data(value:*):void
		{
			super.data=value;
			//如果 没有参数 则显示 list 
//			this.list.data=XML(value);
			if(this.contentIDParam!=""){
				this.list.visible=false;
				this.picBox.data=XML(value);
			}else{
				this.list.visible=true;
				
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			if(picBox){
				picBox.setSize(this.width,this.height);
			}
			if(list){
				list.visible=false;
				list.setSize(300,this.list.listHeight);
				list.x=this.width-300;  
				list.y=this.height-this.list.listHeight;
			}
			if(data&&this.dataChange&&list&&this.contentIDParam=="")
			 {
			 	
			 	list.data=XML(data).table[0];
    			list.visible=true;
				this.picBox.data=XML(data).table[0];
			 	this.photoContentID=XML(data).table[1].data[0].@contentID;
			 	dataChange=false;
			 }
		}
		
		
	}
}