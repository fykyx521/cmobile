package com.careland.component.render
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.scrollbar.classes.CLDScrollEvent;
	import com.careland.component.scrollbar.classes.CLDSlider;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CLDScrollBar extends CLDBaseComponent implements IMutiLineTextRender
	{
		public function CLDScrollBar()
		{
			
		}
		[Embed(source="assets/滑块组/滑块上 经过.png")]
		private var upCls:Class;
		[Embed(source="assets/滑块组/滑块上 点击.png")]
		private var upClickCls:Class;
		
		[Embed(source="assets/滑块组/滑块下 经过.png")]
		private var downCls:Class;
		[Embed(source="assets/滑块组/滑块下 点击.png")]
		private var upDownCls:Class;
		
		private var upsp:Sprite;
		private var upclicksp:Sprite;
		private var downsp:Sprite;
		private var downclicksp:Sprite;
		
		
		private var splide:CLDSlider;
		public function set position(value:Point):void
		{
			this.x=value.x;
			this.y=value.y;
			
		}
		
		private var up:Sprite;
		private var down:Sprite;
		override protected function addChildren():void
		{
			up=new Sprite;
			this.addChild(up);
			
			down=new Sprite;
			this.addChild(down);
			
			splide=new CLDSlider;
			this.addChild(splide);
			
			splide.addEventListener(MouseEvent.MOUSE_DOWN,sliderDown);
			
			upsp=new Sprite();
			upsp.addChild(new upCls as Bitmap);
			up.addChild(upsp);
			upsp.buttonMode=true;
//			upsp.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			upsp.addEventListener(MouseEvent.CLICK,upclick);
			upclicksp=new Sprite();
			upclicksp.addChild(new upClickCls as Bitmap);
			up.addChild(upclicksp);
			upclicksp.visible=false;
			
			
			downsp=new Sprite();
			downsp.addChild(new downCls as Bitmap);
			downsp.buttonMode=true;
			down.addChild(downsp);
			
			downclicksp=new Sprite();
			downclicksp.addChild(new upDownCls as Bitmap);
			down.addChild(downclicksp);
			downclicksp.visible=false;
			down.addEventListener(MouseEvent.CLICK,downclick);
//			down.addEventListener(MouseEvent.MOUSE_DOWN,downSpHandler);
		}
		
		public var maxValue:int=10;
		public var pageSize:int=10;
		
		private function sliderDown(e:MouseEvent):void
		{
			splide.startDrag(false,new Rectangle(8, 35, 0,this.height-60-5*2-splide.height));
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUp);
		}
		private function stageUp(e:MouseEvent):void
		{
				scrollEvt();
		}
		
		
		public function upclick(e:MouseEvent):void
		{
			this.splide.y-=140;//35;
			if(this.splide.y<=35)
			{
				this.splide.y=35;
			}
			scrollEvt();
		}
		public function downclick(e:MouseEvent):void
		{
			this.splide.y+=140;//35;
			if(this.splide.y>=this.height-30-splide.height)
			{
				this.splide.y=this.height-30-splide.height;
			}
			scrollEvt();
		}
		
		public function scrollEvt():void
		{
			var scr:CLDScrollEvent=new CLDScrollEvent(CLDScrollEvent.SCROLL);
			splide.stopDrag();
			var value:Number=(this.splide.y-35)/(this.height-35*2-this.splide.height)*100;
			value=(this.maxValue-this.pageSize)*value/100;
			scr.value=-value;
			this.dispatchEvent(scr);
		}
		
		private function downHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			upsp.visible=false;
			this.upclicksp.visible=true;
		}
		
		private function upHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			upsp.visible=true;
			this.upclicksp.visible=false;
			this.splide.y--;//35;
			if(this.splide.y<=35)
			{
				this.splide.y=35;
			}
			scrollEvt();
			
		}
		
		private function downSpHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP,bottomUpHandler);
			downsp.visible=false;
			this.downclicksp.visible=true;
		}
		
		private function bottomUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,bottomUpHandler);
			downsp.visible=true;
			this.downclicksp.visible=false;
			this.splide.y++;//35;
			if(this.splide.y>=this.height-60-5*2-splide.height)
			{
				this.splide.y=this.height-60-5*2-splide.height;
			}
			scrollEvt();
		}
		
		public function reflush():void
		{
			this.invalidate();
		}
		
		
		
		override public function draw():void
		{
			 this.splide.height=Math.round((this.height-35*2)/ (this.maxValue)*this.height-35*2);
			 if(this.splide.height>this.height-35*2||maxValue<=this.pageSize)
			 {
				 this.splide.height=this.height-35*2;
			 }
			 
			 this.splide.y=35;
			 splide.x=8;
			 this.down.y=this.height-30;
			
		}
	}
}