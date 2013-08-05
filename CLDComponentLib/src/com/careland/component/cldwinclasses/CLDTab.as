package com.careland.component.cldwinclasses
{
	import flash.display.Sprite;

	public class CLDTab extends Sprite
	{
		private var arr:Array=[];
		
		
		public function CLDTab()
		{
			super();
		}
		
		public function addTab(str:String):void
		{
			var type:String="center";
			var tabcls:TabClass=new TabClass(str,type);
			
			this.addChild(tabcls);
			arr.push(tabcls);
			
		}
		public function update():void
		{
			if(arr.length<=0){
				return;
			}
			switch(arr.length){
				
				case 1:arr[0].updateTo("first");this.width=arr[0].widthbreak;
				case 2:arr[0].updateTo("left");arr[1].x=arr[0].width+1;arr[1].updateTo("right");this.width=arr[0].width+arr[1].width+1;break;
				default:change();break;
			}
		}
		private function change():void
		{
			arr[0].updateTo("left");
			var arw:int=arr[0].width;
			
			var nowW:int=0;
			for(var i=1;i<arr.length-1;i++){
				if(i==1){
					arr[i].updateTo("center");
					arr[i].x=arw+1;
					nowW=arr[i].x+arr[i].width;
				}else{
					arr[i].x=nowW+1;
					nowW=arr[i].x+arr[i].width
				}
				
			}
			arr[arr.length-1].updateTo("right");
			arr[arr.length-1].x=nowW+1;
			this.width=arr[arr.length-1].width+nowW+1;
			
		}
		
	}
}