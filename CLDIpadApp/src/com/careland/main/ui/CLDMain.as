package com.careland.main.ui
{
	import com.careland.component.CLDViewContent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CLDMain extends CLDBaseUI
	{
		private var logo:CLDLogo;
		private var mainMenu:CLDMainMenu;
		private var back:CLDBack;
		private var menu2:CLDMenu2;
		private var menu3:CLDMenu3;
		private var main:CLDMainContent;
		public function CLDMain()
		{
			super();
		}
		override protected function addChildren():void
		{
			back=new CLDBack();
			this.addChild(back);
			logo=new CLDLogo();
			this.addChild(logo);
			
			main=new CLDMainContent();
			this.addChild(main);
			//main.visible=false;//默认不显示内容区域   雷达图就可以点击
			mainMenu=new CLDMainMenu();
			this.addChild(mainMenu);  
			menu2=new CLDMenu2();
			this.addChild(menu2);
			menu3=new CLDMenu3();
			this.addChild(menu3);
			
		}
		override public function draw():void
		{
		 	mainMenu.y=this.height-141;
			mainMenu.setSize(width,141);
			logo.setSize(this.width,105);
		    menu2.x=this.width-260;
			menu2.y=111;   
			menu2.setSize(260,818);
			menu3.y=111;  
			menu3.setSize(260,818);
			menu3.x=this.width-500;
			menu2.stageWidth=menu3.stageWidth=this.width;
			menu3.stageHeight=menu2.stageHeight=this.width;
			back.move((this.width-1920)/2,(this.height-1080)/2); //背景是1080的
			main.setSize(this.width,this.height-141-111);
			main.y=111;
		}
	}
}