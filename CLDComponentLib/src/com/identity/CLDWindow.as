package com.identity
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.YDConfig;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.cldwinclasses.CLDTab;
	import com.careland.component.util.ComponentFactory;
	import com.identity.QQWin.CLDTabWindow;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.*;

	/**
	* Flex窗体封装类
	*
	* author: 程斌斌 (2011-3-29)
	**/
	public class CLDWindow extends CLDBaseComponent
	{
 

		private var sprite:Sprite
		private var image:Bitmap;
		private var loader:Loader;
		private var text:TextField;
		private var closeText:TextField;
		private var contentBground:CLDWindowFiter;
		private var title:CLDWindowTitle;
		private var closeBtn:CLDCloseBtn;
		private var bit:Bitmap;
		private var ifClose:Boolean=false;
		private var dis:DisplayObject;
		private var img0:Bitmap=new Bitmap();
		private var img1:Bitmap=new Bitmap();
		private var img2:Bitmap=new Bitmap();
		private var img3:Bitmap=new Bitmap();
		private var img4:Bitmap=new Bitmap();
		private var img5:Bitmap=new Bitmap();
		private var img6:Bitmap=new Bitmap();
		private var img7:Bitmap=new Bitmap();
		private var img8:Bitmap=new Bitmap();
		private var bulkLoader:BulkLoader;
		public var titleHeight:int=35;
		public var ifMoveRight:Boolean;
		public var _title:String="";
		public var _ifclose:Boolean=true;
		public var _ifMove:Boolean=true;		
		public var _contentIfMove:Boolean=false;		
		public var _ifMax:Boolean=false;		
		public var _ifMin:Boolean=false;		
		public var _content:Sprite=new Sprite();		
		private var isLoad:Boolean=false;		
		private var ifCloseText:Boolean=false;
		private var tab:CLDTab;
		private var content:CLDBaseComponent;
		private var contentMask:Sprite;
		private var _winType:String;
		private var dataArray:Array=[]; //数据数组
		private var bitlist:Array=new Array()
       
		public function CLDWindow()
		{
			super();
			//设置图片			
		}
         override public function dispose():void{
          super.dispose();
          this.bitlist=null;
          this.dataArray=null;
          this._winType=null;
          this.contentMask=null;
          this.content=null;
          this.tab=null;
          this.ifCloseText=null;
          this.isLoad=null;
          this._content=null;
          this._ifMin=null;
          this.sprite=null;
          this.image=null;
          this.loader=null;
          this.text=null;
          this.closeText=null;
          this.contentBground=null;
          this.title=null;
          this.closeBtn=null;
          this.bit=null;
          this.ifClose=null;
          this.dis=null;
          this.img0=null;
          this.img1=null;
          this.img2=null;
          this.img3=null;
          this.img4=null;
          this.img5=null;
          this.img6=null;
          this.img7=null;
          this.img8=null;
          this.bulkLoader=null;
         
        }
		/***
		* 添加子类
		*
		***/
		override protected function addChildren():void
		{
			if (!contentBground && !ifClose)
			{
				contentBground=new CLDWindowFiter();
				this.addChild(contentBground);
			}
			if (!title)
			{
				setTitle();
			}
			//设置窗体内容     
			this.addChild(_content);			 
			sprite=new Sprite();
			this.addChild(sprite);
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			loadImage();
		}

		override public function draw():void
		{
			super.draw();
			title.width=width;
			title.height=30;
			if (!ifClose)
			{
				contentBground.width=width;
				contentBground.height=height;
			}
			if (height != 0)
			{
				if (dis == null)
				{
					dis=this.getdis();
					this.addChild(dis);
					this._content.mask=dis;
				}
			}
			img1.width=this.width - 12;
			img2.x=this.width - 6;
			img3.height=this.height - 12;
			img4.y=this.height - 6;
			img5.width=this.width - 12;
			img5.y=this.height - 1;
			img6.x=this.width - 6;
			img6.y=this.height - 6;
			img7.height=this.height - 12;
			img7.x=this.width - 1;
			img8.x=this.width-78;
			img8.y=-39;	
			img8.visible=true;	 
		}

		override public function set data(value:*):void
		{
			super.data=value;
			pauseData(value);
		}

		//http://192.168.0.202/sz/DataServer/AjaxPreview.aspx?id=100
		private function pauseData(value:String):void
		{
			switch (this.winType)
			{
				case "1":
					pauseNormal(value);
					break;
				case "2":
					pauseqq(value);
					break;
				case "3":
					break;
				case "4":
					break;
				default:
					pauseNormal(value);
					break;
			}

		}

		//qq window
		private function pauseqq(value:String):void
		{
			var tabs:Array=value.split("|");
			for (var i:int=0; i < tabs.length; i++)
			{
				var contentN:String=tabs[i];
				if (contentN)
				{
					var contents:Array=contentN.split("#");
					var title:String=contents[0];
					var ids:Array=contents[1].split("§");
					var idarr:Array=[];
					for each (var tid:String in ids)
					{
						if (tid)
						{
							idarr.push(tid);
								//this.loadDataByID(tid);						
						}
					}
					dataArray.push({id: tid, title: title, ids: idarr});
				}
			}
			this.content=new CLDTabWindow();
			this.addChild(content);
			content.width=500;
			content.addEventListener("uiLoad", loaded);
			function loaded(e:Event):void
			{
				content.setSize(500, 900);
				content.data=dataArray;
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
					var ids:Array=contents[1].split("§")
					dataArray.push({id: tid, title: title, ids: ids});
					for each (var tid:String in ids)
					{
						if (tid)
						{
							this.loadDataByID(tid);
						}
					}
				}
			}
		}

		public function set winType(value:String):void
		{
			this._winType=value;

		}

		public function get winType():String
		{
			return this._winType;
		}

		override protected function loadComponentData(id:String, data:*):void
		{


			var xml:XML=XML(this.dataLoader.data);
			var config:XML=xml.config[0];
			var type:String=config.@["内容类型"];
			var timeInterval:Number=Number(config.@["刷新频率"]);
			var content:CLDBaseComponent=ComponentFactory.getComponent(type, id, timeInterval, false);
			content.setSize(this.width, this.height);

			content.autoLoad=true;


			this.addContent(content);
			this.invalidate();
		}

		/**
		*
		* 加载图片路径
		*/
		private function loadImage():void
		{
			img0.bitmapData=getBitmap("win_leftRange.png").bitmapData.clone();
			img0.x=0;
			img0.y=0;
			img0.width=6;
			img0.height=6;
			this.addChild(img0);
			img1.bitmapData=getBitmap("win_line.png").bitmapData.clone();
			img1.x=6;
			img1.y=0;
			img1.height=0.5;
			this.addChild(img1);
			img2.bitmapData=getBitmap("win_rightRange.png").bitmapData.clone();
			img2.width=6;
			img2.height=6;
			this.addChild(img2);
			img3.bitmapData=getBitmap("win_line.png").bitmapData.clone();
			img3.y=6;
			img3.x=0;
			img3.width=0.5;
			this.addChild(img3);
			img4.bitmapData=getBitmap("win_downLeftRange.png").bitmapData.clone();
			img4.x=0;
			img4.width=6;
			img4.height=6;
			this.addChild(img4);
			img5.bitmapData=getBitmap("win_line.png").bitmapData.clone();
			img5.x=6;
			img5.height=0.5;
			this.addChild(img5);
			img6.bitmapData=getBitmap("win_downRightRange.png").bitmapData.clone();
			img6.width=6;
			img6.height=6;
			this.addChild(img6);
			img7.bitmapData=getBitmap("win_line.png").bitmapData.clone();
			img7.width=0.5;
			img7.y=6;
			this.addChild(img7);
		    var sprite:Sprite=new Sprite();		    
			img8.bitmapData=getBitmap("win_closeBtn.png").bitmapData.clone();
			sprite.addEventListener(MouseEvent.CLICK, closeBtnClick);			 
			img8.width=getBitmap("win_closeBtn.png").width;
			img8.height=getBitmap("win_closeBtn.png").height;
			img8.visible=false;
		    sprite.addChild(img8);
			this.addChild(sprite);				
		}
		public function getBitmap(key:*):Bitmap
		{

			return YDConfig.instance().getBitmap(key);
		}
		/**
		 *
		 * 关闭按钮点击事件
		 */
		private function closeBtnClick(ev:MouseEvent):void
		{
			graphics.clear(); //清理面板
           while(this.numChildren>0){
		  	this.removeChildAt(0);
		  }
		}

	 

		public function getdis():DisplayObject
		{

			var sprite:Sprite=new Sprite;
			var g:Graphics=sprite.graphics;
			g.beginFill(0xffffff, 1);
			g.drawRect(0, this.titleHeight, width, height -this.titleHeight);
			g.endFill();
			return sprite;
		}

	 

	 

		/**
		 *
		 * 填充标题
		 */
		private function setTitle():void
		{
			title=new CLDWindowTitle();
			title.width=width;
			title.height=30;
			title.x=1;
			title.y=1;
			title.addEventListener(MouseEvent.MOUSE_DOWN, title_mouseDown);
			title.addEventListener(MouseEvent.MOUSE_UP, title_mouseUp);
			this.addChild(title);
		}

		/**
		  * 标题鼠标mouseDown事件
		  */
		private function title_mouseDown(event:MouseEvent):void
		{
			if (_ifMove)
			{
				this.startDrag(); //设置可拖拽
			}
		}

		private function title_mouseUp(event:MouseEvent):void
		{
			if (_ifMove)
			{
				this.stopDrag(); //设置停止拖拽
			}
		}

		/**
		* 标题的鼠标悬停事件
		*/
		public function title_mouseOver(event:MouseEvent):void
		{
			//Mouse.hide();	//这里改变鼠标样式 	   
			//this._content.mask=     
		}

		/**
		*
		* 鼠标离开事件
		*/
		public function title_mouseOut(event:MouseEvent):void
		{
			//这里改变鼠标样式
		}

		public function addContent(dis:DisplayObject):void
		{
			var _y:int=this.titleHeight;
			for (var i:int=0; i < this._content.numChildren; i++)
			{
				var child:Sprite=this._content.getChildAt(i) as Sprite;
				_y+=child.height + 20;
			}
			dis.y=_y;

			if (dis.width > this.width - 8)
			{
				dis.width=this.width - 8;
				dis.x=0;
			}
			else
			{
				 dis.x=(this.width - 8 - dis.width) / 2;
			}
			if (_ifMove)
			{
				_content.addEventListener(MouseEvent.MOUSE_DOWN, mouse_mouseDown);
				_content.addEventListener(MouseEvent.MOUSE_UP, mouse_mouseUp);
			}

			// _content.addEventListener(MouseEvent.MOUSE_OUT,mouse_mouseUp);
			this._content.addChild(dis);
		}
        public function removeChilds():void{
          while(this._content.numChildren>0){
		  	this._content.removeChildAt(0);
		  }
        }
		private function mouse_mouseDown(e:MouseEvent):void
		{
			if(!ifMoveRight){
				this._content.startDrag(false, new Rectangle(0, 0, 0, -10000));
			}else{
				this._content.startDrag();
			}
			
		}

		private function mouse_mouseUp(e:MouseEvent):void
		{
			this._content.stopDrag();
		}

		/**
		*
		* ，清理背景
		*/
		public function drawBground():void
		{

			this.graphics.clear();
		}

	}
}
