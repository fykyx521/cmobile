package com.careland.component.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.bit101.components.Component;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CLDRadarUI extends CLDBaseComponent
	{
		
		
		private var back:Bitmap;
		private var center:Sprite;
		private var centerBit:Bitmap;
		
		public var isFirstPage:Boolean;
		private var angle:int=1;
		public function CLDRadarUI(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent,xpos,ypos,autoLoad,timeInteval);
			//this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private var points:Sprite;
		
		private var over:CLDMapOverWin;
		
		private var realWidth:Number;
		public function getBitmap(key:String):Bitmap
		{
			var loader:BulkLoader=BulkLoader.getLoader("main");
			return loader.getBitmap(key);
			
		}
		override protected function addChildren():void
		{
			 back=new Bitmap;
			 back.bitmapData=this.getBitmap("randar").bitmapData.clone();
			 this.addChild(back);

			 centerBit=new Bitmap;
			 centerBit.bitmapData=this.getBitmap("randarPoint").bitmapData.clone();
			 center=new Sprite();
			 center.addChild(centerBit);
			 this.addChild(center);
			 this.addEventListener(Event.ENTER_FRAME,update);
			 points=new Sprite();
			 this.addChild(points);
			 
			 over=new CLDMapOverWin();
			 this.addChild(over);
			 over.visible=false;
			 //0.5 0.29444444445
			 
		}
		override public function draw():void
		{
			super.draw();
			var num:Number=this.width>this.height?this.height:this.width;
			realWidth=num;
			if(back)
			{
				back.width=num;
				back.height=num;
			}
			if(center&&this.centerBit)
			{
				centerBit.width=num;
				centerBit.height=num;
				center.x=num/2;
				center.y=num/2;
				centerBit.x=-center.x;
				centerBit.y=-center.y;
			}
			//data="<config><data x='0.5' y='0.29444444445' content='提示信息'/></config>";
			if(data&&points)
			{
				disponsePoints();
			  
				var xml:XML=XML(this.data)
				if(xml.data&&xml.data.length()>0)
				{
					var item:XML=xml.data[0];
					if(String(item.@content)=="0")
					{
						return;
					}
				}
				  //0 绿色 1黄色 2红色
					for (var i:int=0; i < xml.data.length(); i++)
					{
						 var item:XML=xml.data[i];
						var content:String="时间:"+item.@dateTime+"<br/>"+"创建人:"+item.@CreateBy+"<br/>事件内容:"+item.@content;
					    var cp:CLDRadarPoint=new CLDRadarPoint(item.@x,item.@y,content,num,int(item.@status));
						cp.addEventListener(MouseEvent.CLICK,clickHandler);
    					points.addChild(cp);
					}
			}
		
		}
		private function clickHandler(e:MouseEvent):void
		{
			 var target:CLDRadarPoint=e.target as CLDRadarPoint;
			 if(target)
			 {
				   if(parent&&(parent as CLDRadar).isFirstPage)
				   {
					   over.visible=true;
					   over.data=target.content;
					   over.x=(this.width-this.over.width)/2;
					   over.y=(this.height-this.over.height)/2;
					  
				   }else
				   {
					   var cle:CLDEvent=new CLDEvent(CLDEvent.ALERTGLOBALWIN);
					   cle.obj=target.content;
					   this.config.dispatchEvent(cle);
				   }
				   
				  
				   
			 }
		}
		private function update(e:Event):void
		{
			 if(center)
			 {
				 center.rotation=this.angle;
				 this.angle++;
				 if(this.angle>360)
				 {
					 this.angle=0;
				 }
			 }
		}
		override public function dispose():void
		{
			super.dispose();
			if(back)
			{
				back.bitmapData.dispose();
				back=null;
			}
			if(centerBit)
			{
				centerBit.bitmapData.dispose();
				centerBit=null;
			}
			if(points)
			{
				disponsePoints();
				points=null;
			}
			
			this.removeEventListener(Event.ENTER_FRAME,update);
		
		}
		
		public function disponsePoints():void
		{
			while(points.numChildren>0)
			{
				var cp:CLDRadarPoint=points.getChildAt(0) as CLDRadarPoint;
				points.removeChildAt(0);
				cp.dispose();
				cp.removeEventListener(MouseEvent.CLICK,this.clickHandler);
			}
		}
		
	}
	
}
