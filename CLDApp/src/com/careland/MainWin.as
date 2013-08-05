package com.careland
{
	import com.careland.component.IMenu;
	import com.careland.component.MenuBase;
	import com.careland.component.YDMenu;
	import com.careland.component.YDMenu2Item;
	import com.careland.component.util.Style;
	import com.careland.event.CLDEvent;
	import com.careland.event.LogoEvent;
	import com.careland.event.YDMenuDownEvent;
	import com.careland.mainwinui.ActiveRect;
	import com.careland.mainwinui.BackSprite;
	import com.careland.mainwinui.Logo;
	import com.careland.mainwinui.Menu2Level;
	import com.careland.mainwinui.Menu3Level;
	import com.careland.mainwinui.MenuGroup;
	import com.careland.mainwinui.MenuRect;
	import com.careland.mainwinui.Trash;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	
	
	public class MainWin extends YDTouchComponent 
	{
		private var logo:Logo;
		private var back:BackSprite;  
		private var trash:Trash;//回收站
		private var activeRect:ActiveRect;//窗口活动区
		private var menu2:Menu2Level;
		private var menu3:Menu3Level;
		
		private var menuGroup:MenuGroup;//菜单组
		private var menuRect:MenuRect;//一级菜单区域 包含了回收站一级菜单
		private var dragObj:MenuBase;
		
		
		private var testMemory:TextField;
		
		private var disx:Number;
		private var disy:Number;
		
		private var dict2:Dictionary=new Dictionary;//存放2级菜单的每个拖动元素MenuBase
		
	    private var maxNum:int = 3;//每次移动复制出来的数量 不要太多 会占用很大内存
	    
	   
	    private var blobs2:Array=[];
	    
	    private var init:Boolean=false;// 第一次初始化 二级菜单不可见
		
		
	    
		public function MainWin()
		{
			
			super();
			this.blobContainerEnabled=true;
		}
		
		override protected function addToStage(e:Event):void{
			super.addToStage(e);
			stage.addEventListener(Event.RESIZE,resizeHandler); 
			//stage.addEventListener(TUIOEvent.TUIO_MOVE,particleHandler);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE,particleHandler);
			stage.addEventListener(TUIOEvent.TUIO_UP,menu1UPHandler);
		}
		private function particleHandler(e:Event):void
		{
			
			  for ( var i = 0; i < maxNum; i++ )
                        {
                                var color:uint;
                                 color = 0xffffff; //判断状态选择颜色
                                //var particles = new Particles(color,1,2); //颜色 、粒子移动的速度、粒子大小
//                                var particles:CLDParticles = new CLDParticles(color,1,Math.random()*5); 
//                                addChild( particles );
//                                particles.x = mouseX; //跟随鼠标
//                                particles.y = mouseY;
//                                particles.rotation = Math.random() * 360; //随机运动轨迹
                        }
		}
	    override protected function createUI():void{
			logo=new Logo();
			back=new BackSprite();
			trash=new Trash();
			
			menuGroup=new MenuGroup();
			menuRect=new MenuRect();
			activeRect=new ActiveRect();
			
			//activeRect.visible=false;//雷达图要点击得话 初始化为false
			menu2=new Menu2Level();
			menu3=new Menu3Level();
			
			this.addChild(back);
			
			menuRect.addChild(menuGroup);
			menuRect.addChild(trash);
			menuRect.addMenuGroup(menuGroup);
			menuRect.addTrash(trash);
			//trash.y=10;
			//menuRect.visible=false;
			//this.activeRect.visible=false;
			
			
			this.addChild(activeRect);
			this.addChild(menu2);
			this.addChild(menu3);
			this.addChild(logo);
			this.addChild(menuRect);
			//this.addChild(trash);
			//this.initialized=true;
			
			this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			//menuGroup.url="../AjaxServer.aspx";
			
			
			menuGroup.addEventListener(YDMenuDownEvent.YDMENU_DOWN,menu1DownHandler);
			menu2.addEventListener(YDMenuDownEvent.YDMENU_DOWN,ydDownHandler);
			menuGroup.addEventListener(YDMenuDownEvent.YDMENU_UP,menu1UPHandler0);
			menu2.addEventListener(YDMenuDownEvent.YDMENU_UP,menu1UPHandler0);
			
			menu3.addEventListener(YDMenuDownEvent.YDMENU_DOWN,ydDownHandler);
			menu3.addEventListener(YDMenuDownEvent.YDMENU_UP,menu1UPHandler0);
			
			
			menu2.addEventListener("menu2Hide",menu2Hide);
			menu2.addEventListener("menu2Show",menu2Show);
			
			this.menuRect.addEventListener("MainMenuHide",menu1Hide);
			this.menuRect.addEventListener("MainMenuShow",menu1Show);
			
			this.activeRect.addEventListener("ActiveRectVisible",ActiveRectVisible);
			activeRect.addEventListener("Menu3Show",menu3Show);
			activeRect.addEventListener("Menu3Hide",menu3Hide);
			this.addEventListener(TUIOEvent.TUIO_UP,menu1UPHandler);
			logo.addEventListener(LogoEvent.HIDE,hideLogohandler);
			logo.addEventListener(LogoEvent.SHOW,showLogohandler);
			this.addEventListener(Event.ENTER_FRAME,update);
			
			//this.menu3.hide();
			layout();
//			var mes:MenuBase=new MenuBase();
//			mes.menuID=1457;
//			mes.menuName="春节保障";
//			menu2.dragEnter(mes);
//			menu2.show();
//			testMemory=new TextField;
//			testMemory.embedFonts=true;
//			testMemory.x=980;
//			testMemory.width=600;
//			this.addChild(testMemory);
//			
		}
		private function menu3Show(e:CLDEvent):void
		{
			this.menu3.show();//=true;
			this.menu3.addMenu(e.obj.xml as XML,e.obj.menuName);
		}
		private function menu3Hide(e:Event):void
		{
			this.menu3.hide();
			this.menu2.hide();
			
		}
		private function ActiveRectVisible(e:Event):void
		{
			//new
//			if(this.activeRect.visible){
//				this.menu2.show();
//				this.menu3.show();
//			}else{
//				this.menu2.hide();
//				this.menu3.hide();
//			}
			//new
		}
		
		private function ydDownHandler(e:YDMenuDownEvent):void
		{
//			if(!this.hasEventListener(Event.ENTER_FRAME)){
//				this.addEventListener(Event.ENTER_FRAME,update);
//			}
			for(var i:int=0;i<this.blobs2.length;i++){
				if(blobs2.id==e.touchID){
					return;
				}
			}
			blobs2.push({id:e.touchID});
			var target:YDMenu2Item=e.target as YDMenu2Item;
			var clone:MenuBase=target.cloneImg();
			this.dict2[e.touchID]=clone;
			
			this.addChild(clone); 
			
			var contentP:Point=target.getTargetPoint();
			
			clone.x=contentP.x;
			clone.y=contentP.y;
			
			clone.disX=e.stageX-clone.x;
			clone.disY=e.stageY-clone.y;
			this.activeRect.menuTouchDown();
			
		}
		private function update(e:Event):void
		{
			
//			var mic:String="启动后分钟数:"+Math.round(flash.utils.getTimer()/1000/60)+"\n";
//			this.testMemory.text=mic+int(System.totalMemory/1024/1024)+":";
//				
//			this.testMemory.setTextFormat(Style.getTFF());
//		
			  
			for(var item in this.dict2){
				var menuBase:Object=dict2[item];
				var tobj:TUIOObject=TUIO.getObjectById(int(item));
				if(menuBase&&tobj){
					menuBase.x=tobj.x-menuBase.disX;
					menuBase.y=tobj.y-menuBase.disY;
				}
			}
			//TUIO.getObjectById()
		}
		private function menu2Hide(e:Event):void
		{
			activeRect.menu2Hide();
		}
		
		private function menu2Show(e:Event):void
		{
			activeRect.menu2Show();
		}
		private function menu1Hide(e:Event):void
		{
			activeRect.menu1Hide();
			this.menu2.menu1Hide();
		}
		private function menu1Show(e:Event):void
		{
			activeRect.menu1Show();
			this.menu2.menu1SHow();
		}
		
		
		//logo隐藏处理函数
		private function hideLogohandler(e:LogoEvent):void
		{
			this.activeRect.y=0;
			//this.menu2.y=0;
			//Tweener.addTween(activeRect,{y:0,time:.5});
			//Tweener.addTween(menu2,{y:0,time:.5});
			activeRect.hideLogohandler();
			this.menu2.hideLogohandler();
			//this.activeRect.height=911+140;
			
			
		}
		//logo显示处理函数
		private function showLogohandler(e:LogoEvent):void
		{
			activeRect.showLogohandler();
			this.menu2.showLogohandler();
			this.activeRect.y=105;
			///this.menu2.y=105;
			//Tweener.addTween(activeRect,{y:145,time:.5});
			//Tweener.addTween(menu2,{y:145,time:.5});
		}
		
		
		public function updateDisplay():void
		{
			//this.layoutUI();
		}
		
	     public function layout():void{
		 	
		 	
		    var menuLocation:String=YDConfig.instance().uiConfig.@一级菜单位置;
		 	if(menuLocation=="下"){
		 		menuRect.x=0;
				menuRect.y=sh-141;
				
				menu2.x=this.sw;//ActiveRect._WIDTH+15;//图片的宽度+距右边距5
				menu2.y=111;
				activeRect.y=105;
				//menu3.x=ActiveRect._WIDTH+15-252;//ActiveRect._WIDTH+15;//图片的宽度+距右边距5
				menu3.x=sw-500;
				menu3.y=111;
				
				trash.x=0;
				trash.y=5;

		 	}else{ //right
		 		menuRect.x=sw-145;
		 		menuRect.y=0;
				var temp=10;//新皮肤有点靠左了
		 		menu2.x=sw-(394)-145+temp;//图片的宽度+距右边距5
				menu2.y=145;
				
				trash.x=0;
				trash.y=sh-145;
				
//				var pmenu2:Point=menu2.globalToLocal(new Point((sw-21-341-145),250));
//				menu2.menu2Tip.x=pmenu2.x;
//				menu2.menu2Tip.y=pmenu2.y;
		 	}
			//activeRect.y=111;
//			activeRect.y=108;
			
			if(!this.init){
				this.menu2.menu2Hide(true);    
			}
			this.init=true;
//			activeRect.menu3Tip.x=301;
//			activeRect.menu3Tip.y=436;
		}
		
		 private var  currentMenu1:YDMenu;
		 
		private function menu1DownHandler(e:YDMenuDownEvent):void
		{
			//new
			this.menu2.show();
			//new end 
			this.menu2.removeListener();
			var menu1:IMenu=e.target as IMenu;
			
			if(!menu1&&this.dragObj!=null){
				return;
			}
			
			trace(this.dragObj+"-------------------------");
			dragObj=menu1.cloneImg();
			this.addChildAt(dragObj,this.numChildren-1);
			var p:Point=menu1.getTargetPoint();
			dragObj.x=p.x;
			dragObj.y=p.y;
			dragObj.alpha=1;
			
			disx=e.stageX-dragObj.x;
			disy=e.stageY-dragObj.y;
			if(!this.hasEventListener(TUIOEvent.TUIO_MOVE)){
				this.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			}
			
			if(dragObj.getLevel()!=2){
				this.menu2.menuTouchDown();
			}
			//this.activeRect.menuTouchDown();
			
			
			
			
		}
		private function moveHandler(e:TUIOEvent):void
		{
			if(!dragObj)
				return;	
			dragObj.x=e.stageX-disx;
			dragObj.y=e.stageY-disy;
			
			dragObjDragging(e);
			
			var menuBase:MenuBase=this.dict2[e.ID];
			if(menuBase){
				menuBase.x=e.localX;
				menuBase.y=e.localY;
			}
			
		}
		private function dragObjdownHandler(e:Event):void
		{
			//dragObj.x+=e.dx;
			//dragObj.y+=e.dy;
			
		}
		private function dragObjDragging(e:TUIOEvent=null):void
		{
			if(dragObj.getLevel()!=2){
				if(dragObj.hitTestObject(this.menu2.menu2Tip)){
					//menu2.showBorder();
				}else{
					//menu2.hideBorder();
				}
			}
			
			if(dragObj.hitTestObject(this.activeRect.menu3Tip)){
				//activeRect.showBorder();
			}else{
				//activeRect.hideBorder();
			}
			var menuBase:MenuBase=this.dict2[e.ID];
			if(!menuBase)return;
			if(menuBase.hitTestObject(this.activeRect.menu3Tip)){
				//activeRect.showBorder();
			}else{
				//activeRect.hideBorder();
			}
		}
		private function menu1UPHandler(e:TUIOEvent):void
		{
			var tid:int=e.ID;
			
			menuUp(tid,e.target as  YDMenu);
		
		}
		private function menu1UPHandler0(e:YDMenuDownEvent):void
		{
			//this.removeEventListener(Event.ENTER_FRAME,update);
			var tid:int=e.touchID;
			menuUp(tid,e.target as IMenu);
			this.activeRect.menuTouchUP();
		
		}
		
		private var currentMenu2:YDMenu2Item;
		
		private function menuUp(touchID:int,target:IMenu):void
		{
			var menuBase:DisplayObject=this.dict2[touchID];
			if(menuBase){
				if(menuBase.hitTestObject(this.activeRect.menu3Tip)){
					var mu:MenuBase=menuBase as MenuBase;
					var isDragEnter:Boolean=true;
					if(mu.getLevel()==2||mu.getLevel()==3)
					{
						if(mu.hitTestObject(this.menu2)||this.menu3.hitTestObject(mu))
						{
							isDragEnter=false;		
						}
					}
					if(isDragEnter)
					{
						activeRect.dragEnter(new Point(menuBase.x,menuBase.y),menuBase as MenuBase);
					}
					
					
				}
				this.removeChild(menuBase);
				delete dict2[touchID]; 
				//trace("remove:"+menuBase);
			
			}
			
			if(target is YDMenu)
			{
				if(currentMenu2)
				{
					currentMenu2.setSelected(false);
					currentMenu1=target as YDMenu;
					currentMenu1.setSelected(true);
				}
			}
			if(target is YDMenu2Item)
			{
				if(currentMenu2)
				{
					currentMenu2.setSelected(false);
				}
				currentMenu2=target as YDMenu2Item;
				currentMenu2.setSelected(true);
			}
			
			
		
			if(!target is YDMenu)
				return;
			try{
				
				this.activeRect.menuTouchUP();
				this.menu2.menuTouchUP();
				dragEnterHandler();
				this.removeChild(dragObj);
				dragObj=null;
				menu2.addListener();
			}catch(e:Error){
				
			}
		}
		
		private function dragEnterHandler():void
		{
//			menu2.hideBorder();
//			activeRect.hideBorder();
			if(dragObj.hitTestObject(this.menu2.menu2Tip)){
				menu2.dragEnter(dragObj);
			}
			if(dragObj.hitTestObject(this.activeRect.menu3Tip)){
				activeRect.dragEnter(new Point(dragObj.x,dragObj.y),dragObj,true);
			}
		}  
		
		//窗口拖动结束事件
		private function upHandler(e:TUIOEvent):void
		{
			
		}
		

	}
}