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

package com.careland.tuio{
	import caurina.transitions.Tweener;
	
	import com.touchlib.*;
	
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	public dynamic class TUIOSwipe extends Sprite
	{
		public var blobs:Array;		// blobs we are currently interacting with
		private var GRAD_PI:Number = 180.0 / 3.14159;
		public var state:String;
		
		//物体运动开始时的尺寸，角度，位置
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point = new Point(0,0);
		
		public var blob1:Object;				//两个基准点
		public var blob2:Object;		
		
		public var bringToFront:Boolean = true; //是否允许置前		
		public var noScale = true;				//是否允许放大
		public var noRotate = true;			//是否允许旋转
		public var noMove = false;				//是否允许移动
		public var mouseSelection = false;		//是否允许鼠标选中
		public var MaxScale=0.5;					//Scale的最大值
		public var MinScale=0.1;				//Scale的最小值
		public var noMouseMove=false;			//是否允许鼠标操作。
		public var XMove=true;					//是否允许左右拖拽
		public var YMove=true;					//是否允许上下拖拽
		public var MaxMoveDistance:Number=300;	//瞬间允许移动的最大值。
		public var noFloat=false;				//是否有浮起来的效果。
		public var moveTimer:Number=0.06;
		//-----------记录物体运动的增量----
				
		private var preX:Number=9999;				//新增的变量--为了计算真实的dx，dy
		private var preY:Number=9999;
		//private var preX:Number=9999;				//新增的变量--为了计算真实的dx，dy
		//private var preY:Number=9999;
		private var preAngle:Number=9999;
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		
		private var ScaleLimitTweenerflag:Boolean=true;
		private var LastCenterPoint:Point=new Point(0,0);   //最后的注册点
		//Click variables
		
		//DoubleClick variables
		private var doubleclickDuration:Number = 500;
		//private var singleclickRadius:Number = 50;
		private var clickRadius:Number = 30;		
		private var lastClickTime:Number = 0;
		private var lastX:Number=0;
		private var lastY:Number=0;
		
		
		protected var vh:String="h";// h横向 v纵向
		
		public function TUIOSwipe()
		{
			state = "none";

			blobs = new Array();
			this.addEventListener(TUIOEvent.TUIO_MOVE, moveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, downEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, upEvent, false, 0, true);	
			//this.addEventListener(TUIOEvent.TUIO_CLICK, clickEvent, false, 0, true);									
			
		
 		
 			
			
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);		
		
			dX = 0;
			dY = 0;			
			dAng = 0;
		}

		
		/*
		----------------添加一个触点到队列--------------------------------------------
		*/
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
			if(blobs.length == 1)
			{				
				//设置相关变量
				state = "dragging";
				curScale = this.scaleX;
				curAngle = this.rotation;					
				preX=curPosition.x = x;
				preY=curPosition.y = y;				
				blob1 = blobs[0];				
				dX=0;
				dY=0;
				dAng=0;	
				// 9999
				if (this.noFloat) return;
				//----------------------------------添加阴影，浮起来效果----------------------------------------------
				
				//----------------------------------添加阴影，浮起来效果-----------------------------------------------
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
					{
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
					}
					//end dispatch Click Event-------------------------------------------------------------------
					blobs.splice(i, 1);
					
					if(blobs.length == 0)
					{
						state = "none";

						if (this.noFloat)	return;		
						//--------------去掉阴影---------------------------------------------------
						
						this.filters=new Array();
						//--------------去掉阴影---------------------------------------------------			
					}
					if(blobs.length == 1)  
					{
						state = "dragging";
						curScale = this.scaleX;
						curAngle = this.rotation;					
						preX=curPosition.x = x;
						preY=curPosition.y = y;	
						dX=0;
						dY=0;					
						blob1 = blobs[0];	
						//如果在这里加上清零，那么角度旋转就没有了惯性
						//dX=0;
						//dY=0;
						//dAng=0;						
						var tuioobj1:TUIOObject = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					
				}
			}			
		}
				//根据其中一个基准点获取另外一个基准点。
		
		private function getOtherPoint(blob:Object)
		{
			var MaxsDistance:Number= 0;
            var m:int=0;
            for (var i:int=0; i < blobs.length; i++)
            {
            	var tempDistance:Number= (blobs[i].origX- blob.origX) * (blobs[i].origX- blob.origX)
               							 + (blobs[i].origY - blob.origY) * (blobs[i].origY- blob.origY);
               	if (MaxsDistance < tempDistance)
               	{
                   	MaxsDistance = tempDistance;
                   	m = i;
               	}   
            }
			if (blob.id==blob1.id)
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
			curScale = this.scaleX;
			curAngle = this.rotation;					
			curPosition.x = x;
			curPosition.y = y;	
			
			preX=x;
			preY=y;
			preAngle=this.rotation;			
				
			dX=0;
			dY=0;
			dAng=0;	
			
			var tuioobj1 = TUIO.getObjectById(blob1.id);
			var tuioobj2 = TUIO.getObjectById(blob2.id);			
			var midPoint:Point = Point.interpolate(this.globalToLocal(new Point(tuioobj1.x, tuioobj1.y)),this.globalToLocal(new Point(tuioobj2.x, tuioobj2.y)),0.5);
			//设置注册点
			//setRegistration(midPoint.x,midPoint.y);
			
			if(tuioobj1)
			{
				var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));	
				blob1.origX = curPt1.x;
				blob1.origY = curPt1.y;
			}	
			if(tuioobj2)
			{
				var curPt1:Point = parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));	
				blob2.origX = curPt1.x;
				blob2.origY = curPt1.y;
			}	
		}
	
//------------多点触控消息处理--------------------------------------------------------------------------------
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
		
		public function moveHandler(e:TUIOEvent):void
		{
			
			//this.x=e.localX;
			e.stopPropagation();	
		}
		public function clickEvent(e:TUIOEvent):void
		{
			
			if (lastClickTime==0)
			{
				lastClickTime=getTimer();
				lastX=e.stageX;
				lastY=e.stageY;
				
			}
			else
			{
				var distance:Number=((lastX-e.stageX)*(lastX-e.stageX))+((lastY-e.stageY)*(lastY-e.stageY));
				if (Math.abs(lastClickTime-getTimer())<this.doubleclickDuration && distance < clickRadius*clickRadius)
				{
					var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
					if (tuioobj)
					{
						var localPoint:Point = this.parent.globalToLocal(new Point(x, y));							
						this.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_DOUBLECLICK,true,false,tuioobj.x,tuioobj.y,localPoint.x, localPoint.y, 0, 0,this,false,false,false,true,0,tuioobj.TUIOClass,tuioobj.ID,tuioobj.sID,tuioobj.angle));
					}
				}
			}
			if (flash.utils.getTimer())
			this.lastClickTime=flash.utils.getTimer();		
			//end check double Click	
		}
		
//-end-----------多点触控消息处理--------------------------------------------------------------------------------


//------------鼠标触控消息处理--------------------------------------------------------------------------------		
		public function mouseDownEvent(e:MouseEvent):void
		{
			if (noMouseMove) return;
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			if(!noMove)
				{	
					//this.startDrag();	
				}
		
				
		
			e.stopPropagation();
		}
		
		

		
		
//end----------多点触控消息处理--------------------------------------------------------------------------------

		
		public function released(dx:Number, dy:Number, dang:Number)
		{
			
		}
		protected function resetRotation():void{
			
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
				curScale = this.scaleX;
				curAngle = this.rotation;					
				preX=curPosition.x = x;
				preY=curPosition.y = y;	
				dX=0;
				dY=0;					
				blob1 = blobs[0];
			}
		}
		private function update(e:Event):void
		{
			if (parent==null) return;
			if (blobs.length>1) lastClickTime=0;
			//trace(Tweener);
			//-----------------防止过大，过小缩放---------------------------
			
			//end-----------------防止过大，过小缩放---------------------------
			if(state == "dragging")			
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}
				
				var curPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));	//得到当前触点坐标
				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				

				//计算需要移动的距离
				var tempx:Number,tempy:Number;
				if(!noMove)
				{
					if (this.XMove)
						tempx = curPosition.x + (curPt.x - (blob1.origX ));		
					else
						tempx = x;	
					if (this.YMove)
						tempy = curPosition.y + (curPt.y - (blob1.origY ));		
					else
						tempy = y;
				}
				else
				{
					tempx=x;
					tempy=y;
				}
				
				LastCenterPoint=curPt;
				
				dX=x-preX;
				dY=y-preY;
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
				if (Math.abs(dX)<MaxMoveDistance && Math.abs(dY)<MaxMoveDistance && ScaleLimitTweenerflag)				//限制瞬间移动
				{
					//curPt.y>this.y//如果y坐标在MenuGroup范围内 才移动，如果在活动区就不移动
					
					//curPt.x>this.x  如果x坐标在Menu2Level2级菜单区才可以移动
					if(vh=="h"&&curPt.y>this.y){
						Tweener.addTween(this,{x:tempx, time:moveTimer,transition:"linear"});
					}else if(vh=="v"&&curPt.x>this.x){
						Tweener.addTween(this,{y:tempy, time:moveTimer,transition:"linear"});
					}		
				}
				else
				{
					dX=0;
					dY=0;
				}
				preX=x;
				preY=y;

			} else {
				if(dX != 0 || dY != 0)
				{
					trace("dy"+dY);
					this.released(dX, dY, dAng);
					dX = 0;
					dY = 0;
					dAng = 0;
				}
			}

		}	
				
	}
}

