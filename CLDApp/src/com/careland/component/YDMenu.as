package com.careland.component
{
	import com.careland.YDBase;
	import com.careland.YDConfig;
	import com.careland.component.util.Style;
	import com.careland.event.YDMenuDownEvent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	public class YDMenu extends YDBase implements IMenu
	{
//		[Embed(source='assets/menu1/menu1.png')]
//		private var iconCls:Class;
//		
//		[Embed(source='assets/menu1/menu1c.png')]
//		private var selectedIconCls:Class;
		
		private var icon:Bitmap;
		private var selectedIcon:Bitmap;
		
		private var selected:Boolean=false;
		
		private var drapClone:MenuBase;
		
		private var downTime:Number;//点击的时间
		
		private var downPoint:Point;//点击的坐标
		
		private var isMove:Boolean=false;
		
		private var num:int=-1;
		private var _menuName:String="";
		
//		[Embed(source='assets/m1.png')]
//		private var iconBit:Class;
//		[Embed(source='assets/m1selected.png')]
//		private var selBit:Class;
		
		private var remoteBit:Bitmap;
		
		public function YDMenu(iconstr:String,selIcon:String,num:int,menuName:String)
		{
			
			super();
			icon=new Bitmap;//new Bitmap(new iconBit as Bitmap);
			selectedIcon=new Bitmap;//new Bitmap();
			//remoteBit=new Bitmap;  
			this.num=num;
			this._menuName=menuName;
//			this.loadContent(iconstr,iconResult);
//			this.loadContent(selIcon,selIconResult);
    		iconstr="assets/qycx.png";
			this.loadContent(iconstr,result);
		
			createUI();
			 
			this.addEventListener(TUIOEvent.TUIO_DOWN,down);
		
		}
		
		private function result(e:Event):void{
			this.icon.bitmapData=(e.target.content as Bitmap).bitmapData;
			//var vy:Number=this.icon.bitmapData.height;
			
			var text:TextField=new TextField();
			text.text=this._menuName;
			//			text.text=num+":"+this._menuName;
			text.selectable=false;
			text.width=150;
			text.embedFonts=true;
			text.setTextFormat(Style.getTFF());
			//			/text.y=95;
			text.y=110;
			
			//text.visible=false;
			this.addChild(text);
		}
		
		override protected function createUI():void{
			this.addChildAt(icon,0); 
			this.addChildAt(selectedIcon,1); 
			
			selectedIcon.visible=false;
			this.y=-5;
			 
			
		}
		
		public function setSelected(value:Boolean):void
		{
			this.selected=value;
			this.updateUI();
		}
		
		private function down(evt:TUIOEvent):void
		{
			this.selected=true;
			updateUI();
			this.addEventListener(TUIOEvent.TUIO_UP,up);
			this.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			this.downTime=flash.utils.getTimer();
			this.downPoint=new Point(evt.localX,evt.localY);
			
			
		}
		
		private function disEvent(evt:TUIOEvent):void
		{
				evt.stopPropagation();
				this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
				var yd:YDMenuDownEvent=new YDMenuDownEvent(YDMenuDownEvent.YDMENU_DOWN,true,true);
				yd.stageX=evt.stageX;
				yd.stageY=evt.stageY;
				yd.touchID=evt.ID;
				this.dispatchEvent(yd);
			
		}
		//只有x移动<20并且 y向上移动 才判定它是点击菜单的 (菜单位于下方时)
		private function menuBottom(disTime:Number,dis:Point,curPoint:Point,evt:TUIOEvent):void
		{
			if(disTime>100&&Math.abs(dis.x)<20&&Math.abs(dis.y)>30&&curPoint.y<downPoint.y){
				
				disEvent(evt);
			}else{
				isMove=true;
			}
		}
		
		// (菜单位于右方时)
		private function menuRight(disTime:Number,dis:Point,curPoint:Point,evt:TUIOEvent):void
		{
			if(disTime>100&&Math.abs(dis.y)<20&&Math.abs(dis.x)>30&&curPoint.x<downPoint.x){
				
				disEvent(evt);
				
			}else{
				isMove=true;
			}
		}
		//菜单位于左方时
		private function menuLeft(disTime:Number,dis:Point,curPoint:Point,evt:TUIOEvent):void
		{
			if(disTime>100&&Math.abs(dis.y)<20&&Math.abs(dis.x)>30&&curPoint.x>downPoint.x){
				
				disEvent(evt);
			}else{
				isMove=true;
			}
		}
		
		
		
		//private function 
		private function moveHandler(evt:TUIOEvent):void
		{
			var curTime=flash.utils.getTimer();
			var disTime=curTime-downTime;
			
			var curPoint:Point=new Point(evt.localX,evt.localY);
			var dis:Point=curPoint.subtract(downPoint);
			
			//因为菜单位置有可能随时改变
			var menuLocation:String=YDConfig.instance().uiConfig.@一级菜单位置;
			
			switch(menuLocation){
				case "左":  menuLeft(disTime,dis,curPoint,evt);break;
				case "右": menuRight(disTime,dis,curPoint,evt);break;
				case "下":menuBottom(disTime,dis,curPoint,evt);break;
			}
			
			
			
			
		}
		private function up(evt:TUIOEvent):void
		{
			
			isMove=false;
			
			this.selected=false;
			updateUI();
			
			this.removeEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			
			this.removeEventListener(TUIOEvent.TUIO_UP,up);
			var yd:YDMenuDownEvent=new YDMenuDownEvent(YDMenuDownEvent.YDMENU_UP,true,true);
			yd.stageX=evt.stageX;
			yd.stageY=evt.stageY;
			this.dispatchEvent(yd);

		}
		private function iconResult(e:Event):void{
			this.icon.bitmapData=(e.target.content as Bitmap).bitmapData;
			//var vy:Number=this.icon.bitmapData.height;
			
			var text:TextField=new TextField();
			text.text=this._menuName;
//			text.text=num+":"+this._menuName;
			text.selectable=false;
			text.width=150;
			text.embedFonts=true;
			text.setTextFormat(Style.getTFF());
//			/text.y=95;
			text.y=115;
			
			//text.visible=false;
			this.addChild(text);
		}
		private function selIconResult(e:Event):void{
			this.selectedIcon.bitmapData=(e.target.content as Bitmap).bitmapData;
		}
		override protected function updateUI():void{
//			if(this.selected){
//				this.icon.visible=false;
//				this.selectedIcon.visible=true;
//			}else{
//				this.icon.visible=true;
//				this.selectedIcon.visible=false;
//			}
		}
		 public function cloneImg():MenuBase
		{
			var newbmp:Bitmap=new Bitmap(icon.bitmapData.clone());
			
			//var newbmp:Bitmap=new Bitmap(icon.bitmapData);
			//drapClone=new YDBitmapTouchButton(newbmp,newbmp);
			 
			var menuBase:MenuBase=new MenuBase();
			menuBase.level=this.getLevel();
			menuBase.menuID=this.num;
			menuBase.menuName=this._menuName;
			menuBase.addChild(newbmp);
			return menuBase;
		}
		public function dispose():void
		{
			if(icon){
				this.icon.bitmapData.dispose();
			}
		}
		
		public function getTargetPoint():Point{
			if(!parent){
				return null;
			}
			var mp:Point=new Point(this.x,this.y);
			var contentP:Point=parent.localToGlobal(mp);
			
			return contentP;
		}
		public function getLevel():int
		{
			return 1;
		}

	}
}
