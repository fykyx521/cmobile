package com.careland.component
{
	import com.careland.component.cldwinclasses.CLDBorder;
	import com.careland.component.cldwinclasses.CLDRect;
	import com.careland.component.cldwinclasses.CLDTab0;
	import com.careland.component.win.WinModel;
	import com.identity.QQWin.CLDTabWindow;
	import com.identity.tab.CLDTab;
	import com.touchlib.TUIOEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDWindow extends CLDTouchObj
	{


		protected var border:CLDBorder;
		protected var rect:CLDRect;

	

		public var content:CLDBaseComponent;
		private var contentMask:Sprite;

		private var _winType:String;

		private var dataArray:Array=[]; //数据数组

		private var _title:String;
		
		private var tab0:CLDTab0;
		
		public var oldParam:Object=new Object;//保存旧的位置信息

		private var space:Number=5;
		
		public var isMapWin:Boolean=false;
		
		public var index:int=0;
		
		public var winModel:WinModel;
		
		public var winScaleX:Number;
		
		public var winScaleY:Number;
		
		public var winWidth:Number;
		public var winHeight:Number;
		
		public var alertWin:Boolean=false;
		
		
		public function CLDWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos);
		}

		public function set title(value:String):void
		{
			this._title=value;
		}

		public function get title():String
		{
			return this._title;
		}
		
		override public function set constom(value:Boolean):void
		{
//			value=false;
			if(value){
				this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);
				this.addEventListener(TUIOEvent.TUIO_OUT,this.outEvent);
				this.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);
				if(stage){
					stage.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);
				}
				
				
				this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
			}else{
				
				this.removeEventListener(TUIOEvent.TUIO_DOWN, this.downEvent);
				this.removeEventListener(TUIOEvent.TUIO_UP, upEvent);
			
				this.removeEventListener(Event.ENTER_FRAME, this.update);
				if(stage){
					stage.removeEventListener(TUIOEvent.TUIO_UP, upEvent);
				}
			}
		}
		private function outEvent(e:TUIOEvent):void
		{
			trace("out")
			//throw new Error;
		}
		
		override protected function downEvent(e:TUIOEvent):void
		{
			super.downEvent(e);
			if(parent&&!this.isMapWin){
				parent.setChildIndex(this,parent.numChildren-1);
			}
		}		
		override protected function addChildren():void
		{

			border=new CLDBorder();
			//border.init(w,h);
			this.addChild(border);


			rect=new CLDRect();
			//rect.init(w-10,h-10);
			this.addChild(rect);

			content=new CLDBaseComponent();

			this.addChild(content);
			
//			tab0=new CLDTab0();
//			
//			this.addChild(tab0);
			
			contentMask=new Sprite();

			this.addChild(contentMask);

			this.content.mask=contentMask;
			trace("addChild");
			
			this.filters=[this.getShadow(10,false)];
			
			
			
			this.hitArea=this.rect;
			
//			CONFIG::flexapp{ 
//				//执行调试代码。
//				this.addEventListener(MouseEvent.MOUSE_DOWN,mdown);
//				this.addEventListener(MouseEvent.MOUSE_UP,mup);
//			}

			
		}
		private function mdown(e:MouseEvent):void
		{
			this.startDrag();
		}
		private function mup(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		override public function hitTestPoint(vx:Number, vy:Number, shapeFlag:Boolean=false):Boolean
		{
			var gl:Point=parent.localToGlobal(new Point(this.x,this.y));			
			var dx:Number=vx-gl.x;
			var dy:Number=vy-gl.y;
			if(this.visible&&dx>0&&dy>0&&vx<(gl.x+this.width)&&vy<(gl.y+this.height)){
				return true;
			}
			return false;
		}	
		public function set winType(value:String):void
		{
			this._winType=value;
		}

		public function get winType():String
		{
			return this._winType;
		}
		
		
		//绘制背景
		override public function draw():void
		{
			super.draw();
			if (super.width == 0)
			{
				width=100;
			}
			if (super.height == 0)
			{
				height=100;
			}
			if (border)
			{
				border.setSize(width, height);
					//this.border.draw();
			}
			if (rect)
			{
				rect.setSize(width, height);
			}
			
			if(this.tab0){
				tab0.x=(this.width-tab0.width)/2;
				tab0.y=5;
				tab0.data=this.title;
			}
			if (this.content)
			{
				content.x=5;
				content.y=0;
//				content.y=this.tab0.height+10;
				content.width=this.width-10;
				content.height=this.height-content.y;


			}
			if (this.contentMask&&this.content)
			{
				contentMask.x=content.x;
				contentMask.y=content.y;
				var g:Graphics=this.contentMask.graphics;
				g.clear();
				try{
					g.beginFill(0xffffff, 1);
					g.drawRect(0, 0, content.width, content.height);
					g.endFill();
				}catch(e:Error){
					
				}
				this.content.mask=contentMask;
			}
			//contentMask.y=this.tab0.height+10;
			if(content){
				updateChild();
			}
			
			
//			if(this.tabpanel){
//				
//				tabpanel.width=content.width;
//				tabpanel.height=content.height;
//			}
		}
		
		public function drawTab():void
		{
			if(this.tab0){
				tab0.x=(this.width-tab0.width)/2;
				tab0.y=5;
				tab0.data=this.title;
			}
		}

		override public function set data(value:*):void
		{
			super.data=value;
			pauseData(value);
			
		}

		//http://192.168.0.202/sz/DataServer/AjaxPreview.aspx?id=100
		protected function pauseData(value:String):void
		{
			//return;
			switch (this.winType)
			{
				case "1":
					pauseNormal(value);
					break;
				case "2":
					pauseqq(value);
					break;
				case "3":
					pauseTab(value);
					break;
				case "4":
					break;
				default:
					pauseNormal(value);
					break;
			}

		}
		
		private function pauseTab(value:String):void
		{
			var ct:com.identity.tab.CLDTab=new com.identity.tab.CLDTab();
			ct.setSize(this.width,this.height);
			ct.contentIDParam=this.contentIDParam;
			ct.data=value;
			content.addChild(ct);

		}
		
		
		//qq window
		private function pauseqq(value:String):void
		{
			
			
			var cld:CLDTabWindow=new CLDTabWindow();
			cld.contentIDParam=this.contentIDParam;
			cld.setSize(500,500);
			cld.data=value;
			content.addChild(cld);
		
			

		}
		//rem 删除已有的内容
		public function addContent(ct:CLDContent,rem:Boolean=true):void
		{
			
			if(content){
				if(rem) while(content.numChildren>0)content.removeChildAt(0);
				content.addChild(ct);
			}
		}

		//普通窗体
		private function pauseNormal(value:String):void
		{
			var tabs:Array=value.split("|");
			for (var i:int=0; i < tabs.length; i++)
			{

				var content:String=tabs[i];
				if (content)
				{
					var contents:Array=content.split("#");
					var title:String=contents[0];
					if(contents[1]){
						var ids:Array=contents[1].split("§")
					
					
						dataArray.push({id: tid, title: title, ids: ids});
						for each (var tid:String in ids)
						{
							if (tid)
							{

							//this.loadDataByID(tid);
							var cld:CLDContent=new CLDContent();
							cld.contentIDParam=this.contentIDParam;
							cld.uuid=this.uuid;
							cld.contentID=tid;
							cld.autoLoad=true;
							this.content.addChild(cld);
							}

						}
					}
					

				}


			}
		}
		




		override public function dispose():void
		{
			this.constom=false;
			super.dispose();
			this.graphics.clear();
			if(this.tab0){
				this.tab0.dispose();
			}
			
			if (border)
			{
				border.graphics.clear();
					//this.border.draw();
			}
			if (rect)
			{
				rect.graphics.clear();
			}
			border=null;
			rect=null;
			if(this.contentMask)contentMask.graphics.clear();
			this.contentMask=null;
			this.winModel=null;
			this.tab0=null;
			this.content=null;
			this.oldParam=null;
			
			winScaleX=undefined;
			winScaleY=undefined;
			winWidth=undefined;
		 	winHeight=undefined;
		
			
			
		}

		public function updateChild():void
		{
			super.draw();

			var num:int=content.numChildren;
			var nw:Number=this.content.width;
			var nh:Number=this.content.height/num-(num-1)*this.space;
			var ypos:Number=0;
			for (var i:int=0; i < num; i++)
			{
				var child:DisplayObject=content.getChildAt(i);
				child.width=nw
				child.height=nh;
				child.y=ypos;
				ypos+=nh+this.space;
				trace(content.width+"childwidth"+child.width+"child"+child);

			}

		}






	}
}