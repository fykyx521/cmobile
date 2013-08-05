package com.identity.Grild
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.RowEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;

	/**
	 * 
	 * 表格头部
	 **/ 
	
	public class CLDTableHeader extends CLDBaseComponent
	{
	  	private var HeadData:XML=new XML();//表头数据
		public var  rowHeight:int=34;  //行高
 		public var  rowWidth:int=0;
		private var xml:XML;
		public var uiinit:Boolean=false;
		private var list:Array=[];
		private var cloumCount:int;
		private var currentIndex:Number=0;
		private var parm:String;
		private var parmList:Array=[];
		private var totalWidth:Number=0; //用户设置的宽度和
		private var totalScale:Number=0;//总比例和
		private var temW:Number=0;
		private var mouseClickColor:int;
		private var mouseOutColor:int;
		private var temC:String;
	    public function CLDTableHeader(_xml:XML,_width:Number,_height:Number)
		{
		   this.xml=_xml;
		   this.width=_width;
		   this.height=_height;
		   build();
		 
		}
		  override public function pause():void
		 {
		 	
		 }
		 override public function dispose():void
		 {
		 	super.dispose();
		 	this.HeadData=null;
		 	this.rowHeight=null;
		 	this.rowWidth=null;
		 	this.xml=null;
		 	this.uiinit=null;
		 	this.list=null;
		 	this.cloumCount=null;
		 	this.currentIndex=null;
		 	this.parm=null;
		 	this.parmList=null;
		 	this.totalWidth=null;
		 	this.totalScale=null;
		 	this.temW=null;
		 	this.mouseClickColor=null;
		 	this.mouseOutColor=null; 	  
			this.temC=null;
			 
		}
		 /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	    	    	          
	         this.addEventListener(Event.RESIZE,resize);
	    }
	    
	     private function resize(e:Event):void{
	    	if(this.list.length>0){
	    		reload();
	    	}     	
	    }
	    /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{
			super.draw();
			if(uiinit&&data&&this.dataChange&&!this.isDispose){
                this.build();
			}			
		}	
		private function reload():void{
		  if(!xml.hasOwnProperty("table")){
				return;
			}
			var _x:Number=0;
			var _width:int;
		   for(var i=0;i<list.length;i++){		   	
		   	 var cloum:CLDCloum=list[i] as CLDCloum;
		   	     cloum.x=_x;
		   	     _width=cloum.scale*this.width;
		   	      if(i>0&&i<list.length){
		   	      	   cloum.setSize(_width+1,this.rowHeight+1);
		   	      }else{
		   	          cloum.setSize(_width,this.rowHeight);
		   	      }		   	  
		   	     _x+=_width;
		   }   	
		}		 
		 /**
		 *设置图片大小
		 */
		private function loadImage():void
		{
            	 
			 this.uiinit=true;
		     this.invalidate();
		   //  buildHeader();
		}	 
		 /**
		 * 初始化表头
		 * 
		 */ 
		 private function build():void
		 {		 	
            if(!xml.hasOwnProperty("table")){
				return;
			}
		     parm=xml.table[0].data[0].@初始化参数;	
		     temC=xml.table[0].data[0].@单元格颜色;
			 mouseOutColor=parseInt("0x"+temC.substr(1,temC.length));
			 if(mouseOutColor==0){
			 	mouseOutColor=0xCCCCCC;
			 }
			 temC=xml.table[0].data[0].@鼠标悬停颜色;
			 mouseClickColor=parseInt("0x"+temC.substr(1,temC.length));
			 if(mouseClickColor==0){
			 	mouseClickColor=0xCCCCCC;
			 } 	   
	  	     parmList=parm.split(",");
	 	     rowWidth=width/parmList.length;
	 	     for(var i:int=0;i<parmList.length;i++){
	 	     	 temW=parmList[i].toString().split(":")[1];
	 	     	 if(temW==0){
	 	     	 	temW=rowWidth;
	 	     	 }
	 	     	 totalWidth+=temW;
	 	     }	   	
             for(var i:int=0;i<parmList.length;i++){	  
             	var title:String= parmList[i].toString().split(":")[0];  	 		 
			    var cloum:CLDCloum=new CLDCloum(parmList.length,i,title);	
			        cloum.addEventListener(MouseEvent.CLICK,mouseClick);
			        cloum.colID=i;
			        if(i==parmList.length-1){
			        	 cloum.scale=1-totalScale;
			        }else{
			        	temW=parmList[i].toString().split(":")[1];
			        	 cloum.scale=temW/totalWidth;
			        }
			         totalScale+=cloum.scale;			      			       
			         cloum.setNoUsed();			       			     
			     this.addChild(cloum);    
			     list.push(cloum);    
	 	     }	 
	 	     reload();	     
	 	}
	 	private function mouseClick(e:Event):void{
	 	   var oldCloum:CLDCloum=list[currentIndex] as CLDCloum;
	 	       oldCloum.setNoUsed();
	 	   var newCloum:CLDCloum=e.currentTarget as CLDCloum;
	 	       newCloum.setUsed();
	 	       currentIndex=newCloum.dataIndex;
	 	       var rowClick:RowEvent=new RowEvent(RowEvent.rowClick);	         
		    	   rowClick.colID=newCloum.colID;		       
		         rowClick.mouseClickColor=this.mouseClickColor;
		         rowClick.mouseOutColor=this.mouseOutColor;
				 this.dispatchEvent(rowClick); 	
    	}
    	
      
 
	}
}