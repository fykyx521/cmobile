package com.careland.component
{
	import caurina.transitions.Tweener;
	
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.layout.*;
	import com.careland.event.CLDEvent;
	import com.careland.gesevents.CLDTwoFingerEvent;
	import com.demonsters.debugger.MonsterDebugger;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import fr.mazerte.controls.openflow.OpenFlow;
	import fr.mazerte.controls.openflow.env.FlashEnv;
	import fr.mazerte.controls.openflow.interpolator.DefaultInterpolator;
	import fr.mazerte.controls.openflow.layout.AppleHorizontalLayout;
	import fr.mazerte.controls.openflow.layout.CircleOutLayout;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.seek.DefaultSeeker;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.PanGestureDirection;
		
	public class CLDViewContent extends CLDBaseComponent
	{
		
		private var ctb:CLDTouchButton;//转到视图状态
		private var closeBt:CLDTouchButton;//关闭按钮
		public var winArr:Array=[];//所有打开的窗口
		private var of:OpenFlow;
		
		private var _isFlowState:Boolean=false;//是否是 openFlow状态，是的话调整视角
		
		private var openFlowdata:Array=[];
		
		private var thiswin:Object=new Object;//当前的显示视图
		
		//openFlow属性
	    private var _mouseIsDown:Boolean=false;
	    private var _xOffset:Number=0;
	    private var _oldX:Number=0;
	    
	    private var blobs:Array=[];
	    
	    private var state:String="";
	    
	    private var curPosition:Point=new Point(0,0);
	    private var blob1:Object;
	    
	    private var layoutSprite:Sprite=new Sprite;
	    
	    private var preX:Number;
	    private var preY:Number;
		
		private var pan3Gesture:PanGesture;
		
		
		public function CLDViewContent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			pan3Gesture=new PanGesture(this);
			var p:Gesture=new LongPressGesture(this);
			
			pan3Gesture.minNumTouchesRequired=3;
			pan3Gesture.maxNumTouchesRequired=4;
			pan3Gesture.addEventListener(GestureEvent.GESTURE_BEGAN,pan3Begin);
			pan3Gesture.addEventListener(GestureEvent.GESTURE_CHANGED,pan3Handler);
			pan3Gesture.addEventListener(GestureEvent.GESTURE_ENDED,pan3End);
			
		}
		override protected function stageInit():void
		{
			stage.addEventListener(TUIOEvent.TUIO_UP,this.contentUp);
		}
		
		public function set isFlowState(value:Boolean):void
		{
			this._isFlowState=value;
			if(value){
				//stage.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDownHandler);
				this.removeEventListener(TUIOEvent.TUIO_DOWN,contentDown,true);
				this.removeEventListener(TUIOEvent.TUIO_UP,contentUp,true);
				stage.removeEventListener(TUIOEvent.TUIO_UP,this.contentUp,true);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDownHandler);
				this.removeEventListener(Event.ENTER_FRAME,update);
				of.data=this.getBitmapArray();
				of.visible=true;
				
				
				
				
			}else{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,_mouseDownHandler);
				stage.removeEventListener(Event.ENTER_FRAME, _mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
				this.addEventListener(TUIOEvent.TUIO_DOWN,contentDown,true);
				this.addEventListener(TUIOEvent.TUIO_UP,contentUp,true);
				stage.addEventListener(TUIOEvent.TUIO_UP,this.contentUp,true);
				this.addEventListener(Event.ENTER_FRAME,update);
				of.visible=false;
				
				
				
			}
			
		}
		private var firstPoint:Point;
		private function pan3Begin(e:GestureEvent):void
		{
			  firstPoint=new Point(0,0);
		}
		
		private function pan3Handler(e:GestureEvent):void
		{
			var gesture:PanGesture=e.target as PanGesture;
			firstPoint=firstPoint.add(new Point(Math.abs(gesture.offsetX),Math.abs(gesture.offsetY)));
			if(gesture&&!this.isFlowState)
			{
				
				if(gesture.touchesCount==3)
				{
					
//					this.closeDown(); //关闭当前视图
					
				}else if(gesture.touchesCount==4)
				{
					
					 toOpenFlow();
					
				}
			}
		}
		private function pan3End(e:GestureEvent):void
		{
			var gesture:PanGesture=e.target as PanGesture;
			firstPoint=new Point(0,0);
		}
		
		public function get isFlowState():Boolean
		{
			return this._isFlowState;
		}
		
		
		override protected function addChildren():void
		{
//			ctb=new CLDTouchButton();
			closeBt=new CLDTouchButton();
//			var bit0:Bitmap=this.config.getBitmap("toflowe");
//			var bit1:Bitmap=this.config.getBitmap("toflowc");
//			ctb.setBit(bit0,bit1);
//			this.addChild(ctb);
//			ctb.visible=false;
//			
//			var bit2:Bitmap=this.config.getBitmap("closed");
//			var bit3:Bitmap=this.config.getBitmap("closec");
//			closeBt.setBit(bit2,bit3); 
//			closeBt.alpha=.3;
			closeBt.visible=false;
			 
			 
			of=new OpenFlow(null,LayoutItemRenderer,new FlashEnv(),layout,[new DefaultInterpolator()],new DefaultSeeker());
			this.addChild(of);
//			of.visible=false;
//			ctb.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			
			of.addEventListener(CLDTwoFingerEvent.CLD_TWO_FINGER_TAB,twoFingler,true);
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,contentDown,true);
			this.addEventListener(TUIOEvent.TUIO_UP,contentUp,true);
			
			this.addChild(layoutSprite);
			this.addChild(closeBt);
			closeBt.addEventListener(TUIOEvent.TUIO_DOWN,closeDown);
		}
		
		private function contentDown(e:TUIOEvent):void
		{
			//throw new Error;
			this.addBlob(e.ID,e.stageX,e.stageY);
			trace("addPoint"+e.ID);
		}
		
		private function addBlob(id:Number, origX:Number, origY:Number):void
		{
			//防止重复添加
			for (var i:int=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
					return;
			}
			//添加一个触点到队列		
			blobs.push({id: id, origX: origX, origY: origY, myOrigX: x, myOrigY: y});
			if(blobs.length==3&&!this.isFlowState&&this.thiswin.dis){
			     this.state="deleteLayout";
			}
			if(blobs.length==4&&!this.isFlowState&&this.thiswin.dis){
				this.state="toFlow";
				
				this.deletebitmapSprite(this.layoutSprite);
				//while(this.layoutSprite.numChildren>0)this.layoutSprite.removeChildAt(0);
				
				if(thiswin.dis){
					this.toFLowTweener(thiswin.dis);
					//删除所有点击点
					blobs.splice(0,this.blobs.length);
				} 
			}
			
		}
		//转到视图列表 
		public function toOpenFlow():void
		{
			if(thiswin.dis){
				this.toFLowTweener(thiswin.dis);
			}
		}
		private function contentUp(e:TUIOEvent):void 
		{
			this.removeBlob(e.ID);
			trace("removePoint"+e.ID);
		}
		
		private function removeBlob(id:Number):void
		{
			for (var i:Number=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
				{
					blobs.splice(i, 1);
				}

			}
//			if(this.blobs.length==0&&this.thiswin.dis){
//				this.deletebitmapSprite(this.layoutSprite);
//				thiswin.dis.startRender();
//			}
			if(blobs.length==3&&!this.isFlowState&&this.thiswin.dis){
				
     			this.state="deleteLayout";
//				
//				thiswin.dis.pause();
//				while(this.layoutSprite.numChildren>0)this.layoutSprite.removeChildAt(0);
//				
//				var current:Bitmap=this.drawCurrent();
//				this.layoutSprite.addChild(current); 
//				
//				this.preX=curPosition.x=layoutSprite.x=0;
//				this.preY=curPosition.y=layoutSprite.y=0;
//				
//				blob1=blobs[0];
//				var tuioobj1:TUIOObject=TUIO.getObjectById(blob1.id);
//	
//				if (tuioobj1)
//				{
//					blob1.origX=tuioobj1.x;
//					blob1.origY=tuioobj1.y;
//				}
			}
		
		}
		
		//转到视图状态下的效果
		public function toFLowTweener(cldui:CLDLayoutUI):void
		{
				if(!this.isFlowState)this.blobs.splice(0,this.blobs.length);//删除所有点击的点
				var bit:Bitmap=cldui.drawCurrent();
				this.addChild(bit);
				cldui.visible=false;
				Tweener.addTween(bit,{width:524,height:444,
				x:(this.width-524)/2,y:(this.height-444)/2,time:.5,alpha:.1,onCompleteParams:[bit,cldui],onComplete:toFlowTwEnd});
		}
		
		//转到视图状态
		private function toFLow(e:Event):void
		{
			var cldui:CLDLayoutUI=e.target as CLDLayoutUI;
			if(cldui){
				
				this.toFLowTweener(cldui);
				
			}
		}
		//效果完成后
		private function toFlowTwEnd(bit:Bitmap,cldui:CLDLayoutUI):void
		{
			bit.bitmapData.dispose();
			
			this.removeChild(bit);
			bit=null;
			//销毁此对象
			
			//cldui.visible=false;
			downHandler(cldui);
		}
		
		
		//转到视图状态
		private function downHandler(cldui:CLDLayoutUI):void
		{
			if(this.isFlowState)return;
	    	this.transformData(cldui);
			this.isFlowState=true;
			thiswin.dis=null;
			cldui.dispose();
			this.removeChild(cldui);
			
			this.invalidate();
		}
		//点击关闭按钮的处理事件
		private function closeDown(e:Event=null):void
		{
			if(this.isFlowState&&this.openFlowdata.length==0)return;
			
			
			if(this.thiswin.dis){

				thiswin.dis.dispose();
				removeChild(thiswin.dis);
				
				closeover();
			}
			function complete0(bit:Bitmap):void
			{

				
			}
			
		}
		//关闭窗口后
		private function closeover():void
		{
			
			var index:int=-1;
			for(var i:int=0;i<this.openFlowdata.length;i++){
				if(openFlowdata[i].ID==thiswin.id){
					var obj:Object=openFlowdata.splice(i,1);
					if(obj.isBit)obj.view.dispose();
					index=i;
					break;
				}
			}
			this.thiswin.dis=null;
			if(this.openFlowdata.length>0){
				//this.isFlowState=true;
				
				//this.invalidate();
				var viewData:Object=this.openFlowdata[openFlowdata.length-1];
				this.show(viewData.data,viewData.viewParam);//显示上一个
				this.invalidate();
			}else{
				this.config.dispatchEvent(new Event("showDesk"));
			}

		}
		
		override public function draw():void
		{
			
//			var g:Graphics=this.graphics;
//			g.beginFill(0x000000,0);
//			g.drawRect(0,0,this.width,this.height);
//			g.endFill();
			if(ctb){
				ctb.x=this.width-110;
				//ctb.y=-10;
				this.setChildIndex(ctb,this.numChildren-1);
			}
			if(closeBt&&this.openFlowdata.length>0){
				//closeBt.visible=true;
				closeBt.x=this.width-79;
				
				this.setChildIndex(closeBt,this.numChildren-1);
			}
			if(this.isFlowState&&this.closeBt){
				this.closeBt.visible=false;
			}

			if(this.thiswin.dis){
				this.thiswin.dis.setSize(this.width,this.height);
			}
			
			if(of){
				of.width=this.width;
				of.height=this.height;
				if(isFlowState){
					this.changeTransform(this.openFlowConfig.fieldOfView,openFlowConfig.focalLength);
				}
			}
			
		}

		
		//截图  判断最后一个是否截图 
	    public function transformData(ui:CLDLayoutUI):void
		{
			
			if(ui){
				var bit:Bitmap=ui.drawCurrent();
				var ofLength:int=this.openFlowdata.length
				if(ofLength>0){
					var isBit:Boolean=openFlowdata[ofLength-1].isBit
					if(!isBit){
						openFlowdata[ofLength-1].view=bit.bitmapData;
						openFlowdata[ofLength-1].isBit=true;
					}
					
				}
			}
			

		}
		//获取截图数组
		 public function getBitmapArray():Array
		{
			
		
			var newArray:Array=[];  
			for each(var obj:Object in this.openFlowdata){
				
				newArray.push({ID:obj.ID,viewID:obj.viewID,view:obj.view,data:obj.data,viewParam:obj.viewParam});
			}	
			return newArray;
		}
		
		
		private function twoFingler(e:CLDTwoFingerEvent):void
		{
			if(!this.isFlowState)return;
			var dis:LayoutItemRenderer=e.target as LayoutItemRenderer;
			if(!dis)
				return;
			
			if(!config.webConfig)//如果是ipad
			{
				show(dis.xmlData,dis.param);
				return;
			}
				
			var global:Point=dis.parent.local3DToGlobal(new Vector3D(dis.x,dis.y,0));
			 
			var cld:DisplayObject=dis.clone();
			
			var newpoint:Point=this.globalToLocal(new Point(global.x,global.y));
			cld.x=newpoint.x;
			cld.y=newpoint.y;
			cld.width=524;
			cld.height=444;
			this.addChild(cld);
			
			var showID:int=0;
			Tweener.addTween(cld,{x:0,y:0,width:this.width,height:this.height,alpha:.3,time:1,onComplete:complete});
			
			function complete():void
			{
				removeChild(cld);
				show(dis.xmlData,dis.param);//显示视图
				
			}
		}
		//显示当前视图
		public function show(data:*,viewParam:String):void
		{
			this.isFlowState=false;
			this.of.visible=false;
			var obj:Object=this.initViewID(data);
			if(!obj)return;
			var currentWin:CLDLayoutUI=this.initLayout(obj.viewID,data,viewParam);
			currentWin.setSize(this.width,this.height);
			this.transform.perspectiveProjection=null;
			this.thiswin.dis=currentWin;
			this.thiswin.id=obj.uid;
			this.thiswin.uuid=currentWin.uuid;
			this.invalidate();
		} 
		
		
		
		public function get layout():ILayout
		{
			
			var layout:ILayout=null;
			switch(Number(this.openFlowConfig.layout)){
				case 0:layout=new AppleHorizontalLayout();break;
				case 1:layout==new CircleOutLayout();break;
			}
			return layout;

		}
		
		public function get openFlowConfig():XML
		{
			return XML(config.config.ui.openFlow[0]);
		}
		
		public function changeTransform(fv:Number,fl:Number):void
		{
			this.transform.perspectiveProjection=new PerspectiveProjection();
			this.transform.perspectiveProjection.fieldOfView = fv;
			this.transform.perspectiveProjection.focalLength = fl;
			this.transform.perspectiveProjection.projectionCenter = new Point(this.width >> 1, this.height >> 1);
		}
		
		
		
		private function initLayout(viewID:int,data:XML,contentParam:String=""):CLDLayoutUI
		{
			
			var currentWin:CLDLayoutUI;
			switch(viewID-1){
				case 0:currentWin=new CLDLayout0;break;
				case 1:currentWin=new CLDLayout1;break;
				case 2:currentWin=new CLDLayout2;break;
				case 3:currentWin=new CLDLayout3;break;
				case 4:currentWin=new CLDLayout4;break;
				case 5:currentWin=new CLDLayout5;break;
				case 6:currentWin=new CLDLayout6;break;
				case 7:currentWin=new CLDLayout7;break;
				case 8:currentWin=new CLDLayout8;break;
				case 9:currentWin=new CLDLayout9;break;
				case 10:currentWin=new CLDLayout10;break;
				case 11:currentWin=new CLDLayout11;break;
				
				default:currentWin=new CLDLayout12;currentWin.isConstom=true;break;
			} 
//			if(!currentWin){
//				this.config.getPluginLayout(viewID);
//			}
//			if(!currentWin){
//				currentWin=new CLDLayout12;currentWin.isConstom=true;
//			}

			currentWin.setSize(this.width,this.height);
			currentWin.contentIDParam=contentParam;
			currentWin.data=data;
			this.addChild(currentWin);
			return currentWin;
		}
		//初始化视图ID
		private function initViewID(data:XML):Object
		{
			var newData:XML=null;
			var viewID:int=0;
			var uid:int=0;
			try{
				 newData=data.data[0];
				 viewID=newData.@视图ID;
				 uid=newData.@ID;
			}catch(e:Error){
				trace(e);
				return null;	
			}finally{
				
			}
			return {viewID:viewID,uid:uid};
		}
		private function deleteExitsView(obj:Object):void
		{
			for(var i:int=0;i<this.openFlowdata.length;i++){
				var ofObj:Object=openFlowdata[i];
				if(ofObj.ID==obj.uid)
				{
					this.openFlowdata.splice(i,1);
					if(ofObj.isBit){
						ofObj.view.dispose();
					}
				}
				
			}
		}
		
//		public function addViewWithParam(data:XML,contentParam:String):void
//		{
//			
//		}
		
		//contentParam 视图参数
		public function addView(data:XML,viewParam:String=""):CLDLayoutUI
		{
			if(this.isFlowState)return null;
			var obj:Object=this.initViewID(data);
			if(!obj)return null;
			
			deleteExitsView(obj);//删除已经存在的视图
			
//			var currentWin:CLDLayoutUI=this.initLayout(obj.viewID,data,viewParam);
			 
			 var preDis:CLDLayoutUI=null;
			 
			//把上一个视图 截图
		    if(thiswin.dis){
		    	preDis=thiswin.dis;
		    	if(openFlowdata.length>0){
		    		var isBit:Boolean=openFlowdata[openFlowdata.length-1].isBit;
		    		if(!isBit){
		    			var bit:Bitmap=preDis.drawCurrent();
		    			openFlowdata[openFlowdata.length-1].view=bit.bitmapData;
		    			openFlowdata[openFlowdata.length-1].isBit=true;
		    		}
		    	}
		    }
			if(preDis){
				//把截图 放到上一个index数组中，用于显示
				preDis.dispose();
				this.removeChild(preDis);
			}
			var currentWin:CLDLayoutUI=this.initLayout(obj.viewID,data,viewParam);
			//放入内容
		    openFlowdata.push({uuid:currentWin.uuid,ID:obj.uid,viewID:obj.viewID,data:data,viewParam:viewParam,isBit:false});
		    currentWin.reflush();
		  
			fixOpenFlowData();
		    
		    thiswin.dis=currentWin;
		    thiswin.id=obj.uid;
		    thiswin.uuid=currentWin.uuid;
//		    if(preDis){
//		    	//把截图 放到上一个index数组中，用于显示
//		    	preDis.dispose();
//		    	this.removeChild(preDis);
//		    }
		    this.invalidate();
		    this.disposeXML(data);
		    return currentWin;
		}
		//删除 默认大于7个 的 数据
		private function fixOpenFlowData():void
		{
			var num:int=int(config.openFlowLength());
			if(num==0){
				num=7;
			}
			var spliteArray:Array=[];
			if(this.openFlowdata.length>num){
				spliteArray=openFlowdata.splice(0,openFlowdata.length-num);
			}
			for each(var obj:Object in spliteArray)
			{
				if(obj.isBit==true){
					obj.view.dispose();
				}
				obj=null;
			}
			
		}
		
		private function deleteLayout(e:Event):void
		{
			this.closeDown(e);
		}
		
		
		 private function _mouseDownHandler(event:MouseEvent):void
			{
				_mouseIsDown = true;
				_oldX = stage.mouseX;
				if(of.hitTestPoint(stage.mouseX, stage.mouseY))
				{
					stage.addEventListener(Event.ENTER_FRAME, _mouseMoveHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
				}
			}
			
			private function _mouseMoveHandler(event:Event):void
			{
				if(!_mouseIsDown)
					return;
				
				_xOffset = stage.mouseX - _oldX;
				of.setSeek(of.getSeek() + ( - (_xOffset / 444)), false); 
				//of.setSeek(of.getSeek() + (  (_xOffset / 444)), false); 
				
				_oldX = stage.mouseX;
			}
			
			private function _mouseUpHandler(event:MouseEvent):void
			{
				if(!_mouseIsDown)
					return;
				
				_mouseIsDown = false;
				
				//of.setSeek(Math.round(of.getSeek() + ( - (_xOffset / 444) * 4)));
				var ofSeek=Math.round(of.getSeek() + ( -(_xOffset / 444) * 4))

				of.setSeek(ofSeek);
				_xOffset = 0;
				
				stage.removeEventListener(Event.ENTER_FRAME, _mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
			}
			//更新
			public function update(e:Event):void
			{
				if (state == "deleteLayout")
				{
					dragHandler();
				}
				if(state=="toFlow"){
					
//					var tempArray:Array=[];
//					if(this.blobs.length!=4)return;
//					var step:int=0;
//					for(var i:int=0;i<this.blobs.length;i++){
//						var blob:Object=this.blobs[i];
//						var tuioobj:TUIOObject=TUIO.getObjectById(blob.id);
//						if (!tuioobj)
//						{
//							removeBlob(blob.id);
//							return;
//						}	
//						
//						var op:Point=new Point(tuioobj.x,tuioobj.y);
//						var np:Point=new Point(blob.origX,blob.origY);
//						var dis:Point=np.subtract(op);
//						
//						var length:Number=Math.sqrt(Math.abs(dis.x*dis.x+dis.y+dis.y));
//						
//						
//						if(length>50){
//							step++;
//						}
//						
//					}
//					if(step==4){
//						this.toFLowTweener(this.thiswin.dis);
//					}
					
					
					//if(tempArray.length<4) return;
					
					
					
					
				}

			}
			private function dragHandler():void
			{
				
				var tempArray:Array=[];
				if(this.blobs.length!=3)return;
				var step:int=0;
				for(var i:int=0;i<this.blobs.length;i++){
					var blob:Object=this.blobs[i];
					var tuioobj:TUIOObject=TUIO.getObjectById(blob.id);
					if (!tuioobj)
					{
						removeBlob(blob.id);
						return;
					}	
					
					var op:Point=new Point(tuioobj.x,tuioobj.y);
					var np:Point=new Point(blob.origX,blob.origY);
					var dis:Point=np.subtract(op);
					
					var length:Number=Math.sqrt(Math.abs(dis.x*dis.x+dis.y+dis.y));
					
					
					if(length>50){
						step++;
					}
					
				}
				if(step>1){
					this.closeDown();
				}
				
				
			}
			override public function dispose():void
			{
				this.removeEventListener(TUIOEvent.TUIO_DOWN,contentDown,true);
				this.removeEventListener(TUIOEvent.TUIO_UP,contentUp,true);
				stage.removeEventListener(TUIOEvent.TUIO_UP,this.contentUp,true);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,_mouseDownHandler);
				stage.removeEventListener(Event.ENTER_FRAME, _mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
				
				if(pan3Gesture)
				{
					//pan3Gesture.removeEventListener(GestureEvent.GESTURE_ENDED,pan3gestureHandler);
					pan3Gesture.dispose();
					pan3Gesture=null;
				}
				
				super.dispose();
			}
			override public function register():void
			{
				 this.registerCommand(CMD.ALERT_WIN);
				 if(config)
				 config.addEventListener(CLDEvent.ALERTWIN,sendAlertWin);
			}
			override public function unregister():void
			{
				 this.unregisterCommand(CMD.ALERT_WIN);
				 if(config)
				 {
					 config.removeEventListener(CLDEvent.ALERTWIN,sendAlertWin);
				 }
			}
			private function sendAlertWin(e:CLDEvent):void
			{
				 var mes:Message=Message.buildMsg(CMD.ALERT_WIN);
				 mes.data={mouseClickData:e.mouseClickData};
				 this.sendCommand(mes);
			}
			
			override protected function handlerRemote(e:Message):void
			{
				 if(CMD.ALERT_WIN==e.type)
				 {
					  var cle:CLDEvent=new CLDEvent(CLDEvent.ALERTWIN);
					  cle.mouseClickData=e.data.mouseClickData;
					  this.config.dispatchEvent(cle);
				 }
			}
		
		
		
		
		
	}
}