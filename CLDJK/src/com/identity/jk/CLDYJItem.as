package com.identity.jk
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDInfo;
	import com.careland.events.CLDInfoEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDYJItem extends CLDBaseComponent
	{
		
		[Embed(source="assets/文字框/文字框展开.png")]
		private var zhankai:Class;
		[Embed(source="assets/文字框/文字框关闭.png")]
		private var guanbi:Class;
		public function CLDYJItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			//this.addEventListener(MouseEvent.ROLL_OVER,overHandler);
		}
		
		
		public var columnRealWidth:Array;
		
		public var truncateIndex:int;
		
		public var gap:Number=5;
		
		private var zkgb:Sprite;
		
		//private var info:CLDInfo;
		
		public var infoGap:int=52;
		
		public var lineHeight:int;
		
		private function clickHandler(e:MouseEvent):void
		{
			 if(this.zkbit.visible)
			 {
				this.show();
//				 if(info&&parent.parent.parent.contains(info))
//				 {
//					 parent.parent.parent.removeChild(info);
//					 info=null;
//				 }
//				 info=new CLDInfo();
//				 parent.parent.parent.addChild(info);
				 var info:CLDInfoEvent=new CLDInfoEvent(CLDInfoEvent.INFO,true,false);
				 info.targetObj=this;
				 var lp:Point=parent.localToGlobal(new Point(this.x,this.y));
				 info.width=columnRealWidth[truncateIndex]-50;
				 info.data=data.items[this.truncateIndex];
				 info.x=data.position[this.truncateIndex]+infoGap;
				 info.y=lp.y;
				 this.dispatchEvent(info);
				 
				 
				 //stage.setChildIndex(info,parent.numChildren-1);
			 }else
			 {
				 var info:CLDInfoEvent=new CLDInfoEvent(CLDInfoEvent.INFO,true,false);
				 info.isShow=false;
				 this.dispatchEvent(info);
				 
				 this.hide();
			 }
			 
		}
		
		public function show():void
		{
			this.gbbit.visible=true;
			this.zkbit.visible=false;
		}
		public function hide():void
		{
			this.gbbit.visible=false;
			this.zkbit.visible=true;
		}
		
		private var isOver:Boolean=false;
		private function overHandler(e:MouseEvent):void
		{
			 this.addEventListener(MouseEvent.ROLL_OUT,outHandler);
			 isOver=true;
			 this.draw();
		}
		private function outHandler(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			isOver=false;
			this.draw();
		}
		override public function draw():void
		{
			if(this.isOver)
			{
				this.graphics.clear();
				this.graphics.beginFill(0xffffff,1);
				this.graphics.drawRect(0,0,this.width-15,this.height);
				this.graphics.endFill();
			}else
			{
				this.graphics.clear();
			}
			if(data&&this.dataChange)
			{
				if(zkgb)
				{
					zkgb.removeEventListener(MouseEvent.CLICK,clickHandler);
					this.removeChild(zkgb);
					zkgb=null;
				}

				while(this.numChildren>0)
				{
					this.removeChildAt(0);
				}
				
				for(var i:int=0;i<this.data.items.length;i++)  
				{
					
					var txt:TextField=new TextField();
					txt.multiline=false;
					txt.background=false;
					txt.selectable=false;
					txt.wordWrap=false;
					txt.background=false;
					txt.defaultTextFormat=new TextFormat("msyh",30,0x01314d);
					//txt.embedFonts=true;
					
					this.addChild(txt);
					txt.x=data.position[i];
					
					var txtStr:String=data.items[i];
					
					txt.text=txtStr;
					txt.width=txt.textWidth+gap;
					var txtWidth:Number=txt.textWidth+5;
					var colWidth:Number=columnRealWidth[i];
					
					if(txt.textWidth<colWidth)
					{
						txt.x=(colWidth-txt.textWidth)/2+txt.x;
					}
					var isTran:Boolean=false;
					if(truncateIndex==i)
					{
						if(txtWidth+gap>colWidth-gap*2)
						{
							isTran=trans(txtStr,txt,colWidth-gap*2);
						}
					}
					if(isTran)
					{
						  if(!zkgb)
						  {
							   zkgb=new Sprite();
							   zkgb.addEventListener(MouseEvent.CLICK,this.clickHandler);
							   this.addChild(zkgb);
						  }
						  zkbit=new zhankai as Bitmap;
						  gbbit=new guanbi as Bitmap;
						  zkbit.x=data.position[truncateIndex]+columnRealWidth[truncateIndex]-50;
						  gbbit.x=zkbit.x;
						  zkbit.y=5;
						  gbbit.y=5;
						  zkgb.addChild(zkbit);
						  zkgb.addChild(gbbit); 
						  gbbit.visible=false;
					}
					
				}
			}
		}
		
		private var zkbit:Bitmap;
		private var gbbit:Bitmap;
		private var currentTxt:TextField;
		
		public function trans(txt:String,text:TextField,colwidth:Number):Boolean
		{
			
			  var isTran:Boolean=false;
			  text.text=txt;
			  while(text.textWidth+gap>colwidth-40)
			  {
				  if(txt.length>1)
				  {
					  txt=txt.substring(0,txt.length-1-1);
					  text.text=txt+"...";
					  isTran=true;
				  }
			  }
			  currentTxt=text;
			  return isTran;
		}
	}
}