package com.identity.radar
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.ui.*;

	/**
	 *
	 * @author Administrator
	 */
	public class CLDRadar extends CLDBaseComponent
	{
		private var bulkLoader:BulkLoader;
		public var time:int=0;
		private var round:CLDRound;
		private var range:Number=0;
		private var sprite:Sprite=new Sprite();
		private var pointList:Array=[];
		private var scale:Number=1; //比例
		private var num:Number;
		private var radar:Bitmap;
		public var angle:Number=1; //旋转角度
		private var overSprite:Sprite;
		private var titleSprite:Sprite=new Sprite(); 
		private var dataXML:XML;
		private var titleXML:XML;
		private var titleArray:Array;
		private var _x:Number;
		private var _y:Number;
		private var size:Number;
		private var yellow:Bitmap;
		private var red:Bitmap;
		private var green:Bitmap;
		private var orange:Bitmap;
		
	 	public function CLDRadar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			  super(parent,xpos,ypos,autoLoad,timeInteval);
			  this.addEventListener(Event.ENTER_FRAME, update);
		}
        override public function dispose():void{
           super.dispose();
           this.overSprite=null;
           this.titleSprite=null;
           this.dataXML=null;
           this.titleXML=null;
           this.titleArray=null;
           this._x=0;
           this._y=0;
           this.overSprite=null;
           this.angle=null;
           this.radar=null;
           this.num=null;
           this.scale=null;
           this.pointList=null;
           this.sprite=null;
           this.range=null;
           this.round=null;
           this.time=null;
           this.bulkLoader=null;
           this.removeEventListener(Event.RESIZE, resize);
           this.removeEventListener(Event.ENTER_FRAME, update);
        }
		override protected function addChildren():void
		{
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			this.addEventListener(Event.RESIZE, resize);
			
		}

		//给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
		    build();
//		    if(this.yellow==null){
//		    	  setTitle();
//		    }		  
		}

		private function resize(e:Event):void
		{
			if (this.height > this.width)
			{
				this.num=this.width;
			}
			else
			{
				this.num=this.height;
			}			
		    if(this.pointList.length>0){
		    	reload();
			} 
			
  	  }
		override public function draw():void
		{		 
		}

		public function getBitmap(key:*):Bitmap
		{
			return this.config.getBitmap(key);
		}

		private function reload():void
		{		
			_x=(this.width-num)/2;
			_y=(this.height-num)/2;
			  scale=this.num / 1000;	 	 
			  radar.width=this.num;
			  radar.height=this.num; 
			  radar.x=_x;
			  radar.y=_y;
			  round.width=this.num;
		      round.height=this.num;
			  round.x=this.num / 2+_x;
			  round.y=this.num / 2+_y;
			  for(var i:int=0;i<pointList.length;i++){
			  	var point:CLDPoint=pointList[i] as CLDPoint;
			  	var pointStr:String=this.setPointByLayer(point.layer, point.quadrant);
			  	   var numX:Number=pointStr.split(":")[0] ;
			  	   var numY:Number=pointStr.split(":")[1];
			  	    point.x=numX+_x;
				    point.y=numY+_y;
				    point.angle=this.setRangeByQuadrant(numX,numY,point.quadrant);				  
			  } 
			 
			//  titleSprite.x=_x;   
			//  titleSprite.y=_y;  
		}            		 
		/**
		* 画点
		*/
		private function build():void
		{		
			 dataXML=XML(this.data);	
		     if(radar==null){
		     	 radar=new Bitmap();
			 radar.bitmapData=getBitmap("randar").bitmapData.clone();
			 radar.width=this.num;
			 radar.height=this.num;
	 	     this.addChild(radar);	 			 	 	
			 scale=this.num / 1000;
			
			 round=new CLDRound();	
 			 this.addChild(round);	
		     }
		    for (var m:int=0; m < pointList.length; m++)
			{
				var point:CLDPoint=pointList[m] as CLDPoint;
				if (this.contains(point))
				{
					this.removeChild(point);
				}
			}
			pointList=[];
			for (var i:int=0; i < dataXML.table[1].data.length(); i++)
			{
				var layer:int=dataXML.table[1].data[i].@圈;
				var bgColor:String=dataXML.table[1].data[i].@颜色值;
				var color:int=parseInt("0x" +bgColor.substr(1,bgColor.length));
				var size:Number=dataXML.table[1].data[i].@点大小;
				var point:CLDPoint=new CLDPoint(scale, color,size/2,true);				
				var lady:String=dataXML.table[1].data[i].@point;
				point.quadrant=dataXML.table[1].data[i].@象限;
				point.layer=layer;
				point.mouseClickData=dataXML.table[1].data[i].@点击数据;				
				point.addEventListener(MouseEvent.CLICK, mouseClick,true);
 				var pointStr:String=this.setPointByLayer(point.layer, point.quadrant);
				point.x=pointStr.split(":")[0];
				point.y=pointStr.split(":")[1];
				point.setSize(30,30);
				point.angle=this.setRangeByQuadrant(point.x,point.y,point.quadrant);
				this.addChild(point);
				pointList.push(point);
			}			
		  	 reload();
		}

		/**
		 * 根据圈生成坐标
		 * @parm  圈,象限,每圈的大小
		 */
		private function setPointByLayer(layer:int, quadrant:int):String
		{
           /**
           * 段大小是 指针头外圈 到  组件外环内圈的距离  平分成4圈 
           */ 
			var _x:Number;
			var _y:Number;
			var section:Number=(this.num - 120*scale) / 8; //段大小		  
			var R:Number=this.num / 2; //圆半径 
			var r:Number=(this.num -120*scale ) * layer / 8;
			var a:int;
			var c:int; //计算C边长度	
			var b:int;
			if(layer==1){
				a=20*this.scale+(section-40*this.scale)*Math.random();
				b=20*this.scale+(section-40*this.scale)*Math.random();
				c=b+1;
			}else{
			    a=(layer * section-120*scale) * Math.random();
			    c=layer*section-section/2+section/2*Math.random();
			    b=Math.sqrt(c*c-a*a); 
			}		 
			 if(isNaN(b)||b>c){
			 	this.setPointByLayer(layer,quadrant);
			 }
			switch (quadrant) //判断象限
			{
				case 1:				    
					_x=R + a ;
					_y=R - b;					 										 
					break;
				case 2:
					_x=R - a;
					_y=R - b;					 
					break;
				case 3:
					_x=R - a ;
					_y=R + b;					 
					break;
				case 4:
					_x=R + a;
					_y=R + b;					 
					break;
			}
 			return _x + ":" + _y;
 			
 		}   
		/**
		* 根据坐标点以及象限生成旋转角度
		*/
		public function setRangeByQuadrant(_x:Number, _y:Number, quadrant:int):Number
		{
			var range:Number;
			var a:Number;
			var b:Number;
			var c:Number;
			var sinA:Number;
			var Ha:Number;
			if (quadrant == 1)
			{ //第一象限
				a=_x - this.num/ 2;
				b=this.num /2 - _y;
				c=Math.sqrt(a * a + b * b);
				sinA=a / c;
				Ha=Math.asin(sinA);
				range=Ha * 180 / Math.PI;			 
			}
			if (quadrant == 4)
			{ //第四象限
				a=_y -this.num / 2;
				b=_x - this.num / 2;
				c=Math.sqrt(a * a + b * b);
				sinA=a / c;
				Ha=Math.asin(sinA);
				range=Ha * 180 / Math.PI+90;				 
			}
			if (quadrant == 3)
			{ //第三象限
				a=this.num / 2 - _x;
				b=_y - this.num / 2;
				c=Math.sqrt(a * a + b * b);
				sinA=a / c;
				Ha=Math.asin(sinA);
				range=Ha * 180 / Math.PI+180;				 
			}
			if (quadrant == 2)
			{ //第二象限
				a=this.num / 2 - _y;
				b=this.num / 2 - _x;
				c=Math.sqrt(a * a + b * b);
				sinA=a / c;
				Ha=Math.asin(sinA);
				range=Ha * 180 / Math.PI+270;			 
			}
			return range;
		}
		/**
		* 标注点闪动，方向标旋转
		*/
		public function update(e:Event):void
		{
			if(this.round!=null){
		      this.round.rotation=range;
			  if (pointList != null)
			  {
				checkPoint();
				range+=angle;
				if (range >= 360)
				{
					range=0;
				}
			  }
			}		
		}
		/**
		 * 显示图例
		 */ 
		 private function setTitle():void{		 	 
		 	 titleXML=XML(this.data);
	 	 	 var title:String=titleXML.table[0].data[0].@图例说明;
		 	  size=titleXML.table[0].data[0].@大小;
		 	 titleArray=title.split(",");
		 	 var _x:int=0;
		 	 var _y:int=0;
		 	 var color:int;		 	 	 	     
		 	     var text:TextField=new TextField();
		 	         text.text=title.split(",")[0];
		 	         text.x=size+5;
		 	         text.y=0;
		 	         titleSprite.addChild(text);
		 	     var text1:TextField=new TextField();
		 	         text1.text=title.split(",")[1];
		 	         text1.x=size+5;
		 	         text1.y=size;
		 	         titleSprite.addChild(text1);	
		 	      var text2:TextField=new TextField();
		 	         text2.text=title.split(",")[2];
		 	         text2.x=size+5
		 	         text2.y=size*2;
		 	         titleSprite.addChild(text2);
		 	       var text3:TextField=new TextField();
		 	         text3.text=title.split(",")[3];
		 	         text3.x=size+5;
		 	         text3.y=size*3;
		 	         titleSprite.addChild(text3);       	 	        	
		 	        	 	         	    
		 	  			 	
		 	yellow=new Bitmap();
			yellow.bitmapData=getBitmap("randarYellow").bitmapData;			 
			yellow.height=size;
			yellow.width=size;			
			yellow.y=size*2;
			yellow.x=0;
			titleSprite.addChild(yellow);
			red=new Bitmap();
			red.bitmapData=getBitmap("randarRed").bitmapData;
			red.height=size;
			red.width=size;
			titleSprite.addChild(red);
			red.y=0;
			orange=new Bitmap();
			orange.bitmapData=getBitmap("randarOrange").bitmapData;
			orange.height=size;
			orange.width=size;
			orange.y=size;
			titleSprite.addChild(orange);
			green=new Bitmap();	
			green.bitmapData=getBitmap("randarGreen").bitmapData;
			green.height=size;
			green.width=size;
			green.x=0;
			green.y=size*3;
			titleSprite.addChild(green); 	 	 
 		    this.addChild(titleSprite);
		 }
		/**
		* 判断标注点的显示和隐藏
		*/
		private function checkPoint():void
		{	 
			for (var i:int=0; i < pointList.length; i++)
			{
				var point:CLDPoint=pointList[i] as CLDPoint;
				if (range >= point.angle && (range - point.angle) <= 90)
				{
					point.flashing=true;				
				}
				else
				{
					point.flashing=false;	
 			    }
				if(range>point.angle-5&& (range - point.angle) <= 90){
					if(this.contains(point)){
						  this.swapChildren(point,round);
					}
					 
				}
				if (range <= point.angle2 && point.angle >= 270)
				{ //在第一象限区域旋转的时候改变第二象限
					point.flashing=true;
					if(this.contains(point)){
						  this.swapChildren(point,round);
					}
				}
			}
		}

		 
		private function mouseClick(e:MouseEvent):void
		{	
			if(overSprite!=null){
				 if(contains(overSprite)){
			 	   this.removeChild(overSprite);
			    }
			} 	
			overSprite=new Sprite();		 
			var point:CLDPoint=e.currentTarget as CLDPoint;			
			overSprite.alpha=.9;
			var overText:TextField=new TextField();
			overText.embedFonts=true;
			overText.text=point.mouseClickData.split("<br/>").join("\n");		 
			overText.setTextFormat(Style.getTF());			 
			overText.x=(this.num-overText.width)/2+_x;
			overText.y=(this.num-overText.height)/2+_y;			 					
			overText.width=overText.textWidth+10;
			overText.height=overText.textHeight+10;
			overSprite.addChild(overText);
			overSprite.graphics.beginFill(0xFFFFFF, 1);
			overSprite.graphics.drawRect(overText.x, overText.y, overText.width, overText.height);
			overSprite.graphics.endFill();
			overSprite.addEventListener(MouseEvent.CLICK,mouseOut);	
			if(overText.text!=""){
				this.addChildAt(overSprite,this.numChildren-1);
			}				 
			
		}

		private function mouseOut(e:MouseEvent):void
		{
			 if(contains(overSprite)){
			 	this.removeChild(overSprite);
			 }			
		}

	}
}