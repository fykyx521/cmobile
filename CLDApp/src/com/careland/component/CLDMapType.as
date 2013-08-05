package com.careland.component
{
	import br.com.stimuli.loading.BulkLoader;
	
	import caurina.transitions.Tweener;
	
	import com.bit101.components.Style;
	import com.careland.YDTouchComponent;
	import com.careland.component.util.Style;
	import com.careland.events.MapEvent;
	import com.careland.util.StyleDraw;
	import com.careland.util.UIConfig;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDMapType extends YDTouchComponent
	{
		
		
		private var back:Bitmap;
		private var yx:CLDStateButton;
		private var v25d:CLDStateButton;
		private var nav:CLDStateButton;
		
		private var current:CLDStateButton;
		private var currentIndex:int=0;
		private var firstIndex=0;
		
		public var pressSp:CLDStateButton;
		private var v25dIndex=0;
		public function CLDMapType()
		{
			super();
			init();
		}
		override public function getBitmap(key:String,clone:Boolean=true)
		{
			var bitdata:Bitmap=BulkLoader.getLoader("main").getBitmap(key);
			if(clone)
			{
				var bit:Bitmap=new Bitmap(bitdata.bitmapData.clone());
				return bit;
			}
			return bitdata;
			
			
		}
		private function init():void
		{
			  this.back=this.getBitmap("maptypeback");
			  this.addChild(back);
			  
			  yx=new CLDStateButton();
			  yx.setBit(getBitmap("maptypeyx"),getBitmap("maptypeyxc"));
			  
			  v25d=new CLDStateButton();
			  v25d.setBit(getBitmap("maptype2.5d"),getBitmap("maptype2.5dc"));
			  
			  nav=new CLDStateButton();
			  nav.setBit(getBitmap("maptypenav"),getBitmap("maptypenavc"));
			  
			  
			  this.addChild(yx);
			  this.addChild(v25d);
			  this.addChild(nav);
			  
			  
			  nav.x=33;
			  yx.x=33+96;
			  v25d.x=33+96*2;
			 
			  v25d.y=yx.y=nav.y=15;
			  
			  v25d.addEventListener(MouseEvent.CLICK,v25dClick);
			  yx.addEventListener(MouseEvent.CLICK,yxClick);
			  nav.addEventListener(MouseEvent.CLICK,navClick);
			  nav.addEventListener(MouseEvent.CLICK,navClick);
			  this.cldConfig.addEventListener(MapEvent.MapTypeChange,changeHandler);
		}
		private function changeHandler(e:MapEvent):void
		{
 			this.currentIndex=e.mapTileNum;
			if(this.currentIndex==0||this.currentIndex==1)
			{
				this.v25d.visible=false;
			}else
			{
				v25dIndex=e.mapTileNum;
				this.v25d.visible=true;
			}
			if(current)
			{
				current.press=false;
			}
			 switch(this.currentIndex)
			 {
				 case 0:
					 current=this.nav;
					break;
				 
				 case 1:
					 	current=this.yx;
					 	break;
				 default:current=this.v25d;break; 
			 }
			 current.press=true;
		}
		private function v25dClick(e:MouseEvent):void
		{
			if(current==v25d)
			{
				return;
			}
			if(current)
			{
				current.press=false;
			}
			current=v25d;
			current.press=true;
			clickHandler(this.v25dIndex,true);
			
		}
		private function yxClick(e:MouseEvent):void
		{
			if(current==yx)
			{
				return;
			}
			if(current)
			{
				current.press=false;
			}
			current=yx;
			current.press=true;
			clickHandler(1);
		}
		private function navClick(e:MouseEvent):void
		{
			if(current==nav)
			{
				return;
			}
			if(current)
			{
				current.press=false;
			}
			current=nav;
			current.press=true;
			clickHandler(0);
		}
		private function clickHandler(num:int,isFirst:Boolean=false):void
		{
			var cle:MapEvent=new MapEvent(MapEvent.ConfigMapChange);
			if(isFirst)
			{
				cle.isFirst=false;	
			}
			cle.mapTileNum=num;
			this.cldConfig.dispatchEvent(cle);
			this.visible=false;
			if(pressSp)
			{
				pressSp.press=false;
			}
			

		}
		private function getConfig():XML
		{
			return this.cldConfig.config;
		}
		
		
	}
}