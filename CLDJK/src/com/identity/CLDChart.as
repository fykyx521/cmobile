/**
 * CLDChart Compoent  (Code by xiaolb 2011-4-11)
 **/
package com.identity
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import uk.co.teethgrinder.*;
	import uk.co.teethgrinder.charts.*;
	import uk.co.teethgrinder.charts.elements.*;
	import uk.co.teethgrinder.charts.series.*;
	import uk.co.teethgrinder.charts.series.bars.*;
	import uk.co.teethgrinder.charts.series.dots.*;
	import uk.co.teethgrinder.charts.series.pies.*;
	import uk.co.teethgrinder.elements.*;
	import uk.co.teethgrinder.elements.axis.*;
	import uk.co.teethgrinder.elements.labels.*;
	import uk.co.teethgrinder.elements.menu.*;
	import uk.co.teethgrinder.global.Global;

	public class CLDChart extends CLDBaseComponent
	{
		///
		//defining variable for using 
		///
		public var VERSION:String="2 Lug Wyrm Charmer";
		private var title:Title=null;
		//private var x_labels:XAxisLabels;
		private var x_axis:XAxis;
		private var radar_axis:RadarAxis;
		private var x_legend:XLegend;
		private var y_axis:YAxisBase;
		private var y_axis_right:YAxisBase;
		private var y_legend:YLegendBase;
		private var y_legend_2:YLegendBase;
		private var keys:Keys;
		private var obs:ObjectCollection;
		public var tool_tip_wrapper:String;
		private var sc:ScreenCoords;
		private var tooltip:Object;
		private var background:Background;
		private var menu:Menu;
		private var ok:Boolean=false;
		private var URL:String; // ugh, vile. The IOError doesn't report the URL
		private var id:String; // chart id passed inf from user
		private var chart_parameters:Object;
		private var json:String;
		private var _url:String;
		private var xml:XML;
		private var _jsonData:*;
		private var maxValue:Number=0;
		private var temValue:Number=0;
		private var dataArray:Array;
		private var lableArray:Array;
		private var list:Array;
		private var child:Object;
		private var Xvalue:String;
		private var Xname:String;
		private var x_data:Array;
		private var lbles:Object;
		private var lableArr:Array;
		private var obj:Object;
		private var yLableArr:Array;
		private var jsonOjbject:Object;
		private var Xtitle:String;
		private var util:String;
		private var maxString:String;
		private var leftList:Array;
		private var rightList:Array;
		private var m:Number=0;
		private var Xdata:Array;
		private var lineArray:Array;
		private var tempValue2:int;
		private var max:int=0;
		private var num:int=0;
		private var len:int=0;
		private var num2:int=0;
		private var colors:Array=["#43003c", "#931035", "#522f01", "#002345", "#425201", "#0f2d01", "#5a3100", "#111244", "#231100", "#36254a"];

        private var totalValue:Number=0;
        private var keyList:Array;
        private var minValue:Number=0;
        private var minString:String;
        
        override public function dispose():void{
        	super.dispose();

        	this.die();
        	

        	this.minValue=null;
        	this.minString=null;
        	this.m=null;
        	this.temValue=null;
        	this.dataArray=null;
        	this.list=null;
        	this.child=null;
        	this.Xvalue=null;
        	this.Xname=null;
        	this.x_data=null;
        	this.lbles=null;
        	this.lableArr=null;
        	this.obj=null;
        	this.yLableArr=null;
        	this.jsonOjbject=null;
        	this.Xtitle=null;
        	this.util=null;
        	this.maxString=null;
        	this.maxValue=null;
        	this.leftList=null;
        	this.rightList=null;
        	this.Xdata=null;
        	this.lineArray=null;
        	this.tempValue2=null;
        	this.max=null;
        	this.num=null;
        	this.len=null;
        	this.leftList=null;
        	this.num2=null;
        	 this.colors=null;
        }

	
		


		/**
		 * CLDChart 构造函数
		 * @param parent 显示对象
		 * @param xpos 该组件显示的X位置
		 * @param ypos 该组件显示的Y位置.
		 * @param autoLoad 组件是否自动加载
		 * @param timeInteval 组件的时间间隔
		 **/
		public function CLDChart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{

			super(parent, xpos, ypos, autoLoad, timeInteval);
			if (stage)
			{

				this.stage.addEventListener(Event.MOUSE_LEAVE, mouseOut);
			}
		}

		override public function set data(value:*):void
		{
			super.data=data;
			die();
			trace("die");
			this.pauseData(value);
		}

		public function pauseData(data:*):void
		{
			xml=XML(data);
			if (!xml.data is XMLList)
			{
				ok=false;
				return;
			}
			var json:Object=null;
			var type:String;
			if (xml.data.length() > 0)
			{
				type=xml.data[0].attributes()[0];
//				xml.data[0].@value=1;
				switch (type)
				{
					case "verGroupPole": //柱状分组图
						json=this.getVerGroupPoleData(xml); //poleAndLine(xml);//this.getVerGroupPoleData(xml);
						break;
					case "pie": //饼图
						json=getRoundData(xml);
						break;
					case "latGroupPole": //横向柱状分组图 
						json=getLatGroupPoleData(xml);
						break;
					case "verSepPole": //柱状分离图 
						json=getVerSepPoleData(xml);
						break;
					case "poleAndLine": //混合图	
						json=poleAndLine(xml);
						break;
					default: //折线图
						json=getLineData(xml);
						break;
				}
			}

			if (json)
			{
				this.jsonData=json;
			}
		}

		/**
		* 线性图数据格式
		*/
		private function getLineData(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.y_legend.style="#736AFF"; //初始化样式		 
			jsonOjbject.y_legend.text=xml.data[0].@Y轴单位;
			jsonOjbject.x_legend=new Object();
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位;
			maxValue=xml.data[0].@最大值;
			minValue=xml.data[0].@最小值;
			dataArray=xml.data[0].@数据列.toString().split(","); //
			jsonOjbject.elements=[];
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18; font-weight: bold;}";
			list=[];
			for (var i:int=0; i < dataArray.length; i++)
			{
				child=new Object();
				child.type="line";
				child.colour=colors[i];
				Xtitle=xml.data[0].@图例;
				child.text=Xtitle.split(",")[i];
				x_data=new Array(xml.data.length());

				for (var j:int=0; j < xml.data.length(); j++)
				{
					Xname=dataArray[i];
					Xvalue=xml.data[j].@[Xname];
				   if (Xvalue!="")
					{
					   x_data[j]=Number(Xvalue);
					   list.push(Number(Xvalue));
					   
					}else{
					    j= xml.data.length()-1;
					}
				}
				child.values=x_data;
				jsonOjbject.elements[i]=child;
			}
			jsonOjbject.x_axis=new Object();
			lbles=new Object();
			lbles.rotate="vertical";
			jsonOjbject.x_axis.labels=lbles;
			jsonOjbject.x_axis.stroke=1; //透明度    	  
			lableArr=new Array(xml.data.length());
			for (j=0; j < xml.data.length(); j++)
			{
				Xvalue=xml.data[j].@X轴数据;
				lableArr[j]=Xvalue;
			}
			// lableArr.push(xml.data[0].@X轴单位);
			jsonOjbject.x_axis.labels=new Object();
			jsonOjbject.x_axis.labels.labels=lableArr;
			jsonOjbject.y_axis=new Object();
			jsonOjbject.y_axis.offset=0;
			jsonOjbject.y_axis.stroke=1; //Y轴线 
			if (maxValue == 0)
			{
				maxValue=getMax(list);
			}
			if (minValue == 0)
			{
				minValue=getMin(list);
			}
			jsonOjbject.y_axis.max=maxValue; //设置最大值	
			jsonOjbject.y_axis.min=minValue; //设置最小 值	
			jsonOjbject.y_axis.tick_height="10";
			jsonOjbject.y_axis.steps=(maxValue - minValue) / 5;
			return jsonOjbject;
		}

		/**
		   * 横向柱状分组图数据格式
		   */
		private function getLatGroupPoleData(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.y_legend.style="#DDDF0D"; //初始化样式		 
			jsonOjbject.y_legend.text=xml.data[0].@Y轴单位;
			maxValue=xml.data[0].@最大值;
			minValue=xml.data[0].@最小值;
			list=[];
			jsonOjbject.x_legend=new Object();
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位;
			dataArray=xml.data[0].@数据列.toString().split(","); //
			jsonOjbject.elements=[];
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18; font-weight: bold;}";
			for (var i:int=0; i < dataArray.length; i++)
			{
				child=new Object();
				child.type="hbar";
				child.colour=colors[i];
				child.tip="#val#<br>值:#right#";
				Xtitle=xml.data[0].@图例;
				child.text=Xtitle.split(",")[i];
				x_data=new Array(xml.data.length());
				for (var j:int=0; j < xml.data.length(); j++)
				{
					Xname=dataArray[i];
					obj=new Object();
					Xvalue=xml.data[j].@[Xname];
					obj.right=Number(Xvalue);
					list.push(Number(Xvalue));
					x_data[j]=obj;
				}
				child.values=x_data;
				if (dataArray.length < 5)
				{
					child.width=50;
				}
				jsonOjbject.elements[i]=child;
			}
			jsonOjbject.x_axis=new Object();
			lbles=new Object();
			lbles.rotate="vertical";
			jsonOjbject.x_axis.labels=lbles;
			if (maxValue == 0)
			{
				maxValue=getMax(list);
			}
			if (minValue == 0)
			{
				minValue=getMin(list);
			}
			jsonOjbject.x_axis.min=0;
			jsonOjbject.x_axis.max=maxValue;
			jsonOjbject.x_axis.min=minValue;
			jsonOjbject.x_axis.offset="true";
			jsonOjbject.x_axis.stroke=0.8; //透明度 
			jsonOjbject.x_axis.steps=(maxValue - minValue) / 5;
			lableArr=new Array(xml.data.length());
			jsonOjbject.x_axis.labels=new Object();
			jsonOjbject.x_axis.labels.steps=jsonOjbject.x_axis.steps;
			
//			for (j=0; j <= jsonOjbject.x_axis.max; j++)
//			{
//				lableArr[j]=String(j); //X轴显示		
//			}
//			
//			for (j=0; j <= xml.data.length(); j++)
//			{
//				lableArr[j]=String(j); //X轴显示		
//			}
			
//			jsonOjbject.x_axis.labels.labels=lableArr;
			jsonOjbject.y_axis=new Object();
			
			yLableArr=new Array(xml.data.length());
			for (j=0; j < xml.data.length(); j++)
			{
				Xvalue=xml.data[j].@X轴数据;
				yLableArr[j]=Xvalue;
			}
			// lableArr.push(xml.data[0].@X轴单位);
			jsonOjbject.y_axis.labels=new Object();
			jsonOjbject.y_axis.labels=yLableArr; //Y轴显示
			jsonOjbject.y_axis.offset="true";
			jsonOjbject.y_axis.tick_height="30";

			return jsonOjbject;
		}

		/**
		 * 柱状分离图数据格式
		 */
		private function getVerSepPoleData(xml:XML):Object
		{
			
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.y_legend.style="#DDDF0D";
			jsonOjbject.y_legend.text=xml.data[0].@Y轴单位; //xml.config.attributes()[1];   	
			jsonOjbject.x_legend=new Object();
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位;
			maxValue=xml.data[0].@最大值;
			minValue=xml.data[0].@最小值;
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18px; font-weight: bold;}";
			dataArray=xml.data[0].@数据列.toString().split(",");
			lableArray=xml.data[0].@图例.toString().split(",");
			jsonOjbject.elements=[];
			child=new Object();
			child.type="bar_stack";			 
			x_data=[];
			keyList=[];
			Xdata=[];
			list=[];
			for (var j:int=0; j < lableArray.length; j++)
			{
				var obj={"colour": colors[j], "text": lableArray[j], "font-size": 12};
				keyList.push(obj);
			}
			child.keys=keyList;
			 m=xml.data.length();
			 if(m<10){
			 	 m=10;
			 }
			for (var i:int=0; i < m; i++)
			{
				x_data=[];
				totalValue=0;
				for (var j:int=0; j < dataArray.length; j++)
				{
					Xname=dataArray[j];
					if(xml.data[i]!=null){
						Xvalue=xml.data[i].@[Xname];
					    totalValue+=Number(Xvalue);
					    x_data.push({"colour": colors[j], "val": Number(Xvalue), "tip": Number(Xvalue)});
					}else{						 
					  	x_data.push({"colour": colors[j], "val":minValue,"tip":minValue});
					 }					
				}
				Xdata.push(x_data);
				list.push(totalValue);
			}
			child.values=Xdata;			 
			jsonOjbject.elements[0]=child;
 			jsonOjbject.x_axis=new Object();
			if (maxValue == 0)
			{
				maxValue=getMax(list);
			}
			if (minValue == 0)
			{
				minValue=getMin(list);
			}
			jsonOjbject.x_axis.max=m;
			jsonOjbject.x_axis.steps=1;
			jsonOjbject.x_axis.labels=new Object();
			lableArr=[];
			for (var j:int=0; j <xml.data.length(); j++)
			{
				if(xml.data[j]!=null){
					Xvalue=xml.data[j].@X轴数据;
				}else{
				   Xvalue="";
				}
				
				lableArr.push(Xvalue);
			}
			jsonOjbject.x_axis.labels.labels=lableArr;
			jsonOjbject.y_axis=new Object();
			jsonOjbject.y_axis.max=maxValue;
			jsonOjbject.y_axis.min=minValue;
			jsonOjbject.x_axis.stroke=1;
			jsonOjbject.x_axis.tick_height=1;
			return jsonOjbject;
		}
		private function poleAndLine(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.y_legend.style="#DDDF0D"; //初始化样式	
			util=xml.data[0].@Y轴单位;
			
			var isTwoPoint:Boolean=("true"==String(xml.data[0].@是否双坐标));
			
			if(isTwoPoint)
			{
				return this.poleAndLine_old(xml);
			}
			jsonOjbject.y_legend.text=util.split(",")[0]; //xml.config.attributes()[1];   	//标题
			if (util.split(",").length > 1)
			{
				jsonOjbject.y2_legend=new Object();
				jsonOjbject.y2_legend.style="#DDDF0D"; //初始化样式					 
				jsonOjbject.y2_legend.text=util.split(",")[1];
			}
			
			jsonOjbject.x_legend=new Object();
			maxString=xml.data[0].@最大值;
			minString=xml.data[0].@最小值;
			var maxValue:Number=0;
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位; //xml.config.attributes()[1];   	//标题			  			
			dataArray=xml.data[0].@数据列.toString().split(","); //
			var dirsction:String=xml.data[0].@坐标轴方向;
			var left:String;
			if (dirsction != "")
			{
				left=dirsction.split(",")[0];
			}
			else
			{
				left="pole";
			}
			var type:String=xml.data[0].@标识列; //标识线还是柱子
			jsonOjbject.elements=[];
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18; font-weight: bold;}";
			var leftList:Array=[];
			var rightList:Array=[];
			if (left == "pole")
			{
				left="bar_glass";
			}
			if (dirsction != "")
			{
			}
			for (var i:int=0; i < dataArray.length; i++)
			{
				child=new Object();
				if (dirsction != "")
				{
					if (left == "line")
					{
						if (type.split(",")[i] == "line")
						{
							child.type="line";
						}
						else
						{
							child.type="bar_glass";
							if (dataArray.length < 5)
							{
								child.barwidth=10;
							}
							if(isTwoPoint)
							{
								child.axis="right";
							}
						//	child.axis="right";
						}
					}
					else
					{
						if (type.split(",")[i] == "line")
						{
							child.type="line";
							if(isTwoPoint)
							{
								child.axis="right";
							}
							//child.axis="right";
						}
						else
						{
							child.type="bar_glass";
							if (dataArray.length < 5)
							{
								child.barwidth=10;
							}
						}
					}
				}
				else
				{
					if (type.split(",")[i] == "line")
					{
						child.type="line";
					}
					else
					{
						child.type="bar_glass";
						if (dataArray.length < 5)
						{
							child.barwidth=10;
						}
						
					}
				}
				
				child.colour=colors[i];
				Xtitle=xml.data[0].@图例;
				child.text=Xtitle.split(",")[i]; //显示图例
				x_data=new Array(xml.data.length());
				var m:Number=xml.data.length();
				if (m * dataArray.length < 8)
				{
					m=8
				}
				for (var j:int=0; j < m; j++)
				{
					Xname=dataArray[i];
					if (xml.data[j] != undefined)
					{
						Xvalue=xml.data[j].@[Xname];
					}
					else
					{
						Xvalue=this.minValue.toString();
					}
					if (Xvalue!="")
					{
						x_data[j]=Number(Xvalue);
						if (dirsction != "")
						{
							if (child.type == left)
							{
								leftList.push(Number(Xvalue));
							}
							else
							{
								rightList.push(Number(Xvalue));
							}
						}
						else
						{
							leftList.push(Number(Xvalue));
						}
					}else{
						j=m-1;
					}
					
				}
				child.values=x_data;
				jsonOjbject.elements[i]=child;
			}
			jsonOjbject.x_axis=new Object();
			lbles=new Object();
			lbles.rotate="vertical";
			jsonOjbject.x_axis.labels=lbles;
			jsonOjbject.x_axis.tick_height=100;
			jsonOjbject.x_axis.stroke=1; //透明度    
			
			
			Xdata=[];
			lineArray=[];
			
			for (j=0; j < m; j++)
			{
				if (xml.data[j] != undefined)
				{
					Xvalue=xml.data[j].@X轴数据;
				}
				else
				{
					Xvalue="0";
				}
				
				Xdata.push(Xvalue);
			}
			//lableArr.push(xml.data[0].@X轴单位);
			jsonOjbject.x_axis.labels=new Object();
			jsonOjbject.x_axis.labels.labels=Xdata;
			jsonOjbject.y_axis=new Object();
			jsonOjbject.y_axis.y_offset=true;
			jsonOjbject.y_axis.x_offset=true;
			jsonOjbject.y_offset=true;
			jsonOjbject.y_axis.tick_length=5;
			if (maxString == "" || maxString == null)
			{
				maxValue=getMax(leftList);
				if(!isTwoPoint)
				{
					var temMax=getMax(rightList);
					maxValue=maxValue>temMax?maxValue:temMax;
				}
				
			}
			else
			{
				maxValue=maxString.split(",")[0];
			}
			if (minString == "" || minString == null)
			{
				minValue=getMin(leftList);
				if(!isTwoPoint)
				{
					var temMin=getMin(rightList);
					minValue=minValue<temMin?minValue:temMin;
				}
				
			}
			else
			{
				minValue=minString.split(",")[0];
			}
			jsonOjbject.y_axis.max=maxValue; //设置最大值
			jsonOjbject.y_axis.min=minValue; //设置最小值
			jsonOjbject.y_axis.steps=(maxValue - minValue) / 5;
			if (dirsction != ""&&isTwoPoint)
			{
//								jsonOjbject.y_axis_right=new Object();
//								jsonOjbject.y_axis_right.y_offset=true;
//								jsonOjbject.y_axis_right.x_offset=true;
//								if (maxString == "" || maxString == null)
//								{
//									maxValue=getMax(rightList);
//								}
//								else
//								{
//									maxValue=maxString.split(",")[1];
//								}
//								if (minString == "" || minString == null)
//								{
//									minValue=getMin(rightList);
//								}
//								else
//								{
//									minValue=minString.split(",")[1];
//								}
//								jsonOjbject.y_axis_right.max=maxValue; //设置最大值
//								jsonOjbject.y_axis_right.min=minValue;
//								jsonOjbject.y_axis_right.tick_height="10";
//								jsonOjbject.y_axis_right.steps=(maxValue - minValue) / 5;
			}
			return jsonOjbject;
		}
			
		private function poleAndLine_old(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.y_legend.style="#DDDF0D"; //初始化样式	
			util=xml.data[0].@Y轴单位;
			jsonOjbject.y_legend.text=util.split(",")[0]; //xml.config.attributes()[1];   	//标题
			if (util.split(",").length > 1)
			{
				jsonOjbject.y2_legend=new Object();
				jsonOjbject.y2_legend.style="#DDDF0D"; //初始化样式					 
				jsonOjbject.y2_legend.text=util.split(",")[1];
			}

			jsonOjbject.x_legend=new Object();
			maxString=xml.data[0].@最大值;
			minString=xml.data[0].@最小值;
			var maxValue:Number=0;
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位; //xml.config.attributes()[1];   	//标题			  			
			dataArray=xml.data[0].@数据列.toString().split(","); //
			var dirsction:String=xml.data[0].@坐标轴方向;
			var left:String;
			if (dirsction != "")
			{
				left=dirsction.split(",")[0];
			}
			else
			{
				left="pole";
			}
			var type:String=xml.data[0].@标识列; //标识线还是柱子
			jsonOjbject.elements=[];
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18; font-weight: bold;}";
			var leftList:Array=[];
			var rightList:Array=[];
			if (left == "pole")
			{
				left="bar_glass";
			}
			if (dirsction != "")
			{
			}
			for (var i:int=0; i < dataArray.length; i++)
			{
				child=new Object();
				if (dirsction != "")
				{
					if (left == "line")
					{
						if (type.split(",")[i] == "line")
						{
							child.type="line";
						}
						else
						{
							child.type="bar_glass";
							if (dataArray.length < 5)
							{
								child.barwidth=10;
							}
							child.axis="right";
						}
					}
					else
					{
						if (type.split(",")[i] == "line")
						{
							child.type="line";
							child.axis="right";
						}
						else
						{
							child.type="bar_glass";
							if (dataArray.length < 5)
							{
								child.barwidth=10;
							}
						}
					}
				}
				else
				{
					if (type.split(",")[i] == "line")
					{
						child.type="line";
					}
					else
					{
						child.type="bar_glass";
						if (dataArray.length < 5)
						{
							child.barwidth=10;
						}

					}
				}

				child.colour=colors[i];
				Xtitle=xml.data[0].@图例;
				child.text=Xtitle.split(",")[i]; //显示图例
				x_data=new Array(xml.data.length());
				var m:Number=xml.data.length();
				if (m * dataArray.length < 8)
				{
					m=8
				}
				for (var j:int=0; j < m; j++)
				{
					Xname=dataArray[i];
					if (xml.data[j] != undefined)
					{
						Xvalue=xml.data[j].@[Xname];
					}
					else
					{
						Xvalue=this.minValue.toString();
					}
					if (Xvalue!="")
					{
						x_data[j]=Number(Xvalue);
						if (dirsction != "")
						{
							if (child.type == left)
							{
								leftList.push(Number(Xvalue));
							}
							else
							{
								rightList.push(Number(Xvalue));
							}
						}
						else
						{
							leftList.push(Number(Xvalue));
						}
					}else{
					  j=m-1;
					}

				}
				child.values=x_data;
				jsonOjbject.elements[i]=child;
			}
			jsonOjbject.x_axis=new Object();
			lbles=new Object();
			lbles.rotate="vertical";
			jsonOjbject.x_axis.labels=lbles;
			jsonOjbject.x_axis.tick_height=100;
			jsonOjbject.x_axis.stroke=1; //透明度    
			Xdata=[];
			lineArray=[];

			for (j=0; j < m; j++)
			{
				if (xml.data[j] != undefined)
				{
					Xvalue=xml.data[j].@X轴数据;
				}
				else
				{
					Xvalue="0";
				}

				Xdata.push(Xvalue);
			}
			//lableArr.push(xml.data[0].@X轴单位);
			jsonOjbject.x_axis.labels=new Object();
			jsonOjbject.x_axis.labels.labels=Xdata;
			jsonOjbject.y_axis=new Object();
			jsonOjbject.y_axis.y_offset=true;
			jsonOjbject.y_axis.x_offset=true;
			jsonOjbject.y_offset=true;
			jsonOjbject.y_axis.tick_length=5;
			if (maxString == "" || maxString == null)
			{
				maxValue=getMax(leftList);
			}
			else
			{
				maxValue=maxString.split(",")[0];
			}
			if (minString == "" || minString == null)
			{
				minValue=getMin(leftList);
			}
			else
			{
				minValue=minString.split(",")[0];
			}
			jsonOjbject.y_axis.max=maxValue; //设置最大值
			jsonOjbject.y_axis.min=minValue; //设置最小值
			jsonOjbject.y_axis.steps=(maxValue - minValue) / 5;
			if (dirsction != "")
			{
				jsonOjbject.y_axis_right=new Object();
				jsonOjbject.y_axis_right.y_offset=true;
				jsonOjbject.y_axis_right.x_offset=true;
				if (maxString == "" || maxString == null)
				{
					maxValue=getMax(rightList);
				}
				else
				{
					maxValue=maxString.split(",")[1];
				}
				if (minString == "" || minString == null)
				{
					minValue=getMin(rightList);
				}
				else
				{
					minValue=minString.split(",")[1];
				}
				jsonOjbject.y_axis_right.max=maxValue; //设置最大值
				jsonOjbject.y_axis_right.min=minValue;
				jsonOjbject.y_axis_right.tick_height="10";
				jsonOjbject.y_axis_right.steps=(maxValue - minValue) / 5;
			}
			return jsonOjbject;
		}

		/**
		 * 柱状分组图
		 */
		private function getVerGroupPoleData(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.y_legend=new Object();
			jsonOjbject.embedFont=true;
			jsonOjbject.y_legend.style="#DDDF0D"; //初始化样式		 	 
			jsonOjbject.y_legend.text=xml.data[0].@Y轴单位; //xml.config.attributes()[1];   	//标题	
			jsonOjbject.x_legend=new Object();
			jsonOjbject.x_legend.style="#DDDF0D"; //初始化样式					 
			jsonOjbject.x_legend.text=xml.data[0].@X轴单位;
			maxValue=xml.data[0].@最大值;
			minValue=xml.data[0].@最小值;
			dataArray=xml.data[0].@数据列.toString().split(","); //
			jsonOjbject.elements=[];
			jsonOjbject.title=new Object();
			jsonOjbject.title.text=xml.data[0].@标题;
			jsonOjbject.title.style="{font-size:18; font-weight: bold;}";
			list=[];
			for (var i:int=0; i < dataArray.length; i++)
			{
				child=new Object();
				child.type="bar_glass"; //bar_glass
				child.colour=colors[i];
				Xtitle=xml.data[0].@图例;
				child.text=Xtitle.split(",")[i];
				x_data=new Array(xml.data.length());

				    m=xml.data.length();
				if (m * dataArray.length < 8)
				{
					m=8
				}
				for (var j:int=0; j < m; j++)
				{
					Xname=dataArray[i];
					if (xml.data[j] != undefined)
					{
						Xvalue=xml.data[j].@[Xname];
					}
					else
					{
						Xvalue=this.minValue.toString();
					}
					x_data[j]=Number(Xvalue);
					list.push(Number(Xvalue));
				}
				child.values=x_data;
				if (xml.data.length() < 5)
				{
					child.width=50;
				}
				jsonOjbject.elements[i]=child;
			}
			jsonOjbject.width=50;
			jsonOjbject.x_axis=new Object();
			lbles=new Object();
			lbles.rotate="vertical";

			//json.x_legend.text="x轴单位";
			jsonOjbject.x_axis.labels=lbles;
			jsonOjbject.x_axis.tick_height=100;
			jsonOjbject.x_axis.stroke=1; //透明度    	  
			lableArr=new Array(xml.data.length());
			for (j=0; j < m; j++)
			{
				if (xml.data[j] != undefined)
				{
					Xvalue=xml.data[j].@X轴数据;
				}
				else
				{
					Xvalue="";
				}
				lableArr[j]=Xvalue;
			}
			jsonOjbject.x_axis.labels=new Object();
			jsonOjbject.x_axis.labels.labels=lableArr;
			jsonOjbject.y_axis=new Object();
			jsonOjbject.y_axis.y_offset=false;
			jsonOjbject.y_axis.x_offset=false;
			jsonOjbject.y_offset=true;
			jsonOjbject.y_axis.tick_length=5;
			if (maxValue == 0)
			{
				maxValue=getMax(list)
			}
			if (minValue == 0)
			{
				minValue=getMin(list);
			}
			jsonOjbject.y_axis.max=maxValue; //设置最大值
			jsonOjbject.y_axis.min=minValue; //设置最小值
			jsonOjbject.y_axis.tick_height="10";
			jsonOjbject.y_axis.steps=(maxValue - minValue) / 5;
			return jsonOjbject;
		}

		/**
		* 饼图数据格式
		*/
		private function getRoundData(xml:XML):Object
		{
			jsonOjbject=new Object();
			jsonOjbject.elements=[];
			child=new Object();
			
			child.type="pie";
			child.colour=this.colors;
			child.border="2";
			x_data=new Array(xml.data.length());
			for (var j:int=0; j < xml.data.length(); j++)
			{
				obj=new Object();
				obj.value=Number(xml.data[j].@["Value"]);
//				obj.label=xml.data[j].attributes()[2] + " (#val#)";
				
				obj.label=xml.data[j].@X轴数据 + " (#val#)";
				x_data[j]=obj;
			}
			child.values=x_data;
			jsonOjbject.elements[0]=child;
			return jsonOjbject;
		}

		/**
		* 排序
		*/
		private function getMax(array:Array):Number
		{
			maxValue=0;
			//查找最大值
			for (var i:int; i < array.length; i++)
			{
				temValue=array[i];
				if (temValue > maxValue)
				{
					maxValue=temValue;
				}
			}
			//取整数位
			if (maxValue > 10)
			{
				//取整数位
				tempValue2=maxValue
				if (tempValue2 < 100000000)
				{
					max=maxValue;
					len=max.toString().length;
					num=1;
					num=(len - 1) * 10;
					num2=tempValue2 / num;
					maxValue=(num2 + 1) * num;
				}
			}
			if (maxValue < 10 && maxValue > 1)
			{
				maxValue=10;
			}
			if (maxValue < 1)
			{
				maxValue=1;
			}
			return maxValue;
		}

		private function getMin(array:Array):Number
		{

			minValue=0;
			//查找最小值
			for (var i:int; i < array.length; i++)
			{
				temValue=array[i];
				if (temValue < minValue)
				{
					minValue=temValue;
				}
			}
			return minValue;
		}

		override public function initStage(stage:Stage):void
		{
			super.initStage(stage);
		}

		///
		//override CLDBaseComponent init() method
		///
		override protected function init():void
		{
			super.init();
		}

		///
		//override CLDBaseComponent darw method
		///
		override public function draw():void
		{
			try
			{
				this.resize();
			}
			catch (e:Error)
			{

			}


		}

		///
		// the url property
		///
		public function set url(value:String):void
		{
			this._url=value;
			load();
		}

		/**
		 * Load data method  该方法可以用来加载静态或者现成的JSON文件
		 **/
		public function load():void
		{
			var urll:URLLoader=new URLLoader();
			urll.addEventListener(Event.COMPLETE, complete);
			urll.load(new URLRequest(_url));
		}

		/**
		 * load data complete event
		 * **/
		private function complete(e:Event):void
		{
			var txt:String=String(e.target.data);
			var ok:Boolean=false;
			if (txt.length > 0)
			{
				ok=true;
				//根据JSON数据开始画图表  一定要是JSON格式的数据很重要  实现图表组件的主要方法
				build_chart(JSON.deserialize(txt));


			}
			else
			{

				return;
			}
			this.resize();

		}

		/**
		 * Chart display main method 重画大小 显示图形 图表组件的主要方法
		 * resize_pie ()
		 * **/
		//画饼图
		private function resize_pie():ScreenCoordsBase
		{

			// 增加鼠标移动事件
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

			this.background.resize(w, h);

			this.title.resize(w, h);

			// this object is used in the mouseMove method
			this.sc=new ScreenCoords(this.title.get_height(), 0, w, h, null, null, null, 0, 0, false);
			this.obs.resize(sc, w, h);

			return sc;
		}

		private function resize_radar():ScreenCoordsBase
		{
			this.background.resize(w, h);
			this.title.resize(w, h);
			this.keys.resize(0, this.title.get_height(), w, h);

			var top:Number=this.title.get_height() + this.keys.get_height();

			// this object is used in the mouseMove method
			var sc:ScreenCoordsRadar=new ScreenCoordsRadar(top, 0, w, h);

			sc.set_range(this.radar_axis.get_range());
			// 0-4 = 5 spokes
			sc.set_angles(this.obs.get_max_x() - this.obs.get_min_x() + 1);

			// resize the axis first because they may
			// change the radius (to fit the labels on screen)
			this.radar_axis.resize(sc);
			this.obs.resize(sc, w, h);

			return sc;
		}

		public function resize():void
		{
			//
			// the chart is async, so we may get this
			// event before the chart has loaded, or has
			// partly loaded
			//
			if (!this.ok)
				return; // <-- something is wrong

			var sc:ScreenCoordsBase;

			if (this.radar_axis != null)
				sc=this.resize_radar();
			else if (this.obs.has_pie())
				sc=this.resize_pie();
			else
				sc=this.resize_chart();

			if (this.menu)
				//	this.menu.resize();	
				// tell the web page that we have resized our content	
				sc=null;
		}

		private function mouseMove(event:Event):void
		{

			if (!this.tooltip)
				return; // <- an error and the JSON was not loaded

			switch (this.tooltip.get_tip_style())
			{
				case Tooltip.CLOSEST:
					this.mouse_move_closest(event);
					break;

				case Tooltip.PROXIMITY:
					this.mouse_move_proximity(event as MouseEvent);
					break;

				case Tooltip.NORMAL:
					this.mouse_move_follow(event as MouseEvent);
					break;

			}
		}

		private function mouseOut(event:Event):void
		{

			if (this.tooltip != null)
				this.tooltip.hide();

			if (this.obs != null)
				this.obs.mouse_out();
		}

		private function mouse_move_closest(event:Event):void
		{

			var elements:Array=this.obs.closest_2(this.mouseX, this.mouseY);
			this.tooltip.closest(elements);
		}

		private function mouse_move_proximity(event:MouseEvent):void
		{

			//tr.ace(event.currentTarget);
			//tr.ace(event.target);

			var elements:Array=this.obs.mouse_move_proximity(this.mouseX, this.mouseY);
			this.tooltip.closest(elements);
		}

		private function mouse_move_follow(event:MouseEvent):void
		{

			tr.ace(event.currentTarget);
			tr.ace(event.target);
			if (event.target is has_tooltip)
				this.tooltip.draw(event.target as has_tooltip);
			else
				this.tooltip.hide();
		}



		/**
		 *  build chart main method
		 * param json:object  -- users json data

		**/
		public function build_chart(json:Object):void
		{
			// init singletons:
			NumberFormat.getInstance(json);
			NumberFormat.getInstanceY2(json);
			this.tooltip=new Tooltip(json.tooltip)
			var g:Global=Global.getInstance();
			g.set_tooltip_string(this.tooltip.tip_text);
			// these are common to both X Y charts and PIE charts:
			this.background=new Background(json);
			this.title=new Title(json.title);
			//
			this.addChild(this.background);
			//		
			if (JsonInspector.is_radar(json))
			{
				this.obs=Factory.MakeChart(json);
				this.radar_axis=new RadarAxis(json.radar_axis);
				this.keys=new Keys(this.obs);
				this.addChild(this.radar_axis);
				this.addChild(this.keys);
			}
			else if (!JsonInspector.has_pie_chart(json))
			{
				this.build_chart_background(json);
			}
			else
			{
				// this is a PIE chart
				this.obs=Factory.MakeChart(json);
				// PIE charts default to FOLLOW tooltips
				this.tooltip.set_tip_style(Tooltip.NORMAL);
			}

			// these are added in the Flash Z Axis order
			this.addChild(this.title);
			for each (var set:Sprite in this.obs.sets)
				this.addChild(set);
			this.addChild(this.tooltip as DisplayObject);

			if (json['menu'] != null)
			{
				this.menu=new Menu('99', json['menu']);
				this.addChild(this.menu);
			}

			this.ok=true;


		}

		//
		// PIE charts don't have this.
		// build grid, axis, legends and key
		//
		private function build_chart_background(json:Object):void
		{
			//
			// This reads all the 'elements' of the chart
			// e.g. bars and lines, then creates them as sprites
			//
			this.obs=Factory.MakeChart(json);
			//
			this.x_legend=new XLegend(json.x_legend);
			this.y_legend=new YLegendLeft(json);
			this.y_legend_2=new YLegendRight(json);
			this.x_axis=new XAxis(json, this.obs.get_min_x(), this.obs.get_max_x());
			this.y_axis=new YAxisLeft();
			this.y_axis_right=new YAxisRight();

			// access all our globals through this:
			var g:Global=Global.getInstance();
			// this is needed by all the elements tooltip
			g.x_labels=this.x_axis.labels;
			g.x_legend=this.x_legend;

			//
			// pick up X Axis labels for the tooltips
			// 
			this.obs.tooltip_replace_labels(this.x_axis.labels);
			this.keys=new Keys(this.obs);

			this.addChild(this.x_legend);
			this.addChild(this.y_legend);
			this.addChild(this.y_legend_2);
			this.addChild(this.y_axis);
			this.addChild(this.y_axis_right);
			this.addChild(this.x_axis);
			this.addChild(this.keys);

			// now these children have access to the stage,
			// tell them to init
			this.y_axis.init(json, 200);
			this.y_axis_right.init(json, 200);
		}

		// 图表组件的宽属性
		public function get w():Number
		{
			return this.width == 0 ? 200 : this.width;
		}

		// 高属性
		public function get h():Number
		{
			return this.height == 0 ? 200 : this.height;
		}

		private function resize_chart():ScreenCoordsBase
		{

			//
			// we want to show the tooltip closest to
			// items near the mouse, so hook into the
			// mouse move event:
			// 
			// FlashConnect.trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			this.background.resize(w, h);
			this.title.resize(w, h);

			var left:Number=this.y_legend.get_width() /*+ this.y_labels.get_width()*/ + this.y_axis.get_width();

			this.keys.resize(left, this.title.get_height(), w, h);

			var top:Number=this.title.get_height() + this.keys.get_height();

			var bottom:Number=h;
			bottom-=(this.x_legend.get_height() + this.x_axis.get_height());

			var right:Number=w;
			right-=this.y_legend_2.get_width();
			//right -= this.y_labels_right.get_width();
			right-=this.y_axis_right.get_width();

			// this object is used in the mouseMove method
			this.sc=new ScreenCoords(top, left, right, bottom, this.y_axis.get_range(), this.y_axis_right.get_range(), this.x_axis.get_range(), this.x_axis.first_label_width(), this.x_axis.last_label_width(), false);

			this.sc.set_bar_groups(this.obs.groups);

			this.x_axis.resize(sc,
				// can we remove this:
				h - (this.x_legend.get_height() + this.x_axis.labels.get_height()) // <-- up from the bottom
				);
			this.y_axis.resize(this.y_legend.get_width(), sc);
			this.y_axis_right.resize(0, sc);
			this.x_legend.resize(sc, w, h);
			this.y_legend.resize(w, h);
			this.y_legend_2.resize(w, h);
			this.obs.resize(sc, w, h);
			// Test code:
			this.dispatchEvent(new Event("on-show"));
			return sc;
		}

		private function die():void
		{
			if (this.obs != null)
				this.obs.die();

			this.obs=null;
			this.xml=null;
			if (this.tooltip != null)
				this.tooltip.die();

			if (this.x_legend != null)
				this.x_legend.die();
			if (this.y_legend != null)
				this.y_legend.die();
			if (this.y_legend_2 != null)
				this.y_legend_2.die();
			if (this.y_axis != null)
				this.y_axis.die();
			if (this.y_axis_right != null)
				this.y_axis_right.die();
			if (this.x_axis != null)
				this.x_axis.die();
			if (this.keys != null)
				this.keys.die();
			if (this.title != null)
				this.title.die();
			if (this.radar_axis != null)
				this.radar_axis.die();
			if (this.background != null)
				this.background.die();

			this.tooltip=null;
			this.x_legend=null;
			this.y_legend=null;
			this.y_legend_2=null;
			this.y_axis=null;
			this.y_axis_right=null;
			this.x_axis=null;
			this.keys=null;
			this.title=null;
			this.radar_axis=null;
			this.background=null;

			while (this.numChildren > 0)
				this.removeChildAt(0);

			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

			// do not force a garbage collection, it is not supported:
			// http://stackoverflow.com/questions/192373/force-garbage-collection-in-as3

		}

		public function set jsonData(value:*):void
		{
			this._jsonData=value;
			build_chart(value);
			this.invalidate();

		}




	}

}
