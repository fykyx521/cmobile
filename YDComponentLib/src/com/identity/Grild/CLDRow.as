package com.identity.Grild
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.RowEvent;
	import com.identity.CLDButtons;
	import com.identity.CLDCheckBox;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class CLDRow extends CLDBaseComponent
	{
 		public var rowID:Number;
		public var colID:Number;
 		public var title:String;
		private var text:TextField;	 
		public  var bgroundColor:int=0xCCCCCC;
		private var border:Sprite=new Sprite();
        private var bground:Sprite=new Sprite();
        public  var scale:Number=0;
        public var contentType:int=0 ;// 类型  1  文本  2  button 3 复选框      
        private var btn:CLDButtons;
        public var value:String;
        private var titleList:Array=[];
        private var loader:Loader;
        private var request:URLRequest;
        private var urlLoader:URLLoader;
        private var rowEvent:RowEvent;
        private var ifLoad:Boolean;
        public var check:CLDCheckBox;     
        override public function dispose():void{
		  super.dispose();
		  this.rowID=null;
		  this.colID=null;
		  this.title=null;
		  this.text=null;
		  this.bgroundColor=null;
		  this.border=null;
		  this.bground=null;
		  this.scale=null;
		  this.contentType=null;
		  this.btn=null;
		  this.value=null;
		  this.titleList=null;
		  this.ifLoad=null;
		  this.rowEvent=null;
		  this.urlLoader=null;
		  this.request=null;
		  this.loader=null;
		}
		public function CLDRow(_title:String,_contentType:int){
			this.title=_title;			 
		  	this.addEventListener(Event.RESIZE, resize);
		  	this.contentType=_contentType;
			 build(); 
	 	}
		
		 
		override protected function addChildren():void{
		   
		    this.addChild(border);
		    this.addChild(bground);
		    
 		}
		override public function draw():void{
		   
		}
		private function build():void{		     
		       setBground();
		       setBorder();
		       setContent();
		     
		}
		private function resize(e:Event):void{
//               if(this.text!=null){
//               	   reload(); 
//               }                 	                                  
		}
		//重设大小
		public function reload():void{		   
		    setBorder();
		    setBground();
		    reloadContent();
		}
		public function reloadContent():void{
			switch(this.contentType){
			    case 0:
			        text.selectable=false;
					text.width=this.width-2;
					text.height=this.height-2;
					text.wordWrap=true;
					text.embedFonts=true;				
 					text.text=this.title;
 					text.setTextFormat(Style.getTFList());	
 					 this.text.x=1;
		             this.text.y=1;
		             break;
		        case 1:     
		            btn.y=(this.height-30)/2;
			 	    btn.x=5;
			        btn.setSize(this.width-10,30);
			        break;
			    case 2:    
			        check.y=(this.height-30)/2;
			        check.x=(this.width-30)/2;			        
			        break;
			}	           		  
		}
		//添加内容
		public function setContent():void{
			  switch(this.contentType){
			     case 0:
			        text=new TextField();
                    text.selectable=false;
					text.width=this.width;
					text.height=this.height;
					text.wordWrap=true;
					text.embedFonts=true;				
 					text.text=this.title;
 					text.setTextFormat(Style.getTFList());	
 				 	this.addChild(text);
 				 	break;
 				 case 1:
 				 	  titleList=title.split("|");
			          btn=new CLDButtons();			 
			          btn.width=this.width-10;
			          btn.height=30;
			          btn.y=(this.height-30)/2;
			          btn.x=5;
			          btn.ifLoad=titleList[3];
			          btn.lable=titleList[2];
			          btn.value=titleList[1];			  
			          this.ifLoad=btn.ifLoad;
		              btn.addEventListener(MouseEvent.CLICK,btnClick);	
			          this.addChild(btn);	
			          break;
			      case 2:
			         check=new CLDCheckBox();
			         check.width=30;
			         check.height=30;
			         check.addEventListener(MouseEvent.CLICK,checkClick);
			         this.addChild(check);    			              	    
			}
                    			 
		}
		private function checkClick(e:MouseEvent):void{
		         rowEvent=new RowEvent(RowEvent.btnClick);	         		    	   	       
		         rowEvent.value=check.value;
		         rowEvent.ifLoad=this.ifLoad;		         
		         rowEvent.GPS=3;
		         this.config.dispatchEvent(rowEvent);	       
		
		}
		private function btnClick(e:MouseEvent):void{
		    
	             rowEvent=new RowEvent(RowEvent.btnClick);	         		    	   	       
		         rowEvent.value=btn.value;
		         rowEvent.ifLoad=this.ifLoad;
		         rowEvent.GPS=0;
		         this.config.dispatchEvent(rowEvent);	         
		       // this.dispatchEvent(rowEvent); 
			    
		}
//		private function onError(e:Event):void{
//		
//		}
//		private function complete(e:Event):void{
//		  urlLoader=e.target as URLLoader;
//		  btn.xml=XML(urlLoader.data);
//		         rowEvent=new RowEvent(RowEvent.loadBtnDataFinish);	         		    	   	       
//		         rowEvent.value=btn.value;
//		         rowEvent.xml= btn.xml;
//		         this.dispatchEvent(rowEvent); 	      		
//		}
		//设置边框
		private function  setBorder():void{
		    border.graphics.clear();
		    border.graphics.beginFill(0x000000,1);
		    border.graphics.drawRect(0,0,this.width,this.height);
		    border.graphics.endFill();
		}
		//设置背景
		public function setBground():void{ 
			 bground.graphics.clear();
			 bground.graphics.beginFill(this.bgroundColor,1);
			 bground.graphics.drawRect(1,1,this.width-2,this.height-2);	
			 bground.graphics.endFill();		 		 	
		}		
	}
}