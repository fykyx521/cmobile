package com.careland.component
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.cldwinclasses.CLDDragRect;
	import com.careland.component.win.CLDTransparentWindow;
	import com.careland.component.win.WinModel;
	import com.careland.event.CLDEvent;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class CLDLayoutUI extends CLDBaseComponent
	{
		//触控需要的属性
		
		private var GRAD_PI:Number=180.0 / 3.14159;
		public var state:String;

		//物体运动开始时的尺寸，角度，位置
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point=new Point(0, 0);

		public var blob1:Object; //两个基准点
		public var blob2:Object;

		public var bringToFront:Boolean=true; //是否允许置前		
		public var bringToFrontNum:int=1; //置前多少
		public var noScale=false; //是否允许放大
		public var noRotate=true; //是否允许旋转
		public var noMove=false; //是否允许移动
		//	public var mouseSelection = false;		//是否允许鼠标选中
		public var MaxScale=10; //Scale的最大值
		public var MinScale=0.01; //Scale的最小值
		public var MaxWidth;
		public var MaxHeight;
		//	public var noMouseMove=true;			//是否允许鼠标操作。
		public var XMove=true; //是否允许左右拖拽
		public var YMove=true; //是否允许上下拖拽
		public var MaxMoveDistance:Number=200; //瞬间允许移动的最大值。
		public var noFloat=true; //是否有浮起来的效果。
		public var moveTimer:Number=0.06; //滞后时间，可以设置平滑度
		//-----------记录物体运动的增量----

		private var preX:Number=9999; //新增的变量--为了计算真实的dx，dy
		private var preY:Number=9999;
		//private var preX:Number=9999;			//新增的变量--为了计算真实的dx，dy
		//private var preY:Number=9999;
		private var preAngle:Number=9999;
		public var dX:Number;
		public var dY:Number;
		public var dAng:Number;

		private var ScaleLimitTweenerflag:Boolean=true;
		private var LastCenterPoint:Point=new Point(0, 0); //最后的注册点

		//DoubleClick variables
		private var doubleclickDuration:Number=500;
		private var clickRadius:Number=30;
		private var lastClickTime:Number=0;
		private var lastX:Number=0;
		private var lastY:Number=0;

		//为了能够正确地识别惯性旋转，需要计算最后一个抬起的点跟倒数第二个抬起的点时间差，
		//如果这个时间差小于某个值比如200ms，那么启动旋转的惯性，否则，没有惯性。
		private var lastPointUpTime:Number=0;
		private var preLastPointUpTime:Number=0;


		private var touchSprite:Sprite=new Sprite; //拖动
		
		private  var layoutSprite:Sprite=new Sprite;// 布局的sprite;
		//本身属性
		protected var _spacing:Number = 5;
		
		
		
		
	
		
		private var isSwitchWin:Boolean=false;//是否交换窗口
		
		private var dic:Dictionary=new Dictionary;
		
		
		
		private var touchObj:TouchObj=new TouchObj(null,null);
		
		private var blobs:Array=[];//存放已经点击的点
		
		private var blobsRect:Array=[];//存放 点击后的虚框
		
		private var scaleWin:CLDWindow=null;
		
		private var isScale:Boolean=false;//是否 放大过地图
		
		private var isMax:Boolean=false;//是否窗口是最大化
		
		private var oldParam:Object;
		
		public var _isConstom:Boolean=false;//是否 是自定义窗口
		
		public var viewID:String;//视图iD
		
		public function CLDLayoutUI(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0,isSwitchWin:Boolean=true)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			
			this.isSwitchWin=true;
			if(isSwitchWin){
				this.addEventListener(Event.ENTER_FRAME,update);
				this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
				if(stage){
					this.stage.addEventListener(TUIOEvent.TUIO_UP,upHandler);
				}else{
					this.addEventListener(Event.ADDED_TO_STAGE,addStage);  
				}
				this.addEventListener(TUIOEvent.TUIO_DOWN,layoutDown,true);
			}
		}
		
		public function set isConstom(value:Boolean):void
		{
			
			_isConstom=value;
			if(value){
				//this.pause();
			}else{
				//this.startRender();
			}
			
		}
		public function get isConstom():Boolean
		{
			return this._isConstom;
		}
		//开始渲染
		override public function startRender():void
		{
//			this.addEventListener(TUIOEvent.TUIO_DOWN,layoutDown,true);//加个true 会和window本身的事件冲突
			this.addEventListener(TUIOEvent.TUIO_DOWN,layoutDown); 
			if(stage){
				this.stage.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			}
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		//停止渲染
		override public function pause():void
		{
			this.removeEventListener(TUIOEvent.TUIO_DOWN,layoutDown);
			if(stage){
				this.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
			}
			this.removeEventListener(Event.ENTER_FRAME,update);			
		}
 
	
 
		override public function dispose():void
		{
			this.pause();
			super.dispose();
			this.layoutSprite=null;
			this.touchSprite=null;
			this.scaleWin=null;
			this.dic=null;
		}
		
		
		
			//因为有iframe  所以得重写下visible方法
		override public function set visible(value:Boolean):void
		{
			super.visible=value;
			var obj:Object=this.config.getIframeByID(this.uuid);
			if(obj){
				obj.comp.visible=value;
			}
			if(visible){
				ExternalInterface.call("IFun.setUUID",this.uuid);
				this.startRender();
			}else{
				this.pause();
			}
		}
		
		
	    
		
		
		private function addStage(e:Event):void
		{
			stage.removeEventListener(Event.ADDED_TO_STAGE,addStage);
			this.stage.addEventListener(TUIOEvent.TUIO_UP,upHandler);	
		}
		
		//获取点击的窗体
		private function getwinByTouchId(id:Number,stageX:Number,stageY:Number):CLDWindow
		{
			for(var i:int=0;i<this.numChildren;i++){
				var win:CLDWindow=this.getChildAt(i) as CLDWindow;
				
				//var tuio:TUIOObject=TUIO.getObjectById(id);
				if(win&&win.hitTestPoint(stageX,stageY)){
					return win;
				}
			}	
			return null;
		}
		
		private function addBlob(id:Number, origX:Number, origY:Number):void
		{
			if(!this.touchObj.over0&&!this.touchObj.over1){
				return;
			}
			//防止重复添加
			for (var i:int=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
					return;
			}
			//添加一个触点到队列		
			blobs.push({id: id, origX: origX, origY: origY, myOrigX: x, myOrigY: y});
			//判断点击到了 哪个窗体
			if(blobs.length==0){
				state="none";
			}
			if(blobs.length==1&&!this.isMax){
				state="dragging";
				
				var cld:CLDWindow=this.getwinByTouchId(blobs[0].id,origX,origY);
				if(cld){
					var cldRect:CLDDragRect=new CLDDragRect();
					
					var fil:GlowFilter=new GlowFilter();
					cldRect.setSize(cld.width,cld.height);
					cldRect.filters=[fil];
					cldRect.x=cld.x;
					cldRect.y=cld.y;
					var p:Point=this.localToGlobal(new Point(cld.x,cld.y));
					cldRect.disP=new Point(origX-p.x,origY-p.y);
					cldRect.dis=cld;
					cldRect.oldPoint=new Point(p.x,p.y);
					blobsRect.push({id:id,rect:cldRect});
					this.addChild(cldRect);
					this.setChildIndex(cldRect,this.numChildren-1);
					
				}
				
			}
			if(blobs.length==2){
				var cld0:CLDWindow=this.getwinByTouchId(blobs[0].id,origX,origY);
				var cld1:CLDWindow=this.getwinByTouchId(blobs[1].id,origX,origY);
				
				if(cld0&&cld0==cld1){
					deleteDragSprite();
					blob1=blobs[0];
					blob2=blobs[1];
									
					touchSprite.x=cld1.x;
					touchSprite.y=cld1.y;
					touchSprite.rotation=0;
					touchSprite.scaleX=1;
									
					this.state="rotatescale";
					this.resetBasePointVar();
					this.isScale=true;//是否两个手指点击到一个窗体上
					scaleWin=cld1;
					this.deletebitmapSprite(this.touchSprite);
					//while(this.touchSprite.numChildren>0)this.touchSprite.removeChildAt(0);
					
					var bit:Bitmap=cld1.drawCurrent();
					if(!this.contains(this.touchSprite)){
						this.addChild(touchSprite);
					}
					this.setChildIndex(touchSprite,this.numChildren-1);
					touchSprite.addChild(bit);	
					touchSprite.alpha=.3;
				}
				
				
			}
			if(this.blobs.length==3&&false){
				
				this.state="deleteLayout";
				if(!this.contains(layoutSprite)){
					layoutSprite.alpha=.3;
					this.addChild(layoutSprite)
				}
				this.deletebitmapSprite(this.layoutSprite);
				
				curScale=layoutSprite.scaleX;
				curAngle=layoutSprite.rotation;
				preX=curPosition.x=layoutSprite.x;
				preY=curPosition.y=layoutSprite.y;
				dX=0;
				dY=0;
				blob1=blobs[0];
											
				var tuioobj1:TUIOObject=TUIO.getObjectById(blob1.id);

						// if not found, then it must have died..
				if (tuioobj1)
				{
					var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));

					blob1.origX=curPt1.x;
					blob1.origY=curPt1.y;
				}
				var layoutbit:Bitmap=this.drawCurrent();
				
				this.layoutSprite.addChild(layoutbit);
				var filter:GlowFilter=new GlowFilter();
				layoutSprite.filters=[filter];
			}
			if(this.blobs.length==4){
				
				//this.toFlow();
			}
			
		}
		private function toFlow():void{
			this.dispatchEvent(new Event("toFlow"));
		}
		
		private function layoutDown(e:TUIOEvent):void
		{
		
			this.addBlob(e.ID,e.stageX,e.stageY);
		}


		override public function set data(value:*):void
		{
			super.data=value;
			pauseXML(data);
			
		}
		
		 protected function isImgMap():void
		{
			
		}
		protected function isMap(dt:String,param:Boolean=false):void
		{
			
		}
		
		private function setMapType(mapConfig:String):void
		{
			if(this.contentIDParam!=""){
				this.isMap(contentIDParam,true);
			}else{
				this.isMap(mapConfig);
			}
			
		}
		
		protected function pauseXML(data:*):void
		{
			var xml:XML=XML(data);
			if(!xml){
				return;
			}
			for(var i:int=0;i<xml.data.length();i++){ 
				
				var type:String=xml.data[i].attribute("窗口类型");
				var dt:String=String(xml.data[i].attribute("内容ID"));
				var isMapwin:Boolean=false;
				
				var cldw:CLDWindow=new CLDWindow();
				if(this.isConstom){
					
					switch(type){
						case "4":setMapType(dt);isMapwin=true;break;
						case "5":this.isImgMap();isMapwin=false;break;
						//设置透明窗体
					}
					
				}
				if(isMapwin){
					continue;
				}
				switch(type){
//					case "4":this.isMap(dt);isMapwin=true;break;
//					case "5":this.isImgMap();isMapwin=false;break;
					case "6":isMapwin=false;cldw=new CLDTransparentWindow();break;
						//设置透明窗体
				}
				
				
				//特定视图下
				cldw.contentIDParam=this.contentIDParam;
				
				
				
				cldw.setSize(500,500);
				
				cldw.index=xml.data[i].attribute("窗口排序");
				
				this.addChild(cldw);
				//cldw.addEventListener(CLDEvent.IS_MAP_WIN,isMapWin,true);
				
				if(this.isConstom){
					cldw.addEventListener(CLDEvent.WINUP,winUp);
				}
				
				var title:String=xml.data[i].attribute("窗口标题");
				cldw.title=title;
				//var type:String=xml.data[i].attribute("窗口类型");
				cldw.winType=type;
				
				cldw.uuid=this.uuid;
				cldw.constom=this.isConstom;
				var winWidth:Number=Number(xml.data[i].attribute("窗口宽度"));
				var winHeight:Number=Number(xml.data[i].attribute("窗口高度"));
				if(winWidth==0){
					winWidth=1;
				}
				if(winHeight==0){
					winHeight=1;
				}
				
				var winPos:String=xml.data[i].attribute("窗口位置");
				
				var winX:Number=0;
				var winY:Number=0;
				if(winPos){
					var winposArray:Array=winPos.split(',');
					if(winposArray.length>1){
						winX=winposArray[0]=="Infinity"?0:Number(winposArray[0]);
						winY=winposArray[1]=="Infinity"?0:Number(winposArray[1]);
					}
					
				}
				
				var nw=winWidth*this.width;
				var nh=winHeight*this.height;
				if(winX!=0){
					cldw.x=this.width/winX;
				}
				if(winY!=0){
					cldw.y=this.height/winY;
				}
				cldw.setSize(nw,nh);
				cldw.winScaleX=winX;
				cldw.winScaleY=winY;
				
				cldw.winWidth=winWidth;
				cldw.winHeight=winHeight;
				
				cldw.data=dt;
				var winModel:WinModel=null;
				
				winModel=new WinModel(winWidth,winHeight,winX,winY);
				
				cldw.winModel=winModel;
				
				trace(cldw.data);
			}	
			this.disposeXML(data);
			this.invalidate();
		}
		protected function winUp(e:CLDEvent):void
		{
			var win:CLDWindow=e.target as CLDWindow;
			
			if(win){
				
				
				if(e.stageX<145&&e.stageY>stageHeight-145){
					Tweener.addTween(win,{alpha:.5,time:.5});
					win.removeEventListener(CLDEvent.WINUP,winUp);
			  //	 var cld:CLDEvent=new CLDEvent(CLDEvent.WINCLOSEWIN);
					var winGP:Point=this.localToGlobal(new Point(win.x,win.y));
				//	cld.stageX=winGP.x
				//	cld.stageY=winGP.y;
		 		//  cld.obj=win.drawCurrent();
				//	config.dispatchEvent(cld);					
					win.x=this.stageWidth;
					win.y=this.stageHeight;
					this.removeChild(win);
					win.dispose();
					win=null;
//					Tweener.addTween(win,{x:0,height:0,alpha:.1,time:.3,delay:.5,onComplete:function(){
//						//dispatchEvent(new Event("deleteLayout"));
//						
//					}});
				}
			
				
			}
		}
		
		//如果是地图类型 就放置到最底层
		private function isMapWin(e:CLDEvent):void
		{
		
			var win:CLDWindow=e.currentTarget as CLDWindow;
			if(win&&this.isConstom){
				win.removeEventListener(CLDEvent.IS_MAP_WIN,isMapWin);
				win.isMapWin=true;
				win.setSize(this.width,this.height);
				this.setChildIndex(win,0);
			}
			this.reflush();
			
		}
		
		protected function onResize(event:Event):void
		{
			invalidate();
		}
		override public function draw():void
		{
			super.draw();
			reflush();
		}
		
		public function reflush():void
		{
			deleteDragSprite();
			if(!this.isMax){
				this.layout();
			}else{
				Tweener.addTween(this.scaleWin,{width:this.width,height:this.height,time:.1});
			}
			
		}
		
		private function deleteDragSprite():void
		{
			var delObj:Array=[];
			for(var i:int=0;i<this.numChildren;i++){
				
				var obj:DisplayObject=this.getChildAt(i);
				
				if(obj is CLDDragRect){
					delObj.push(obj);
				}
			}
			for each(var dragobj:DisplayObject in delObj){
				this.removeChild(dragobj);
			}
		}
		
		protected function layout():void
		{
			//initLayout();
			if(this.isConstom){
				for(var i:int=0;i<this.numChildren;i++){
					
					var win:CLDWindow=this.getChildAt(i) as CLDWindow;
					
					//如果不是弹出框
					if(win&&!win.alertWin){
						if(win.winScaleX!=0){
							win.x=this.width/win.winScaleX;
						}
						if(win.winWidth!=0){
							win.width=win.winWidth*this.width;
						}
						if(win.winScaleY!=0){
							win.y=this.height/win.winScaleY;
						}
						if(win.winHeight!=0){
							win.height=win.winHeight*this.height;
						}
						
						
					}
				}
			}
		}
		
		
		
		
		
		private function hitTestTouch(rect:CLDDragRect):void
		{
			for(var i:int=0;i<this.blobs.length;i++){
				var id:Number=blobs[i].id;
				var tuioobj:TUIOObject=TUIO.getObjectById(id);
				if(!rect.hitTestPoint(tuioobj.x,tuioobj.y)&&this.contains(rect)){
					this.removeChild(rect);
				}
			}
		}
		
	
		private function removeBlob(id:Number):void
		{
			
			var tuio:TUIOObject=TUIO.getObjectById(id);
			for (var i:Number=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
				{
					blobs.splice(i, 1);
				}
			}
			if(this.blobs.length==0&&!this.isMax){
				state="none";
				if(tuio){
					blobs0(id,tuio.x,tuio.y);
				}
			}
			//不是自定义视图
//			if(this.blobs.length==0&&!this.isConstom){
//				while(this.layoutSprite.numChildren>0)this.layoutSprite.removeChildAt(0);
//				layoutSprite.scaleX=1;
//				layoutSprite.scaleY=1;
//				layoutSprite.x=0;
//				layoutSprite.y=0;
//				if(this.blob1){
//					
//					var tuioobj:TUIOObject=TUIO.getObjectById(blob1.id);
//					if(tuioobj&&tuioobj.x<145&&tuioobj.y>stageHeight-145){
//						this.dispatchEvent(new Event("deleteLayout_old"));
//					}
//				}
//				
//			}
			
			//如果是放大 
			if(blobs.length==0&&this.isScale){
				this.deletebitmapSprite(touchSprite);
				//while(this.touchSprite.numChildren>0)this.touchSprite.removeChildAt(0);
				if(this.contains(this.touchSprite)){
					this.removeChild(touchSprite);
				}
				deleteDragSprite();
				if(!this.isMax&&this.touchSprite.scaleX>1){
						
						
						for(var z:int=0;z<this.numChildren;z++){
							var zw:CLDWindow=this.getChildAt(z) as CLDWindow;
							if(zw&&zw!=this.scaleWin){
								zw.visible=false;
							}
						}
						var obj0:Object=new Object;
						obj0.x=scaleWin.x;
						obj0.y=scaleWin.y; 
						obj0.width=scaleWin.width;
						obj0.height=scaleWin.height;
						this.oldParam=obj0;
						isMax=true;
						var s:Matrix3D;
						

						Tweener.addTween(this.scaleWin,{x:0,y:0,width:this.width,height:this.height,time:.5});
						
						
					}else if(this.isMax&&this.touchSprite.scaleX<1){
						var oldP:Object=oldParam;
						Tweener.addTween(this.scaleWin,{x:oldP.x,y:oldP.y,width:oldP.width,height:oldP.height,time:0.4,transition:"easeinoutback"});
						isMax=false;
						
						for(var x:int=0;x<this.numChildren;x++){
							var zw0:CLDWindow=this.getChildAt(x) as CLDWindow;
							if(zw0&&zw0!=this.scaleWin){
								zw0.visible=true;
							}
						}
						
					}
					isScale=false;
			}
			
			
		}
		
		private function upHandler(e:TUIOEvent):void
		{
			this.removeBlob(e.ID);
		}
		
		//
		private function blobs0(id:Number,stageX:Number,stageY:Number):void
		{
			
			
			var rectobj:Object=null;
			for(var i:int=0;i<this.blobsRect.length;i++){
				if(blobsRect[i].id==id){
					rectobj=blobsRect.splice(i,1);
				}
			}
			if(rectobj){
				
				//获取本地坐标
				var lp:Point=this.globalToLocal(new Point(stageX,stageY));
				
				//var displays:Array=this.stage.getObjectsUnderPoint(new Point(e.stageX,e.stageY));
				
				for(var j:int=0;j<this.numChildren;j++){
					
					var cldw:CLDWindow=this.getChildAt(j) as CLDWindow;
					//判断当前 点是否处于cldw 范围内 ,并且不属于拖动源对象
					//源对象
					var sobj:Object=rectobj[0].rect.dis;
					if(cldw&&sobj!=cldw&&cldw.hitTestPoint(stageX,stageY)){
						
						var sourceobj:Object={x:sobj.x,y:sobj.y,width:sobj.width,height:sobj.height};
						var toobj:Object={x:cldw.x,y:cldw.y,width:cldw.width,height:cldw.height};
						
						this.touchObj.over0=false;
						this.touchObj.over1=false;
						Tweener.addTween(cldw,{x:sourceobj.x,y:sourceobj.y,width:sourceobj.width,height:sourceobj.height,time:.3,onComplete:complete0});
						
						Tweener.addTween(sobj,{x:toobj.x,y:toobj.y,width:toobj.width,height:toobj.height,time:.3,onComplete:complete1});
						
						this.swapChildren(cldw,sobj as DisplayObject);
						break;
						
					}
					
				}
				try{
					this.removeChild(rectobj[0].rect);
				}catch(e:Error){
					
				}
				
				
			}
			
		}
		

		private function complete0():void
		{
			this.touchObj.over0=true;
		}
		
		private function complete1():void
		{
			this.touchObj.over1=true;
			this.invalidate();
		}
		
		
		
		
		private function update(e:Event):void
		{
			if(state=="dragging"){
				for(var i:int=0;i<this.blobsRect.length;i++){
				
				var id:Number=blobsRect[i].id;
				var rect:CLDDragRect=blobsRect[i].rect;
				
				var tuioobj:TUIOObject=TUIO.getObjectById(id);
				if(tuioobj){
					//tuioojb.x,y是全局坐标  需要转成本地坐标
					var lp:Point=this.globalToLocal(new Point(tuioobj.x,tuioobj.y));
					rect.x=lp.x-rect.disP.x;
					rect.y=lp.y-rect.disP.y;

				}
				}
			}
			
			
			//解决触电释放 不能消除对象的问题
//			for(var v:int=0;v<this.numChildren;v++){
//				var rect:CLDDragRect=this.getChildAt(v) as CLDDragRect;
//				if(rect){
//					 
//					this.hitTestTouch(rect);
//				}
//				
//			}
			var ObjectPosition:Point
			var lineBO:Point
			var lenBO:Number
			var angBO:Number
			if (state == "rotatescale")
			{
				
				
				var tuioobj1=TUIO.getObjectById(blob1.id);
				var tuioobj2=TUIO.getObjectById(blob2.id);
				// if not found, then it must have died..
				if (!tuioobj1)
				{
					removeBlob(blob1.id);
					trace("move");
					return;
				}
				// if not found, then it must have died..
				if (!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}
				var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
				var curPt2:Point=parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));
				var curCenter:Point=Point.interpolate(curPt1, curPt2, 0.5);

				var origPt1:Point=new Point(blob1.origX, blob1.origY);
				var origPt2:Point=new Point(blob2.origX, blob2.origY);
				var centerOrig:Point=Point.interpolate(origPt1, origPt2, 0.5);

				var offs:Point=curCenter.subtract(centerOrig);
				var len1:Number=Point.distance(origPt1, origPt2);
				var len2:Number=Point.distance(curPt1, curPt2);
				var len3:Number=Point.distance(origPt1, new Point(0, 0));

				var newscale:Number=curScale * len2 / len1;

				//计算BA的角度
				var origLine:Point=origPt1;
				origLine=origLine.subtract(origPt2);
				var ang1:Number=getAngleTrig(origLine.x, origLine.y);
				//计算B1A1的角度		
				var curLine:Point=curPt1;
				curLine=curLine.subtract(curPt2);
				var ang2:Number=getAngleTrig(curLine.x, curLine.y);

				LastCenterPoint=curCenter;
				//this.lastPoint=new Point(tuioobj.x,tuioobj.y);
				if (!noRotate)
				{
					dAng=this.rotation - preAngle; //curAngle + (ang2 - ang1) - preAngle;
					if (dAng > 180)
						dAng-=360;
					if (dAng < -180)
						dAng+=360;
					if (dAng > 30)
						dAng=30;
					if (dAng < -30)
						dAng=-30;
				}
				dX=this.touchSprite.x - preX;
				dY=this.touchSprite.y - preY;


				//关键是计算出中心点移动的坐标，即dx，dy。
				//点O（curPosition）为原始对象的中心点。
				//点A（origPt1）为基准点blob1的初始点。
				//点B（origPt2）为基准点blob2的初始点
				//点O1（nextCenter）使我们要求出的点的坐标，。
				//点A1（curPt1）为基准点blob1的目前所在点。
				//点B1（curPt2）为基准点blob2的目前所在点
				//已知 OAB跟O1A1B1为相似三角形，O1A1B1为OAB的 n=newscale/scaleX倍大小。

				//计算角AO的角度
				lineBO=curPosition;
				lineBO=lineBO.subtract(origPt2);
				angBO=getAngleTrig(lineBO.x, lineBO.y);
				var angB1O1:Number=angBO + (ang2 - ang1);
				var linBO:Number=Point.distance(origPt2, curPosition);
				var nextCenter:Point=Point.polar(newscale / curScale * linBO, angB1O1 / 180 * Math.PI);
				nextCenter=nextCenter.add(curPt2);

				if (newscale > MaxScale * 1.5)
				{
					this.resetBasePointVar();
					newscale=MaxScale * 1.5;
					newscale=MaxScale * 1.5;
					nextCenter.x=this.touchSprite.x;
					nextCenter.y=this.touchSprite.y;
					ang2=ang1;
						//curAngle+ang2-ang1=this.rotation;
				}
			
				setProperty2(nextCenter.x, nextCenter.y, newscale, newscale, curAngle + (ang2 - ang1));

				preX=x;
				preY=y;
				preAngle=rotation;

			}
			//如果是3个手指则进行拖动
			if (state == "deleteLayoutvv")
			{
				var tuioobj:TUIOObject=TUIO.getObjectById(blob1.id);

				// if not found, then it must have died..
				if (!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}

				var curPt:Point=parent.globalToLocal(new Point(tuioobj.x, tuioobj.y)); //得到当前触点坐标
				var oldX:Number, oldY:Number;
				oldX=this.layoutSprite.x;
				oldY=this.layoutSprite.y;


				//计算需要移动的距离
				var tempx:Number, tempy:Number;
				if (!noMove)
				{
					if (this.XMove)
						tempx=curPosition.x + (curPt.x - (blob1.origX));
					else
						tempx=this.layoutSprite.x;
					if (this.YMove)
						tempy=curPosition.y + (curPt.y - (blob1.origY));
					else
						tempy=this.layoutSprite.y;
				}
				else
				{
					tempx=layoutSprite.x;
					tempy=layoutSprite.y;
				}

				LastCenterPoint=curPt;

				dX=layoutSprite.x - preX;
				dY=layoutSprite.y - preY;
				//trace(dX);
				//trace(dY);
				//为了使照片能够稳定不动。
				//this.released(dX, dY, 0);
				//end--计算需要移动的距离
				//-----------test--------------------------
				/*
				if(scaleX < MinScale) scaleX = MinScale;
				if(scaleX > MaxScale) scaleX = MaxScale;
				if(scaleY < MinScale) scaleY = MinScale;
				if(scaleY > MaxScale) scaleY = MaxScale;
				*/
				if (Math.abs(dX) < MaxMoveDistance && Math.abs(dY) < MaxMoveDistance && ScaleLimitTweenerflag) //限制瞬间移动
				{
					Tweener.addTween(layoutSprite, {x: tempx, y: tempy, time: moveTimer, transition: "linear"});
				}
				else
				{
					dX=0;
					dY=0;
				}
				preX=layoutSprite.x;
				preY=layoutSprite.y;

			}
			if(this.blobs.length!=0){
				return;
			}
			
			
		}
		public function setProperty2(x_2:Number, y_2:Number, scaleX2:Number, scaleY2:Number, rotation2:Number):void
		{
			if (rotation2 - rotation > 180)
				rotation2-=360;
			if (rotation2 - rotation < -180)
				rotation2+=360;
			if (noScale)
			{
				scaleX2=scaleY2=this.touchSprite.scaleX;
			}
			if (noMove)
			{
				x_2=touchSprite.x;
				y_2=touchSprite.y;
			}
			if (this.noRotate)
			{
				rotation2=rotation;
			}
			//Tweener.addTween(this.touchSprite, { scaleX: scaleX2, scaleY: scaleY2, rotation: rotation2, time: this.moveTimer, transition: "linear"});
			Tweener.addTween(this.touchSprite, {x: x_2, y: y_2, scaleX: scaleX2, scaleY: scaleY2, rotation: rotation2, time: this.moveTimer, transition: "linear"});
		}
		
		private function getAngleTrig(X:Number, Y:Number):Number
		{
			if (X == 0.0)
			{
				if (Y < 0.0)
					return 270;
				else
					return 90;
			}
			else if (Y == 0)
			{
				if (X < 0)
					return 180;
				else
					return 0;
			}
			if (Y > 0.0)
				if (X > 0.0)
					return Math.atan(Y / X) * GRAD_PI;
				else
					return 180.0 - Math.atan(Y / -X) * GRAD_PI;
			else if (X > 0.0)
				return 360.0 - Math.atan(-Y / X) * GRAD_PI;
			else
				return 180.0 + Math.atan(-Y / -X) * GRAD_PI;
		}
		private function resetBasePointVar():void
		{
			curScale=this.touchSprite.scaleX;
			curAngle=this.touchSprite.rotation;
			curPosition.x=touchSprite.x;
			curPosition.y=touchSprite.y;

			preX=x;
			preY=y;
			preAngle=this.touchSprite.rotation;

			dX=0;
			dY=0;
			dAng=0;

			var tuioobj1=TUIO.getObjectById(blob1.id);
			var tuioobj2=TUIO.getObjectById(blob2.id);

			var curPt1:Point
			if (tuioobj1)
			{
				//	var midPoint:Point = Point.interpolate(this.globalToLocal(new Point(tuioobj1.x, tuioobj1.y)),this.globalToLocal(new Point(tuioobj2.x, tuioobj2.y)),0.5);
				curPt1=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
				blob1.origX=curPt1.x;
				blob1.origY=curPt1.y;
			}
			if (tuioobj2)
			{
				curPt1=parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));
				blob2.origX=curPt1.x;
				blob2.origY=curPt1.y;
			}
		}

		
		
		
		
		
		
	}
}
	import flash.display.DisplayObject;
	import flash.geom.Point;
	

class TouchObj{
	public var dis:DisplayObject;
	public var preP:Point;
	public var source:DisplayObject;
	
	public var over0:Boolean=true;
	public var over1:Boolean=true;
	
	public var id:int;
	public function TouchObj(dis:DisplayObject,preP:Point){
		this.dis=dis;
		this.preP=preP;
	}
}