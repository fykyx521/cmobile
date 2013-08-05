package com.careland.component.render
{
	import caurina.transitions.Tweener;
	
	import com.careland.CLDBase;
	import com.careland.component.CLDBaseComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	public class CLDTextRender extends CLDBaseComponent implements IMutiLineTextRender
	{
		
		private var txt:TextField;
		public function CLDTextRender()
		{
			super();
		}
		override protected function addChildren():void
		{
			if(!txt)
			{
				txt=new TextField();
				txt.multiline=true;
				txt.selectable=false;
				this.addChild(txt);
			}
		}
		private var rect:Rectangle;
		override public function draw():void
		{
			if(data)
			{
				txt.text=data;
				txt.width=txt.textWidth+5;
			}
		}
		
		public function set position(value:Point):void
		{
			this.x=value.x;
			this.y=value.y;
		}
		
		public function initEvent():void
		{
			flash.utils.setInterval(function():void{
				
				var ny:Number=rect.y+txt.getLineMetrics(0).height+1;
				Tweener.addTween(rect,{y:ny,onUpdate:update,time:1});
				//txt.scrollRect=rect;
			},1500);
		}
		private function update():void
		{
			txt.scrollRect=rect;
		}
		
		public function reflush():void
		{
			
		}
	}
}