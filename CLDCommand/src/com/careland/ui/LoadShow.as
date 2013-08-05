package com.careland.ui
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	/**
	 * 2012-12-17
	 * author vinson
	 */
	public class LoadShow extends EventDispatcher
	{
		private var uiLoader:BaseLoaderSprite;
		private var selNumber:int;
		private var loadMode:String;//loadMode有三種模式,"c"表示circle是圓的UI "r"表示rcet是方的UI "t"表示特殊的UI
		public function LoadShow(selNumber:int = 1,loadMode:String="c")
		{
			this.selNumber = selNumber;
			this.loadMode = loadMode;
			init(); 
		}
		private function init():void
		{
			if (loadMode == "c")
			{
				switch(selNumber)
				{
					case 1:
						uiLoader = new LoadBarCircle1;
						break;
					case 2:
						uiLoader = new LoadBarCircle2;
						break;
					case 3:
						uiLoader = new LoadBarCircle3;
						break;
					case 4:
						uiLoader = new LoadBarCircle4;
						break;
					case 5:
						uiLoader = new LoadBarCircle5;
						break;
					default:
						trace("=========您提供的數字已經超出限制值了===========")
						break;
				}
			}
			else if (loadMode == "r")
			{
				switch(selNumber)
				{
					case 1:
						uiLoader = new LoadRect1;
						break;
					case 2:
						uiLoader = new LoadRect2;
						break;
					case 3:
						uiLoader = new LoadRect3;
						break;
					default:
						trace("========您提供的數字已經超出限制值了============")
						break;
				}
			}
			else if (loadMode == "t")
			{
				switch(selNumber)
				{
					case 1:
						uiLoader = new LoadRain;
						break;
					default:
						trace("========您提供的數字已經超出限制值了============")
						break;
				}
			}
		}
		//得到进度条load的UI
		public function get UILoader():Sprite
		{
			return uiLoader;
		}
		//设置进度条的数值0-100
		public function set loadPercent(percent:int):void
		{
			uiLoader.loadPercent = percent;
		}
		//设置UI线条的颜色
		public function set LineColor(value:uint):void
		{
			uiLoader.lineColor = value;
			reCreateChildren();
		}
		//设置UI填充的颜色
		public function set FillColor(value:uint):void
		{
			uiLoader.fillColor = value;
			reCreateChildren();
		}
		//设置UI文字的颜色
		public function set TxtColor(value:uint):void
		{
			uiLoader.txtColor = value;
			reCreateChildren();
		}
		//设置长条形的UI长度
		public function set RectLength(value:uint):void
		{
			uiLoader.rectLength = value;
			reCreateChildren();
		}
		//重新创建UI
		public function reCreateChildren():void
		{
			uiLoader.reCreateChildren();
		}
		//自动居中对齐
		public function seatAutoCentre(stageObj:Object):void
		{
			UILoader.x=stageObj.stageWidth/2-UILoader.width/2;
			UILoader.y=stageObj.stageHeight/2-UILoader.height/2;
		}
		//----start--helpLoad-----------
		/*
		 * 这个load进度条也可以帮助处理加载的工作,可是加载的工作不是这个类的原始工作,所以不建议
		 * 使用这个方法,这方法只是提供测试和参考作用,如果是懒人的话,那我就不多说什么了,你懂得.
		*/
		private var loader:Loader;
		public function helpLoad(url:String):void
		{
			loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		//当加载完成后外部要帧听加载完成,然后外部去调用loaderObject这个函数提取加载的内容
		private function onLoadComplete(evt:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			setTimeout(delayClear, 1000);
		}
		//加载完成1秒后还不提取将会自动清理掉
		private function delayClear():void
		{
			loader = null;
			uiLoader = null;
		}
		private function onError(evt:IOErrorEvent):void
		{
			trace("你提供的地址出错:"+evt)
		}
		private function onProgress(evt:ProgressEvent):void
		{
			var percent:int = int((evt.bytesLoaded / evt.bytesTotal) * 100);
			loadPercent = percent;
		}
		//得到加载的Loader
		public function get loaderObject():Loader
		{
			return loader;
		}
		//----end--helpLoad-------------
	}
}
//--------------下面都是UI部分---------------------
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Transform;
import flash.net.LocalConnection;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

dynamic class dynamicShape extends Shape
{
	//定義為這個類時可以擁有動態屬性
}

class BaseLoaderSprite extends Sprite
{
	
	protected var loadBar:Sprite;
	protected var loadBarCircle:Shape;
	protected var loadBarRect:Shape;
	protected var loadBarSide:Shape
	protected var loadBarContent:Shape;
	protected var loadBarMask:Shape;
	
	protected var objWidth:int = 10;
	protected var objHeight:int = 10;
	protected var halfWidth:Number=objWidth/2;
	protected var percent:int=0;
	
	protected var objText:TextField;
	protected var NAME:String = "loadUi"
	private var lis:Array;//定义一数组保存侦听
	protected var loadBox:Array;
	
	public var lineColor:uint = 0X1F7302;
	public var fillColor:uint = 0XA4F709;
	public var txtColor:uint = 0XFFFFFF;
	public var rectLength:Number = 100;
	
	public function BaseLoaderSprite() 
	{
		lis = new Array();
		loadBox = new Array();
		addEventListener(Event.REMOVED, remove);//侦听删除事件
		createChildren();
	}
	override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
	{
		lis.push([type,listener,useCapture]);
		super.addEventListener(type,listener,useCapture,priority,useWeakReference);
	}
	public function remove(e:Event):void 
	{
		if (e.currentTarget != e.target)
			return;
		trace("删除前有子对象",numChildren);
		while (numChildren > 0) 
		{
			removeChildAt(0);
		}
		trace("删除后有子对象",numChildren);
		//删除动态属性
		for (var k:String in this)
		{
			trace("删除属性",k);
			delete this[k];
		}
		//删除侦听
		for (var i:uint = 0; i < lis.length; i++) 
		{
			trace("删除Listener",lis[i][0]);
			removeEventListener(lis[i][0],lis[i][1],lis[i][2]);
		}
		trace("删除前loadBar有子对象",loadBar.numChildren);
		while (loadBar.numChildren > 0)
		{
			loadBar.removeChildAt(0);
		}
		trace("删除后loadBar有子对象",loadBar.numChildren);
			
		lis = null;
		loadBox = null;
		loadBar = null;
		loadBarCircle = null;
		loadBarRect = null;
		loadBarSide = null;
		loadBarContent = null;
		loadBarMask = null;
		lineColor = 0;
		fillColor = 0;
		txtColor = 0;
		objWidth = 0;
		objHeight = 0;
		halfWidth = 0;
		percent = 0;
		objText = null;
		NAME = "";
		
		//釋放內存;
		try {new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
		} catch (e:Error) { }
		
		childRemove();
	}
	//子类删除函数,如果有些内容无法删除,那么就要让他的子类去完成了.
	protected function childRemove():void
	{
		
	}
	//创建整个Loader的UI函数,呼叫它可以创建一个完整的UI
	protected function createChildren():void
	{
		
	}
	//循环函数,这个在父类不帧听,那个子类需要用到它,就在子类中帧听就可.
	protected function onEFrame(evt:Event):void
	{
		
	}
	//创建加载的进度数字00%-100%
	protected function createText():void
	{
		objText = new TextField();
		objText.autoSize = TextFieldAutoSize.CENTER;
		objText.text = "";
		objText.textColor = txtColor;
		objText.x = 0;
		objText.y = loadBar.height/2;
		addChild(objText);
	}
	//加载进度条的动画
	protected function loadMove():void
	{
		loadBar.rotation+=20;
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
	//给UI加模糊特效
	protected function blurFilter(bluX:Number=5,bluY:Number=5,quality:int=1):Array
	{
		var blur:BlurFilter = new BlurFilter(bluX,bluY,quality)
		return [blur];
	}
	//基本画圆
	protected function baseDrawCircle(color_:uint,alpha_:Number,x_:Number,y_:Number,radius_:Number,mode:String="noLine"):Shape
	{
		var shape:Shape = new Shape;
		if (mode == "line")
			shape.graphics.lineStyle(1,color_);
		else if(mode == "noLine")
			shape.graphics.beginFill(color_, alpha_);
		else if(mode == "all")
		{
			shape.graphics.lineStyle(1, color_);
			shape.graphics.beginFill(color_, alpha_);
		}
		shape.graphics.drawCircle(x_, y_, radius_);
		shape.graphics.endFill();
		return shape;
	}
	//基本画方
	protected function baseDrawRect(color_:uint,alpha_:Number,x_:Number,y_:Number,width_:Number,height_:Number,mode:String="noLine"):Shape
	{
		var shape:Shape = new Shape;
		if (mode == "line")
			shape.graphics.lineStyle(1,color_);
		else if(mode == "noLine")
			shape.graphics.beginFill(color_, alpha_);
		else if(mode == "all")
		{
			shape.graphics.lineStyle(1, color_);
			shape.graphics.beginFill(color_, alpha_);
		}
		shape.graphics.drawRect(x_, y_, width_,height_);
		shape.graphics.endFill();
		return shape;
	}
	//设置进度条的加载进度值
	public function set loadPercent(percent:int):void
	{
		this.percent = percent;
		loadMove();
	}
	//重新创建工UI,每当UI在外部有被改变界面属性时都会调用它重新来创建UI
	public function reCreateChildren():void
	{
		while (numChildren > 0) 
			removeChildAt(0);
		while (loadBar.numChildren > 0)
			loadBar.removeChildAt(0);
			
		loadBar = null;
		loadBarCircle = null;
		loadBarContent = null;
		loadBarMask = null;
		objText = null;
		removeEventListener(Event.ENTER_FRAME, onEFrame);
		createChildren();
	}
}
class LoadBarCircle1 extends BaseLoaderSprite
{
	public function LoadBarCircle1()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite;
		loadBarContent = new Shape;
		loadBarMask = new Shape;
		loadBar.graphics.lineStyle(0.5)
		loadBar.graphics.beginFill(fillColor, 1);
		loadBar.graphics.drawCircle(0, 0, 20);
		loadBar.graphics.drawCircle(0, 0, 15);
		loadBar.graphics.drawRect(0, -halfWidth, 20, objWidth);
		loadBar.graphics.drawRect(0, -halfWidth, -20, objWidth);
		loadBar.graphics.drawRect(-halfWidth, 0, objWidth, 20);
		loadBar.graphics.drawRect(-halfWidth, 0, objWidth, -20);
		loadBar.graphics.endFill();
		loadBar.graphics.beginFill(fillColor, 0.5);
		loadBar.graphics.drawCircle(0, 0, 15);
		loadBar.graphics.endFill();
		
		loadBarMask.graphics.beginFill(0)
		loadBarMask.graphics.drawCircle(0, 0, 20);
		loadBarMask.graphics.endFill();
		loadBar.mask = loadBarMask;
			
		addChild(loadBarMask);
		addChild(loadBar);
			
		createText();
		loadMove();
	}
}

class LoadBarCircle2 extends BaseLoaderSprite
{
	public function LoadBarCircle2()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite;
		for (var i:int = 0; i < 12; i++)
		{
			var dx:Number = Math.cos((i * 30 * Math.PI / 180) - Math.PI / 3) * 20;
			var dy:Number = Math.sin((i * 30 * Math.PI / 180) - Math.PI / 3) * 20;
			loadBar.graphics.beginFill(fillColor, 2 / (12-i));
			loadBar.graphics.drawCircle(dx, dy, 4);
			loadBar.graphics.endFill();
		}
		addChild(loadBar);
		loadBar.filters = blurFilter(4, 4);
		createText();
		loadMove();
	}
}

class LoadBarCircle3 extends BaseLoaderSprite
{
	public function LoadBarCircle3()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite;
		for (var i:int = 0; i < 24; i++)
		{
			var loadChild:Shape = new Shape();
			var dx:Number = Math.cos((i * 30 * Math.PI / 180) - Math.PI / 3) * 20;
			var dy:Number = Math.sin((i * 30 * Math.PI / 180) - Math.PI / 3) * 20;
			loadChild.graphics.beginFill(fillColor, 1);
			loadChild.graphics.drawRect(-20, 0, 7, 3);
			loadChild.graphics.endFill();
			loadChild.rotation = (i * 15 );
			loadBar.addChild(loadChild);
		}
		loadBarCircle= new Shape();
		loadBarCircle.graphics.beginFill(fillColor, 1);
		loadBarCircle.graphics.drawCircle(-16, 0, 7);
		loadBarCircle.graphics.endFill();
		addChild(loadBar);
		addChild(loadBarCircle);
		loadBarCircle.filters = blurFilter(10,10)
		createText();
		addEventListener(Event.ENTER_FRAME, onEFrame);
		loadMove();
	}	
	override protected function onEFrame(evt:Event):void
	{
		loadBar.rotation += 5
		loadBarCircle.rotation-=10
	}
	override protected function loadMove():void
	{
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
}

class LoadBarCircle4 extends BaseLoaderSprite
{
	public function LoadBarCircle4()
	{
		super();
	}
	override protected function createChildren():void
	{
		//用drawUI是因為LoadBarCircle5繼承LoadBarCircle4要用到
		drawUI();
	}
	protected function drawUI():void
	{
		loadBar = new Sprite;
		loadBarContent = new Shape;
		loadBarMask= new Shape();
		loadBarMask.graphics.beginFill(fillColor, 1);
		loadBarMask.graphics.drawCircle(0, 0, 24);
		loadBarMask.graphics.drawCircle(0, 0, 16);
		loadBarMask.graphics.endFill();
		loadBarMask.mask = loadBarContent;
		
		loadBarSide = baseDrawCircle(lineColor, 1, 0, 0, 24, "line");;
		loadBarCircle = baseDrawCircle(lineColor, 1, 0, 0, 16, "line");
		loadBarSide.filters = blurFilter(3,3);
		loadBarCircle.filters = blurFilter(3,3);
		
		loadBar.addChild(loadBarContent);
		loadBar.addChild(loadBarMask);
		loadBar.addChild(loadBarSide);
		loadBar.addChild(loadBarCircle);
		addChild(loadBar);
		loadBar.rotation = -90;
		createText();
		loadMove();
	}
	private function drawArcLine(obj:Shape,radius:Number,angle:Number,color:uint=0xff0000,hasLine:Boolean=false,hasFill:Boolean=true,pointNumber:Number = 0.01):void
	{
		obj.graphics.clear();
		if (hasFill)
			obj.graphics.beginFill(color);
		if (hasLine)
			obj.graphics.lineStyle(1);
		if(!hasFill&&hasLine)
			obj.graphics.moveTo(radius, 0);
			
		var radian:Number=angle/180*Math.PI/pointNumber;
		for (var i:int=0; i<=radian; i++)
		{
			obj.graphics.curveTo(Math.cos(i*pointNumber)*radius,Math.sin(i*pointNumber)*radius,Math.cos(i*pointNumber)*radius,Math.sin(i*pointNumber)*radius);
		}
		if(hasFill)
			obj.graphics.endFill();
	}
	override protected function loadMove():void
	{
		var tempPercent:Number = percent / 100 * 360;
		drawArcLine(loadBarContent, 24,tempPercent, fillColor);
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
}

class LoadBarCircle5 extends LoadBarCircle4
{
	public function LoadBarCircle5()
	{
		super();
	}
	override protected function createChildren():void
	{
		drawUI();
		var maskContainer:Sprite = new Sprite;
		for (var i:int = 0; i < 8; i++)
		{
			var maskRect:Shape = baseDrawRect(fillColor, 1, 0, -4, 25, 8);
			maskRect.rotation = i / 8 * 360;
			maskContainer.addChild(maskRect);
		}
		addChild(maskContainer);
		loadBar.mask = maskContainer;
		maskContainer.rotation -= 45/2;
	}
}

class LoadRect1 extends BaseLoaderSprite
{
	public function LoadRect1()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite();
		loadBarContent = new Shape();
		loadBarMask = new Shape();
		loadBarSide= new Shape();
		var totalNum:Number = rectLength / 10;
		for (var i:int = 0; i < totalNum; i++)
		{
			var color:uint = i % 2 == 0 ? 0xffffff : 0;
			loadBarContent.graphics.beginFill(color)
			loadBarContent.graphics.drawRect(i * 10, 0, 10, 50)
			loadBarContent.graphics.endFill();
		}
		loadBarMask.graphics.beginFill(0);
		loadBarMask.graphics.drawRect(20, 0, loadBarContent.width - 20, 6);
		loadBarMask.graphics.endFill();
		
		loadBarSide.graphics.lineStyle(1, 0);
		loadBarSide.graphics.drawRect(20, 0, loadBarContent.width - 20, 6);
			
		loadBarContent.mask = loadBarMask;
		var mat:Matrix = new Matrix();
		mat.c = 1;
		var tran:Transform = new Transform(loadBarContent);
		tran.matrix = mat;
			
		loadBar.addChild(loadBarContent);
		loadBar.addChild(loadBarMask);
		loadBar.addChild(loadBarSide);
		addChild(loadBar);
		createText();
		objText.x = loadBar.width / 2 - 12;
		objText.y -= 15;
		addEventListener(Event.ENTER_FRAME, onEFrame);
		loadMove();
	}
	override protected function onEFrame(evt:Event):void
	{
		loadBarContent.x += 2
		if (loadBarContent.x >= 20)
		{
			loadBarContent.x = 0
		}
	}
	override protected function loadMove():void
	{
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
}

class LoadRect2 extends BaseLoaderSprite
{
	public function LoadRect2()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite();
		loadBarContent = createLoaderUi();
		loadBarMask = createLoaderUi();	
		loadBarMask.scaleX *= -1;
		loadBarMask.x = loadBarMask.width * 2;
		
		loadBarCircle = baseDrawCircle(0XFFFFFF, 1, -16, 0, 7);
		loadBarCircle.filters = blurFilter();
		loadBarCircle.scaleX = loadBarCircle.scaleY = 0.01;
		
		addChild(loadBar);
		loadBar.addChild(loadBarContent);
		loadBar.addChild(loadBarMask);
		loadBar.addChild(loadBarCircle);
		
		createText();
		objText.x = loadBar.width / 2;
		
		addEventListener(Event.ENTER_FRAME, onEFrame);
		loadMove();
	}
	private function createLoaderUi():Shape
	{
		var shape:Shape = new Shape;
		var fillType:String = GradientType.LINEAR;
		var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
		var alphas:Array = [0, 100, 0];
		var ratios:Array = [0x00, 0xFF, 0x00];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(rectLength, rectLength, 0,0,0);
		var spreadMethod:String = SpreadMethod.PAD;
		shape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
		shape.graphics.drawRect(0, 0, rectLength, 2);
		shape.graphics.endFill();
		shape.filters = blurFilter(1, 1);
		return shape;
	}
	override protected function onEFrame(evt:Event):void
	{
		loadBarCircle.x += 2;
		if (loadBarCircle.x < this.width / 2)
		{
			loadBarCircle.scaleX += 0.02;
			loadBarCircle.scaleY += 0.02;
		}
		else
		{
			loadBarCircle.scaleX -= 0.02;
			loadBarCircle.scaleY -= 0.02;
		}	
		if (loadBarCircle.x >= rectLength*2)
		{
			loadBarCircle.x = 0
			loadBarCircle.scaleX=loadBarCircle.scaleY=0.01
		}
	}
	override protected function loadMove():void
	{
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
}

class LoadRect3 extends BaseLoaderSprite
{
	public function LoadRect3()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite();
		loadBarContent = createLoaderUi(fillColor);
		loadBarMask = createLoaderUi(lineColor, "line");
		loadBarContent.width = 1;
		loadBarMask.alpha=0.3
		
		addChild(loadBar);
		loadBar.addChild(loadBarContent);
		loadBar.addChild(loadBarMask);
		
		createText();
		objText.x = loadBar.width / 2;
		
		loadMove();
	}
	private function createLoaderUi(color_:uint,mode:String=null):Shape
	{
		var shape:Shape = new Shape;
		if (mode == "line")
			shape.graphics.lineStyle(1,color_);
		else
			shape.graphics.beginFill(color_);
		shape.graphics.drawRect(0, 0, rectLength, 4);
		shape.graphics.endFill();
		return shape;
	}
	override protected function loadMove():void
	{
		loadBarContent.width = percent / 100 * loadBarMask.width;
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text = _percent + "%";
	}
}
class LoadRain extends BaseLoaderSprite
{
	private var rainContainerWidth:int = 400;
	private var rainContainerHeight:int = 200;
	private var boat:Shape;
	private var direction:int = 1;
	private var speed:Number = 1.2;
	public function LoadRain()
	{
		super();
	}
	override protected function createChildren():void
	{
		loadBar = new Sprite;
		loadBarRect = baseDrawRect(lineColor, 1, 0, 0, rainContainerWidth, rainContainerHeight);
		loadBarMask = baseDrawRect(lineColor, 1, 0, 0, rainContainerWidth, rainContainerHeight);
		loadBarContent = baseDrawRect(fillColor, 1, 0, -rainContainerHeight, rainContainerWidth, rainContainerHeight);
		boat=getBoat();
		loadBar.addChild(loadBarRect);
		loadBar.addChild(loadBarContent);
		loadBar.addChild(boat);
		boat.y=loadBarContent.y = rainContainerHeight;
		loadBarContent.height = 1;
		addChild(loadBar);
		addChild(loadBarMask);
		loadBar.mask = loadBarMask;
		createText();
		objText.x = loadBar.width / 2;
		objText.y = rainContainerHeight + objText.height;
		
		for (var i:int = 0; i < 50;i++)
		{
			var tempShape:dynamicShape=getRain();
			tempShape.y = Math.random() * rainContainerHeight;
			loadBox.push(tempShape);
			loadBar.addChild(tempShape);
		}
		addEventListener(Event.ENTER_FRAME, onEFrame);
		loadMove();
	}
	private function getBoat():Shape
	{
		var shape:Shape=new Shape;
		shape.graphics.beginFill(0xffffff);
		shape.graphics.moveTo(10,0);
		shape.graphics.lineTo(15,10);
		shape.graphics.lineTo(10,20);
		shape.graphics.lineTo(25,20);
		shape.graphics.lineTo(21,27);
		shape.graphics.lineTo(4,27);
		shape.graphics.lineTo(0,20);
		shape.graphics.lineTo(10,20);
		shape.graphics.lineTo(10, 0);
		return shape;
	}
	private function getRain():dynamicShape
	{
		var tempShape:dynamicShape;
		var radius:Number = Math.random() * 0.5 + 0.5;
		tempShape = new dynamicShape;
		tempShape.graphics.beginFill(fillColor);
		tempShape.graphics.drawCircle(0, 0, radius);
		tempShape.v = radius / 10;
		tempShape.y = -10;
		tempShape.x = rainContainerWidth * Math.random();
		return tempShape;
	}
	override protected function onEFrame(evt:Event):void
	{
		var tempShape:dynamicShape;
		for each( tempShape in loadBox)
		{
			tempShape.v += 0.2;
			tempShape.y += tempShape.v;
			tempShape.scaleX += 0.01;
			tempShape.scaleY += 0.01;
			if (tempShape.y > rainContainerHeight + 10)
			{
				var radius:Number = Math.random() * 0.5 + 0.5;
				tempShape.v = radius / 10;
				tempShape.y = -10;
				tempShape.x = rainContainerWidth * Math.random();
				tempShape.scaleX = tempShape.scaleY = 1;
			}
		}
		//船左右跑动
		boat.y=rainContainerHeight-loadBarContent.height-boat.height;
		boat.x += speed * direction;
		if (boat.x >= rainContainerWidth - boat.width)
		{
			direction *= -1;
			boat.x = rainContainerWidth - boat.width - speed;
		}
		else if (boat.x <=0)
		{
			direction *= -1;
			boat.x = speed;
		}
	}
	override protected function loadMove():void
	{
		loadBarContent.height = percent / 300 * loadBarMask.height;
		var _percent:String = percent < 10?("0" + String(percent)):String(percent);
		objText.text ="下雨下了百分之"+ _percent;
	}
}
