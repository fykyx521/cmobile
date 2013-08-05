package com.careland
{
	import com.careland.util.CLDConfig;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class CLDTouch2MapContainer extends CLDMapContainer
	{
		
		private var blobs:Array=[];
		private var state:String="none";
		private var blob1:Object;
		private var blob2:Object;
		public function CLDTouch2MapContainer(config:CLDConfig, center:Point, vzoom:int)
		{
			super(config, center, vzoom);
		}
		override protected function addChildren():void
		{
			super.addChildren();
			this.addEventListener(TUIOEvent.TUIO_DOWN, downEvent);
			this.addEventListener(TUIOEvent.TUIO_UP, touchUp);
		}
		public function downEvent(e:TUIOEvent):void
		{
			if (e.stageX == 0 && e.stageY == 0)
				return;
			this.prePoint=new Point(e.stageX,e.stageY);
			
			var curPt:Point=parent.globalToLocal(new Point(e.stageX, e.stageY));
			addBlob(e.ID, curPt.x, curPt.y);
			e.stopPropagation();
		}
		public function touchUp(e:TUIOEvent):void
		{
			removeBlob(e.ID);
			e.stopPropagation();
		}
		private function addBlob(id:Number, origX:Number, origY:Number):void
		{
			//防止重复添加
			for (var i=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
					return;
			}
			//添加一个触点到队列		
			blobs.push({id: id, origX: origX, origY: origY, myOrigX: x, myOrigY: y});
			if(blobs.length == 1)
			{				
				state = "dragging";		
				
				this.addEventListener(Event.ENTER_FRAME,update);
				
			} 
			if (blobs.length == 2)
			{
				state="rotatescale";

				blob1=blobs[0];
				blob2=blobs[1];
				

			}
		}
		private function removeBlob(id:Number):void
		{
			for (var i:Number=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
				{

					blobs.splice(i, 1);
					if(blobs.length==0){
						state = "none";
						this.removeEventListener(Event.ENTER_FRAME,update);
					}
					if(blobs.length == 1)  
					{
						state = "dragging";		
						
						var tuioobj1:TUIOObject = TUIO.getObjectById(blob1.id);						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1:Point = this.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
					}
					if (blobs.length == 2)
					{
						state="rotatescale";
						if (blob1.id != id && blob2.id != id)
							return;

						if (blob1.id == blobs[0].id)
						{
							blob2=blobs[1];
						}
						else
						{
							blob2=blobs[0];
							blob1=blobs[1];
						}
						
					}


				}

			}
			
	
				
			}
			private function update(e:Event):void
			{
//				if(state=="dragging"){
//					dragHandler();
//				}else if(state=="maxmin"){
//					updatewin();
//				}else{
//			
//				}
			}
		
	}
}