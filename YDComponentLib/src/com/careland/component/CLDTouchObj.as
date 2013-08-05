package com.careland.component
{
	import com.careland.event.CLDEvent;
	import com.touchlib.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;

	public class CLDTouchObj extends CLDBaseComponent
	{
		protected var blobs:Array=[];
		private var GRAD_PI:Number=180.0 / 3.14159;
		private var blob1:Object;
		private var blob2:Object;
		private var state:String="";
		private var curPosition:Point=new Point(0,0);
		
		private var curScaleX:Number;
		private var curScaleY:Number;
		
		
		protected var curScale:Number;
		private var curAngle:Number;
		public var noMove=false; //是否允许移动
		private var ScaleLimitTweenerflag:Boolean=true;
		private var LastCenterPoint:Point=new Point(0, 0); //最后的注册点
		public var noMouseMove=true; //是否允许鼠标操作。
		public var XMove=true; //是否允许左右拖拽
		public var YMove=true; //是否允许上下拖拽
		public var MaxMoveDistance:Number=300; //瞬间允许移动的最大值。
		private var preX:Number=9999; //新增的变量--为了计算真实的dx，dy
		private var preY:Number=9999;
		public var moveTimer:Number=0.06;
		//private var preX:Number=9999;				//新增的变量--为了计算真实的dx，dy
		//private var preY:Number=9999;
		private var preAngle:Number=9999;
		public var dX:Number;
		public var dY:Number;
		public var dAng:Number;
		
		public var canScale:Boolean=true;
		
		private var touchPointDis:Point=new Point(0,0);
		
		public function CLDTouchObj(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
//			this.addEventListener(TUIOEvent.TUIO_DOWN,downEvent,true);
//			this.addEventListener(TUIOEvent.TUIO_UP,upEvent,true);
//			this.addEventListener(Event.ENTER_FRAME,update);
			
			if(stage){
				//this.stage.addEventListener(TUIOEvent.TUIO_UP,upEvent);
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,initTUIO);
			}
			
			dX=0;
			dY=0;
			dAng=0;
		}
		private function initTUIO(e:Event):void
		{
			//this.stage.addEventListener(TUIOEvent.TUIO_UP,upEvent);
		}
		
		public function set constom(value:Boolean):void
		{
//			value=false;
			if(value){
				this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);
				
				this.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);
				if(stage){
					stage.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);
				}
				
				
				this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
			}else{
				
				this.removeEventListener(TUIOEvent.TUIO_DOWN, this.downEvent);
				this.removeEventListener(TUIOEvent.TUIO_UP, upEvent);
			
				this.removeEventListener(Event.ENTER_FRAME, this.update);
				if(stage){
					stage.removeEventListener(TUIOEvent.TUIO_UP, upEvent);
				}
			}
		}
		
		
		
		protected function downEvent(e:TUIOEvent):void
		{
			this.addBlob(e.ID,e.stageX,e.stageY);
			e.stopPropagation();
			
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
			var thisGL:Point=this.parent.localToGlobal(new Point(this.x,this.y));
			var disPoint:Point=new Point(origX,origY).subtract(thisGL);
			blobs.push({id: id, origX: origX, origY: origY, myOrigX: x, myOrigY: y, disPoint:disPoint});
			if (blobs.length == 1)
			{
				//设置相关变量
				state="dragging";
				//curScaleX=this.scaleX;
				
				curScale=this.scaleX;
				curAngle=this.rotation;
				preX=curPosition.x=x;
				preY=curPosition.y=y;
				blob1=blobs[0];
				dX=0;
				dY=0;
				dAng=0;
				
				
				
			}
			if (blobs.length == 2) //last two point。
			{
				state="maxmin";
				this.curWidth=this.width;
				this.curHeight=this.height;
				blob1=blobs[0]; //first two point。								
				blob2=blobs[1]; //first two point。
				
				this.resetBasePointVar();
				
				
			}
			
		}
		
		protected function removeBlob(id:Number,stageX:Number=0,stageY:Number=0):void
		{
			var obj:Object=null;
			for (var i:Number=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
				{
				
					obj=blobs.splice(i, 1);
				}
			}
			if(blobs.length==0){
				state="none";
				if(obj!=null&&this.parent){
					var thisGloble:Point=this.parent.localToGlobal(new Point(this.x,this.y));
					var cle:CLDEvent=new CLDEvent(CLDEvent.WINUP);
					cle.touchID=id;
					cle.stageX=thisGloble.x+obj[0].disPoint.x;
					cle.stageY=thisGloble.y+obj[0].disPoint.y;
					this.dispatchEvent(cle);
				}
				
				
			}
			
			if (blobs.length == 1)
			{
					state="dragging";
					//curScaleX=this.scaleX;
						
					curScale=this.scaleX;
					curAngle=this.rotation;
					preX=curPosition.x=x;
					preY=curPosition.y=y;
					dX=0;
					dY=0;
					blob1=blobs[0];
						//如果在这里加上清零，那么角度旋转就没有了惯性
						//dX=0;
						//dY=0;
						//dAng=0;						
					var tuioobj1:TUIOObject=TUIO.getObjectById(blob1.id);

						// if not found, then it must have died..
					if (tuioobj1)
					{
//						var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
//						blob1.origX=curPt1.x;
//						blob1.origY=curPt1.y;
						blob1.origX=tuioobj1.x;
						blob1.origY=tuioobj1.y;
					}

			}
			if (blobs.length == 2)
			{
						state="maxmin";
						
						this.curWidth=this.width;
						this.curHeight=this.height;
//						if (blob1.id == blobs[0].id)
//						{
//							blob2=blobs[1];
//						}
//						else
//						{
//							blob2=blobs[0];
//							blob1=blobs[1];
//						}
						blob1=blobs[0]; //first two point。								
						blob2=blobs[1]; //first two point。
				
						this.resetBasePointVar();
			}
		}
		
//		override public function set width(value:Number):void
//		{
//			super.width=value;
//			this.curWidth=value;
//			
//		}
//		override public function set height(value:Number):void
//		{
//			super.height=value;
//			this.curHeight=value;
//			
//		}
//		override public function setSize(w:Number, h:Number):void
//		{
//			super.setSize(w,h);
//			this.curWidth=w;
//			this.curHeight=h;
//		}
		
		private function resetBasePointVar()
		{
			
			curPosition.x=this.x;
			curPosition.y=this.y;			
			curScaleX=this.scaleX;
			curScaleY=this.scaleY;
			
			//curWidth=this.width;
			//curHeight=this.height;
			
			preX=x;
			preY=y;
			preAngle=this.rotation;

			dX=0;
			dY=0;
			dAng=0;
			
			var tuioobj1=TUIO.getObjectById(blob1.id);
			var tuioobj2=TUIO.getObjectById(blob2.id);
		
			if (tuioobj1)
			{
				var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
				blob1.origX=curPt1.x;
				blob1.origY=curPt1.y;
			}
			if (tuioobj2)
			{
				var curPt1:Point=parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));
				blob2.origX=curPt1.x;
				blob2.origY=curPt1.y;
			}
			
			
			
			
		}

		protected function upEvent(e:TUIOEvent):void
		{
			this.removeBlob(e.ID,e.stageX,e.stageY);
			e.stopPropagation();
			trace("upevent");
		}
		
		public function update(e:Event):void
		{
//			switch(state){
//				case "dragging":dragHandler();break;
//				case "maxmin":updatewin();break;
//			}
			if(state=="dragging"){
				dragHandler();
			}else if(state=="maxmin"){
				updatewin();
			}else{
				if (dX != 0 || dY != 0)
				{
					dX=0;
					dY=0;
					dAng=0;
				}
			}
			
		}
		public var curWidth:Number=500;
		public var curHeight:Number=500;
		
		private function dragHandler():void
		{
			    var tuioobj:TUIOObject=TUIO.getObjectById(blob1.id);

				// if not found, then it must have died..
				if (!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}
				trace(tuioobj.x+":"+tuioobj.y);
				
//				/var curPt:Point=parent.globalToLocal(new Point(tuioobj.x, tuioobj.y)); //得到当前触点坐标
				var newX:Number=this.curPosition.x+tuioobj.x-this.blob1.origX;
				var newY:Number=this.curPosition.y+tuioobj.y-this.blob1.origY;
				
				var old:Point=new Point(this.preX,this.preY);
				var newP:Point=new Point(newX,newY);
				var disPoint:Point=newP.subtract(old);
				
				var dis:Number=Math.sqrt(Math.abs(disPoint.x*disPoint.x+disPoint.y*disPoint.y));
				
				if(dis>40){
					this.x=newX;
					this.y=newY;
				}
				
				
			

		
				
		}
		function getAngleTrig(X:Number, Y:Number):Number
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
		
		private function updatewin():void
		{
			    var tuioobj1:TUIOObject=TUIO.getObjectById(blob1.id);
				var tuioobj2:TUIOObject=TUIO.getObjectById(blob2.id);
				// if not found, then it must have died..
				if (!tuioobj1)
				{
					removeBlob(blob1.id);
					return;
				}
				// if not found, then it must have died..
				if (!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}
				//计算当前两点的中心点
				var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
				var curPt2:Point=parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));
				var curCenter:Point=Point.interpolate(curPt1, curPt2, 0.5);
				
				//计算最初的两点的中心点(初始的两点的中心点);
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
				var ang2:int=getAngleTrig(curLine.x, curLine.y);
//				newscale=newscale-0.05;

				var lineBO:Point=curPosition;
				lineBO=lineBO.subtract(origPt2);
				
				var angBO:Number=getAngleTrig(lineBO.x, lineBO.y);
				var angBO:Number=getAngleTrig(lineBO.x, lineBO.y);
				var angB1O1:Number=angBO + (ang2 - ang1);
				
				var linBO:Number=Point.distance(origPt2, curPosition);
				
				var nextCenter:Point=Point.polar(newscale / curScale * linBO, angB1O1 / 180 * Math.PI);
				nextCenter=nextCenter.add(curPt2);
				
				
				var newscaleX:Number=this.curScaleX*(curCenter.x/centerOrig.x);
				var newscaleY:Number=this.curScaleY*(curCenter.y/centerOrig.y);
				
				var newwidth=curWidth*newscale;
				var newheight=curHeight*newscale;
				

				//如果两点之间的距离小于30 左右移动  >30<60 左右上下 >60上下移动
			
				var angle:Number=Math.atan2(origLine.y,origLine.x)

				var angleV:Number=angle * 180/Math.PI;
				if(angleV>90) angleV=180-angleV;
				var angleAbs:Number=Math.abs(angleV);
				
				trace(angleV+"angleVVVV");
				trace(ang1+"angle:::::");
				if(angleAbs>0&&angleAbs<30){
					x=nextCenter.x;
					width=newwidth;
					//Tweener.addTween(this,{x:nextCenter.x,width:newwidth,time:0.06});
				}else if(angleAbs>30&&angleAbs<60){
					x=nextCenter.x;
					width=newwidth;
					y=nextCenter.y;
					height=newheight;
					//Tweener.addTween(this,{x:nextCenter.x,y:nextCenter.y,width:newwidth,height:newheight,time:0.06});
				}else{
					y=nextCenter.y;
					height=newheight;
					//Tweener.addTween(this,{y:nextCenter.y,height:newheight,time:0.06});
				}
				
				
				
				
//				var newscaleX:Number=this.curScaleX*((curPt1.x-curPt2.x)/(origPt1.x-origPt2.x));
//				var newscaleY:Number=this.curScaleY*((curPt1.y-curPt2.y)/(origPt1.y-origPt2.y));
//				this.width=curWidth*newscaleX;
//				this.height=curHeight*newscaleY;
				//Tweener.addTween(this, {width:,height:this.curHeight*newscaleY,time: 0.06, transition: "linear"});
				

				
				

			
			
		}
		
	}
}