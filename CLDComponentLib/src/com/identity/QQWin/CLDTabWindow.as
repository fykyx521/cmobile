package com.identity.QQWin
{
	import caurina.transitions.Tweener;
	
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;

	public class CLDTabWindow extends CLDBaseComponent
	{
		public function CLDTabWindow(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{

		}
		public var winIndex:int;//新增属性  方便 远程控制 判断 唯一内容 或窗体  
		 private var bitArray:Array=new Array(5);
		private var styleXML:XML; //表格皮肤
		private var xml:XML;
		private var tabList:Array=[];
		private var index:int; //当前激活的下标位
		private var direction:String;
		public var contentHeight:int=200;
		public var pData:Boolean=false; //是否解析Data				
		public var loaded:Boolean=false;
		private var dataArray:Array=[];
		private var tweenObject:CLDTab;
		private var ifFinish:Boolean=true;
		public var isContent:Boolean=false;
		private var titleHeight:Number=41;
		private var ItemList:Array;
		private var list:Array=[];
    	/**
		 *
		 * 覆盖父类添加子例方法
		 */
		override protected function addChildren():void
		{
		  	this.addEventListener(Event.RESIZE, resize);
			
		}

		private function resize(e:Event):void
		{
		   if(list!=null){
		   	   reload();
		   }
		}
		//undefined
		override public function dispose():void
		{			
			this.removeEventListener(Event.RESIZE, resize);		    
 		    styleXML=null;
			this.xml=null;
			loaded=null;
			if(this.dataArray){
				dataArray.length=0;
				this.dataArray=null;
			}			
			tweenObject=null;
			ifFinish=undefined;
			isContent=undefined;
	 		if(ItemList)ItemList.length=0;ItemList=null;
			if(list)list.length=0;list=null;
		 	list=null;
			super.dispose();
			
		}
		

      private function reload():void{
      	this.contentHeight=this.height-this.list.length*this.titleHeight;
         for(var i:int=0;i<list.length;i++){
         	 var cldTab:CLDTab=list[i] as CLDTab;        	                 
         	     cldTab.width=this.width;  
         	     cldTab.height=387;
  	      }
      }
		public function getBitmap(key:*):Bitmap
		{
			return this.config.getBitmap(key);
		}

		//给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
			loadDatacomplete();
		}
		private function loadDatacomplete():void
		{
			if (!ifFinish)
			{
				return;
			}						 
			if (this.data == null)
			{
				return;
			}		
			for (var i:int=0; i < this.bitArray.length; i++)
			{
				bitArray[i]=getBitmap("tabimg" + i);
			}
			var tabs:Array=this.data.split("|");
			contentHeight=387;
		    for (i=0; i < tabs.length; i++)
			{
				var content:String=tabs[i];
				if (content != "")
				{
					var id:String=content.split("#")[1].toString().split("§")[0];
					var title:String=content.split("#")[0].toString();					 
					var	tab:CLDTab=new CLDTab(id, bitArray,this.titleHeight, this.width, contentHeight, 0, 0, title, "true", isContent);						 
						tab.content.visible=true;
	 				    tab.addEventListener("titleClick", tabChange);			 
					    index=0;
					    tabList.push(tab);					
				}
			}
			build();
		}
        
        private function build():void{
        	if(!this.list)return;
        	var _y:Number=0;
        	this.contentHeight=this.height-this.tabList.length*this.titleHeight;
           for(var i:int=0;i<tabList.length;i++){
           	   var tab:CLDTab=tabList[i] as CLDTab          	   
           	   	   tab.height=contentHeight;             	   	          	   
           	       tab.width=this.width;
           	        tab.y=_y;         	                 	    
           	      	 tab.ifopen=false;
           	      	 tab.isUsed=false;
           	      	 tab.setNoUsed();
           	      	 tab.content.visible=false;
           	      	 _y+=titleHeight;
           	     
           	      if(list){
           	      	  list.push(tab);
           	      	  this.addChild(tab);
           	      }
            }
        }
		private function MouseDown(e:MouseEvent):void
		{
			this.startDrag(); //设置可拖拽
		}

		private function MouseUP(e:MouseEvent):void
		{
			this.stopDrag();

		}

		/**
		* 标签多个同时切换
		*/
		private function tabChange(e:Event=null):void
		{
			var tab:CLDTab=e.currentTarget as CLDTab;
			tabClickHandler(tab);
			sendTabClick(tab);
			
		}
		private function tabClickHandler(tab:CLDTab):void
		{
			if(!ifFinish)
			{
				return;
			}
			var sourY:int;
			//查找当前被激活的选项    
			for (var i:int=0; i < tabList.length; i++)
			{
				var _tab:CLDTab=tabList[i] as CLDTab;
				if (_tab == tab)
				{
					if (!_tab.isUsed)
					{
						_tab.isUsed=true;						 
						_tab.setUsed(); //激活标签(设置标签背景)		
					}
					//移除之前所有内容     
					if (!_tab.ifopen)
					{
						if (ifFinish)
						{
							for (var j:int=i + 1; j < tabList.length; j++)
							{
								var _tab2:CLDTab=tabList[j] as CLDTab;									 
								var _tab5:CLDTab=tabList[i] as CLDTab;
								sourY=_tab2.y +_tab5.height;
								tweenObject=_tab2;
								Tweener.addTween(_tab2, {y: sourY, time: 0.3, onComplete: onComplete});
							}
							if(sourY>0){
								ifFinish=false;	
							}							 
						}
						_tab.setLogo2();
						_tab.content.visible=true;						 
						_tab.ifopen=true; //已经打开过的下次点击就关闭						 
					}
					else
					{
						if (ifFinish)
						{
							for (j=i+1; j < tabList.length; j++)
							{
								var _tab3:CLDTab=tabList[j] as CLDTab;
								var _tabe4:CLDTab=tabList[i] as CLDTab;
								sourY=_tab3.y - _tabe4.height;
								tweenObject=_tab3;
								Tweener.addTween(_tab3, {y: sourY, time: 0.3, onComplete: onComplete});
							}
							if(sourY>0){
								ifFinish=false;	
							}																
						}
						_tab.content.visible=false;
						_tab.setLogo();
						_tab.ifopen=false;  
					}
					tabList[i]=_tab;
					index=i;
				}
				else
				{
					if (_tab.isUsed)
					{
						_tab.isUsed=false;
						_tab.setNoUsed(); //当前点击的窗体非之前激活的标签时候将之前激活的标签设置为未激活状态
					}
				}
			}
		}
		

		/**
		* 回谈回调函数判断回弹是否完成
		*/
		private function onComplete():void
		{
			ifFinish=true;
		}
		private function sendTabClick(tab:CLDTab):void
		{
			var mes:Message=Message.buildMsg(CMD.QQTABCLICK);
			var obj:Object={};
			obj.winIndex=this.winIndex;
			obj.id=tab.id;
			mes.data=obj;
			this.sendCommand(mes);
		}
		override public function register():void
		{
			 this.registerCommand(CMD.QQTABCLICK);
		}
		override public function unregister():void
		{
			this.unregisterCommand(CMD.QQTABCLICK);
		}
		override protected function handlerRemote(e:Message):void
		{
			if(e.data.winIndex==this.winIndex)
			{
				 var tab:CLDTab=this.getRemoteTab(e.data.id);
				 if(tab)
				 {
					 this.tabClickHandler(tab);//
				 }
			}
		}
		private function getRemoteTab(id:String):CLDTab
		{
			for(var i=0;i<this.numChildren;i++)
			{
				var tab:CLDTab=this.getChildAt(i) as CLDTab;
				if(tab&&tab.id==id)
				{
					 return tab;
				}
			}
			return null;
		}
		
		
		

	}
}