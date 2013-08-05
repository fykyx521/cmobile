package  com.identity.SingleNode
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	public class SingleNode extends AbstractSZYD
	{
		public static var Sheight:int=110;
		private var _textField:TextField;
		public var url:String="";
		public var id:String="";
		private var _text:String;
		
		[Embed(source='assets/close.gif')]
		private var closeCls:Class;
		private var closeSprite:Sprite;
		
		[Embed(source='assets/vvvvv.png')]
		private var border:Class;
		public function set text(v:String):void{
			
			this._text=v;
			initTooTip();
			
		}
		public function showClose():void{
			var bit:Bitmap=new closeCls as Bitmap; 
			var btn:BitmapButton=new BitmapButton(bit,bit,bit);
			btn.x=60;
			this.addChild(btn); 
			btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		public function onClick(e:MouseEvent):void
		{
			ExternalInterface.call("closeFlash");
			
		}
		
		
		public function  get text():String{
			return this._text;
		}
		public function SingleNode(str:String="assets/node.gif")
		{
			super(); 
			initBorder();
			loadImgV(str);
		}
		private function loadImgV(v:String):void{
			loadImg(v,onLoadImg); 
		}
		
		public function initBorder():void
		{
			var bit:Bitmap=new border as Bitmap;
			this.addChild(bit);
		}
		private function onLoadImg(e:Event):void
		{
			var bit:Bitmap=e.target.content as Bitmap;
			bit.x=0;
			bit.y=0; 
			this.addChild(bit);	
		}
		private function init():void
		{
			//画4边 
			var g:Graphics=this.graphics; 
			g.lineStyle(1,000099,0.8);
			g.drawRect(0,0,60,70);
			g.endFill();
			
		    g.beginFill(0x00ffff,0.2);
			g.drawRect(2,2,56,66);
			g.endFill();
		}  
		private function init3():void
		{
			var g:Graphics=this.graphics;
			//g.lineGradientStyle("radial",[0x723913],[1],[90]);
			g.lineStyle(1,000099,0.5);
			g.moveTo(0,70); 
			g.lineTo(30,100);
			g.lineTo(60,70);
			g.endFill();
		}
		
		private function initTooTip():void{
			this._textField=new TextField();
			_textField.selectable=false;
			_textField.text=this._text;
			_textField.wordWrap=true;
			_textField.x=0;
			_textField.y=57;
			_textField.width=140;
			this.addChild(_textField);
			
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRoundRect(0,57,140,40,1);
			this.graphics.endFill();		
		}
		
		 
		
		
		
	}
}