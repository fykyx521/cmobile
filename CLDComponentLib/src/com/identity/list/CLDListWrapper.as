package com.identity.list
{
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	import com.identity.list.classes.CLDListUI;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	

	public class CLDListWrapper extends CLDBaseComponent
	{
		private var list:CLDList;
		private var contentMask:Sprite;
		
		public var listHeight:Number=387;
		
		private var listUI:CLDListUI;
		private var maskBit:Bitmap;
		private var centerMask:Sprite;
		private var isInit:Boolean=false;
		public function CLDListWrapper(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			listUI=new CLDListUI();
			this.addChild(listUI);
			list=new CLDList();
			this.addChild(list);
			contentMask=new Sprite();
			this.addChild(contentMask);
			list.mask=contentMask;
			listUI.addEventListener("cld_listui_down",listuiDown);
			maskBit=new Bitmap(this.config.getBitmap("list_centerMask").bitmapData.clone());			
			list.addEventListener(ImgEvent.mouseClick,mouseClick);
			list.addEventListener(ImgEvent.listItemClick,mouseClick);
			centerMask=new Sprite();
			centerMask.addChild(maskBit);
			 
			 this.addChild(centerMask);
			
			 centerMask.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			 centerMask.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			 centerMask.addEventListener(TUIOEvent.TUIO_OUT,upHandler);
			// centerMask.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			
		}
		private function downHandler(e:TUIOEvent):void
		{
			centerMask.filters=[getFilters()];
			this.listuiDown(e);
			//centerMask.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			//centerMask.addEventListener(MouseEvent.MOUSE_OUT,upHandler);
		}
		
		override public function dispose():void
		{
			if(this.centerMask){
				centerMask.removeEventListener(TUIOEvent.TUIO_DOWN,downHandler);
				centerMask.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
				centerMask.removeEventListener(TUIOEvent.TUIO_OUT,upHandler);
			}
			
			super.dispose();
			if(maskBit&&maskBit.bitmapData){
				maskBit.bitmapData.dispose();
			}
			if(this.listUI){
				this.listUI.removeEventListener("cld_listui_down",listuiDown);
			}
			maskBit=null;
			this.list=null;
			this.listUI=null;
			this.centerMask=null;
			
		}
		
		private function getFilters():BitmapFilter
		{
			var g:GlowFilter=new GlowFilter();
			return g;
		}
		private function upHandler(e:Event):void
		{
			centerMask.filters=null;
		}
		private function mouseClick(e:ImgEvent):void{
		  this.dispatchEvent(e.clone());
		}
		private function listuiDown(e:TUIOEvent=null):void
		{
			list.listuiDown(e);
		}
		override public function register():void
		{
			this.registerCommand(CMD.LISTITEMCLICK);
		}
		override public function unregister():void
		{
			this.unregisterCommand(CMD.LISTITEMCLICK);
		}
		override protected function handlerRemote(e:Message):void
		{
			 if(e.type==CMD.LISTITEMCLICK)
			 {
				  var rdata:Object=e.data;
				  if(this.contentID==rdata.contentID&&this.contentIDParam==rdata.contentIDParam)
				  {
					   if(list)
					   {
						   list.dispatherItemEvent(e.data.id,e.data.object);
					   }
				  }
			 }
		}
		override public function draw():void
		{
			super.draw();
			
			if(this.listUI)
			{
				listUI.setSize(this.width,this.listHeight);
			}
			if(list)
			{
				list.setSize(this.width,this.listHeight);
			}
			if(this.contentMask)
			{
				var g:Graphics=this.contentMask.graphics;
				g.clear();
				g.beginFill(0x000000,0);
				g.drawRect(5,5,this.width-20,this.listHeight-20);
				g.endFill();
			}
			if(this.data&&this.dataChange&&!isInit)
			{
				isInit=true;
				if(list)list.data=this.data;
				this.dataChange=false;
			}
			if(this.centerMask)
			{
				centerMask.x=8;
				centerMask.width=this.width-16;
				centerMask.height=54;
				centerMask.y=162;
			}
			
		}
		
	}
}