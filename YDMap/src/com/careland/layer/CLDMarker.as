package com.careland.layer
{
	import com.careland.util.MapConfig;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.bytearray.gif.player.GIFPlayer;

	public class CLDMarker extends CLDBaseMarker
	{
		
		
		public function CLDMarker()
		{
			super();
			this.removeEventListener("rightClick",this.rightClick);
		
		}
		private var gif:GIFPlayer;
		
		private var imgLoader:Loader;
		
		public var img:String="assets/images/alarm/bg.png";
		
		
		
//		override public function get src():String
//		{
//			return this._src;
//		}
//		
		override public function dispose():void
		{
			if(gif){
				gif.dispose();
				gif=null;
			}
			if(this.imgLoader){
				this.imgLoader.unload();
				imgLoader=null;
			}
		}
		
		override public function draw():void
		{
			
			if(this.isInit)return;
			switch(this.pointType){
				case "image":this.addChildren();break;
				case "text":this.addText();break;
				case "point":this.addPoint();break;
				default :this.addChildren();
			}
			
		}
		public function change(center:Point,vscale:Number,vw:Number,vh:Number,gl:Point,mapConfig:MapConfig):void
		{

//			var np:Point=Object(parent).getScreenPoint(cldPoint,center,vscale,vw,vh,mapConfig);
			//触控
			
			var np:Point=getScreenPoint(cldPoint,center,vscale,vw,vh,gl,mapConfig);
			//web
			//var np:Point=Object(parent).getScreenPoint(cldPoint,center,vscale,vw,vh);
			//var np:Point=getScreenPoint(cldPoint,center,vscale,vw,vh,gl);

			this.x=np.x;
			this.y=np.y;
			trace(cldPoint.x+":"+cldPoint.y);
			//this.screenPoint=this.getScreenPoint(this.lp,center,vscale,vw,vh);

			//this.invalidate();
		}
		public function addPoint():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.lineStyle(1,0x333fff,.5);
			g.beginFill(0xfff333,.5);
			g.drawCircle(0,0,10);
			g.endFill();
			
		}
		private function ioError(e:IOErrorEvent):void
		{
			trace("marker:"+e.text);
		}
		public function addChildren():void
		{
			
			
			var request:URLRequest = new URLRequest(this.src);
			if(src.indexOf(".gif")!=-1){
				gif=new GIFPlayer();
				
				gif.load(request);
				
				this.addChild(gif);
				gif.x=this.offx;
				gif.y=this.offy;
				gif.addEventListener("rightClick",rightClick);
			}else{
			    imgLoader=new Loader();
				//this.addChild(imgLoader);
				imgLoader.x=this.offx;
				imgLoader.y=this.offy; 
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
				imgLoader.load(request);
			}
			this.isInit=true;

		}
		
		private function complete(e:Event):void
		{
			var w:Number=e.target.content.width;
			var h:Number=e.target.content.height;
			var dis:DisplayObject=e.target.content as DisplayObject;
			this.addChild(e.target.content);
			if(this.offx==0)
			{
				offx=-w/2;
			}
			if(this.offy==0)
			{
				offy=-h/2;
			}
			dis.x=this.offx;
			dis.y=this.offy; 
			dis.addEventListener("rightClick",rightClick);
		}
		override protected function rightClick(e:Event):void
		{
			super.rightClick(e);
		}
		
		 
		
		public function addText():void
		{
			var txt:TextField=new TextField();
			txt.text=this.text;
			txt.selectable=false;
			txt.wordWrap=false;
			txt.multiline=false;
			txt.embedFonts=false;
			var tf:TextFormat=new TextFormat();
			tf.size=12;
			tf.color="red";
			txt.defaultTextFormat=tf;
			this.addChild(txt);
		}
		
		
	}
}