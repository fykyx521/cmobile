package com.identity
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDTextField;
	import com.careland.component.util.Style;
	
	import fl.controls.ScrollBarDirection;
	import fl.controls.UIScrollBar;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.*;
	
	import uk.co.teethgrinder.string.StringUtils;
 
	/*************************************************
	 * 
	 *
	 * 
	 * 文本封装类
	 * author: 程斌斌 (2011-3-30)
	 *************************************************/
	public class CLDTextArea extends CLDBaseComponent
	{
        /**
        * 全局变量
        */ 
		private var text:TextField;
		private var downPoint:Point;
        private var tempCount:int=0; //该变量用来控制鼠标的拨动速度
		/**
		  *
		  * 文本内容
		 */
		private var _value:String="";
		/**
		 * 文本的行高
		 */
		private var rowH:int=0;
		/**
		 * 滚动条
		 */	 
        
        public var bground:Boolean=false;
        /**
        * 
        * 滚动条显示方式  
        *说明: 0 固定显示   1鼠标拖拽显示，鼠标离开时隐藏 2 不显示
        */ 
        public var disType:int=2;
        /**
        * 
        * 构造函数
        */ 
		public function CLDTextArea(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
		 	super(parent,xpos,ypos,autoLoad,timeInteval);
		}
		/***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	    	
	    	
	       setContent();
	    	
	    }
	   
		  //给该组件设置动态数据
		override public function set data(value:*):void
		{
			
			var xml:XML=XML(value);
	    	super.data=String(xml.data.@content);
			this.invalidate();
		}

	     private function build():void{
//	          text.width=this.width - 16;
//			  text.height=height - 1.5;
//			  if(bground){
//			    graphics.clear();
//		        graphics.beginFill(0xFFFFFF,1);
//		        graphics.drawRect(0,0,this.width,this.height);
//		        graphics.endFill();
//			  }
		
	     } 
	   
	    /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{
			super.draw();
	 
			if (this.dataChange)
			{		
				/**
				  * 绘制内容
				 */
		    	text.text=String(this.data).split("<br>").join("\n").split("<br/>").join("\n").split("<br />").join("\n");				
				rowH=text.textHeight / text.numLines; //文本行高=文本的高度/行数   	 	
//				text.x=1;
//				text.y=1;				 
				text.multiline=true;
			    text.setTextFormat(Style.getTFTXT());
				this._dataChange=false;
			}
 	        if(text&&text.text!=""){
             	text.width=this.width;
             	text.height=this.height;
             }
            
			//设置滚动条
           
		}

    	public function set value(v:String):void
		{	
			this._value=v;
			this.invalidate();
		}
		public function get value():String
		{	
			return this._value;			  
	    }
        /**
        * 
        * 设置文本内容
        */ 
        private function setContent():void{          
            text=new CLDTextField();    
            text.wordWrap=true;  
            text.multiline=true;       
		    text.selectable=false;			          			  
		    text.mouseWheelEnabled=true;
		    text.embedFonts=true;		    
		   
		    this.addChild(text);
//		     text.addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN);
//		     if(disType!=2){  //滚动条设置为不显示时不支持滚动条触发事件
//		    		 			    
//		         text.addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL);   
//		         text.addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP);			  
//		     }				   		     
		  
//		    hScrollBar= new UIScrollBar();
//            hScrollBar.direction = ScrollBarDirection.VERTICAL;
//           // hScrollBar.scrollTarget = text;             
//            hScrollBar.visible=false;                                
//            addChild(hScrollBar);
//            build();
        }
        /**
        * 文本内容mouseDown  
        * 
        */          
        private function  MOUSE_DOWN(event:MouseEvent):void{     
        	  
        	 text.addEventListener(MouseEvent.MOUSE_MOVE, MOUSE_MOVE);         
        	 text.addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP);   
        	 text.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP);          	
        	 downPoint=new Point(event.localX,event.localY);//鼠标释放时获取鼠标坐标点
        }
 
       /***
       * 
       * 文本内容MouseMove事件
       */ 
       private function  MOUSE_MOVE(event:MouseEvent):void{    
//       	if(disType!=2){
//       		hScrollBar.visible=true;   
//       	}    	
       	/***
       	 * 这里设置了两个坐标，downPoint鼠标释放的坐标，disPoint鼠标当前坐标，通过行高来控制速度,行高越低(字体越小)速度越快
       	 */       	  		 
       	 var newPoint:Point=new Point(event.localX,event.localY);
       	 var disPoint:Point=newPoint.subtract(downPoint);  
       	 
          if(tempCount>=rowH/3){
          	  if(disPoint.y >0){    	 	 	
		 	    text.scrollV-=1;	           	
		     }else{
		 	    text.scrollV+=1;		 	   
		      }
		      tempCount=0;
          }  
             tempCount++;                              	  	            	 	
      	    downPoint=newPoint;
       }       
       /**
       * 
       * 鼠标弹起或鼠标离开事件
       */ 
       private function MOUSE_UP(event:MouseEvent):void
       {     	
//       	 if(disType==1){
//       	 	hScrollBar.visible=false;   //隐藏滚动条
//       	 	text.removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP);
//         	text.removeEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP);            	    
//       	 }    
//       	  text.removeEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE);   	           	 	     
       }  
       
       /***
       * 
       * 滚轮滚动事件
       * 说明:在设置滚动条为动态显示的时候,单纯的鼠标滚动事件不会触发滚动条隐藏事件，鼠标离开自动隐藏
       *  
       */  
       private function MOUSE_WHEEL(event:MouseEvent):void{
//       		if(disType!=2){
//               hScrollBar.visible=true;    
//           }
//            text.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP);  
       }   
    
 }
}