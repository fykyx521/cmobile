package com.careland.component
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	public class CLDCoverFlow extends Sprite
	{
		private const stageWidth:Number = 800;
		private const stageHeight:Number = 400;
		//帧频
		private var frameRate:uint = 25;
		//图片宽高
		private const imgWidth:Number = 240;
		private const imgHeight:Number = 320;
		//左右两边小图的缩小比例  
		private const imgSmallScale:Number = .7; 
		//图片图片之间的距离，即两个图片的注册中心之间的X距
		private const imgSpace:Number = imgWidth * imgSmallScale / 4;
		//图片的Y轴旋转角度
		private const imgRoationYS:Number = 50;
		//整个图片轴的X中心，也是中心图片的最终X座标
		private const imgXCenter:Number = stageWidth / 2;
		//左边图片的右边界线
		private const imgXLeftCenter:Number = imgXCenter - imgWidth / 2;
		//右边图片的左边界线
		private const imgXRightCenter:Number = imgXCenter + imgWidth / 2;
		//整个图片轴的Y中心，也是中心图片的最终Y座标
		private const imgYCenter:Number = stageHeight / 2;
		//当前中心图片的ID号（ID号根据XML表中的顺序生成）
		private var currentID:uint;
		//鼠标点击的ID号
		private var clickID:uint;
		private var gytTimer:Timer;
		//图片总数，根据XML表的数据长度获得
		private var imgTotal:uint;
		//图片总数的中心，代表中心图片在图片数组中的索引，根据图片总数决定
		private var imgCenter:uint;
		private var Main:Sprite;
		private var imgXML:XML;
		//图片数组
		private var imgArr:Array;
		public function CLDCoverFlow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event=null):void
		{
			Main = new Sprite;
			addChild(Main);
			//加载XML数据
			loadXml();
			//使图片旋转起来的Timer
			gytTimer = new Timer(1000/frameRate);
			gytTimer.addEventListener(TimerEvent.TIMER, moveImg);
			gytTimer.start();
		}
		private function loadXml():void
		{
			var xmlLoader:URLLoader = new URLLoader;
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.load(new URLRequest("assets/GytCoverFlow.xml"));
		}
		private function xmlLoaded(e:Event)
		{
			imgXML = new XML(e.target.data);
			imgArr = [];
			var imgNum:uint = imgXML.children().length()
			while (imgArr.length < 20)
			{
				//循环添加直到图片数量大于20个，因为如果小于20个，图片显示不布满整个舞台，不协调
				for (var i:int = 0; i < imgNum; i++) 
				{
					var newImg:CLDImg = new CLDImg(imgXML.pic[i].location,imgWidth,imgHeight);
					newImg.ID = i;
					newImg.y = imgYCenter;
					Main.addChild(newImg);
					newImg.addEventListener(MouseEvent.CLICK, gotoImg);
					newImg.buttonMode = true;
					imgArr.push(newImg);
				}
			}
			imgTotal = imgArr.length;
			imgCenter = imgTotal / 2;
			currentID = imgArr[imgCenter].ID;
		}
		private function gotoImg(e:MouseEvent)
		{
			
			clickID = e.currentTarget.ID;
			while (true)
			{
				//如果点击的图片ID与当前显示的图片ID不一样，则马上执行把鼠标点击的图片居中到数组的动作
				if (clickID == currentID) return;
				//如果鼠标点击的图片在左边，则不断滚动到下一张图片
				if (e.currentTarget.x < imgXLeftCenter)
				nextImg();
				//如果鼠标点击的图片在右边，则不断滚动到上一张图片
				else if (e.currentTarget.x > imgXRightCenter)
				prevImg();
			}
		}
		private function nextImg()
		{
			//通过改变图片在图片数组中的索引位置来改变图片在舞台上的X座标与旋转角度
			//这个函数只改变索引，改变位置与角度的动作由gytTimer不断调用moveImg函数执行
			imgArr.unshift(imgArr.pop());
			imgArr[0].x = imgXLeftCenter - imgCenter * imgSpace;
			Main.setChildIndex(imgArr[0], 0);
			currentID = imgArr[imgCenter].ID;
		}
		private function prevImg()
		{
			imgArr.push(imgArr.shift());
			imgArr[imgTotal - 1].x = imgXRightCenter + (imgTotal - imgCenter) * imgSpace;
			Main.setChildIndex(imgArr[imgTotal-1], 0);
			currentID = imgArr[imgCenter].ID;
		}
		private function moveImg(e:TimerEvent)
		{
			/**
			 * 根据图片在数组中的索引位置来调整图片的位置与角度
			 * 其思路是：假如整个图片轴是静态的话，图片轴中的图片与图片数组对应，则相应图片数组中的图片位置是固定的
			 * 如果我改变了图片在图片数组中的索引位置，同时有一个函数不断检查图片数组中的图片是否位于它应该在的位置
			 * 如果不在，则马上执行调整，直至所有图片都位于它应该在的位置
			 */
			var panX:Number;
			var panRationY:Number;
			var panScaleX:Number;
			var panScaleY:Number;
			for (var i:int = 0; i < imgTotal; i++) 
			{
				if (i < imgCenter)
				{
					//如果图片在图片数组中索引中心的左边，调整到相应位置与角度
					if (imgArr[i].x != imgXLeftCenter - (imgCenter - i) * imgSpace)
					{
						panX= (imgXLeftCenter - (imgCenter - i) * imgSpace) - imgArr[i].x;
						imgArr[i].x += panX / 10;
						if (Math.abs(imgArr[i].x - (imgXLeftCenter - (imgCenter - i) * imgSpace)) < .5 )
						imgArr[i].x = imgXLeftCenter - (imgCenter - i) * imgSpace;
					}
					if (imgArr[i].rotationY != -imgRoationYS)
					{
						panRationY = -imgRoationYS - imgArr[i].rotationY;
						imgArr[i].rotationY += panRationY;
						if (Math.abs( imgArr[i].rotationY + imgRoationYS) < .1)
						imgArr[i].rotationY = -imgRoationYS;
					}
				}
				else if (i == imgCenter)
				{
					//如果图片就是图片数组索引中心，则放调整位置为中心图片的位置与角度
					if (imgArr[i].x !=imgXCenter )
					{
						panX = imgXCenter - imgArr[i].x;
						imgArr[i].x += panX / 10;
						if (Math.abs(imgArr[i].x - imgXCenter) < .5)
						imgArr[i].x = imgXCenter
					}
					else
					{
						//当中心图片已经静止时，执行下一张图片
						nextImg();
					}
					if (imgArr[i].rotationY != 0)
					{
						panRationY = - imgArr[i].rotationY;
						imgArr[i].rotationY += panRationY;
						if (Math.abs(imgArr[i].rotationY) < .1)
						imgArr[i].rotationY = 0;
					}
				}
				else if (i > imgCenter)
				{
					//如果图片在图片数组中索引中心的右边，调整到相应位置与角度
					if (imgArr[i].x != imgXRightCenter + (i - imgCenter  ) * imgSpace)
					{
						panX=(imgXRightCenter + (i - imgCenter  ) * imgSpace) - imgArr[i].x;
						imgArr[i].x += panX / 10;
						if (Math.abs(imgArr[i].x - (imgXRightCenter + (i - imgCenter  ) * imgSpace)) < .5)
						imgArr[i].x = imgXRightCenter + (i - imgCenter  ) * imgSpace;
					}
					if (imgArr[i].rotationY != imgRoationYS)
					{
						panRationY = imgRoationYS - imgArr[i].rotationY;
						imgArr[i].rotationY += panRationY;
						if (Math.abs(imgArr[i].rotationY - imgRoationYS) < .1)
						imgArr[i].rotationY = imgRoationYS;
					}
				}
				//调整图片的绽放比例
				if (i != imgCenter)
				{
					if (imgArr[i].scaleX != imgSmallScale)
					{
						panScaleX = imgSmallScale - imgArr[i].scaleX;
						imgArr[i].scaleX += panScaleX / 10;
						if (Math.abs(imgArr[i].scaleX - imgSmallScale) < .001)
						imgArr[i].scaleX = imgSmallScale
					}
					if (imgArr[i].scaleY != imgSmallScale)
					{
						panScaleY = imgSmallScale - imgArr[i].scaleY;
						imgArr[i].scaleY += panScaleY / 10;
						if (Math.abs(imgArr[i].scaleY - imgSmallScale  )<.001)
						imgArr[i].scaleY = imgSmallScale
					}
				}
				else 
				{
					if (imgArr[i].scaleX != 1)
					{
						panScaleX = 1 - imgArr[i].scaleX;
						imgArr[i].scaleX += panScaleX / 10;
						if (Math.abs(imgArr[i].scaleX - 1) < .001)
						imgArr[i].scaleX = 1
					}
					if (imgArr[i].scaleY != 1)
					{
						panScaleY = 1 - imgArr[i].scaleY;
						imgArr[i].scaleY += panScaleY / 10;
						if (Math.abs(imgArr[i].scaleY - 1) < .001)
						imgArr[i].scaleY = 1
					}
				}
				Main.setChildIndex(imgArr[i], i < imgCenter?i:imgTotal-1-(i-imgCenter) );
			}
		}
	}
}