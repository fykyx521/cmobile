package com.careland.component.touch
{
	import com.careland.component.TUIOTouchObj;
	
	import flash.events.Event;

	public class TouchBase extends TUIOTouchObj
	{
		 
       
      
        private var velX:Number = 0;
        private var velY:Number = 0;
        private var velAng:Number = 0;
        public var friction:Number = 0.92;
        public var angFriction:Number = 0.9;
        private var border_size:Number = 10;
        public var left:Number = 0;
        public var right:Number = 1300;
        public var top:Number = 0;
        public var bottom:Number = 700;
        public var noTweener:Boolean = false;
        public var iniSize:Number = 200;
        public var ScreenX:Number = 0x0400;
        public var ScreenY:Number = 0x0300;

        public function TouchBase(){
          
            super();
            this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
        }
      
      
        override public function released(dx:Number, dy:Number, dang:Number){
//            velX = (dx * 2);
//            velY = (dy * 2);
//            velAng = (dang / 2);
        }
        private function slide(e:Event):void{
        	
            if (this.state == "none"){
                if (Math.abs(velX) < 0.001){
                    velX = 0;
                } else {
                    x = (x + velX);
                    velX = (velX * friction);
                };
                if (Math.abs(velY) < 0.001){
                    velY = 0;
                } else {
                    y = (y + velY);
                    velY = (velY * friction);
                };
                if (Math.abs(velAng) < 0.001){
                    velAng = 0;
                } else {
                    velAng = (velAng * angFriction);
                    this.rotation = (this.rotation + velAng);
                };
                if ((((((((right == 0)) && ((left == 0)))) && ((bottom == 0)))) && ((top == 0)))){
                    return;
                };
                if (this.x > right){
                    this.x = right;
                    velX = (velX * -1);
                };
                if (this.x < left){
                    this.x = left;
                    velX = (velX * -1);
                };
                if (this.y > bottom){
                    this.y = bottom;
                    velY = (velY * -1);
                };
                if (this.y < top){
                    this.y = top;
                    velY = (velY * -1);
                };
            };
        }

    
		
	}
}