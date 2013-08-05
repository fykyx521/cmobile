package com.identity.map
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.mapLayers.CLDContentLayer;
	import com.careland.event.ColorEvent;
	
	import flash.display.DisplayObjectContainer;
	
	//色带管理器
	public class CLDColorManageLayerAdapter extends CLDBaseComponent
	{
		private var color:CLDColorSprite;
		private var layer:CLDContentLayer;
		public function CLDColorManageLayerAdapter(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			 color=new CLDColorSprite;
			 this.addChild(color);
			 color.addEventListener(ColorEvent.colorClick,this.colorClick);
		}	
		
		private function colorClick(e:ColorEvent):void
		{
			if(this.layer){
				layer.colorClick(e);
			}
			
		}
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w,h);
			if(color){
				color.setSize(this.width,this.height);
				color.x=(this.width-this.color.width)/2;
				
			}
		}
		
		
		override public function set data(value:*):void
		{
			super.data=value;
			//创建新的
			if(color){
				color.data=value;		
			}
			
			
			
		}
		override public function dispose():void
		{
			if(color){
				color.dispose();
				color=null;
			}
			layer=null;
		}
		public function set contentLayer(l:CLDContentLayer):void
		{
			this.layer=l;
		}
		public function get contentLayer():CLDContentLayer
		{
			return this.layer
		}
		
		
		
	}
}