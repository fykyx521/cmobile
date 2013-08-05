package com.touchlib {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	//import flash.utils.Timer;
	//import flash.events.MouseEvent;
	//import flash.events.Event;
	

	public class TUIOObject 
	{
		public var x:Number;
		public var y:Number;
		
		public var oldX:Number;
		public var oldY:Number;
		
		public var dX:Number;
		public var dY:Number;				
		
		public var area:Number;
		
		public var TUIOClass:String;		// cur or Obj.. 
		public var sID:int;
		public var ID:int;
		public var angle:Number;		
		public var pressure:Number;
		
		public var ObjectWidth:Number;
		public var ObjectHeight:Number;
		
		
		private var isNew:Boolean;
		public var isAlive:Boolean;		
		public var obj;
		public var spr:Sprite;
		public var trlx:Sprite;
		
		public var color:int;
		
		var aListeners:Array;

		public function TUIOObject (cls:String, id:int, px:Number, py:Number,w:Number,h:Number, dx:Number, dy:Number, sid:int = -1, ang:Number = 0, o = null):void
		{
			aListeners = new Array();
			TUIOClass = cls;
			ID = id;
			x = px;
			y = py;
			oldX = px;
			oldY = py;
			dX = dx;
			dY = dy;
			sID = sid;
			angle = ang;
			isAlive = true;
			
			ObjectWidth= w;
			ObjectHeight=h;
			/*
			if (w==0 || h==0) 
			{
				ObjectWidth=6;
				ObjectHeight=6;
			}*/
			
			var c = int(Math.random() * 4);
			
			if(c == 0)
				color = 0xff0000;
			else if(c == 1)
				color = 0x00ffff;
			else if(c == 2)
				color = 0x00ff00;				
			else if(c == 3)
				color = 0x0000ff;		
							
			if(spr==null){
				spr = new TUIOCursor(ID.toString());
			}			
			spr.x = x;
			spr.y = y;  		
			
			try {
 	 			obj = o;
			} catch (e:Error)
			{
				obj = null;
			}
			
			//trace("Start " + ID + ", " + sID + " (" + int(px) + "," + int(py) + ")");
			isNew = true;
		}
		
		public function notifyCreated():void
		{
			if(obj)
			{
				try
				{
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
					//trace("Down : " + localPoint.x + "," + localPoint.y);
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));													
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_DOWN, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));									
				} catch (e)
				{
					trace("Failed : " + e);
					obj = null;
				}
			}			
		}
		
		public function setObjOver(o:DisplayObject):void
		{
			try {				
				if(obj == null)
				{
					obj = o;				
					if(obj) 
					{
						var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
						obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));					
					}
				} else if(obj != o) 
				{
					
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));								
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OUT, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));
					if(o)
					{
						localPoint = obj.parent.globalToLocal(new Point(x, y));
						o.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OVER, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));
					}
					obj = o;								
				}
			} catch (e:Error)
			{
//				trace("ERROR " + e);
			}
		}
		
		public function addListener(reciever:Object):void
		{
			aListeners.push(reciever);
		}
		public function removeListener(reciever:Object):void
		{
			for(var i:int = 0; i<aListeners.length; i++)
			{
				if(aListeners[i] == reciever)
					aListeners.splice(i, 1);
			}
		}		
		
		public function kill():void
		{
			//trace("Die " + ID);			
			var localPoint:Point;
			//del by denghuaqin
			
			if(obj && obj.parent)
			{				
				localPoint = obj.parent.globalToLocal(new Point(x, y));	
				//if (this.oldX)	
				obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_OUT, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));				
				//莫名奇妙这两地方开始报错
				try{
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_UP, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));									
				}catch(e:Error)
				{
					trace(e.message);
				}
				
				//莫名奇妙这两地方开始报错
				if(obj.stage){
					
					try{
						obj.stage.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_UP, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));									
					}catch(e:Error)
					{
					trace(e.message);
					}
				
					
				}
			}
			
			//del by denghuaqin
			obj = null;
			
			for(var i:int=0; i<aListeners.length; i++)
			{
				trace("kill2");
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));				
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_UP, true, false, x, y, localPoint.x, localPoint.y, 0, 0, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));								
			}
		}
		
		public function notifyMoved():void
		{
			if(obj)
			{
				//oldX = px;
				//oldY = py;
				try
				{
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle,ObjectWidth,ObjectHeight));													
				} catch (e:Error)
				{
					trace("Failed : " + e);
					obj = null;
				}
			}		
			/*
			var localPoint:Point;
			for(var i:int=0; i<aListeners.length; i++)
			{
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));	
				trace("notifyMoved");				
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, 0, 0, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle));								
			}*/		
		}
	}
}