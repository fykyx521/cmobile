package com.identity.tab
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.getTimer;
	public class CLDTab extends CLDBaseComponent
	{
		private var tiltle:CLDTabTitle;
		private var content:CLDTabContent;
		private var titleHeight:int=35;
		public var titleWidth:int;
        private var titleArray:Array;
        private var contentArray:Array=[];
        private var count:int=0;
        private var minWidth:Number;
        private var widthList:Array=[];
        private var preTime:int;
        private var _timeInteval:int=30;
        private var currentIndex:int=0;
		public function CLDTab()
		{
			this.addEventListener(Event.RESIZE,resize);	
		}
         override  public function dispose():void{
          super.dispose();
          this.removeEventListener(Event.ENTER_FRAME,update);
          this.tiltle=null;          
          this.content=null;
          this.titleHeight=null;
          this.titleWidth=null;
          if(titleArray){
          	 for each(var tab:CLDTabTitle in titleArray)
          	 {
          	 	if(tab){
          	 		tab.removeEventListener(MouseEvent.CLICK,mouse_click);
          	 	}
          	 }
          }
          this.titleArray=null;                   
          this.contentArray=null;
          this.count=null;
          this.minWidth=null;
          this.widthList=null;
        }
		override protected function addChildren():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		 private function update(e:Event):void{		
		  
		   var newTime:int=flash.utils.getTimer();
			var dis:int=newTime-preTime;
			if(dis>=this._timeInteval*1000){
				preTime=flash.utils.getTimer();
				 if(currentIndex>=this.titleArray.length-1){
				 	currentIndex=0;
				 }else{
				     currentIndex++;
				 }
				  for(var i:int=0;i<titleArray.length;i++){
				  	var _title:CLDTabTitle=titleArray[i] as  CLDTabTitle;
				  	var _content:CLDTabContent=contentArray[i] as CLDTabContent;
				      if(i==currentIndex){
				      	 _title.setUsed();
				      	 _content.show();				          
				      }else{
				      	_title.setNoUsed();
				      	_content.hide();				       			       
				      } 
				  }		    
			}
    	}
		private function resize(e:Event):void{
		   reload();
		}
		override public function set width(value:Number):void
		{
			if(value<this.minWidth) value=this.minWidth;
			super.width=value;
		}
		
         private function reload():void{
          
         	if(titleArray==null) return;
         	var _x:int=0;
           	this.titleWidth=this.width*4/5;
	    	  for(var i:int=0;i<titleArray.length;i++){
	    	  	 var title:CLDTabTitle=titleArray[i] as CLDTabTitle;
	    	  	     title.width=this.titleWidth/titleArray.length;
	    	  	     title.x=_x+(this.width-this.titleWidth)/2;
	    	  	     _x+=titleWidth/titleArray.length	    	  	  
	    	  }
	    	   for( i=0;i<contentArray.length;i++){
	    	      var content:CLDTabContent=contentArray[i] as CLDTabContent;
	    	          content.setSize(this.width,this.height-37);	    	            	          
	    	   }
	    	   
	     }
		override public function draw():void
		{

			if(this.dataChange){
				
				this.dataChange=false;
			}

		}
          //给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
		 	build();		   
		}	  
		
 
		//动态解析内容
		public function build():void
		{		     
			this.titleWidth=this.width*4/5; 
			var tabs:Array=this.data.split("|");
			var _x:int=0;
			titleArray=new Array(tabs.length-1);
			//contentArray=new Array(tabs.length-1);
			for (var i:int=0; i < tabs.length; i++)
			{
				var contentN:String=tabs[i];
				if (contentN != "")
				{
					var conArry:Array=contentN.split("#");
					var idArry:Array=conArry[1].split("§");
					var cid:String=idArry[0].toString();
					var tiltles:CLDTabTitle=new CLDTabTitle(i,tabs.length, conArry[0]);
					tiltles.height=this.titleHeight;
					tiltles.addEventListener(MouseEvent.CLICK,mouse_click);
				    widthList.push(tiltles.textWidth);
				var tabContent:CLDTabContent=new CLDTabContent();
					tabContent.contentIDParam=this.contentIDParam;
					tabContent.width=this.width;
					tabContent.height=this.height;
					tabContent.y=this.titleHeight+2;
					tabContent.contentID=cid;
					tabContent.autoLoad=true;				 
					this.addChild(tabContent);
					contentArray.push(tabContent);				   
					if(i==0){
				      tabContent.visible=true;
					  tiltles.setUsed();					 
					}else{
				      tabContent.visible=false;
					   tiltles.setNoUsed();					  
					}
					_x+=titleWidth/(tabs.length-1);
					titleArray[i]=tiltles;				 
					this.addChild(tiltles);				 
				}
        	}
        	this.minWidth=getMax(widthList)* (tabs.length-1);
        	if(tabs.length==2){
        		 this.removeEventListener(Event.ENTER_FRAME, update);
        	}
            reload();
		}
		private function getMax(array:Array):Number{
			var num:Number=0;
			for(var i:int=0;i<array.length;i++){
				 var temp:Number=array[i];
				 if(temp>num){
				 	 num=temp;
				 }
			}
		  return num ;
		}
        //鼠标点击事件
        private function mouse_click(e:MouseEvent):void{
           var tilte:CLDTabTitle=e.currentTarget as CLDTabTitle;
           var test:int=tilte.dataIndex;
           for(var i:int=0;i<titleArray.length;i++){
           		var _tab:CLDTabTitle=titleArray[i] as CLDTabTitle;
           	    var sprite:CLDTabContent=contentArray[i] as CLDTabContent;            	   			          		 
           		if(_tab==tilte){          		
           		     sprite.show();          		   
           		     currentIndex=i;
           		     preTime=flash.utils.getTimer();
           		}else{
           		  	_tab.setNoUsed();  
           		    sprite.hide();
           		 
           		   
           		}             		  		
           }          
             tilte.setUsed();
        }
	}
}