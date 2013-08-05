package com.careland.tuio {
	import caurina.transitions.Tweener;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;

    public class TUIOSwipeY extends TUIOSwipe {

        private var clickgrabber:Shape;
        public var photoLoader:Loader = null;
        private var border:Shape;
        private var velX:Number = 0;
        private var velY:Number = 0;
        private var velAng:Number = 0;
        public var friction:Number = 0.92;
        public var angFriction:Number = 0.9;
        private var border_size:Number = 10;
        public var left:Number = 0;
        public var right:Number = 60000;
        public var top:Number = 0;
        public var bottom:Number = 200;
        public var noTweener:Boolean = false;
        public var iniSize:Number = 200;
        public var ScreenX:Number = 1200;
        public var ScreenY:Number = 200;

        public function TUIOSwipeY(){
          
            super();
            super.vh="v";
            this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
        }
      
      
        override public function released(dx:Number, dy:Number, dang:Number){
            //velX = (dx * 2);
            velY = (dy * 2);
            velAng = (dang / 2);
        }
        private function slide(e:Event):void{
            if (this.state == "none"){
              
                if (Math.abs(velY) < 0.001){
                    velY = 0;
                } else {
                    y = (y + velY);
                    velY = (velY * friction);
                };
              
                if ((((((((right == 0)) && ((left == 0)))) && ((bottom == 0)))) && ((top == 0)))){
                    return;
                };
               if(this.y>this.bottom){
               		this.y=bottom;
               		velY = (velY * -1);
               }
               if(this.y<this.top){
               		this.y=top;
               		velY = (velY * -1);
               }
          
            };
        }

    }
}//package app 