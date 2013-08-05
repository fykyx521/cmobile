package com.identity.radar
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.*;

	public class CLDPoint extends CLDBaseComponent
	{
		public var angle:int;
		public var angle2:Number=0;
		private var filter:GlowFilter
		private var sprite:Sprite;
		private var scale:Number=1;
		public var flashing:Boolean=false;
        public var font:int=0x00CCFF;
        public var quadrant:int;//象限
        public var layer:int;//层
        private var color:int;
        public var mouseClickData:String;
        private var radios:Number;
        private var ifFilter:Boolean=true;
         override public function dispose():void
		 {
		 	 super.dispose();
		 	 this.removeEventListener(Event.ENTER_FRAME,update);
		 	 this.sprite=null;
		 	 this.angle=null;
		 	 this.angle2=null;
		 	 this.filter=null;
		 	 this.scale=null;
		 	 this.ifFilter=null;
		 	 this.radios=null;
		 	 this.mouseClickData=null;
		 	 this.color=null;
		 	 this.layer=null;
		 	 this.quadrant=null;
		 	 this.font=null;
		 	 this.flashing=null;
		 	 
		 }
		public function CLDPoint(_scale:Number,_color:int,_radio:Number,_ifFiter:Boolean)
		{
			this.scale=_scale;
			this.color=_color;
			this.radios=_radio;
			this.ifFilter=_ifFiter;
			
		}

		override protected function addChildren():void
		{
			if(ifFilter){
				filter=new GlowFilter(0xFFFF00, 1);
			    this.filters=[filter];
			    this.addEventListener(Event.ENTER_FRAME, update);
			}		
		}

		private function update(e:Event):void
		{
			if (sprite != null)
			{
				filter.inner=true;
				if (flashing)
				{
					if (sprite.visible)
					{
						sprite.visible=false;
					}
					else
					{
						sprite.visible=true;
					}
				}else{
				     sprite.visible=true;
				}
			}

		}
		override public function draw():void
		{
			sprite=new Sprite();
			sprite.graphics.beginFill(color, 1);
			sprite.graphics.drawCircle(-5, 0, radios);
			sprite.graphics.endFill();
			this.addChild(sprite);
		}

	}
}