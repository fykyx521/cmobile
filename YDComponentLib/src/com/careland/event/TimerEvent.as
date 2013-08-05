package com.careland.event
{
    import flash.events.Event;
    import flash.geom.Point;
    
   
	public class TimerEvent extends Event
	{		
        public var millisecond:int;
        public static var timerEvent:String="cld_Timer_event";

        public var ratio:Number;   

     	public var id:int;
     	
     	public var point:Point;//根据radio 计算出的坐标
     	
     	public var points:Array;//坐标


		public function TimerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			 super(type, bubbles, cancelable);

		}		

		
		override  public function clone():Event
		{
			var te:TimerEvent=new TimerEvent(TimerEvent.timerEvent);
			te.point=this.point;
			te.ratio=ratio;
			te.id=id;
			te.points=points;
			return te;
		}
		

	}
}