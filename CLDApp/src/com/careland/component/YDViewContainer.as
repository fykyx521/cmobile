package com.careland.component
{
	import aze.motion.EazeTween;
	
	import com.careland.YDTouchComponent;
	import com.careland.component.layout.*;
	import com.careland.component.win.CLDTrashWin;
	import com.careland.event.CLDEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.Flash3DAdapter;
	

	
	public class YDViewContainer extends YDTouchComponent
	{
		
	    public var currentIndex:int=3;
	    
	    public var _yh:Number=0;
	    public var _yw:Number=0;
	    
	   
	    
	    private var content:CLDViewContent;
	    
	    private var win:Sprite;
	 	
	 	private var contentMask:Sprite;
	  
	  	private var closeWin:CLDTrashWin;
	    
		public function YDViewContainer()
		{
			super();
			
			content=new CLDViewContent();
			this.addChild(content);
			contentMask=new Sprite;
			this.addChild(contentMask);
			content.mask=contentMask;
			//content.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
			EazeTween.specialProperties.transform3D = Flash3DAdapter;
			closeWin=new CLDTrashWin();
			this.addChild(closeWin);
			closeWin.alpha=.5;
			closeWin.visible=false;
			
			//关闭视图窗口
			this.cldConfig.addEventListener(CLDEvent.WINCLOSEWIN,closeLayoutWin);

		}
		private function closeLayoutWin(e:CLDEvent):void
		{
//			if(this.closeWin.numChildren>1){
//				var bit:Bitmap=this.closeWin.removeChildAt(0) as Bitmap;
//			    bit.bitmapData.dispose();
//			} 
//			var dis:DisplayObject=e.obj as DisplayObject;
//			closeWin.setSize(dis.width,dis.height);
//			
//			this.closeWin.addChildAt(dis,0);
//			this.closeWin.visible=true;
//			
//			var lp:Point=this.globalToLocal(new Point(e.stageX,e.stageY));
//			closeWin.x=lp.x;
//			closeWin.y=lp.y;
//			Tweener.addTween(closeWin,{x:0,y:this.height,time:5});
		}
		private function init(e:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE,init)
		}
		private function getTemp():CLDWindow{
			var cld:CLDWindow=new CLDWindow();
			cld.setSize(326,444);
			return cld;
		}
		
		
		public function set yw(value:Number):void
		{
			if(value!=this._yw)
				this._yw=value; this.invalidate();
		}
		public function set yh(value:Number):void
		{
			if(value!=this._yh)
				this._yh=value; this.invalidate();
			
			
		}
		
		public function get yw():Number
		{
			return this._yw;
		}
		public function get yh():Number
		{
			return this._yh;
		}
		
		override protected function updateUI():void
		{
			//Tweener.addTween(content,{width:yw,height:yh,time:.3,transition:"linear"});
			this.content.setSize(yw,yh);
			
			var g:Graphics=this.contentMask.graphics;
			g.clear();
			g.beginFill(0xffffff,0);
			g.drawRect(0,0,yw,yh);
			g.endFill();
		}
		
		public function addView(data:XML,viewParam:String=""):void
		{
			 
			 this.content.addView(data,viewParam);
		}
		
		
		
		
		
	}
}

