package com.identity.imgmap
{
	import com.careland.component.util.Style;
	import com.careland.layer.CLDMarker;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class CLDImgMapMarker extends CLDMarker
	{
		private var txt:TextField;
		
		public var showName:String="";
		
//		private var sprite:Sprite;
		public function CLDImgMapMarker()
		{
			super();
			//this.addEventListener("rightClick",imgRightClick);
		}
//		//覆盖默认的处理函数
//		override protected function rightClick(e:Event):void
//		{
//			
//		}
//		private function imgRightClick(e:Event):void
//		{
//			super.rightClick(e);
//		}
		override public function addChildren():void
		{
			super.addChildren();
			txt=new TextField;
			txt.selectable=false;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.embedFonts=true;
			this.addChild(txt);
			
//			sprite=new Sprite;
//			this.addChild(sprite);
			
		}
		
		override public function draw():void
		{
			super.draw();
			if(showName!=""&&txt){
				txt.text=showName;
				txt.x=20;
				txt.setTextFormat(Style.getWF());
				txt.height=this.txt.textHeight;
			//	txt.width=this.txt.textWidth;
//				var g:Graphics=this.sprite.graphics;
//				g.clear();
//				g.lineStyle(2,0xfff2233);
//				g.beginFill(0x112223,1);
//				var rect:Rectangle=this.getRect(txt);
//				g.drawRect(rect.x,rect.y,rect.width,rect.height);
//				g.endFill();
			}
			
		}
		override public function dispose():void
		{
			super.dispose();
			txt=null;
			showName=undefined;
		}
		
		
		
	}
}