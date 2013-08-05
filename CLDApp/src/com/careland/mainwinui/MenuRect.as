package com.careland.mainwinui
{
	import caurina.transitions.Tweener;
	
	import com.careland.YDTouchComponent;
	import com.careland.component.CLDMapTool;
	import com.careland.component.CLDMapType;
	import com.careland.component.CLDStateButton;
	import com.careland.component.CLDTouchButton;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MenuRect extends YDTouchComponent
	{
		private var prePoint:Point;
		private var isMove:Boolean=false;
		private var location:String="下";
		private var menuLocation:String;
		
		private var menuGroup:MenuGroup;
		private var trash:Trash;
		
		private var showTitle:Bitmap;
		
		private var showDesk:CLDTouchButton;
		
		private var deskBit:Bitmap;
		
		private var backBitmap:Bitmap;
		
		private var maptool:CLDStateButton;
		
		private var  maptype:CLDStateButton;
		
		public function MenuRect()
		{
			super();
			init();
			menuLocation=this.cldConfig.uiConfig.@一级菜单位置;
			
			backBitmap=this.cldConfig.getBitmap("menuback");
			this.addChild(backBitmap);
			showTitle=this.cldConfig.getBitmap("logoshow");
			
			this.addChild(showTitle);
			showTitle.visible=false;
			
			showDesk=new CLDTouchButton();
			deskBit=this.cldConfig.getBitmap("showDesk");
			
			showDesk.setBit(deskBit,deskBit);
			this.addChild(showDesk);
			
			maptool=new CLDStateButton();
			var maptoolbit=this.cldConfig.getBitmap("maptool");
			var maptooldown=this.cldConfig.getBitmap("maptooldown");
			maptool.setBit(maptoolbit,maptooldown);
			this.addChild(maptool);
			
			maptool.addEventListener(MouseEvent.CLICK,maptoolClick);
			
			maptype=new CLDStateButton();
			var maptypebit=this.cldConfig.getBitmap("maptype");
			var maptypedown=this.cldConfig.getBitmap("maptypedown");
			maptype.setBit(maptypebit,maptypedown);
			this.addChild(maptype);
			
			maptype.addEventListener(MouseEvent.CLICK,maptypeClick);
			
			showDesk.x=this.sw-60;
			showDesk.y=0;
			
			maptype.x=this.showDesk.x-120;
			maptool.x=this.maptype.x-120;
			  
			showTitle.x=0;
			showTitle.y=-60;
			this.initMapTypeUI();//因为打开地图后 maptype接受不到事件地图SetLocation事件 所以不能延迟实例化
			this.mapTypeUI.visible=false;
//			showDesk.addEventListener(TUIOEvent.TUIO_DOWN,showDeskHandler);
			showDesk.addEventListener(MouseEvent.CLICK,showDeskHandler);
		}
		private var mapToolUI:CLDMapTool;
		private var mapTypeUI:CLDMapType;
		
		private function initMapTypeUI():void
		{
			if(!mapTypeUI){
				mapTypeUI=new CLDMapType(); 
				mapTypeUI.pressSp=maptype;
				this.addChild(mapTypeUI);
				mapTypeUI.x=this.showDesk.x+60-360;//
				mapTypeUI.y=-140;
			}
			
		}
		
		private function maptoolClick(e:MouseEvent):void
		{
			 this.maptool.press=!this.maptool.press;
			 if(this.maptool.press)
			 {
				  if(!mapToolUI){
					  mapToolUI=new CLDMapTool(); 
					  mapToolUI.pressSp=maptool;
					  this.addChild(mapToolUI);
					  mapToolUI.x=maptool.x-150;//
					  mapToolUI.y=-140;
				  }
				  mapToolUI.visible=true;
				  if(this.mapTypeUI)
				  {
					  this.mapTypeUI.visible=false;
					  this.maptype.press=false;
				  }
			 }else
			 {
				 if(this.mapToolUI)
				 	this.mapToolUI.visible=false;
			 }
		}
		
		private function maptypeClick(e:MouseEvent):void
		{
			this.maptype.press=!this.maptype.press;
			if(this.maptype.press)
			{
				if(!mapTypeUI){
					initMapTypeUI();
				}
				mapTypeUI.visible=true;
				if(this.mapToolUI)
				{
					this.mapToolUI.visible=false;
					this.maptool.press=false;
				}
			}else
			{
				if(this.mapTypeUI)
					this.mapTypeUI.visible=false;
			}
		}
		
		private function showDeskHandler(e:Event):void
		{
			this.cldConfig.dispatchEvent(new Event("showDesk"));
		}
		
		public function addMenuGroup(m:MenuGroup):void{
			menuGroup=m;
			menuGroup.x=150;
		}
		public function addTrash(t:Trash):void
		{
			trash=t;
		}
		
		private function init():void
		{
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			
			//menuGroup.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
		}
		
		private function downHandler(e:TUIOEvent):void
		{
			prePoint=new Point(e.localX,e.localY);
			this.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			trace("down--down");
			//menuGroup.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			//menuGroup.addEventListener(TUIOEvent.TUIO_UP,upHandler);
		}
		private function moveHandler(e:TUIOEvent):void
		{
			
			if(!prePoint){
				return;
			}
			var newPoint:Point=new Point(e.localX,e.localY);
			
			var disPoint:Point=newPoint.subtract(prePoint);
			if(Math.abs(disPoint.y)>10){
				isMove=true;
			}
		}
		private function upHandler(e:TUIOEvent):void
		{
			
			this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			this.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
			if(!this.isMove){
				return;
			}
			var newPoint:Point=new Point(e.localX,e.localY);
			var disPoint:Point=newPoint.subtract(prePoint);
			
			
			switch(this.menuLocation){
				case "左": menuLeft(disPoint);break;
				case "右": menuRight(disPoint);break;
				case "下": menuBottom(disPoint);break;
			}
			
			
//			if(disPoint.x>100&&this.currentState=="show"){
//				this.currentState="hide";
////				this.addEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
////				content.removeEventListener(TUIOEvent.TUIO_DOWN,menu2downHandler);
//				trace("add");
//			}else if(disPoint.x<-40&&this.currentState=="hide"){
//				this.currentState="show";
//				this.hideSprite.visible=false;
////				
//				trace("remove");
//			}
			prePoint=new Point(e.localX,e.localY);
			this.isMove=false;
			
		}
		private function menuLeft(disPoint:Point):void
		{
			
		}
		
		private function menuRight(disPoint:Point):void
		{
			
		}
		
		private function menuBottom(disPoint:Point):void
		{
			if(disPoint.y>20){
				Tweener.addTween(this,{y:this.sh,time:.5});
				showTitle.visible=true;
				showTitle.addEventListener(TUIOEvent.TUIO_DOWN,showDown);
				this.removeEventListener(TUIOEvent.TUIO_DOWN,this.downHandler);
				this.dispatchEvent(new Event("MainMenuHide"));
			}
		}
		private function showDown(e:TUIOEvent):void
		{
			
			Tweener.addTween(this,{y:this.sh-141,time:.5,onComplete:onComplete});
			showTitle.visible=false;
			
		}
		private function onComplete():void
		{
			this.addEventListener(TUIOEvent.TUIO_DOWN,this.downHandler);
			this.dispatchEvent(new Event("MainMenuShow"));
		}
		
		
	}
}