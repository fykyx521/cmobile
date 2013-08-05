 package com.identity.Grild
{
 import com.careland.component.CLDBaseComponent;
 
 import flash.display.*;
 import flash.events.*;
 import flash.net.URLLoader;
 import flash.net.URLRequest;
 import flash.text.TextField;
 import flash.ui.*;
 
 import com.careland.events.DynamicEvent;
 
	 /**
	 * 
	 * 表格分页工具条
	 */ 
	public class CLDTableToolBar extends CLDBaseComponent
	{
		private var  loader:Loader;
		private var  totalPage:int;
		private var  currentPage:int;
		private var  firstBtn:Bitmap;
	    private var  nextBtn:Bitmap;
	    private var  backBtn:Bitmap;
	    private var  lastBtn:Bitmap;
	    private var  refreshBtn:Bitmap;
	    private var  btnList:Array;
	    private var  nextSprite:Sprite;
	    private var  lastSprite:Sprite;
	    private var  refreshSprite:Sprite;
	    private var xml:XML;
	    private var request:URLRequest;
	    private var ifBackDown:Boolean;
	    private var ifNextDown:Boolean;
	    private var  ifPageFiterDown:Boolean;
	    private var  ifChange:Boolean;//是否需要变大变小

	    private var downInteval:uint=0;
	    
	    public var time:int=0;
        /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	    	
	        loadXmlData();
	        this.buttonMode=true;
	    }
	    /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{
			super.draw();	
		    
		}
		public function CLDTableToolBar(totalPage,currentPage)
		{
			 this.totalPage=totalPage;
			 this.currentPage=currentPage;
		}
		/**
		 * 
		 * 加载图片配置
		 */ 
		 private function loadXmlData():void{
		 	var url:URLLoader=new URLLoader();
			url.addEventListener(Event.COMPLETE,COMPLETE);			 
			url.load(new URLRequest("assets/TableToolBar.xml"));
		 }	 
		 /**
		 * 
		 * 设置按钮图片COMPLETE
		 */
		
		  private  function  COMPLETE(e:Event):void{
		  	var url:URLLoader=e.target as URLLoader;
			xml=XML(url.data);	
			 loader=new Loader();
			///添加首页按钮  
			 request=new URLRequest(xml.data[0]);	
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,setFirst);	
		     loader.load(request);	 	     
		  }
		/**
		 * 
		 * 设置首页按钮
		 */ 
		 private function  setFirst(e:Event):void{
		   	   firstBtn=e.target.content; 		   	   
		   	   firstBtn.width=10;
		   	   firstBtn.height=10;		   	 
		  	 ///添加上一页按钮
		 	 loader=new Loader();
			 request=new URLRequest(xml.data[2]);	
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,setBack);						
		     loader.load(request);
		 }
	
		 /**
		 * 设置下一页
		 */ 
		 private function  setNext(e:Event):void{
		       nextBtn=e.target.content; 		   	  
		   	   nextBtn.width=10;
		   	   nextBtn.height=10;
		   	 ///尾页按钮
		     loader=new Loader();
			 request=new URLRequest(xml.data[3]);	
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,setLast);						
		     loader.load(request);
		 }
	     /**
		 * 设置上一页
		 */ 
		 private function  setBack(e:Event):void{
		       backBtn=e.target.content;    
		   	   backBtn.width=10;
		   	   backBtn.height=10;
		   	 ///添加下一页按钮
		 	 loader=new Loader();
			 request=new URLRequest(xml.data[1]);	
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,setNext);						
		     loader.load(request);
		 }
		 /**
		 * 设置尾页
		 */ 
		 private function  setLast(e:Event):void{
		      lastBtn=e.target.content; 
		   	   lastBtn.width=10;
		   	   lastBtn.height=10;  	   	   
		 	 ///设置刷新按钮
		 	 loader=new Loader();
			 request=new URLRequest(xml.data[4]);	
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,setRefresh);						
		     loader.load(request);	     
		 }
		
		 /**
		 * 
		 * 设置刷新按钮
		 */ 
		 private  function  setRefresh(e:Event):void{
		       refreshBtn=e.target.content; ;
		   	   refreshBtn.width=10;
		   	   refreshBtn.height=10;
		   	   setPage();
		   	   if(!this.hasEventListener(Event.ENTER_FRAME)){
		   	   		this.addEventListener(Event.ENTER_FRAME,update);
		   	   }
		 }
		 
		 private function update(e:Event):void
		 {
		 	 time++;
		 	 if(time==2){
		 	 	 if(ifBackDown){
		 	 	 if(this.currentPage>1){
		 			this.currentPage--;
		 		 }
		 		 reload(this.currentPage,this.totalPage);
		 	 	}if(ifNextDown){
		 	 	  if(this.currentPage<this.totalPage){
		 	     	this.currentPage++;
		 	       }	
		 	      reload(this.currentPage,this.totalPage); 	
		 		 }		 	 	 
		 	 	time=0;
		 	 }	 	
		 }
		  /**
		 * 
		 * 设置页码
		 */ 
		 private  function  setPage():void{
		    var  x:int=0;
		   var  sprite:Sprite=new Sprite();  //首页
		   	    sprite.x=x;
		   	    sprite.y=5;
		   	    sprite.addChild(firstBtn);
		   	    sprite.addEventListener(MouseEvent.CLICK,this.firstClick);		   	  
		   	   this.addChild(sprite);			   	  
	    	    sprite=new Sprite(); //上一页
		   	     sprite.x=x+30;
		   	     sprite.y=5;
		   	     sprite.addEventListener(MouseEvent.MOUSE_DOWN,this.backDown);	
		   	     sprite.addEventListener(MouseEvent.MOUSE_UP,this.backUp);
		   	     sprite.addEventListener(MouseEvent.MOUSE_OUT,this.backUp);	
                 sprite.addChild(backBtn);	   	  
		   	   this.addChild(sprite);
		       x+=30;
		    //计算分页工具条所在区间
		     var num:int=this.currentPage/10;
		     var area:int=(num+1)*10;	
		    if(totalPage>=10){
		    	btnList=new Array(10);
		    }else{
		        btnList=new Array(totalPage);
		     }   
		    if(totalPage>=10){
		    	btnList=new Array(10);
		    }else{
		        btnList=new Array(this.totalPage);
		     }   
		     if(this.totalPage-this.currentPage>=9){		    
		         for(var i:int=this.currentPage;i<=this.currentPage+9;i++){
		     	  x+=30;		          
		              var pageFiter:TextField=new TextField();
		                 pageFiter.width=30;
		                 pageFiter.height=height+5;
		                 pageFiter.text=i+"";
		                 pageFiter.x=x;
		                 pageFiter.y=0;
		                 pageFiter.addEventListener(MouseEvent.CLICK,pageClick);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OVER,changeStyleMouseOver);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OUT,changeStyleMouseOut);
		                 pageFiter.selectable=false;
		                 this.addChild(pageFiter);
		                 btnList[i]=pageFiter;  	         
		          } 
		     }else{
		         for(i=totalPage-9;i<=totalPage;i++){
		         	if(i>0){
		              x+=30;		          
		                 pageFiter=new TextField();
		                 pageFiter.width=30;
		                 pageFiter.height=height+5;
		                 pageFiter.text=i+"";
		                 pageFiter.x=x;
		                 pageFiter.y=0;
		                 pageFiter.addEventListener(MouseEvent.CLICK,pageClick);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OVER,changeStyleMouseOver);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OUT,changeStyleMouseOut);	              
		                 this.addChild(pageFiter);
		                 btnList[i]=pageFiter;  
		         	}
		            	
		         }   
		      }
		         nextSprite=new Sprite(); //下一页
		   	     nextSprite.x=x+30;
		   	     nextSprite.y=5;
		   	     nextSprite.addEventListener(MouseEvent.MOUSE_DOWN,this.nextDown);	
		   	     nextSprite.addEventListener(MouseEvent.MOUSE_UP,this.nextUp);
		   	    // nextSprite.addEventListener(MouseEvent.MOUSE_OUT,this.nextUp);
                  nextSprite.addChild(nextBtn);	   	  
		   	      this.addChild(nextSprite);
		   	  lastSprite=new Sprite(); //尾页
		   	     lastSprite.x=x+60;
		   	     lastSprite.y=5;
		   	     lastSprite.addEventListener(MouseEvent.CLICK,this.lastClick);	
                 lastSprite.addChild(lastBtn);	   	  
		   	   this.addChild(lastSprite);
		   	    refreshSprite=new Sprite(); //刷新
		   	     refreshSprite.x=x+90;
		   	     refreshSprite.y=5;
		   	     refreshSprite.addEventListener(MouseEvent.CLICK,this.refreshClick);	
                 refreshSprite.addChild(refreshBtn);	   	  
		   	   this.addChild(refreshSprite);
		   	   
		 }
		 private function pageClick(e:MouseEvent):void
		 {
		 	var target:TextField=e.target as TextField;		 	
		 	var dy:DynamicEvent=new DynamicEvent("gotoPage");
		 	    dy.pageNo=target.text;
		 	    this.dispatchEvent(dy);
		  }		 
		  private function  changeStyleMouseOver(e:MouseEvent):void{
		       ifPageFiterDown=true;
		  }
		  private function changeStyleMouseOut(e:MouseEvent):void{
		       ifPageFiterDown=true;
		  }
		 /**
		 * 重绘工具条
		 */ 
		 public function  reload(current:int,total:int):void{
		   //移除上页，尾页和刷新按钮
		   this.removeChild(nextSprite);
		   this.removeChild(lastSprite);
		   this.removeChild(refreshSprite);
		   //移除之前绘制的文本
		   for(var i:int=1;i<btnList.length;i++){
		   	  if(btnList[i]!=null){
		   	  	 this.removeChild(btnList[i]);
		   	  }	   		     	
		   }
		   var x:int=30;
		    if(totalPage>=10){
		    	btnList=new Array(10);
		    }else{
		        btnList=new Array(total);
		     }   
		     if(total-current>=9){		    
		         for(i=current;i<=current+9;i++){
		     	  x+=30;		          
		              var pageFiter:TextField=new TextField();
		                 pageFiter.width=30;
		                 pageFiter.height=height+5;
		                 pageFiter.text=i+"";
		                 pageFiter.x=x;
		                 pageFiter.y=0;
		                 pageFiter.addEventListener(MouseEvent.CLICK,pageClick);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OVER,changeStyleMouseOver);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OUT,changeStyleMouseOut);
		                 pageFiter.selectable=false;
		                 this.addChild(pageFiter);
		                 btnList[i]=pageFiter;  	         
		          } 
		     }else{
		         for(i=totalPage-9;i<=totalPage;i++){
		         	if(i>0){
		              x+=30;		          
		                 pageFiter=new TextField();
		                 pageFiter.width=30;
		                 pageFiter.height=height+5;
		                 pageFiter.text=i+"";
		                 pageFiter.x=x;
		                 pageFiter.y=0;
		                 pageFiter.addEventListener(MouseEvent.CLICK,pageClick);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OVER,changeStyleMouseOver);
		                 pageFiter.addEventListener(MouseEvent.MOUSE_OUT,changeStyleMouseOut);	              
		                 this.addChild(pageFiter);
		                 btnList[i]=pageFiter;  
		         	}		            	
		         }   
		      }
		         nextSprite=new Sprite(); //下一页
		   	     nextSprite.x=x+30;
		   	     nextSprite.y=5;
		   	     nextSprite.addEventListener(MouseEvent.MOUSE_DOWN,this.nextDown);
		   	     nextSprite.addEventListener(MouseEvent.MOUSE_UP,this.nextUp);
                 nextSprite.addChild(nextBtn);	   	  
		   	      this.addChild(nextSprite);
		   	     lastSprite=new Sprite(); //尾页
		   	     lastSprite.x=x+60;
		   	     lastSprite.y=5;
		   	     lastSprite.addEventListener(MouseEvent.CLICK,this.lastClick);	
                 lastSprite.addChild(lastBtn);	   	  
		   	   this.addChild(lastSprite);
		   	   refreshSprite=new Sprite(); //刷新
		   	     refreshSprite.x=x+90;
		   	     refreshSprite.y=5;
		   	     refreshSprite.addEventListener(MouseEvent.CLICK,this.refreshClick);	
                 refreshSprite.addChild(refreshBtn);	   	  
		   	   this.addChild(refreshSprite);
		   
		 }
		
		 private function firstClick(e:MouseEvent):void{
		 	this.currentPage=1;	 	
		 	reload(this.currentPage,this.totalPage);
		 }
		 
		 private function nextDown(e:MouseEvent):void{
		    ifNextDown=true;
		 }
		  private function nextUp(e:MouseEvent):void{
		     ifNextDown=false; 	 
		  }
		 private function  backDown(e:MouseEvent):void{	 	
		 	 ifBackDown=true;	 	  
		 }
		  private function  backUp(e:MouseEvent):void{
		  	ifBackDown=false;
		  
		  }	
		 private function  lastClick(e:MouseEvent):void{
		  	this.currentPage=this.totalPage-9;	
		  	reload(this.currentPage,this.totalPage);
		 }
		 private function  refreshClick(e:MouseEvent):void{
		 	 this.dispatchEvent(new MouseEvent("refreshClick"));
		 }
	}
}