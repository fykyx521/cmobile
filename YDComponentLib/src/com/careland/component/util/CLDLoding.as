package com.careland.component.util
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.IDisponse;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Graphics;
	import flash.net.URLRequest;
	
	import org.bytearray.gif.player.GIFPlayer;

	public class CLDLoding extends CLDBaseComponent implements IDisponse
	{
		private var gif:GIFPlayer;
		public function CLDLoding()
		{
			super();
			
			
		}
		
		override protected function addChildren():void
		{
			gif=new GIFPlayer();
			var urlRequest:URLRequest=new URLRequest("assets/done.gif");
			this.addChild(gif);
			gif.load(urlRequest);
			
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
		}
		private function downHandler(e:TUIOEvent):void
		{
			e.stopPropagation();	//阻止事件点击
		}
		override public function dispose():void
		{
			super.dispose();
			if(gif){
				gif.dispose();
			}
			gif=null;
			
		}
		
		override public function draw():void
		{
			if(width>0&&this.gif){
				var g:Graphics=this.graphics;
				g.clear();
				g.beginFill(0x003322,.1);
				g.drawRect(0,0,this.width,this.height);
				g.endFill();
				
				gif.x=(this.width-gif.width)/2
				gif.y=(this.height-gif.height)/2;
			}
			
		}
		
		
	}
}