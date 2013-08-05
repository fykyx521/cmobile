package com.identity
{
	import br.com.stimuli.loading.BulkLoader;
	
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.radar.CLDRadar;
	import com.careland.component.util.Style;
	import com.careland.event.CLDSwfEvent;
	import com.careland.event.ImgEvent;
	import com.identity.list.CLDListWrapper;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class CLDFirstBground extends CLDBaseComponent
	{
		public function CLDFirstBground(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);

		}
		private var flashPath:String="assets/full.swf";
		private var loader:Loader;
		private var request:URLRequest;
		private var urlLoader:URLLoader;
		private var content:MovieClip;
		private var parm:String;
		private var xml:XML;
		private var list0:CLDListWrapper;
		private var list1:CLDListWrapper;
		private var urlList:Array=[];
		private var isTrue:Boolean;
		private var url:String;
		private var bulkLoader:BulkLoader;
       	private var center:Point=new Point(114.1958304, 22.6566039);
       	private var po:Point;
       	private var poi:String;
       	private var isClick:Boolean=false;
       	private var sprite:Sprite=new Sprite();
       	private var type:int;
        private var points:Sprite;
        private var overText:TextField;
		protected override function addChildren():void
		{
		    bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}	
			 
		 
			//loadFlash();
		   setRandar();	
		   points=new Sprite();
		    this.addChild(points);	
		   sprite=new Sprite();
			this.addChild(sprite);
			overText=new TextField();
    		sprite.addChild(overText);
		}
      
		override public function draw():void
		{

		}

		private function loadFlash():void
		{
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error);
			request=new URLRequest(flashPath);
			loader.load(request);
		}

		private function complete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, error);
			loader=Loader(e.target.loader);
			content=e.target.content;
			//this.addChild(content);
			var obj:Object=new Object;
			obj.contenturl=this.config.contenturl;
			obj.idList=["1429", "1428","1429"];
			obj.contentID="645";
			
			obj.textList=[" 日 期 ", "赛事项目", "清除点"];
			Object(this.content).init(obj);
			
			//this.setChildIndex(content,0);
			
			
			content.addEventListener("pointClick",swfPointClick);
			// var event:CLDSwfEvent=new CLDSwfEvent();
			//content.addEventListener("flashClick", flashClick);
		}
		private function swfPointClick(e:CLDSwfEvent):void
		{
			this.dispatchEvent(e.clone());
		}
		
		private function onComplete(e:Event):void{
		
		
		}

		
		override public function set data(value:*):void
		{
			super.data=value;
			this.loadComplete(data);
		}

		private function loadComplete(data:Object):void
		{
			this.xml=XML(data);
			for (var i:int=0; i < xml.data.length(); i++)
			{			 
				 po=new Point(xml.data[i].@经度, xml.data[i].@纬度);
				 var url:String=getURL(xml.data[i].@标注图片);
				 if("zxzd"!=url)
				 {
					 break;
				 }
				 var obj:CLDOjbect=new CLDOjbect();
                 var  bit:Bitmap=new Bitmap();
                     
                      bit.bitmapData=getBitmap(url).bitmapData;   
                      obj.addChild(bit);  
                      obj.data=xml.data[i];
                      obj.mouseOverData= xml.data[i].@鼠标经过数据;  
                      obj.mouseClickData= xml.data[i].@视图ID; 
                      obj.title=xml.data[i].@集合名称;             
                      obj.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
                      obj.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
                      obj.addEventListener(MouseEvent.CLICK,mouseClick);
                      obj.x=Math.round(1920 / 2 + (po.x - center.x) / 0.000713838288433438)-130;
                      obj.y=Math.round(1080 / 2 - (po.y - center.y) / 0.000713838288433438)-40;
                      points.addChild(obj);
			}


		}
		private function mouseOut(e:Event):void{
			if(sprite!=null){
				   sprite.visible=false;
			}		
		}
		private function mouseClick(e:Event):void{
		   var point:CLDOjbect=e.currentTarget as CLDOjbect;
		   var event:CLDSwfEvent=new CLDSwfEvent(CLDSwfEvent.pointClick);
			event.id=point.mouseClickData;
			event.obj=point.data;
			event.eventType="1";
			this.dispatchEvent(event);
		}		 
		private function mouse_over(e:MouseEvent):void
		{
			var obj:Object=e.currentTarget as Object;
			sprite.alpha=.9;
			 
			if(obj.mouseOverData==null){
			 obj.mouseOverData="";
			}
			sprite.visible=true;
			overText.text=obj.mouseOverData.split("<br>").join("\n");
			overText.x=e.stageX + 20;
			overText.y=e.stageY + 20;			 
			overText.setTextFormat(Style.getTFTXT());
			overText.width=overText.textWidth+10;
			overText.height=overText.textHeight+10;
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xFFFFFF, 1);
			sprite.graphics.drawRect(overText.x, overText.y, overText.width, overText.height);
			sprite.graphics.endFill();			 
			this.setChildIndex(sprite, this.numChildren - 1);

		}
        public function getBitmap(key:*):Bitmap
		{
			return this.bulkLoader.getBitmap(key, false);
		}
		private function getURL(_name:String):String
		{
			var url:String="zxzd";
			switch (_name)
			{
				case "zxzd":
					url="zxzd";
					break;
				case "dyzx":
					url="dyzx";
					break;
				case "szw":
					url="szw";
					break;
				case "sjzc":
					url="sjzc";
					break;
			}
			return url;
		}

		//判断重复加载
		private function Check(_url:String):Boolean
		{
			isTrue=true;
			for (var i:int=0; i < urlList.length; i++)
			{
				if (urlList[i] == _url)
				{
					isTrue=false;
				}
			}
			return isTrue;
		}

		override public function set width(value:Number):void
		{

		}

		override public function set height(h:Number):void
		{

		}

		private function error(e:Event):void
		{

		}
		
		 /**
		 * 添加雷达图
		 */ 
         private function  setRandar():void{
            

               var  radar:CLDRadar=new CLDRadar(null,0,0,false,30);   
			    radar.isFirstPage=true;
                radar.contentID=config.getProperties("radarID");
                radar.autoLoad=true;  
                radar.x=1370;
                radar.y=150;
                radar.setSize(500,500);
                this.addChild(radar);

         
         }
	}
}