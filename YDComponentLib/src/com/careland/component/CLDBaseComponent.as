/**
 * Component.as
 * Keith Peters
 * version 0.9.5
 * 
 * Base class for all components
 * 
 * Copyright (c) 2010 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * 
 * 
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */
 
package com.careland.component
{
	import com.careland.YDConfig;
	import com.careland.component.util.GUID;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	
	

	public class CLDBaseComponent extends Sprite implements IDisponse
	{
		// NOTE: Flex 4 introduces DefineFont4, which is used by default and does not work in native text fields.
		// Use the embedAsCFF="false" param to switch back to DefineFont4. In earlier Flex 4 SDKs this was cff="false".
		// So if you are using the Flex 3.x sdk compiler, switch the embed statment below to expose the correct version.
		
		// Flex 4.x sdk:
	//	[Embed(source="/assets/pf_ronda_seven.ttf", embedAsCFF="false", fontName="PF Ronda Seven", mimeType="application/x-font")]
		// Flex 3.x sdk:
		  
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:int = -1;
		protected var _enabled:Boolean = true;
		
		protected var _data:*;
		
		protected var _dataChange:Boolean=false;
		protected var _sizeChange:Boolean=false;
		
		public static const DRAW:String = "draw";
		
		private var _produceName:String="";
		private var _params:String;
		
		private var _autoLoad:Boolean=false;
		private var _timeInteval:int=0;//刷新频率
		private var timeInstance:uint=0;//计数器实例
		
		protected var dataLoader:URLLoader;
		
		public static var ajaxurl:String="http://192.168.60.167/dyh/flashtouch/AjaxServer.aspx";		
		public static var contenturl:String=YDConfig.instance().contenturl;		
		public static var produceurl:String=YDConfig.instance().produceurl;		
		public static var produceweburl:String=YDConfig.instance().produceweburl;		
		private var _contentID:String;//内容ID;		
		public var uuid:String=GUID.create();	
		public var stageWidth:Number=1920;
		public var stageHeight:Number=1080;
		private var preTime:int=flash.utils.getTimer();
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		protected var isDispose:Boolean=false;
		protected var config:YDConfig=YDConfig.instance();
		
		public var contentIDParam:String="";//内容ID 数据
		public function CLDBaseComponent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
			move(xpos, ypos);
			if(parent != null)
			{
				parent.addChild(this);
			}
			this._autoLoad=autoLoad;
			this._timeInteval=timeInteval;
			init();
			if(!stage){
				this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			}else{
				stageInit();
			}
		}
		
		protected function addToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			stageInit();
		}
		protected function stageInit():void
		{
			
		}
		
		protected function  deletebitmapSprite(sp:Sprite):void
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
		
		
		public function set contentID(value:String):void
		{
			this._contentID=value;
		}
		
		public function get contentID():String
		{
			return this._contentID;
		}
		
		 
		public function set autoLoad(value:Boolean):void
		{
			this._autoLoad=value;
			if(this.autoLoad&&this.contentID){
				this.loadDataByID(this.contentID);
			}
		}
		
		public function get autoLoad():Boolean
		{
			return this._autoLoad;
		}
		public function set produceName(value:String):void
		{
			this._produceName=value;
		}
		
		public function get produceName():String
		{
			return this._produceName;
		}
		
		public function register():void
		{
			
		}
		
		public function set params(value:String):void{
			this._params=value;
		}
		
		public function get params():String{
			return this._params;
		}
		
		public function setProduce(produceName:String,params:String):void
		{
			this.produceName=produceName;
			this.params=params;
			if(this._autoLoad){
				this.loadDataByID(this.contentID);
			}
		}
		
		protected function loadData(isWeburl:Boolean=true,resultFun:Function=null):void
		{
			trace("loadData");
			if(this.produceName&&this.params){
				var url:String=produceurl;
				if(isWeburl){
					url=produceweburl;
				}
				//var dataXML:String="<params><param name='"+this.produceName+"' args='"+this.params+"'></param></params>";
				var appurl:String=this.produceName;
				
				var func:Function=loadDataComplete;
				if(resultFun!=null){
					func=resultFun;
				}
				this.loadTxt(url + "?SpName=" + encodeURI(this.produceName) + "&paramsString=" + encodeURI(params) + "", null, func);
				//this.loadTxt(produceweburl,null,loadDataComplete);
			}
		}
		
		protected function loadTxt(url:String,data:Object,func:Function):void
		{
			if(!dataLoader){
				dataLoader=new URLLoader();
			}
			
			dataLoader.addEventListener(Event.COMPLETE,func);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			//dataLoader.addEventListener(ProgressEvent.PROGRESS,progress);
			var urlRequest:URLRequest=new URLRequest(url);
			urlRequest.method="post";
			if(data){				
				urlRequest.data=data;
			}
			dataLoader.load(urlRequest);			
		}
		
		protected function ioError(e:IOErrorEvent):void
		{
			//e.target.removeEventListener(Event.COMPLETE,progress);
			e.target.removeEventListener(Event.COMPLETE,loadDataComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			
			trace(e.text);
			//throw e;
		}		
		protected function loadDataComplete(e:Event):void
		{
			if(this.dataLoader){
				//dataLoader.removeEventListener(Event.COMPLETE,progress);
				dataLoader.removeEventListener(Event.COMPLETE,loadDataComplete);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				var data:XML=XML(this.dataLoader.data);
				this.data=data;	
			}
		}
		protected function progress(e:ProgressEvent):void
		{
			
		}
		
		public function drawCurrent():Bitmap
		{
			var bitdata:BitmapData=new BitmapData(this.width, this.height, true, 0xffffff);
			bitdata.draw(this, null, null, null, new Rectangle(0, 0, this.width, this.height), true);
			var bit:Bitmap=new Bitmap(bitdata);
			return bit;
		}

		protected function loadDataByID(tid:String):void
		{
			if(this.contentIDParam){
				var par:String="";
				if(contentIDParam.indexOf(":",0)!=-1){
					//par="category=1";
				}
				this.loadTxt(contenturl+"?id="+tid+"&P="+encodeURI(this.contentIDParam)+"&"+Math.random()+"&"+par,null,result);
			}else{
				this.loadTxt(contenturl+"?id="+tid+"&"+Math.random(),null,result);
			}
		}
		
		private function result(e:Event):void
		{
			if(dataLoader){
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
				dataLoader.removeEventListener(Event.COMPLETE,result);
				loadComponentData(this.contentID,dataLoader.data);
			}			
		}
		protected function loadComponentData(id:String,data:*):void
		{
			//dataLoader.removeEventListener(Event.COMPLETE,loadComponentData);
			this.data=data;
			this.dispatchEvent(new Event("loadDataResult"));
		}
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
			if(this._timeInteval!=0){
				
				startTimeLoad();
				//this.timeInstance=flash.utils.setInterval(this.reloadData,_timeInteval*1000);
			}
		}
		private function startTimeLoad():void
		{
			preTime=flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME,updateTime);
		}
		private function endTimeLoad():void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateTime);
		}
		
		private function updateTime(e:Event):void
		{
			var newTime:int=flash.utils.getTimer();
			var dis:int=newTime-preTime;
			if(dis>=this._timeInteval*1000){
				preTime=flash.utils.getTimer();
				this.reloadData();
			}
		}
		
		
		protected function reloadData():void
		{
			doClearance();
			this.loadDataByID(this.contentID);
		}
		//强制垃圾回收
	   protected function doClearance( ) : void {
                        trace("clear");
                        try{
                                new LocalConnection().connect("foo");
                                new LocalConnection().connect("foo");
                        }catch(error : Error){
                                
                        }                        
         }
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
			
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			
			return new DropShadowFilter(dist, 45, 0x000000, 1, dist, dist, .3, 1, knockout);
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
//			draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		
		public function set data(value:*):void
		{
			this._data=value;
			this.dataChange=true;
			//this.dispatchEvent(new Event("dataChange"));
		}
		public function get data():*{
			return this._data;
		}
		
		public function set dataChange(value:Boolean):void
		{
			this._dataChange=value;
			this.dispatchEvent(new Event("dataChange"));
			if(this.dataChange){
				this.invalidate();
			}
		}
		public function get dataChange():*{
			return this._dataChange;
		}
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public  function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			_sizeChange=true;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			dispatchEvent(new Event(CLDBaseComponent.DRAW));
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			_sizeChange=true;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			_sizeChange=true;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		public function get tag():int
		{
			return _tag;
		}
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
            tabEnabled = value;
			alpha = _enabled ? 1.0 : 0.5;
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		//暂停渲染组件
		public function pause():void
		{
			try{
				this.endTimeLoad();
				var xml:XML=XML(this.data);
				if(xml){
					this.disposeXML(xml);
				}
				
				flash.utils.clearInterval(timeInstance);
			}catch(e:Error){
				//throw e;
			}
			
			
		}
		
		//开始渲染
		public function startRender():void
		{
			if(this.timeInstance!=0){
				//this.timeInstance=flash.utils.setInterval(this.reloadData,_timeInteval*1000);
			}
			
		}
		
		public function disposeXML(xml:XML):void
		{
			System.disposeXML(xml);
			System.gc();
		}
		
		/**
		 * dispose this object
		 * */
		 public function dispose():void{
		 	this.isDispose=true;
		 	this.config=null;
			this.pause();
			//this.dataLoader.data=null;
			if(this.dataLoader){
				this.dataLoader.close();
				dataLoader.removeEventListener(Event.COMPLETE,loadDataComplete);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				
			}
			this.dataLoader=null;
			for(var i:int=0;i<this.numChildren;i++){
				var obj:DisplayObject=this.getChildAt(i);
				
				var cld:IDisponse=obj as IDisponse;
				if(cld){
					cld.dispose();
				}
			}
		}

	}
}