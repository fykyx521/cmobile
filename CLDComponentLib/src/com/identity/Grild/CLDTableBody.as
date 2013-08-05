package com.identity.Grild
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDTextField;
	import com.careland.component.util.Style;
	import com.careland.event.RowEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.system.System;
	import flash.text.*;
	import flash.ui.*;

	/**
	* 绘制身体
	*/
	public class CLDTableBody extends CLDBaseComponent
	{

	 
		public var rowHeight:int=40; //行高
		public var rowWidth:int=0;
		public var headHeight:int=34; //表头高度
		public var align:String="center"; //对齐方式
		public var maxY:int=0; //最大Y坐标
	 	private var bulkLoader:BulkLoader;
	  	public var uiinit:Boolean;
		public var ifHashCheckBox:Boolean=false;
	 	private var xml:XML;
        public var cloums:Array=[]; //所有单元格内容
        private var len:Number;
        private var tempText:CLDTextField;
        private var max:int;
        private var _y:int;
        private var _x:int;
        private var text:String;
        private var list:Array=[];
        private var listHeight:Array;
        private var temRowList:Array;
        private var cldRow:CLDRow;
        public var totalPage:int=1;
        public var currentPage:int=1;
        public var pageSize:int=12;
        public var totalRecord:int=1;
        private var currentSelectRow:int=-1;
        public  var currentSelectCol:int=-1;
       	private var parm:String;
		private var parmList:Array=[];
		private var totalWidth:Number=0; //用户设置的宽度和
		private var totalScale:Number=0;//总比例和
		private var temW:Number=0;	 
		 private var mouseClickColor:int;
		 private var mouseOutColor:int;
		 private var temC:String;	
	     private var oldY:Number=0;
		 private var newY:Number=0;
		 private var oldX:Number=0;
		 private var newX:Number=0;
		 private var distance:Number=0;
		 private var rowEvent:RowEvent;
		 private var title:String;
		 private var type:Boolean=false;
		 private var titleList:Array=[];
		 private var ifnull:Boolean;
 	  	public function CLDTableBody(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
              super(parent,xpos,ypos,autoLoad,timeInteval);
		}
		override public function dispose():void
		{
			super.dispose();
			
			this.len=null;
			this.list=null;
			this.listHeight=null;
			this.totalWidth=null;
			this.totalRecord=null;
			this.totalPage=null;
			this.currentPage=null;
			this.currentSelectCol=null;
			this.currentSelectRow=null;
			this.parm=null;
			this.parmList=null;
			this.tempText=null;
			this.text=null;
			this.tempText=null;
			this.temW=null;
			this.mouseClickColor=null;
			this.mouseOutColor=null;
			this.temC=null;
			this.oldX=null;
			this.newX=null;
			this.distance=null;
			this.rowEvent=null;
			this.len=null;
			this.tempText=null;
			this.max=null;
			this._y=null;
			this.text=null;
			this.list=null;
			this.listHeight=null;
			this.temRowList=null;	
			this.cldRow=null;  
			cloums=null;
			rowHeight=null;
			headHeight=null;
			align=null;
			maxY=null;
		    bulkLoader=null;
		 	uiinit=null;
			ifHashCheckBox=null;
			xml=null;
			this.removeEventListener(RowEvent.rowClick,rowClick);

		}
		/**
	     *
	     * 加载图片路径
	     */
		private function loadImage():void
		{			 
			uiinit=true;
			this.invalidate();
		}

		override public function pause():void
		{

		}
		public function getBitmap(key:*):Bitmap
		{
			return this.bulkLoader.getBitmap(key, false);
		}

		/***
		 *
		 * 覆盖父类添加子例方法
		 */
		override protected function addChildren():void
		{
			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			loadImage();
			this.addEventListener(Event.RESIZE, resize);	          	 
		}       
		private function resize(e:Event):void
		{
			if(this.cloums.length>0){
				try{
					 reload();		
				}catch(e:Error)
				{
					
				}
						 
				 trace(System.totalMemory);
			}		     
		}

		/**
		*
		* 覆盖父类画布方法
		*/
		override public function draw():void
		{
			super.draw();
			if (this.uiinit && this.dataChange && !this.isDispose)
			{
				this.build();
				this.dataChange=false;
			}				 		 		 
		}

		private function reload():void
		{	
			if(!xml.hasOwnProperty("table")){
			  rowEvent=new RowEvent(RowEvent.loadDataFinish); 	 	   	
 	 	   	  this.dispatchEvent(rowEvent);	  
				return;
			}	
		    ifnull=xml.table[1].hasOwnProperty("data");  		 
		    _y=this.headHeight;				    	      
 	 	   for(var i:int=0;i<this.pageSize;i++){
 	 	   	   list=cloums[i] as Array;
 	 	   	   listHeight=[];//临时列表用于保存当前行，计算出实际行高
 	 	   	   _x=0;
 	 	   	    for(var j:int=0;j<list.length;j++){
 	 	   	       cldRow= list[j] as CLDRow;
 	 	   	       if(ifnull){	
 	 	   	       	 if(i<xml.table[1].data.length()){
 	 	   	       	 	  text=xml.table[1].data[i].attributes()[j];
 	 	   	       	 } else{
 	 	   	       	    text="";
 	 	   	       	 }	   	        	   	        
 	 	   	        }else{
 	 	   	          text=" ";
 	 	   	        }
 	 	   	       titleList=text.split("|");
 	 	   	       if(titleList.length>1){
 	 	   	       	 if(titleList[0]=="BTN"){
 	 	   	       	 	  text=" 按 钮 ";
 	 	   	       	 }if(titleList[0]=="CHECKBOX"){
 	 	   	       	      text="复选框";
 	 	   	       	 }
 	 	   	       	 
 	 	   	       }else{
 	 	   	          tempText=new CLDTextField();	
			          tempText.embedFonts=true;	
			          tempText.wordWrap=true;		    
			         // tempText.text=text;
					  //如果有img标签 捕获<img加载完成事件)
//					  tempText.addEventListener("change",function(e:Event):void{
//						  listHeight.push(tempText.textHeight);	
//					  });
					  
					  tempText.htmlText=text;
			          tempText.setTextFormat(Style.getTFList());	
			          tempText.width=cldRow.scale*this.width;
					
					 // listHeight.push(tempText.textHeight);	
					  if(text.indexOf("img")!=-1)
					  {
						  listHeight.push(580+tempText.textHeight);	//如果有图片标签(<img>)
					  }else
					  {
						  listHeight.push(tempText.textHeight);	
					  }
					  
 	 	   	       }   	        
			      				 	   	    	  
 	 	   	    }
 	 	   	    max=getMax(listHeight);	 	   	    
 	 	   	    for(var j:int=0;j<list.length;j++){
 	 	   	    	if(ifnull!=""){
 	 	   	    	   if(xml.table[1].data[i]!=undefined){
 	 	   	       	     text=xml.table[1].data[i].attributes()[j];
 	 	   	            }else{
 	 	   	                text=" ";  
 	 	   	            }	
 	 	   	    	}else{
 	 	   	    	    text="";
 	 	   	    	}	 	   	    	 
 	 	   	    	    cldRow=list[j] as CLDRow; 	
 	 	   	    	    if(cldRow.contentType==2){
 	 	   	    	    	cldRow.check.selected=false; //清除选中状态
 	 	   	    	    }
  	 	   	    	    cldRow.height=max+1;
 	 	   	    	    cldRow.title=text;
 	 	   	    	    cldRow.x=_x;
 	 	   	    	    cldRow.y=_y; 	 	   	    	    	
 	 	   	    	    cldRow.width=cldRow.scale*this.width+1;   
 	 	   	    	    cldRow.reload();    	    
 	 	   	    	     _x+=cldRow.width-1;	
 	 	   	    	     if(j==list.length-1&&i==cloums.length-1){
 	 	   	    	     	 maxY=_y+cldRow.height;
 	 	   	    	     }    	    	    
 	 	   	    }	 	   	      
 	 	   	     _y+=max;	 	   	    
 	 	   	     	
 	 	   }
 	 	    rowEvent=new RowEvent(RowEvent.initHeight);
 	 	   	     rowEvent.max=maxY;
 	 	   	    this.dispatchEvent(rowEvent);	
 	 	    rowEvent=new RowEvent(RowEvent.loadDataFinish);
 	 	   	  rowEvent.max=maxY;
 	 	   	  this.dispatchEvent(rowEvent);	  	 
		}	
		public function loadDataById():void{	
			
			var url:String=contenturl+"?id="+this.contentID+encodeURI("&p=页大小:"+this.pageSize+"|当前页:"+this.currentPage+"&category=1&"+Math.random());
		    if(this.contentIDParam!="")
		    {
		    	url=contenturl+"?id="+this.contentID+encodeURI("&p="+this.contentIDParam+"|页大小:"+this.pageSize+"|当前页:"+this.currentPage+"&category=1&"+Math.random());	
		    }
		    this.loadTxt(url,null,complete);
		}
		private function complete(e:Event):void{
			
		   var url:URLLoader=e.target as URLLoader;
			  this.xml= XML(url.data); 
			 
 	 	   	   
 	 	   	  	   reload();
 	 	   	  
			  
		}			 
		private function build():void
		{
			xml=XML(this.data);
			if(!xml.hasOwnProperty("table")){
			    rowEvent=new RowEvent(RowEvent.loadDataFinish); 	 	   	
 	 	   	    this.dispatchEvent(rowEvent);			   
				return;
			}	
			ifnull=xml.table[1].hasOwnProperty("data");
			if (xml.data && !ifnull)
			{
				return;
			}	
        	 parm=xml.table[0].data[0].@初始化参数;
			 parmList=parm.split(",");
			 rowWidth=this.width/parmList.length;
			 temC=xml.table[0].data[0].@单元格颜色;
			 if(temC==""){
			 	temC="#CCCCCC";
			 }
			 mouseOutColor=parseInt("0x"+temC.substr(1,temC.length));
			 if(mouseOutColor==0){
			 	mouseOutColor=0xCCCCCC;
			 }
			 temC=xml.table[0].data[0].@鼠标悬停颜色;
			 mouseClickColor=parseInt("0x"+temC.substr(1,temC.length));
			 if(mouseClickColor==0){
			 	mouseClickColor=0xCCCCCC;
			 }
			 this.totalPage=xml.table[1].data[0].@总页数;
			 this.pageSize=xml.table[0].data[0].@页大小;			 
			 if(this.pageSize>xml.table[1].data.length()){
			 	  pageSize=xml.table[1].data.length();
			 }
			 /**
			 * 计算每列的宽度
			 */ 	
			  for(var i:int=0;i<parmList.length;i++){
			  	 temW=parmList[i].toString().split(":")[1];
			  	 if(temW==0){
			  	 	temW=this.rowWidth; //默认宽度
			  	 }
	 	     	 totalWidth+=temW;
	 	      }	 	      
			for (var i:int=0; i < xml.table[1].data.length(); i++)
			{  
			     listHeight=[];//临时列表用于保存当前行，计算出实际行高
				 temRowList=[];
				 totalScale=0;
				 for(var j:int=0;j<parmList.length;j++){
				    title=xml.table[1].data[i].@[parmList[j].toString().split(":")[0]];
				    titleList=title.split("|");
				    if(titleList.length>1){
				    	if(titleList[0]=="BTN"){
				    		cldRow=new CLDRow(title,1);
				    	}
				    	 else{ //复选框
				    	    cldRow=new CLDRow(title,2);
				    	}				    	
				    }else{
				           cldRow=new CLDRow(title,0);
				     }				  	
	            	cldRow.colID=j;
				 	cldRow.rowID=i;
				    cldRow.bgroundColor=this.mouseOutColor;             	      
				 	if(j==parmList.length-1){
				 	   cldRow.scale=1-totalScale;
				 	}else{
				 		temW=parmList[j].toString().split(":")[1];			 	
				 		cldRow.scale=temW/totalWidth;
				 		totalScale+=cldRow.scale;
				 	}
				 	cldRow.addEventListener(MouseEvent.CLICK,rowClick);				 	
				 	this.addChild(cldRow);
				    temRowList.push(cldRow);
				 }
				 cloums.push(temRowList);	    
			}
			   reload();
	         // this.dispatchEvent(new Event("getTotalPage"));	 		    			 
		}
		//计算当前行最大高度	 
		private function getMax(e:Array):Number
		{
			var MaxValue:int=0;
			for (var i:int=0; i < e.length; i++)
			{
				var num:Number=e[i];
				if (MaxValue < num)
				{
					MaxValue=num;
				}
			}
			if(MaxValue<30){
				MaxValue=30;
			}
			return MaxValue+5;			
		}
		// 回首页		  
		public function first():void{
		   this.currentPage=1;
		}
		//跳到尾页
		public function last():void{
		  this.currentPage=this.totalPage;
		}
		//上页
		public function back():void{
		  if(this.currentPage>1){
		  	 this.currentPage--;
		  }
		}
		//下页
		public function next():void{
		  if(this.currentPage<this.totalPage){
		  	  this.currentPage++;
		  }
		}		 
		private function  rowClick(e:Event):void{
			  var selectRow:CLDRow=e.currentTarget as CLDRow;
			  for(var i:int=0;i<cloums.length;i++){
			      list=cloums[i] as Array;
			      for(var j:int=0;j<list.length;j++){
			      	 cldRow=list[j] as CLDRow;			       
			      	  if(cldRow.rowID==selectRow.rowID){
			      	 	  cldRow.bgroundColor=this.mouseClickColor;
			      	   }else{
			      	       cldRow.bgroundColor=this.mouseOutColor;
			      	   }
			      	   cldRow.setBground();
			      }
			  }
			   	 currentSelectRow=selectRow.rowID;		
		}		      
	}
}