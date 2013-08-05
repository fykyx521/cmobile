package org.gestouch.input
{
	import com.touchlib.TUIOEvent;
	import org.gestouch.core.gestouch_internal;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventPhase;
	
	import org.gestouch.core.IInputAdapter;
	import org.gestouch.core.TouchesManager;


	/**
	 * TODO: You can implement your own TUIO Input Adapter (and supply touchesManager with
	 * touch info), but IMHO it is way easier to use NativeInputAdapter and any TUIO library
	 * and manually dispatch native TouchEvents using DisplayObjectContainer#getObjectsUnderPoint()
	 * 
	 * @see NativeInputAdapter
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObjectContainer.html#getObjectsUnderPoint() DisplayObjectContainer#getObjectsUnderPoint() 
	 * 
	 * @author Pavel fljot
	 */
	public class TUIOInputAdapter implements IInputAdapter
	{
		use namespace gestouch_internal;
		private var _stage:Stage;
		
		public function TUIOInputAdapter(stage:Stage)
		{
			super();
			if (!stage)
			{
				throw new ArgumentError("Stage must be not null.");
			}
			
			_stage = stage;
			
			
		}
		public function init():void
		{
			_stage.addEventListener(TUIOEvent.TUIO_DOWN, touchBeginHandler, true);
			_stage.addEventListener(TUIOEvent.TUIO_DOWN, touchBeginHandler, false);
			_stage.addEventListener(TUIOEvent.TUIO_MOVE, touchMoveHandler, true);
			_stage.addEventListener(TUIOEvent.TUIO_MOVE, touchMoveHandler, false);
			// Maximum priority to prevent event hijacking and loosing the touch
			_stage.addEventListener(TUIOEvent.TUIO_UP, touchEndHandler, true, int.MAX_VALUE);
			_stage.addEventListener(TUIOEvent.TUIO_UP, touchEndHandler, false, int.MAX_VALUE);
		}


		public function onDispose():void
		{
			
			_stage.removeEventListener(TUIOEvent.TUIO_DOWN, touchBeginHandler, true);
			_stage.removeEventListener(TUIOEvent.TUIO_DOWN, touchBeginHandler, false);
			_stage.removeEventListener(TUIOEvent.TUIO_MOVE, touchMoveHandler, true);
			_stage.removeEventListener(TUIOEvent.TUIO_MOVE, touchMoveHandler, false);
			// Maximum priority to prevent event hijacking and loosing the touch
			_stage.removeEventListener(TUIOEvent.TUIO_UP, touchEndHandler);
			_stage.removeEventListener(TUIOEvent.TUIO_UP, touchEndHandler);
		}
	   
		protected function touchBeginHandler(event:TUIOEvent):void
		{
			// We listen in EventPhase.CAPTURE_PHASE or EventPhase.AT_TARGET
			// (to catch on empty stage) phases only
			
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;
			
			_touchesManager.onTouchBegin(event.ID, event.stageX, event.stageY, event.target as InteractiveObject);
		}
		
		
		protected function touchMoveHandler(event:TUIOEvent):void
		{
			// We listen in EventPhase.CAPTURE_PHASE or EventPhase.AT_TARGET
			// (to catch on empty stage) phases only
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;
			
			_touchesManager.onTouchMove(event.ID, event.stageX, event.stageY);
		}
		
		
		protected function touchEndHandler(event:TUIOEvent):void
		{
			// We listen in EventPhase.CAPTURE_PHASE or EventPhase.AT_TARGET
			// (to catch on empty stage) phases only
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;
			
			if (event.hasOwnProperty("isTouchPointCanceled") && event["isTouchPointCanceled"])
			{
				_touchesManager.onTouchCancel(event.ID, event.stageX, event.stageY);
			}
			else
			{
				_touchesManager.onTouchEnd(event.ID, event.stageX, event.stageY);
			}
		}

		protected var _touchesManager:TouchesManager;
		public function set touchesManager(value:TouchesManager):void
		{
			_touchesManager = value;
		}
	}
}
