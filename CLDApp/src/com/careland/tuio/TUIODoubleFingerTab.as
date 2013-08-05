package com.careland.tuio
{
	import flash.display.Sprite;

	public class TUIODoubleFingerTab extends Sprite
	{
		public function TUIODoubleFingerTab()
		{
			super();
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
					
					var tuioobj:TUIOObject = TUIO.getObjectById(id);					
					if (tuioobj)
					{						
						var distance:Number=((tuioobj.oldX-tuioobj.x)*(tuioobj.oldX-tuioobj.x))+((tuioobj.oldY-tuioobj.y)*(tuioobj.oldY-tuioobj.y));
						if (distance < clickRadius*clickRadius)
						{
							var localPoint:Point = this.parent.globalToLocal(new Point(x, y));							
							this.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_CLICK,true,false,tuioobj.x,tuioobj.y,localPoint.x, localPoint.y, 0, 0,this,false,false,false,true,0,tuioobj.TUIOClass,tuioobj.ID,tuioobj.sID,tuioobj.angle));
						}// localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));						
					}
					
					//end dispatch Click Event-------------------------------------------------------------------
					blobs.splice(i, 1);
					
					
					
				}
			}			
		}
		public function downEvent(e:TUIOEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			addBlob(e.ID, curPt.x, curPt.y);
			//this.addBlob(e.ID,e.localX,e.localY);
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent):void
		{		
							
			//if (var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);)
			if (!parent) return;
			removeBlob(e.ID);		
			
			e.stopPropagation();				
				
		}		
		
	}
}