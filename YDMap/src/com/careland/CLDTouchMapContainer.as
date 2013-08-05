//-----------------------------------------------------------------------
//名称：可旋转基类-----------------------------
//子类：imageobject
//修改日期：2009年5月27日
//修改时间：2009.12.24。圣诞快乐
/*
 * @author 邓华芹
 * @modify:sofa
 * */
//添加浮起来的阴影效果，惯性滑动修复，平滑效果
//增加X或者Y方向的移动限定	2009年3月24
//取基准点做了修改
//角度变化，移动距离做了限定  MaxMoveDistance:Number=100;
//增加了double click消息
//以相距最远两个点为基准点
//修改了旋转惯性问题
//修改了放大到最大出现的旋转bug
//-----------------------------------------------------------------------

package com.careland
{
	import caurina.transitions.Tweener;
	
	import com.careland.events.DynamicEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDCircleSprite;
	import com.careland.layer.CLDMutiRectSprite;
	import com.careland.layer.CLDRectSprite;
	import com.careland.util.CLDConfig;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.LocalConnection;

	public dynamic class CLDTouchMapContainer extends CLDMapContainer
	{
		public var blobs:Array=[]; // blobs we are currently interacting with
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


		private var touchSprite:Sprite=new Sprite;
		
		private var isTwo:Boolean=false; //是否放大地图
		
		private var circleSprite:CLDCircleSprite;
		
		private var rectSprite:CLDRectSprite;
		
		private var mutirectSprite:CLDMutiRectSprite;
		
		private var isDrawState:Boolean=false;//判断是否是画圆的状态下
		
		
		private var preTouchPoint:Point;//第一次触控的坐标
		
		private var lastPoint:Point=new Point(0,0);//最后一次按下的点
		
		private  var drgSprite:Sprite=new Sprite;

		public function CLDTouchMapContainer(config:CLDConfig, center:Point, vzoom:int)
		{
			super(config, center, vzoom);
			this.addChild(touchSprite);
			this.addChild(drgSprite);
			this.contentEnabled=false;
			this.addEventListener("loadMap",loadMap);
			
		}
		//加载地图
		private function loadMap(e:DynamicEvent):void
		{
			var vcenter:Point=e.center;
			
				var bit:Bitmap=this.drawCurrent();
				this.addChild(bit);
				this.setChildIndex(bit,this.numChildren-1);	
			
			
//			this.addEventListener("imgLoaded",function():void{
//				ImgLoaded(bit);
//				updateLayer();
//			});
//			if(vcenter){
//				loadMapPic(vcenter);
//			}else{
//				loadMapPic();
//			}
			
			loadMapPic();
			ImgLoaded(bit);
			updateLayer();
		}
		
		public function set _center(p:Point):void
		{
			this.newCenter=p;	
			this.invalidate();
		}
		public function get _center():Point
		{
			return this.newCenter;	
		}
	
		
		
		override protected function mapChange(e:MapEvent):void
		{
			super.mapChange(e);
			this.newCenter=this.mapConfig.center;
			this.loadImg(this.newCenter);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			this.addEventListener(TUIOEvent.TUIO_DOWN, downEvent);
			this.addEventListener(TUIOEvent.TUIO_UP, touchUp);
//			this.addEventListener("drawCircle",drawCircle);
//			this.addEventListener("drawRect",drawRect);
//			this.addEventListener("drawMutiRect",drawMutiRect);
			this.addChild(this.touchSprite);
			
			
		}
		
		
		
		

//----------设置对象的各个属性---------------------------------------
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

			Tweener.addTween(this.touchSprite, {x: x_2, y: y_2, scaleX: scaleX2, scaleY: scaleY2, rotation: rotation2, time: this.moveTimer, transition: "linear"});
		}


		private function getScreenPoint(center:Point, vscale:Number, sw:Number, sh:Number):Point
		{
			
			var stagePoint:Point=CLDConfig.instance().toScreenPoint(center.x, center.y, sw, sh, vscale, center.x, center.y,mapConfig.tilemapindex,mapConfig.wscale,mapConfig.hscale);
			var sp:Point=this.content.globalToLocal(stagePoint);
			return sp;
		}
		
		
		/*
		----------------添加一个触点到队列--------------------------------------------
		*/
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
				
//				//设置相关变量
				state = "dragging";
				curScale = 1;
				curAngle = 0;	
				drgSprite.x=0;
				drgSprite.y=0;				
				preX=curPosition.x = this.drgSprite.x;
				preY=curPosition.y = this.drgSprite.y;	
//				preX=curPosition.x = this.content.x;
//				preY=curPosition.y = this.content.y;				
				blob1 = blobs[0];	
							
				dX=0;
				dY=0;
				dAng=0;	
				preTouchPoint=new Point(origX,origY);
				this.drgSprite.addChild(this.drawCurrent());
				drgSprite.alpha=.3;
				
				var filt:GlowFilter=new GlowFilter();
				drgSprite.filters=[filt];
				this.addEventListener(Event.ENTER_FRAME,update);
				
			} 
			if (blobs.length == 2)
			{
				state="rotatescale";

				blob1=blobs[0];
				blob2=blobs[1];
				this.resetBasePointVar();
				
				
				//只截取可视范围的
				var lp:Point=this.content.globalToLocal(new Point(0, 0));


				var screenPoint:Point=getScreenPoint(this.newCenter, this.mapConfig.scale, this.width, this.height);

				screenPoint.x-=this.width / 2;
				screenPoint.y-=this.height / 2;
			   
				
				
				var bit:Bitmap=this.drawCurrent();

				touchSprite.scaleX=1;
				touchSprite.scaleY=1;
				touchSprite.x=0;
				touchSprite.y=0;
				touchSprite.alpha=.2;
				this.addChild(this.touchSprite);
					this.setChildIndex(this.touchSprite,this.numChildren-1);
				this.touchSprite.addChild(bit);
				curScale=1;
				curPosition=new Point(0,0);
				this.curAngle=0;
				
				//this.content.visible=false;
				isTwo=true;
				//this.addEventListener("drawCircle",drawCircle);
				
				//加载
				

			}
			

		}

		private function resetBasePointVar()
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

		public function getZoom():void
		{

		}
		
		override public function draw():void
		{
			if(this.isDispose)return;
			
			super.draw();
			
			var dy:DynamicEvent=new DynamicEvent("loadMap");
				dy.center=newCenter;
				this.dispatchEvent(dy);
			trace("reload");
			//this.loadMapPic(this.newCenter,false);
			
		}
		
		
		public function loadImg(newCenter:Point):void
		{
				var dy:DynamicEvent=new DynamicEvent("loadMap");
				dy.center=newCenter;
				this.dispatchEvent(dy);
		}
		
		
		
		private function ImgLoaded(bit:Bitmap):void
		{
				this.removeEventListener("imgLoaded",ImgLoaded);
				var blur:BlurFilter=new BlurFilter(0,0);
				

				Tweener.addTween(blur,{blurX:10,blurY:10,time:1,onCompleteParams:[bit,this],
					onComplete:complete,onUpdate:onUpdate,onUpdateParams:[bit,blur]});
				
				var blur1:BlurFilter=new BlurFilter(10,10);
				
				function complete(bit:Bitmap,obj:DisplayObject):void
				{
					
					removeChild(bit);
					bit.bitmapData.dispose();
					bit=null;
				}
				function onUpdate(bit:Bitmap,blur:BlurFilter):void
				{
					bit.alpha-=0.05;
//					bit.filters=null;
//					bit.filters=[blur];
				}	
		}
		
		/*
		----------------从队列去掉一个触点--------------------------------------------
		*/
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
						curScale = 1
						curAngle = 0;					
						preX=curPosition.x = this.drgSprite.x;
						preY=curPosition.y = this.drgSprite.y;	
//						preX=curPosition.x = this.content.x;
//						preY=curPosition.y = this.content.y;
						dX=0;
						dY=0;	
						//dAng=0;		
									
						blob1 = blobs[0];	
											
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
						this.resetBasePointVar();
					}


				}

			}
			//如果是0
			if (blobs.length == 0)
			{
				
				
				this.deletebitmapSprite(drgSprite);
				
				
				var newPoint:Point=this.lastPoint;
				
				var disPoint:Point=newPoint.subtract(prePoint);
				
				var isMove:Boolean=Math.sqrt(Math.abs(disPoint.x*disPoint.x+disPoint.y*disPoint.y))>60;
				
				var moveDistance:Number=Math.sqrt(Math.abs(drgSprite.x*drgSprite.x)+Math.abs(drgSprite.y*drgSprite.y));
			
				if(moveDistance>30){
					
					var screenPoint:Point=this.config.toScreenPoint(this.newCenter.x,this.newCenter.y,width,height,this.mapConfig.scale,newCenter.x,newCenter.y,this.mapConfig.tilemapindex,this.mapConfig.wscale,this.mapConfig.hscale);
					
					
					var np0:Point=new Point(0,0);
					np0.x=screenPoint.x-disPoint.x;
					np0.y=screenPoint.y-disPoint.y;
			
					var np:Point=this.config.toMapPoint(np0.x,np0.y,this.width,this.height,this.newCenter,this.mapConfig);

					newCenter=np;
				
					loadImg(newCenter);
				
					trace(this.newCenter.x+":"+this.newCenter.y);
				//this.loadMapPic(this.newCenter,false);
					
					updateLayer();
					
				}
			
				
				
			}
			if (blobs.length == 0 && isTwo)
			{
				//this.removeEventListener(Event.ENTER_FRAME,update);
				
				
				deletebitmapSprite(touchSprite);
				
				var lp:Point=this.globalToLocal(new Point(0, 0));
				touchSprite.x=0;
				touchSprite.y=0;
				this.touchSprite.rotation=0;
				isTwo=false;
				
				var isChange:Boolean=false;
				var isBig:Boolean=false;

				var nscale:Number=touchSprite.scaleX;
				if(nscale>2&&nscale<3)
				{
					 this.zoom++;isChange=true;
					 isBig=true;
				}
				if(nscale>3&&nscale<4)
				{
					this.zoom+=2;isChange=true;
					isBig=true;
				}
				if(nscale>4){
					this.zoom+=3;isChange=true;
					isBig=true;
				}
				if(nscale<0.5&&nscale>0.25){
					this.zoom--; isChange=true;		
					isBig=false;
				}
				if(nscale<0.25&&nscale>0.125){
					this.zoom-=2; isChange=true;
					isBig=false;
				}
				if(nscale<0.125){
					this.zoom-=3; isChange=true;
					isBig=false;
				}
				this.touchSprite.scaleX=1;
				this.touchSprite.scaleY=1;
				
				if(isChange){
					loadImg(newCenter);
					this.updateLayer();
				}

				this.setChildIndex(this.touchSprite,0);
		
			}
		}

		private function onComplete(bit:Bitmap):void
		{
			this.removeChild(bit);
		}

		public function downEvent(e:TUIOEvent):void
		{
			if (e.stageX == 0 && e.stageY == 0)
				return;
			this.prePoint=new Point(e.stageX,e.stageY);
			
			var curPt:Point=parent.globalToLocal(new Point(e.stageX, e.stageY));
			addBlob(e.ID, curPt.x, curPt.y);

			trace("downMap");
			e.stopPropagation();
		}

		public function touchUp(e:TUIOEvent):void
		{
			removeBlob(e.ID);
			e.stopPropagation();
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

		public function update(e:Event):void
		{
			
			var ObjectPosition:Point
			var lineBO:Point
			var lenBO:Number
			var angBO:Number
			var O1:Point;
			if(state == "dragging")			//移动content 对象
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);

				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}
				
				var curPt:Point = this.globalToLocal(new Point(tuioobj.x, tuioobj.y));	//得到当前触点坐标
				var oldX:Number, oldY:Number;
				oldX = this.drgSprite.x;
				oldY = this.drgSprite.y;
//				oldX = this.content.x;
//				oldY = this.content.y;

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
				this.lastPoint=new Point(tuioobj.x,tuioobj.y);
//				dX=this.content.x-preX;
//				dY=this.content.y-preY;
//				dX=this.drgSprite.x-preX;
//				dY=this.drgSprite.y-preY;
				dX=this.drgSprite.x-tempx;
				dY=this.drgSprite.y-tempy;
	
				//trace(dX);
				//trace(dY);
				//为了使照片能够稳定不动。
				//this.released(dX, dY, 0);
				//end--计算需要移动的距离
				
				var isMove:Boolean=false;
				var dis:Number=Math.sqrt(Math.abs(dX*dX)+Math.abs(dY*dY));
				if(dis>30){
					isMove=true;
				}
				
				

				if (Math.abs(dX)<MaxMoveDistance && Math.abs(dY)<MaxMoveDistance && ScaleLimitTweenerflag&&isMove)				//限制瞬间移动
				{
					//Tweener.addTween(this.content,{x:tempx,y:tempy, time:moveTimer,transition:"linear"});
					Tweener.addTween(this.drgSprite,{x:tempx,y:tempy, time:moveTimer,transition:"linear"});
				}
				else
				{
					dX=0;
					dY=0;
				}
				//trace(dX);
				//trace(dY);
//				preX=this.content.x;
//				preY=this.content.y;
				preX=this.drgSprite.x;
				preY=this.drgSprite.y;

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
				trace(curAngle);
				trace(ang2);
				trace(ang1);
				trace(curAngle + (ang2 - ang1));
				trace(this.rotation);
				trace("\n");
				if(Math.abs(newscale-this.curScale)>.3)
				{
					setProperty2(nextCenter.x, nextCenter.y, newscale, newscale, curAngle + (ang2 - ang1));
				}
				
				preX=x;
				preY=y;
				preAngle=rotation;

			}
		}
		
		private function  deletebitmapSprite(sp:Sprite):void
		{
			
			if(!sp)return;
			while (sp.numChildren > 0)
			{
				var dis:DisplayObject=sp.removeChildAt(0);
				if(dis is Bitmap){
					(dis as Bitmap).bitmapData.dispose();
				}
			}
			doClearance();
		}
		
		private function doClearance( ) : void {
                     
                        try{
                                new LocalConnection().connect("foo");
                                new LocalConnection().connect("foo");
                        }catch(error : Error){
                                
                        }                        
          }
		
		override public function dispose():void
		{
			//this.pause();
			super.dispose();
			this.touchSprite=null;
			this.drgSprite=null;
			curPosition=null;
			this.preTouchPoint=null;
			this.lastPoint=null
			LastCenterPoint=null;
		}
		override public function pause():void
		{
			//if(this.drgSprite&&this.drgSprite.numChildren>0)this.drgSprite.removeChildAt(0);
			this.blobs.splice(0,this.blobs.length);//删除所有点
			this.deletebitmapSprite(this.touchSprite);
			this.deletebitmapSprite(this.drgSprite);
////		
			this.removeEventListener(Event.ENTER_FRAME,this.update);
			this.removeEventListener(TUIOEvent.TUIO_DOWN,this.downEvent);
			this.removeEventListener(TUIOEvent.TUIO_UP,this.touchUp);
			
			trace("pause");
			
		}
		override public function startRender():void
		{
			//if(this.touchSprite&&this.touchSprite.numChildren>0)this.touchSprite.removeChildAt(0);
			this.deletebitmapSprite(this.touchSprite);
			this.deletebitmapSprite(this.drgSprite);
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,this.downEvent);
			this.addEventListener(TUIOEvent.TUIO_UP,this.touchUp);
			this.addEventListener(Event.ENTER_FRAME,this.update);
		}

		


	}
}

