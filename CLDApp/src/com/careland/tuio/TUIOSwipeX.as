package com.careland.tuio {
	import caurina.transitions.Tweener;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;

    public class TUIOSwipeX extends TUIOSwipe {

        private var clickgrabber:Shape;
        public var photoLoader:Loader = null;
        private var border:Shape;
        private var velX:Number = 0;
        private var velY:Number = 0;
        private var velAng:Number = 0;
        public var friction:Number = 0.92;
        public var angFriction:Number = 0.9;
        private var border_size:Number = 10;
        public var left:Number = 385;
        public var right:Number = 0;
        public var top:Number = 0;
        public var bottom:Number = 200;
        public var noTweener:Boolean = false;
        public var iniSize:Number = 200;
        public var ScreenX:Number = 1200;
        public var ScreenY:Number = 200;

		private var can:Boolean=true;
		
		private var action:String="";
        public function TUIOSwipeX(){
          
            super();
            super.vh="h";
            this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);
           // this.addEventListener(YDMenuDownEvent.YDMENU_DOWN,downHandler);
            //this.addEventListener(YDMenuDownEvent.YDMENU_UP,upHandler);
          
            
        }
        private function downHandler(e:Event):void
        {
        	
        	throw new Error;
        }
         private function upHandler(e:Event):void
        {
        	can=true;	
        }
      
      
        override public function released(dx:Number, dy:Number, dang:Number)
        {
        	if(can){
        		 velX = (dx * 2);
          //  velY = (dy * 2);
          	     velAng = (dang / 2);
        	}
        	
        	trace("released"+this.x);
           
        }
        private function tend():void
        {
        	can=true;
        	this.addEventListener(Event.ENTER_FRAME,slide);
        }
        private function slide(e:Event):void{
            if (this.state == "none"){
                if (Math.abs(velX) < 0.001){
                	
                    velX = 0;
                    
                } else {
                    x = (x + velX);
                    velX = (velX * friction);
                };
              
                if (Math.abs(velAng) < 0.001){
                    velAng = 0;
                } else {
                    velAng = (velAng * angFriction);
                    
                };
                if ((((((((right == 0)) && ((left == 0)))) && ((bottom == 0)))) && ((top == 0)))){
                    return;
                };
                if (this.x > right){
                    this.x = right;
                    this.action="right";
                    velX = (velX * -1);
                };
                if (this.x < left){
                    this.x = left;
                    this.action="left";
                    velX = (velX * -1);
                };
               
            };
        }

    }
}//package app 