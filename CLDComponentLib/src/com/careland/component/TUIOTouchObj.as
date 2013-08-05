//-----------------------------------------------------------------------
//名称：可旋转基类-----------------------------
//子类：imageobject
//作者：邓华芹
//修改日期：2009年4月3日
//添加浮起来的阴影效果，惯性滑动修复，平滑效果
//增加X或者Y方向的移动限定	2009年3月24
//取基准点做了修改
//角度变化，移动距离做了限定  MaxMoveDistance:Number=100;
//增加了double click消息
//以相距最远两个点为基准点
//-----------------------------------------------------------------------

package com.careland.component
{
	import com.touchlib.*;
	import caurina.transitions.Tweener;
	
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;


	public dynamic class TUIOTouchObj extends CLDBaseComponent
	{
		public var blobs:Array; // blobs we are currently interacting with
		private var GRAD_PI:Number=180.0 / 3.14159;
		public var state:String;

		//物体运动开始时的尺寸，角度，位置
		protected var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point=new Point(0, 0);

		public var blob1:Object; //两个基准点
		public var blob2:Object;

		public var bringToFront:Boolean=true; //是否允许置前		
		public var noScale=false; //是否允许放大
		public var noRotate=false; //是否允许旋转
		public var noMove=false; //是否允许移动
		public var mouseSelection=false; //是否允许鼠标选中
		public var MaxScale=1.5; //Scale的最大值
		public var MinScale=0.5; //Scale的最小值
		public var noMouseMove=true; //是否允许鼠标操作。
		public var XMove=true; //是否允许左右拖拽
		public var YMove=true; //是否允许上下拖拽
		public var MaxMoveDistance:Number=300; //瞬间允许移动的最大值。
		public var noFloat=false; //是否有浮起来的效果。
		public var moveTimer:Number=0.06;
		//-----------记录物体运动的增量----

		private var preX:Number=9999; //新增的变量--为了计算真实的dx，dy
		private var preY:Number=9999;
		//private var preX:Number=9999;				//新增的变量--为了计算真实的dx，dy
		//private var preY:Number=9999;
		private var preAngle:Number=9999;
		public var dX:Number;
		public var dY:Number;
		public var dAng:Number;

		private var ScaleLimitTweenerflag:Boolean=true;
		private var LastCenterPoint:Point=new Point(0, 0); //最后的注册点
		//Click variables

		//DoubleClick variables
		private var doubleclickDuration:Number=500;
		//private var singleclickRadius:Number = 50;
		private var clickRadius:Number=30;
		private var lastClickTime:Number=0;
		private var lastX:Number=0;
		private var lastY:Number=0;

		public function TUIOTouchObj()
		{
			state="none";

			blobs=new Array();
			this.addEventListener(TUIOEvent.TUIO_MOVE, moveHandler, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_DOWN, downEvent, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_CLICK, clickEvent, false, 0, true);
			this.addEventListener(TUIOEvent.TUIO_DOUBLECLICK, doubleclickEvent, false, 0, true);

//			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);
//			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);
//
//			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.DoubleClick);
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);

			dX=0;
			dY=0;
			dAng=0;
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(TUIOEvent.TUIO_MOVE, moveHandler);
			this.removeEventListener(TUIOEvent.TUIO_DOWN, downEvent);
			this.removeEventListener(TUIOEvent.TUIO_UP, upEvent);
			this.removeEventListener(TUIOEvent.TUIO_CLICK, clickEvent);
			this.removeEventListener(TUIOEvent.TUIO_DOUBLECLICK, doubleclickEvent);

		}

		public function setProperty2(x_2:Number, y_2:Number, scaleX2:Number, scaleY2:Number, rotation2:Number):void
		{
			if (rotation2 - rotation > 180)
				rotation2-=360;
			if (rotation2 - rotation < -180)
				rotation2+=360;
			if (noScale)
			{
				scaleX2=scaleY2=scaleX;
			}
			if (noMove)
			{
				x_2=x;
				y_2=y;
			}
			if (this.noRotate)
			{
				rotation2=rotation;
			}
			
			var newWidth:Number=this.width*scaleX2;
			var newHeight:Number=this.height*scaleY2;
			
			//Tweener.addTween(this, {x: x_2, y: y_2, width:newWidth, height: newHeight, rotation: rotation2, time: this.moveTimer, transition: "linear"});
			Tweener.addTween(this, {x: x_2, y: y_2, scaleX: scaleX2, scaleY: scaleY2, rotation: rotation2, time: this.moveTimer, transition: "linear"});

		}

		/*
		----------------添加一个触点到队列--------------------------------------------
		*/
		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			//防止重复添加
			for (var i=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
					return;
			}
			//添加一个触点到队列		
			blobs.push({id: id, origX: origX, origY: origY, myOrigX: x, myOrigY: y});
			if (blobs.length == 1)
			{
				//设置相关变量
				state="dragging";
				curScale=this.scaleX;
				curAngle=this.rotation;
				preX=curPosition.x=x;
				preY=curPosition.y=y;
				blob1=blobs[0];
				dX=0;
				dY=0;
				dAng=0;
				// 9999
				if (this.noFloat)
					return;
				//----------------------------------添加阴影，浮起来效果----------------------------------------------
				Tweener.addTween(this, {scaleX: (15 / width * scaleX) + scaleX, scaleY: (15 / height * scaleY) + scaleY, time: 0.3, transition: "easeinoutquad"});
				var dropshadow:DropShadowFilter=new DropShadowFilter(10, 45, 0x000000, 0.70, 15, 15);
				this.filters=new Array(dropshadow);
					//----------------------------------添加阴影，浮起来效果-----------------------------------------------
			}
			//else if(blobs.length == 2)			//first two point。
			if (blobs.length == 2) //last two point。
			{
				state="rotatescale";

				blob1=blobs[0]; //first two point。								
				blob2=blobs[1]; //first two point。
				this.resetBasePointVar();
			}
			if (blobs.length >= 3)
			{
				state="rotatescale";
				var tuioobj1=TUIO.getObjectById(blob1.id);
				var tuioobj2=TUIO.getObjectById(blob2.id);
				var tuioobj3=TUIO.getObjectById(blobs[blobs.length - 1].id);
				var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
				var curPt2:Point=parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));
				var curPt3:Point=parent.globalToLocal(new Point(tuioobj3.x, tuioobj3.y));

				var Distance1_2:Number=(curPt1.x - curPt2.x) * (curPt1.x - curPt2.x) + (curPt1.y - curPt2.y) * (curPt1.y - curPt2.y);
				var Distance1_3:Number=(curPt1.x - curPt3.x) * (curPt1.x - curPt3.x) + (curPt1.y - curPt3.y) * (curPt1.y - curPt3.y);
				var Distance2_3:Number=(curPt2.x - curPt3.x) * (curPt2.x - curPt3.x) + (curPt2.y - curPt3.y) * (curPt2.y - curPt3.y);
				if (Distance1_3 > Distance1_2 && Distance1_3 > Distance2_3)
				{
					blob2=blobs[blobs.length - 1];
					this.resetBasePointVar();
				}
				if (Distance2_3 > Distance1_2 && Distance2_3 > Distance1_3)
				{
					blob1=blobs[blobs.length - 1];
					this.resetBasePointVar();
				}

			}
		}

		/*
		----------------从队列去掉一个触点--------------------------------------------
		*/
		public function removeBlob(id:Number):void
		{
			for (var i:Number=0; i < blobs.length; i++)
			{
				if (blobs[i].id == id)
				{
					//-----dispatch Click Event----------------
					{
						var tuioobj:TUIOObject=TUIO.getObjectById(id);
						if (tuioobj)
						{
							var distance:Number=((tuioobj.oldX - tuioobj.x) * (tuioobj.oldX - tuioobj.x)) + ((tuioobj.oldY - tuioobj.y) * (tuioobj.oldY - tuioobj.y));
							if (distance < clickRadius * clickRadius)
							{
								var localPoint:Point=this.parent.globalToLocal(new Point(x, y));
								this.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_CLICK, true, false, tuioobj.x, tuioobj.y, localPoint.x, localPoint.y, 0, 0, this, false, false, false, true, 0, tuioobj.TUIOClass, tuioobj.ID, tuioobj.sID, tuioobj.angle));
							} // localPoint.x, localPoint.y, 0, 0, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));						
						}
					}
					//end dispatch Click Event-------------------------------------------------------------------
					blobs.splice(i, 1);

					if (blobs.length == 0)
					{
						state="none";

						if (this.noFloat)
							return;
						//--------------去掉阴影---------------------------------------------------
						if (scaleX - (15 / width * scaleX) > this.MinScale && scaleY - (15 / height * scaleY) > this.MinScale)
							Tweener.addTween(this, {scaleX: scaleX - (15 / width * scaleX), scaleY: scaleY - (15 / height * scaleY), time: 0.3, transition: "easeinoutquad"});
						else
						{
							if (scaleX - (15 / width * scaleX) < this.MinScale && scaleY - (15 / height * scaleY) < this.MinScale)
								Tweener.addTween(this, {scaleX: MinScale, scaleY: MinScale, time: 0.3, transition: "easeinoutquad"});
							else
							{
								if (scaleX - (15 / width * scaleX) < this.MinScale)
									Tweener.addTween(this, {scaleX: MinScale, scaleY: scaleY - (15 / height * scaleY), time: 0.3, transition: "easeinoutquad"});
								else
									Tweener.addTween(this, {scaleX: scaleX - (15 / width * scaleX), scaleY: MinScale, time: 0.3, transition: "easeinoutquad"});
							}
						}
						this.filters=new Array();
							//--------------去掉阴影---------------------------------------------------			
					}
					if (blobs.length == 1)
					{
						state="dragging";
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
							var curPt1:Point=parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));

							blob1.origX=curPt1.x;
							blob1.origY=curPt1.y;
						}

					}
					if (blobs.length == 2)
					{
						state="rotatescale";
						if (blob1.id == blobs[0].id)
						{
							blob2=blobs[1];
						}
						else
						{
							blob2=blobs[0];
							blob1=blobs[1];
						}
						this.resetBasePointVar();
					}
					if (blobs.length >= 3)
					{
						state="rotatescale";
						if (id == blob1.id)
						{
							getOtherPoint(blob2);
							this.resetBasePointVar();
						}
						if (id == blob2.id)
						{
							getOtherPoint(blob1);
							this.resetBasePointVar();
						}

					}
					return;
				}
			}
		}

		//根据其中一个基准点获取另外一个基准点。

		private function getOtherPoint(blob:Object)
		{
			var MaxsDistance:Number=0;
			var m:int=0;
			for (var i:int=0; i < blobs.length; i++)
			{
				var tempDistance:Number=(blobs[i].origX - blob.origX) * (blobs[i].origX - blob.origX) + (blobs[i].origY - blob.origY) * (blobs[i].origY - blob.origY);
				if (MaxsDistance < tempDistance)
				{
					MaxsDistance=tempDistance;
					m=i;
				}
			}
			if (blob.id == blob1.id)
			{
				blob2=blobs[m];
			}
			else
			{
				blob1=blobs[m];
			}
		}

		private function resetBasePointVar()
		{
			curScale=this.scaleX;
			curAngle=this.rotation;
			curPosition.x=x;
			curPosition.y=y;

			preX=x;
			preY=y;
			preAngle=this.rotation;

			dX=0;
			dY=0;
			dAng=0;

			var tuioobj1=TUIO.getObjectById(blob1.id);
			var tuioobj2=TUIO.getObjectById(blob2.id);
//			var midPoint:Point=Point.interpolate(this.globalToLocal(new Point(tuioobj1.x, tuioobj1.y)), 
//			this.globalToLocal(new Point(tuioobj2.x, tuioobj2.y)), 0.5);
			//设置注册点
			//setRegistration(midPoint.x,midPoint.y);

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

//------------多点触控消息处理--------------------------------------------------------------------------------
		public function downEvent(e):void
		{
			if (e.stageX == 0 && e.stageY == 0)
				return;
			if (!parent)
				return;
			var curPt:Point=parent.globalToLocal(new Point(e.stageX, e.stageY));
			addBlob(e.ID, curPt.x, curPt.y);

			if (bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren - 1);

			if (mouseSelection)
			{
				//this.alpha=0.5;				
			}

			e.stopPropagation();
		}

		public function upEvent(e:TUIOEvent):void
		{

			//if (var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);)
			if (!parent)
				return;
			removeBlob(e.ID);

			e.stopPropagation();

		}

		public function moveHandler(e:TUIOEvent):void
		{
			e.stopPropagation();
		}

		public function clickEvent(e:TUIOEvent):void
		{
			trace("Click");
			//if ()
			//check double Click
			if (lastClickTime == 0)
			{
				lastClickTime=getTimer();
				lastX=e.stageX;
				lastY=e.stageY;

			}
			else
			{
				var distance:Number=((lastX - e.stageX) * (lastX - e.stageX)) + ((lastY - e.stageY) * (lastY - e.stageY));
				if (Math.abs(lastClickTime - getTimer()) < this.doubleclickDuration && distance < clickRadius * clickRadius)
				{
					var tuioobj:TUIOObject=TUIO.getObjectById(e.ID);
					if (tuioobj)
					{
						var localPoint:Point=this.parent.globalToLocal(new Point(x, y));
						this.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_DOUBLECLICK, true, false, tuioobj.x, tuioobj.y, localPoint.x, localPoint.y, 0, 0, this, false, false, false, true, 0, tuioobj.TUIOClass, tuioobj.ID, tuioobj.sID, tuioobj.angle));
					}
				}
			}
			if (flash.utils.getTimer())
				this.lastClickTime=flash.utils.getTimer();
			//end check double Click	
		}

		public function doubleclickEvent(e:TUIOEvent):void
		{
			trace("doubleClick");
			//e.stopPropagation();	
		}

//-end-----------多点触控消息处理--------------------------------------------------------------------------------


//------------鼠标触控消息处理--------------------------------------------------------------------------------		
		public function mouseDownEvent(e:MouseEvent):void
		{
			if (noMouseMove)
				return;
			if (e.stageX == 0 && e.stageY == 0)
				return;

			if (!noMove)
			{
				this.startDrag();
			}
			if (bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren - 1);

			if (mouseSelection)
			{
				var dropshadow:DropShadowFilter=new DropShadowFilter(0, 45, 0x000000, 0.70, 15, 15);
				this.filters=new Array(dropshadow);
				Tweener.addTween(this, {scaleX: scaleX * 1.05, scaleY: scaleY * 1.05, time: 0.3, transition: "easeinoutquad"});
			}

			e.stopPropagation();
		}

		public function mouseUpEvent(e:MouseEvent):void
		{
			if (noMouseMove)
				return;
			if (!noMove)
			{
				this.stopDrag();
				e.stopPropagation();
					//trace(lastdX);
					//trace(lastdY);
					//this.released(lastdX,lastdY,0);	
			}
			if (mouseSelection)
			{
				var targetRotation:int=Math.random() * 180 - 90;
				var targetScale:Number=(Math.random() * 0.4) + 0.3;
				this.filters=new Array();
				Tweener.addTween(this, {scaleX: scaleX / 1.05, scaleY: scaleY / 1.05, time: 0.2, transition: "easeinoutquad"});
			}
			//this.released(2,2,0);
		}

		public function mouseMoveHandler(e:MouseEvent):void
		{
			if (noMouseMove)
				return;

		}

//end----------多点触控消息处理--------------------------------------------------------------------------------

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

		public function released(dx:Number, dy:Number, dang:Number)
		{

		}

		protected function resetRotation():void
		{

		}

		public function DoubleClick()
		{
			trace("DoubleClick");
		}

		private function ScaleLimit()
		{
			ScaleLimitTweenerflag=true;
			if (state == "dragging")
			{
				curScale=this.scaleX;
				curAngle=this.rotation;
				preX=curPosition.x=x;
				preY=curPosition.y=y;
				dX=0;
				dY=0;
				blob1=blobs[0];
			}
		}

		public function update(e:Event):void
		{
			if (parent == null)
				return;
			if (blobs.length > 1)
				lastClickTime=0;
			//trace(Tweener);
			//-----------------防止过大，过小缩放---------------------------
			if ((state == "dragging" || state == "none") && (ScaleLimitTweenerflag) && (LastCenterPoint.x != 0 || LastCenterPoint.y != 0))
			{
				if (MinScale - scaleX > 0.001)
				{
					var ObjectPosition=new Point(x, y);
					var lineBO:Point=ObjectPosition.subtract(LastCenterPoint);
					var lenBO:Number=Point.distance(ObjectPosition, LastCenterPoint);

					var angBO:Number=this.getAngleTrig(lineBO.x, lineBO.y);
					var O1:Point=Point.polar(lenBO * MinScale / scaleX, angBO / 180 * Math.PI)

					O1=O1.add(LastCenterPoint);

					ScaleLimitTweenerflag=false;

					Tweener.addTween(this, {x: O1.x, y: O1.y, scaleX: MinScale, scaleY: MinScale, time: 1, transition: "easeOutQuart", onComplete: ScaleLimit, onOverwrite: ScaleLimit});
				}
				if (scaleX - MaxScale > 0.010)
				{

					//基准点中心点坐标 B（LastCenterPoint）
					//对象中心点坐标O（x，y）ObjectPosition
					//目前的放大倍数 scaleX
					//将要把他重置的放大倍数 MaxScale
					//将要把他重置的位置O1（即为我们所求） 
					var ObjectPosition=new Point(x, y);
					var lineBO:Point=ObjectPosition.subtract(LastCenterPoint);
					var lenBO:Number=Point.distance(ObjectPosition, LastCenterPoint);

					var angBO:Number=this.getAngleTrig(lineBO.x, lineBO.y);
					var O1:Point=Point.polar(lenBO * MaxScale / scaleX, angBO / 180 * Math.PI)
					O1=O1.add(LastCenterPoint);
					ScaleLimitTweenerflag=false;
					//trace("x:",x," to-x",O1.x);
					//trace("y:",y," to-y",O1.y);
					Tweener.addTween(this, {x: O1.x, y: O1.y, scaleX: MaxScale, scaleY: MaxScale, time: 1, transition: "easeOutQuart", onComplete: ScaleLimit, onOverwrite: ScaleLimit});
						//Tweener.addTween(this,{scaleX:MaxScale,scaleY:MaxScale, time:0.5,transition:"easeOutCirc",onComplete:ScaleLimit,onOverwrite:ScaleLimit});
				}
			}
			//end-----------------防止过大，过小缩放---------------------------
			if (state == "dragging")
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
				oldX=x;
				oldY=y;


				//计算需要移动的距离
				var tempx:Number, tempy:Number;
				if (!noMove)
				{
					if (this.XMove)
						tempx=curPosition.x + (curPt.x - (blob1.origX));
					else
						tempx=x;
					if (this.YMove)
						tempy=curPosition.y + (curPt.y - (blob1.origY));
					else
						tempy=y;
				}
				else
				{
					tempx=x;
					tempy=y;
				}

				LastCenterPoint=curPt;

				dX=x - preX;
				dY=y - preY;
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
					Tweener.addTween(this, {x: tempx, y: tempy, time: moveTimer, transition: "linear"});
				}
				else
				{
					dX=0;
					dY=0;
				}
				preX=x;
				preY=y;

			}
			else if (state == "rotatescale")
			{
				var tuioobj1=TUIO.getObjectById(blob1.id);
				var tuioobj2=TUIO.getObjectById(blob2.id);
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
				var ang2:int=getAngleTrig(curLine.x, curLine.y);

				LastCenterPoint=curCenter;

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
				dX=x - preX;
				dY=y - preY;


				//var flag:Boolean;
				//flag=false;


				//关键是计算出中心点移动的坐标，即dx，dy。
				//点O（curPosition）为原始对象的中心点。
				//点A（origPt1）为基准点blob1的初始点。
				//点B（origPt2）为基准点blob2的初始点
				//点O1（nextCenter）使我们要求出的点的坐标，。
				//点A1（curPt1）为基准点blob1的目前所在点。
				//点B1（curPt2）为基准点blob2的目前所在点
				//已知 OAB跟O1A1B1为相似三角形，O1A1B1为OAB的 n=newscale/scaleX倍大小。

				//计算角AO的角度
				var lineBO:Point=curPosition;
				lineBO=lineBO.subtract(origPt2);
				var angBO:Number=getAngleTrig(lineBO.x, lineBO.y);
				var angB1O1:Number=angBO + (ang2 - ang1);
				var linBO:Number=Point.distance(origPt2, curPosition);
				var nextCenter:Point=Point.polar(newscale / curScale * linBO, angB1O1 / 180 * Math.PI);
				nextCenter=nextCenter.add(curPt2);

				if (newscale > MaxScale * 1.5)
				{
					newscale=MaxScale * 1.5;
					newscale=MaxScale * 1.5;
					nextCenter.x=x;
					nextCenter.y=y;
					ang2=ang1;
					this.resetBasePointVar();
						//flag=true;					
				}
				setProperty2(nextCenter.x, nextCenter.y, newscale, newscale, curAngle + (ang2 - ang1));

				preX=x;
				preY=y;
				preAngle=rotation;

			}
			else
			{
				if (dX != 0 || dY != 0)
				{
					this.released(dX, dY, dAng);
					dX=0;
					dY=0;
					dAng=0;
				}
			}

		}

	}
}

