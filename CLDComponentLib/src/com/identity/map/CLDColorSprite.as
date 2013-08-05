package com.identity.map
{
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDTextField;
	import com.careland.component.CLDTouchObj;
	import com.careland.component.util.Style;
	import com.careland.event.ColorEvent;
	import com.identity.CLDButtons;
	import com.identity.CldButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class CLDColorSprite extends CLDTouchObj
	{
		public function CLDColorSprite(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			this.constom=true;
			this.canScale=false; 
		}
		private var xml:XML;
		private var text:TextField;
		private var color:CLDColorManage;
		private var range:String;
		private var length:Number;
		private var colorList:Array=[];
		private var bground:CLDColorBround;
		private var lastIndex:int;
		private var currentIndex:int;
		private var buttonList:Array=[];
		private var event:ColorEvent;
      	override public function dispose():void
		{
            super.dispose();
            this.xml=null;
            this.text=null;
            this.color=null;
            this.range=null;
            this.event=null;
            this.buttonList=null;
            this.currentIndex=null;
            this.lastIndex=null;
            this.bground=null;
            this.colorList=null;
            this.length=null;
            this.constom=false;
		}
		
		 
		public function build():void
		{
			colorList=[];
			buttonList=[];
			while(this.numChildren>0){
				this.removeChildAt(0);				
			}
			xml=XML(this.data);
			if (xml == "")
			{
				return;
			}
			text=new CLDTextField();
			 
			text.selectable=false;			 
			text.x=20;		 
			this.addChild(text);
			var buttonX:int=10;
			var buttonY:int=20;
			for (var i:int=0; i < xml.data.length(); i++)
			{
				this.range=xml.data[i].@指标范围;
				this.length=range.split(",").length;
				color=new CLDColorManage(range, (this.width - 80) / length);
				color.colorName=xml.data[i].@指标名称;
				color.text=xml.data[i].@单位;
				color.width=this.width - 80;				 
				color.y=5;
				color.height=20;
				color.x=60;				
				this.addChild(color);
				var btext:TextField=new TextField();
				btext.text=color.colorName;
				var button:CLDButtons=new CLDButtons();
				button.setSize(90, 24);
				button.lable=color.colorName;
				button.x=buttonX;
				button.dataIndex=i;
				button.y=buttonY;
				//button.enabled=true;
				button.addEventListener(MouseEvent.CLICK, buttonClick);
			

				buttonX+=95;
				if (buttonX >= this.width - 90)
				{
					buttonX=10;
					buttonY+=30;
				}
				if (i == 0)
				{
					this.lastIndex=0;
					color.visible=true;
					button.enabled=false;
					
			        text.text=color.text;			 
			        text.setTextFormat(Style.getTab());
					event=new ColorEvent(ColorEvent.colorClick);
					event.color=color.colorName;
					event.index=0;
					event.colorManage=color;
					this.dispatchEvent(event);
					 
				}
				else
				{
					 
					color.visible=false;
				}
				this.addChild(button);
				buttonList.push(button);
				colorList.push(color);
			}

			bground=new CLDColorBround();
			bground.setSize(this.width, buttonY + 35);
			this.addChildAt(bground, 0);

		}

		private function buttonClick(e:Event):void
		{
			var button:CLDButtons=e.currentTarget as CLDButtons;
			button.enabled=false;
			this.colorClickHandler(button.dataIndex);
			//发送命令
			var mes:Message=Message.buildMsg(CMD.MAP_COLOR_SELECTED)
			var obj:Object=new Object();
			obj.dataIndex=button.dataIndex;
			mes.data=obj;
			this.sendCommand(mes);

		}
		private function colorClickHandler(dataIndex:int)
		{
			var btn:CLDButtons=buttonList[lastIndex] as CLDButtons;
			btn.enabled=true;
			var colorManage:CLDColorManage=colorList[lastIndex] as CLDColorManage;
			colorManage.visible=false;
//			var button:CLDButtons=e.currentTarget as CLDButtons;
			
			lastIndex=dataIndex;
			var colorManage2:CLDColorManage=colorList[dataIndex] as CLDColorManage;
			colorManage2.visible=true;
			text.text=colorManage2.text;			 
			text.setTextFormat(Style.getTab());
			
			event=new ColorEvent(ColorEvent.colorClick);
			event.color=colorManage2.colorName;
			event.index=dataIndex;
			event.colorManage=colorManage2;
			this.dispatchEvent(event);
		}
		
		
		override public function register():void
		{
			super.register();
			super.registerCommand(CMD.MAP_COLOR_SELECTED);
		}
		override public function unregister():void
		{
			super.unregister();
			super.unregisterCommand(CMD.MAP_COLOR_SELECTED);
		}
		override protected function handlerRemote(e:Message):void
		{
			super.handlerRemote(e);
			if(CMD.MAP_COLOR_SELECTED==e.type)
			{
				 this.colorClickHandler(e.data.dataIndex);
			}
			
		}

		//给该组件设置动态数据
		

		override protected function addChildren():void
		{

		}

		override public function draw():void
		{
			if (this.data && this.dataChange)
			{
				build();
				this.dataChange=false;
			}
		}



	}
}