package com.identity.jk
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	public class CLDJKBack extends CLDBaseComponent
	{
		[Embed(source="assets/底图/a.png")]
		private var l1:Class;
		[Embed(source="assets/底图/b.png")]
		private var l2:Class;
		[Embed(source="assets/底图/c.png")]
		private var l3:Class;
		[Embed(source="assets/底图/d.png")]
		private var l4:Class;
		[Embed(source="assets/底图/e.png")]
		private var l5:Class;
		[Embed(source="assets/底图/f.png")]
		private var l6:Class;
		
		
		[Embed(source="assets/底图/值班信息.png")]
		private var zbxx:Class;
		
		[Embed(source="assets/底图/监控动态.png")]
		private var jkdt:Class;
		
		[Embed(source="assets/底图/网络预警.png")]
		private var wlyj:Class;
		
		
		public var zbxxb:Bitmap;
		
		public var jkdtb:Bitmap;
		
		public var wlyjb:Bitmap;
		
		public function CLDJKBack(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			var bit1:Bitmap=new l1 as Bitmap;
			var bit2:Bitmap=new l2 as Bitmap;
			var bit3:Bitmap=new l3 as Bitmap;
			var bit4:Bitmap=new l4 as Bitmap;
			var bit5:Bitmap=new l5 as Bitmap;
			var bit6:Bitmap=new l6 as Bitmap;
			
			this.addChild(bit1);
			this.addChild(bit2);
			
			bit2.x=640;
			this.addChild(bit3);
			bit3.x=1280;
			
			this.addChild(bit4);
			bit4.y=540;
			this.addChild(bit5);
			bit5.x=640;
			bit5.y=540;
			this.addChild(bit6);
			bit6.x=1280;
			bit6.y=540;
			
			zbxxb=new zbxx as Bitmap;
			jkdtb=new jkdt as Bitmap;
			wlyjb=new wlyj as Bitmap;
			
			
			this.zbxxb.visible=false;
			this.jkdtb.visible=false;
			this.wlyjb.visible=false;
			
			
			
			this.addChild(zbxxb);
			this.addChild(jkdtb);
			this.addChild(wlyjb);
		}
		
	}
}