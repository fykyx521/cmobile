/**
 * 按纽组件
 * code by xiaolb 2011-4-1
**/
package com.identity 
{
	import com.careland.component.CLDBaseComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	public class CldButton extends CLDBaseComponent
	{
		//按纽相关属性变量
		protected var _back:Sprite;
		protected var _face:Sprite;
		protected var _labelText:String="";
		protected var _text:TextField=null;
		protected var tf:TextFormat=null;		
		protected var hasTxt:Boolean=false;
        protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _selected:Boolean = false;
		protected var _toggle:Boolean = false;	
		protected var _autoSize:Boolean = true;
		
		private var labelChange:Boolean=false;
		/**
		 * 按纽组件构造函数
		 * 参数parent:按纽组件的父显示对象
		 * 参数xpus :组件的x位置
		 * 参数ypus:组件的y位置
		 * 参数defaultHandler:组件的默认事件句苯
		 **/
		public function CldButton(parent:DisplayObjectContainer=null,xpus:Number=0,ypus:Number=0,label:String="",defaultHandler:Function = null)
		{
		    super(parent, xpus, ypus);
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
			this.label = label;
		}
		
		/**
		 * 初始化组件（重载父类初始化方法）
		 **/	 
	   protected override function init():void
		 {
		    super.init();//调父类初始化方法
			buttonMode = true;
		//	useHandCursor = true;
			setSize(100, 20);
		 }
		 
		 /**
		 * 创建增加子显示对象到按纽组件 
		 * 
		 * 
		 **/ 
		 protected override function addChildren():void
		 {
		 	_back= new Sprite();
		 	_back.mouseEnabled=false;
		 	_back.filters=[getShadow(2)];
		 	addChild(_back);
		 	
		 	_face=new  Sprite();
		 	_face.mouseEnabled=false;
		 	_face.filters=[getShadow(2)];
		 	_face.x=1;
		 	_face.y=2;
		 	addChild(_face);
		 	
		 	//按纽的lable文字
					 	_text=new  TextField();
					 	_text.selectable=false;
					 	_text.multiline=false; 	
					 	tf=new TextFormat();
			            tf.align=TextFormatAlign.CENTER;
			            tf.size=10;
			            _text.defaultTextFormat = tf;
			            addChild(_text);		 
		 	addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		 
		 }
		 ////////////////////////////////////////////
		 //公共方法
		 /////////////////////////////////////////
		 override  public function draw():void
		 {
		 	super.draw();		 
		 	_back.graphics.clear();
		 	_back.graphics.beginFill(0xCCCCCC);
		 	_back.graphics.drawRect(0,0,_width, _height);
		 	_back.graphics.endFill();
		 	
		 	_face.graphics.clear();
		 	_face.graphics.beginFill(0xFFFFFF);
		    _face.graphics.drawRect(0,0,_width-2,_height-2);
		    _face.graphics.endFill(); 
		    
		    
		    if(this.label.length>0)
		    {
		       hasTxt=true;
		    }
		    if(hasTxt&&labelChange)
		    {
		    	 _text.text=this.label;
		    	if(_autoSize)
				{			
					this._width=_text.textWidth;
					_text.width=this.width;
		
				}
				else
				{				
					this._width=_text.width;
					
				}	    	
		    	labelChange=false;
				this.invalidate();    	 	   
		    }	 	
		 } 
	///////////////////////////////////
		// event handlers
		///////////////////////////////////		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if(!_down)
			{
				_face.filters = [getShadow(1)];
			}
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseDown(event:MouseEvent):void
		{
			_down = true;
			_face.filters = [getShadow(1, true)];
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseUp(event:MouseEvent):void
		{
			if(_toggle  && _over)
			{
				_selected = !_selected;
			}
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		} 
		 ///////////////////////////////////
		// getter/setters 属性
		///////////////////////////////////
		
		/**
		 * Sets / gets 按纽组件的文本属性
	    **/
		public function set label(str:String):void
		{
			_labelText = str;
			labelChange=true;
			this.invalidate();

		}
		public function get label():String
		{
			return _labelText;
		}
		/**
		 * Sets / gets 按纽组件的autoSize属性
	    **/
		public function set autoSize(b:Boolean):void
		{
			_autoSize = b;
		}
		public function get autoSize():Boolean
		{
			return _autoSize;
		}

	}
}