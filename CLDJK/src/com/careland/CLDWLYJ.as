package com.careland
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDTextRender;
	import com.identity.CLDChart;
	import com.identity.jk.CLDYJList;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CLDWLYJ extends CLDBaseComponent
	{
		
		private var chart1:CLDChart;
		
		private var chart2:CLDChart;
		
		private var chart3:CLDChart;
		
		private var chart4:CLDChart;
		
		
		public function CLDWLYJ()
		{
			
			
		}
		
		var titles:Array=["时间","状态","预警内容","处理情况"];
		
		
		var render:Array=[null,null,CLDTextRender,null];
		var datas:Array=[
			{
				
				时间:"20.20",
				状态:"服务岗",
				预警内容:"事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n",
				处理情况:"已处理"
			}
			
		];
		
		
		[Embed(source="assets/heng.png")]
		private var heng:Class;
		private var bit:Bitmap;
		
		[Embed(source="assets/shu.png")]  
		private var xiaoshuCls:Class;
		private var xiaoshuBit:Bitmap;
		
		
		override public function set data(value:*):void
		{
			this.parse(value);  
			super.data=value;
		}
		
		private var col:Array=[];
		private var ids:Array;
		private var titleHeight:Number=50;
		
		private var chartIDs:Array=[];
		public var truncateIndex:int;
		
		public var weatherID:String;
		private function parse(value:*):void
		{
			var data:XML=XML(value);
			var data0:XML=data.table[0].data[0];
			var title:String=data0.@titles;
			titles=title.split(",");
			var colstr:String=String(data0.@列宽百分比);
			
			var colstrArr:Array=colstr.split(",");
			
			for(var i:int=0;i<colstrArr.length;i++)
			{
				 col.push(Number(colstrArr[i]));
			}
			ids=String(data0.@数据ID).split(",");
			titleHeight=Number(data0.@标题高度);
			
			truncateIndex=int(data0.@超出索引);
			
			getChartID(data);
				
			this.invalidate();
		}
		public function getChartID(data:XML):void
		{ 
			 var datas:XML=data.table[1];
			 var cids:String="";
			 chartIDs.splice(0,chartIDs.length);
			 for(var i:int=0;i<datas.data.length();i++)
			 {
				 var xml:XML=datas.data[i];
				 if(i==0)
				 {
					  this.weatherID=String(xml.@内容ID);
				 }else
				 {
					  chartIDs.push(xml.@内容ID);
				 }
			 }
			// chartIDs=String(data.data[1].@图表ID).split(",");
			 
		}
		
		
		override protected function addChildren():void
		{
			bit=new heng as Bitmap;
			xiaoshuBit=new xiaoshuCls as Bitmap;
		}
		override public function dispose():void
		{
			super.dispose();
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
		}
		
		private function addBit(gridHeight:Number,moveTo:Number):void
		{
			var hengx:Bitmap=new Bitmap(this.xiaoshuBit.bitmapData.clone());
			hengx.x=moveTo;
			
			hengx.height=gridHeight;
			this.addChild(hengx);
		}
		//175 28		  
		override public function draw():void
		{
			if(data)
			{
				
				this.dispose();
				var gridHeight:int=290; //列表高度
				var h1:Number=(this.height-gridHeight)/2;
				
				var w2:Number=this.width/2;
				var h2:Number=(this.height-h1)/2;
			
				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(1,0x000222,1);
				g.lineBitmapStyle(this.xiaoshuBit.bitmapData);
				
				var movoTo:Number=0;
				
				var columnRealWidth:Array=[];
				var columnRealPoint:Array=[0];
				
				
				for(var i:int=0;i<col.length;i++)
				{
					var singleWidth:Number=col[i];//(this.width*columnPreWidth[i]/100);
					movoTo+=singleWidth;
					g.moveTo(movoTo,0);
					g.lineTo(movoTo,gridHeight);
					columnRealWidth.push(singleWidth);//把每一列的宽度 保存起来
					columnRealPoint.push(movoTo);
					
					addBit(gridHeight,movoTo);
				}
				
				for(var j:int=0;j<col.length;j++)
				{
					var txt:TextField=new TextField();
					txt.selectable=false;
					txt.multiline=false;
					txt.wordWrap=false;
					//txt.embedFonts=true;
					txt.defaultTextFormat=new TextFormat("msyh",30,0x00446a);
					txt.text=this.titles[j];
					txt.x=(col[j]-txt.textWidth)/2+columnRealPoint[j];
					txt.y=-50;
					txt.width=txt.textWidth+5;
					this.addChild(txt);
				}
				
				//columnRealWidth.push(this.width*columnPreWidth[columnPreWidth.length-1]/100);
				g.endFill();
				g.clear();
				
				
				var hengx:Bitmap=new Bitmap(this.bit.bitmapData.clone());
				hengx.x=0;
				hengx.y=gridHeight;
				hengx.width=this.width;
				this.addChild(hengx);
				
//			 	g.moveTo(0,gridHeight);
//				g.lineStyle(1,0x332233,1);
//				//g.lineBitmapStyle(this.bit.bitmapData);
//				g.lineTo(this.width,gridHeight);
				
				var hengx2:Bitmap=new Bitmap(this.bit.bitmapData.clone());
				hengx2.x=0;
				hengx2.y=gridHeight+h1;
				hengx2.width=this.width;
				this.addChild(hengx2);
				

				
				
				var shux:Bitmap=new Bitmap(this.xiaoshuBit.bitmapData.clone());
				shux.x=w2;
				shux.y=gridHeight;
				shux.height=this.height-gridHeight;
				this.addChild(shux);
				
				
				var ypos:Number=0;
				for(var i:int=0;i<ids.length;i++)
				{
					var list:com.identity.jk.CLDYJList=new com.identity.jk.CLDYJList();
					list.columnRealPoint=columnRealPoint;
					list.columnRealWidth=col;
					list.setSize(this.width,gridHeight);
					list.truncateIndex=truncateIndex;
					list.titles=titles;
					list.width=this.width-42;//14 scrollbar的宽度
					list.x=0;
					list.y=ypos;
					list.contentID=ids[i];
				    list.autoLoad=true;
					this.addChild(list);
					ypos+=gridHeight;
					
				}
				chart1=new CLDChart(); 
				chart2=new CLDChart();
				chart3=new CLDChart();
				chart4=new CLDChart();
 			    this.addChild(chart1);
			    this.addChild(chart2);
			    this.addChild(chart3);
			    this.addChild(chart4);
				
				chart1.contentID=this.chartIDs[0];
				chart1.autoLoad=true;
				
				chart2.contentID=this.chartIDs[1];
				chart2.autoLoad=true;
				
				chart3.contentID=this.chartIDs[2];
				chart3.autoLoad=true;
				
				chart4.contentID=this.chartIDs[3];
				chart4.autoLoad=true;
				
				
				var gap:Number=5;
				var gap2:Number=10;
				
			
				chart1.setSize(w2-gap2,h2-gap2);
				chart2.setSize(w2-gap2,h2-gap2);
				chart3.setSize(w2-gap2,h2-gap2);
				chart4.setSize(w2-gap2,h2-gap2);
				
				chart1.x=gap;
				chart1.y=gridHeight+gap;
				chart2.x=w2+gap;
				chart2.y=gridHeight+gap;
				chart3.x=gap;
				chart3.y=h2+gridHeight+gap;
				chart4.x=w2+gap;
				chart4.y=h2+gridHeight+gap;
				
				
				var weather:CLDWeather=new CLDWeather();
				this.addChild(weather);
				weather.width=this.width;
				weather.y=-110;
				weather.contentID=this.weatherID+"";
				weather.autoLoad=true;
				
			}
		}
	}
}