package com.careland.gesture
{
	import com.careland.gesevents.CLDTwoFingerEvent;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class CLDDoubleFingerTab extends Sprite
	{
		protected var blobs:Array;
		private var clickRadius:Number = 30;
		private var state:String="none";
		public function CLDDoubleFingerTab()
		{
			super();
			blobs = new Array();
					
			this.addEventListener(TUIOEvent.TUIO_DOWN, downEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);	
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		
		public function dispose():void
		{
			this.removeEventListener(TUIOEvent.TUIO_DOWN, downEvent);						
			this.removeEventListener(TUIOEvent.TUIO_UP, upEvent);	
			this.removeEventListener(Event.ENTER_FRAME,update);
			
		}
		
		private function update(e:Event):void
		{
			if(state=="zoom")
			{
				var tuioobj1:TUIOObject=TUIO.getObjectById(blobs[0].id);
				var tuioobj2:TUIOObject=TUIO.getObjectById(blobs[1].id);
				// if not found, then it must have died..
				if (!tuioobj1)
				{
					removeBlob(blobs[0].id);
					return;
				}
				// if not found, then it must have died..
				if (!tuioobj2)
				{
					removeBlob(blobs[1].id);
					return;
				}
				
				var newXy1:Point=new Point(tuioobj1.x,tuioobj1.y);
				var newXy2:Point=new Point(tuioobj2.x,tuioobj2.y);
				
				var dis:Point=newXy2.subtract(newXy1);
				
				
				var newXy3:Point=new Point(blobs[0].origX,blobs[1].origY);
				var newXy4:Point=new Point(blobs[1].origX,blobs[1].origY);
				
				var dis2:Point=newXy4.subtract(newXy3);
				
				var length:Number=Math.abs(dis.length)-Math.abs(dis2.length);
				if(length>50){
					this.state="none";
					this.blobs.splice(0,blobs.length);
					var evt:CLDTwoFingerEvent=new CLDTwoFingerEvent(CLDTwoFingerEvent.CLD_TWO_FINGER_TAB,true,true);						
					this.dispatchEvent(evt);
					
				}
				
			}
		}
		
		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			//防止重复添加
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}	
			//添加一个触点到队列		
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
			if(this.blobs.length==0){
				this.state="none";
			}
			if(this.blobs.length==1){
				this.state="none";
			}	
			if(this.blobs.length==2){
				this.state="zoom";
			}		
		}
		/*
		----------------从队列去掉一个触点--------------------------------------------
		*/
		private function removeBlob(id:Number):void
		{
			for(var i:Number=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					//-----dispatch Click Event----------------
					blobs.splice(i, 1);	
					var tuioobj:TUIOObject = TUIO.getObjectById(id);					
					if (tuioobj)
					{			
								
						var distance:Number=((tuioobj.oldX-tuioobj.x)*(tuioobj.oldX-tuioobj.x))+((tuioobj.oldY-tuioobj.y)*(tuioobj.oldY-tuioobj.y));
						if (distance < clickRadius*clickRadius)
						{
							if(blobs.length>=1){
//								var localPoint:Point = this.parent.globalToLocal(new Point(x, y));	
//								var evt:CLDTwoFingerEvent=new CLDTwoFingerEvent(CLDTwoFingerEvent.CLD_TWO_FINGER_TAB,true,true);						
//								evt.localX=localPoint.x;
//								evt.localY=localPoint.y;
//								evt.stageX=tuioobj.x;
//								evt.stageY=tuioobj.y;
//								this.dispatchEvent(evt);
								//this.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_CLICK,true,false,tuioobj.x,tuioobj.y,localPoint.x, localPoint.y, 0, 0,this,false,false,false,true,0,tuioobj.TUIOClass,tuioobj.ID,tuioobj.sID,tuioobj.angle));
							}
							
						}// localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));						
					}
					//end dispatch Click Event-------------------------------------------------------------------
					
					
					
					
				}
			}	
			if(this.blobs.length==0){
				this.state="none";
			}
			if(this.blobs.length==1){
				this.state="none";
			}	
			if(this.blobs.length==2){
				this.state="zoom";
			}				
		}
		public function downEvent(e:TUIOEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			addBlob(e.ID, curPt.x, curPt.y);
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent):void
		{		
			if (!parent) return;
			removeBlob(e.ID);		
			e.stopPropagation();					
		}		
		public function clone():Sprite
		{
			return null;
		}
		
	}
}