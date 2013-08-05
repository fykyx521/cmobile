package com.identity.SingleNode
{
//	import com.fairycomic.FMScrollBar.FMScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GroupNode extends AbstractSZYD
	{
		
	//	private var _scrollBar:FMScrollBar;//参见:http://www.fairycomic.com/blog/post/8.html
		protected var content:Sprite;
		
		private var contentmask:Sprite;
		[Embed(source='assets/close.gif')]
		private var closeCls:Class;
		private var close:BitmapButton;
		
		private var isShowScrollBar:Boolean=false;
		public function GroupNode()
		{
			super();
			contentmask=new Sprite();
			content=new Sprite();
			draw();
			initButton();
		}
		private function initButton():void
		{
			var closeBit:Bitmap=new closeCls as Bitmap;
			close=new BitmapButton(closeBit,closeBit,closeBit);
			close.addEventListener(MouseEvent.CLICK,onClose);
			this.addChild(close);
			close.x=690; 
			close.y=10;
		}
		private function onClose(e:MouseEvent):void
		{
			this.visible=false;
		}
		public function loadURL(str:String):void
		{
			 load(str,onLoadXML);
		}
		protected  function onLoadXML(e:Event):void
		{
			var xml:XML=XML(e.target.data);
			init(xml.node);
		}
		public function init(child:XMLList):void
		{
			var step:int=child.length();
			var j:int=0;
			
			//child=child..(@type="node");
			var newXML:Array=[];
			for(var i:int=0;i<step;i++)
			{
				if(child[i].@type=="node"){
					newXML.push(child[i].@label);
						
				}
			}
			for(var z:int=0;z<newXML.length;z++){
				var single:SingleNode=new SingleNode();
					single.text=newXML[z].toString(); 
					
					single.x=64+z%3*218+56;// 64是 bg.jpg三角的长度 218 是 （720-64）/3=218每个singleNode的长度 +56是每个singleNode的间隔宽度
					single.y=j*150+20; 
					if((z+1)%3==0){ 
						j++; 
					}
				content.addChild(single);
					
			}
			
			content.y=20;
		   // _scrollBar=new ContentScrollBar(content, 0x000000, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true,710,140);
		//    _scrollBar=new FMScrollBar(content,700,20,700,140,140,15,40,0,0,0);
	//	    _scrollBar.x=690;
	//	    _scrollBar.y=25;
		    if(newXML.length>3){
		    	this.isShowScrollBar=true;
		    }
	//	    _scrollBar.visible=this.isShowScrollBar;
		//	this.addChild(_scrollBar);
			
			this.addChild(content);
			
			//content.mask=this.contentmask;
			//this.addChild(_scrollBar);
			
		}
		private function draw():void
		{
			this.loadImg("assets/bg.png",onResult);
		} 
		public function onResult(e:Event):void
		{
			var bit:Bitmap=e.target.content as Bitmap;
			bit.x=0;
			this.addChildAt(bit,0);
		} 
		public function clear():void{
			if(!content)
				return;
			while(content.numChildren>0){
				content.removeChildAt(0);
			}
		}
	}
	
}