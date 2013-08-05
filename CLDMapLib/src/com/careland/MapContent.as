package com.careland
{
	
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class MapContent extends Sprite
	{
		//private var layer1:Sprite; //第一层图片
		//private var layer2:Sprite; //第2层图片
		
		public var _isLayer1:Boolean=true;
		
		
		public var layer1:Array=[];
		public var layer2:Array=[];
		
		public var layer1Sp:Sprite;
		public var layer2Sp:Sprite;
		
		public var data:Object; //保存mapdata xml中layer的数据
		
		public function MapContent()
		{
			super();
			init();
			
		}
		
		
		public function set isLayer1(value:Boolean):void
		{
			this._isLayer1=value;
			
		}
		
		public function get isLayer1():Boolean
		{
			return this._isLayer1;
		}
		
		
		public function init():void
		{
			layer1Sp=new Sprite;
			layer2Sp=new Sprite;
			this.addChild(layer1Sp);
			this.addChild(layer2Sp);
		}
		
		public function addContent(child:DisplayObject):void
		{
			//this.addChild(child);
			if(isLayer1){
				this.layer1.push(child);
				layer1Sp.addChild(child);
				
			}else{
				this.layer2.push(child);
				layer2Sp.addChild(child);
			}
		}
		
		public function update():void
		{
			if(this.isLayer1){
				this.disposeArr(this.layer1);
				this.disposeSp(layer1Sp);
				this.setChildIndex(layer1Sp,0);
			}else{
				this.disposeArr(this.layer2);
				this.disposeSp(layer2Sp);
				this.setChildIndex(layer2Sp,0);
			}
		}
		public function disposeArr(arr:Array):void{
			
	
			arr.splice(0,arr.length);
		}
		private function completeHandler(child:DisplayObject):void
		{
			this.removeChild(child);
			try{
					Object(child).dispose();
				}catch(e:Error){
					
				}
		}
		public function disposeSp(s:Sprite):void{
			while(s.numChildren>0){
				var obj:Object=s.removeChildAt(0);
				try{
					Object(obj).dispose();
				}catch(e:Error){
					
				}
			} 
		}
		public function dispose():void
		{
			this.disposeSp(this.layer1Sp);
			this.disposeSp(this.layer2Sp);
			this.disposeArr(layer1);
			this.disposeArr(layer2);
		}
		
		
	}
}