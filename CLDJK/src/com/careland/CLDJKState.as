package com.careland
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.IRender;
	import com.careland.util.CLDUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CLDJKState extends CLDBaseComponent
	{
		
		[Embed(source="assets/heng.png")]
		private var heng:Class;
		private var bit:Bitmap;
		
		[Embed(source="assets/shu.png")]
		private var xiaoshuCls:Class;
		private var xiaoshuBit:Bitmap;
		public function CLDJKState()
		{
			super();
			
			
			
		}
		override protected function addChildren():void
		{
			bit=new heng as Bitmap;
			
			xiaoshuBit=new xiaoshuCls as Bitmap;
			
		}
		
		
		override public function draw():void
		{
			if(!this.data)
			{
				return;
			}
			
			var g:Graphics=this.graphics;
			g.clear();
			g.lineStyle(3,0x3322aa,1);
			g.lineBitmapStyle(bit.bitmapData,null,true,true);
			
			g.moveTo(0,0);
			g.lineTo(0,this.width);
			drawTitle(g);
			g.endFill();
		}
		
		
		
		public var titleHeight:Number=50;
		
		public var columnPreWidth:Array=[10,15,15,50,10];
		
		public var dataRow:int=3;
		
		public var rowHeight:Number=0;
		
		public var columnRealWidth:Array=[];//每一列的实际宽度
		
		public var columnRealPoint:Array=[];//每一列的坐标 
		
		public var render:Array=[];//渲染器
		
		
		
		
		public function drawTitle(g:Graphics):void
		{
			
			var titles:Array=data.titles;
//			var datas:Array=data.datas;
//			dataRow=datas.length;
			columnRealWidth=[];
			columnRealPoint=[0];
			
			g.moveTo(0,titleHeight);
			g.lineTo(this.width,titleHeight);
			
			var lastHeight:Number=(this.height-this.titleHeight)/dataRow;
			this.rowHeight=lastHeight;
			
			//横向
			var nh:Number=lastHeight+this.titleHeight;
			
			for(var ix:int=0;ix<this.dataRow;ix++)
			{
				g.moveTo(0,nh);
				g.lineTo(this.width,nh);
				nh+=lastHeight;
			}
			
			g.lineBitmapStyle(xiaoshuBit.bitmapData);
			
			var movoTo:Number=0;
			
			
			for(var i:int=0;i<this.columnPreWidth.length-1;i++)
			{
				var singleWidth:Number=(this.width*columnPreWidth[i]/100);
				movoTo+=singleWidth;
				g.moveTo(movoTo,0);
				g.lineTo(movoTo,height);
				columnRealWidth.push(singleWidth);//把每一列的宽度 保存起来
				columnRealPoint.push(movoTo);
			}
			g.moveTo(this.width,0);
			g.lineTo(this.width,this.height);
			columnRealWidth.push(this.width*columnPreWidth[columnPreWidth.length-1]/100);
			
			
			
			
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			
			var txtPoint:Number=0;
			
			for(var j:int=0;j<titles.length;j++)
			{
				var txt:TextField=new TextField();
				txt.selectable=false;
				var tf:TextFormat=new TextFormat("msyh",12);
				txt.defaultTextFormat=tf;
				//txt.embedFonts=true;
				txt.text=titles[j];
				
				txt.width=txt.textWidth+10;
				txt.height=txt.textHeight+5;
				txtPoint=columnRealWidth[j];
    			txt.x=columnRealPoint[j]+(txtPoint-txt.width)/2;  
				txt.y=(this.titleHeight-txt.height)/2;
				this.addChild(txt);
			}
			
			
//			var rowY:Number=this.titleHeight;
//			for(var z:int=0;z<datas.length;z++)
//			{
//				this.handlerSingleRow(datas[z],titles,rowY);
//				rowY+=this.rowHeight;
//				
//			}
		}
		
		public function handlerSingleRow(singleData:Object,titles:Array,rowY:Number):void
		{
			for(var j:int=0;j<titles.length;j++)
			{
				
				if(this.render[j] is Class)
				{
					var render:IRender=new this.render[j]() as IRender;
					render.position=new Point(columnRealPoint[j],rowY);
					render.data=singleData[titles[j]];
					render.setSize(columnRealWidth[j],this.rowHeight);
					this.addChild(render as DisplayObject);
					render.reflush();
				}else
				{
					var txt:TextField=new TextField();
					txt.selectable=false;
					var tf:TextFormat=new TextFormat("msyh",12);
					txt.defaultTextFormat=tf;
					txt.text=singleData[titles[j]];
					
					txt.width=txt.textWidth+5;
					txt.height=txt.textHeight+4;
					
					if(txt.width>columnRealWidth[j])
					{
						txt.width=columnRealWidth[j]-10;
						txt.x=columnRealPoint[j];
					}else
					{
						txt.x=columnRealPoint[j]+(columnRealWidth[j]-txt.width)/2;  
					}
					txt.y=(this.rowHeight-txt.height)/2+rowY;
					this.addChild(txt);
				}
				
			}
			
			
		}
		
	}
}