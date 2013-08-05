package com.identity.map
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.CLDEvent;
	import com.identity.Grild.CLDCarelandTable;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.ui.*;

	public class CLDMapSetting extends CLDBaseComponent
	{
		private var bulkLoader:BulkLoader;
		private var maxWidth:int;
		private var sprite:Sprite;
		private var _scaleX:Number=1; //比例
		private var _scaleY:Number=1;
		private var points:Array;
		private var bground:Bitmap=new Bitmap();
		private var scale:Number=1;
		private var SY:Number;
		private var cld:CLDCarelandTable;
		private var logo:CLDPoint;
 		public function CLDMapSetting(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
		     super(parent,xpos,ypos,autoLoad,timeInteval);
		}
	    override public function dispose():void
		{
			super.dispose();
			this.bground=null;
			this.points=null;
			this._scaleX=null;
			this._scaleY=null;
			this.sprite=null;
			this.maxWidth=null;
			this.bulkLoader=null;
			this.removeEventListener(Event.RESIZE,resize);
		}
		/***
		* 添加子类
		*
		***/
		override protected function addChildren():void
		{
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			this.addEventListener(Event.RESIZE, resize);
		}

		private function resize(e:Event):void
		{
			build();
		}
            //给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
		 	   
		}	  
		
		private function build():void
		{
			if (points == null)
			{
				return;
			}		 
		 	this.scale=1;
		 	bground.width=bground.width*this.scale;
		 	bground.height=bground.height*this.scale;
			for (var i:int=0; i < points.length; i++)
			{
				var logo:CLDPoint=points[i] as CLDPoint;				    
				   logo.x=logo._x*_scaleX *this.scale;
				   logo.y=logo._y *_scaleY*this.scale+SY;
			}
		}

		override public function draw():void
		{
            if(this.data&&this.dataChange){
            	loadDatas();	
            	this.dataChange=false;
            }
		}
      
		public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}

		 
		/**
		* 加载点
		*/
		private function loadDatas():void
		{
		   var xml:XML=XML(this.data);
		  
            bground.bitmapData=getBitmap(xml.data[i].@背景图片).bitmapData.clone();
            this.addChild(bground);		 		
			 points=new Array(xml.data.length());
			 var length:int= xml.data.length();
			for (var i:int=0; i <length; i++)
			{
				var _x:String=xml.data[i].@X比例;
				var _y:String=xml.data[i].@Y比例;
				SY=xml.data[i].@Y偏移;
				this._scaleX=Number(_x.split(",")[0])/Number(_x.split(",")[1]);
				this._scaleY=Number(_y.split(",")[0])/Number(_y.split(",")[1]);
				var logo:CLDPoint=new CLDPoint(xml.data[i].@标注图片);
				logo.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
				logo.addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
	 			logo.addEventListener("rightClick",rightClick);
				var position:String=xml.data[i].@坐标;
				logo.parm=xml.data[i].@岗位;
				logo.mouseClikcData=xml.data[i].@点击内容+","+logo.parm+",700,500,1";
				
				logo.mouseOverData=xml.data[i].@鼠标经过数据;
				logo._x=position.split(",")[0];
				logo._y=position.split(",")[1];
				logo.width=50;
				logo.height=50;
				this.addChild(logo);
				points[i]=logo;
			}
			build();
		}

		/**
		* 鼠标悬停
		*/
		private function mouse_over(e:MouseEvent):void
		{
			var logo:CLDPoint=e.currentTarget as CLDPoint;
			sprite=new Sprite();
			sprite.alpha=0.9;
			var overText:TextField=new TextField();
			overText.embedFonts=true;
			overText.text=logo.mouseOverData.split("<br/>").join("\n");					 
			overText.setTextFormat(Style.getTF());
			overText.width=overText.textWidth+20;
			overText.height=overText.textHeight+20;
			overText.x=(this.width-overText.textWidth)/2;
			overText.y=(this.height-overText.textHeight)/2;
			sprite.addChild(overText);
			sprite.graphics.beginFill(0xFFFFFF, 1);
			sprite.graphics.drawRect(overText.x, overText.y, overText.width, overText.height);
			sprite.graphics.endFill();
			this.addChildAt(sprite, this.numChildren - 1);
		}

		private function mouse_out(e:MouseEvent):void
		{
			this.removeChild(sprite);
		}

		private function rightClick(e:Event):void
		{
			logo=e.currentTarget as CLDPoint;
		     var cld:CLDEvent=new CLDEvent(CLDEvent.ALERTWIN);
			     cld.mouseClickData=logo.mouseClikcData; 			   
			 this.config.dispatchEvent(cld);
  
		}
	}
}