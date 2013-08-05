package com.identity.QQWin
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.identity.CLDContent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	public class CLDTab extends CLDBaseComponent
	{                          
         private var ifTitle:Boolean;
         private var ifContent:Boolean;
         private var titleText:TextField;	
         private var left:Bitmap=new Bitmap(); //左边图片
         public var center:Bitmap=new Bitmap(); //未激活中间图片
         public var right:Bitmap=new Bitmap();  //未激活右边图片        
         public var logo:Bitmap=new Bitmap();    //激活logo
         public var contentText:TextField;
         public var content:CLDContent=new CLDContent();
         public var title:String;
         public var isUsed:Boolean=false;//激活状态
         public var bitList:Array=new Array(8);
         public var titleHeight:int=41;//标题高度	  
 		 public var direction:String="down"; //移动方向	
		 public var ifopen:Boolean=false;
		 public var id:String;
		 public var contentHeight:int=0;
		 private var dis:DisplayObject;
		 public var  factHeight:int=0; //实际高度
		 public var statue:int=0;
		 private var isContent:Boolean=false;
 		
 		 private var contentMask:Sprite;
		 override protected function init():void
		 {
		 	 	 		      	
		 }
	     /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	    	    	
	    		titleText=new TextField();
		        titleText.x=40;
		        titleText.y=10;	
		        titleText.embedFonts=true;	       
		       	titleText.addEventListener(MouseEvent.CLICK,titleClick);
		        ifTitle=true;	                           	
               	this.addChild(left);
               	this.addChild(center);
               	this.addChild(right);
               	this.addChild(logo);
               	this.addChild(titleText);
	 	        contentMask=new Sprite();
	        	this.addChild(contentMask); 
	        	this.addChild(content); 
	        	this.content.mask=contentMask;
	          	build();
	          	this.addEventListener(Event.RESIZE, resize);
	    }
	    private function resize(e:Event):void
		{
			if(this.width!=0){
			     reload();
			}	  
		}

	    private function build():void{
	    	 if(isUsed){
	            setUsed();//设置激活背景图片	               
            	setLogo2();
	         	ifopen=true;
	         }if(!isUsed){
	           setNoUsed();//设置未激活背景图片  
	           setLogo();     	
	         }	  
	        //  setBground();		          
	          setTitle();
	      	          
	    }
	    private function reload():void{
	        this.titleText.width=this.width;
	        this.content.width=this.width;
	        this.content.height=this.height-this.titleHeight;
	        this.center.width=this.width-10;
	        this.right.x=this.width-5;
	    }
	    override public function dispose():void
	    {	    	
	    	super.dispose();
	    	if(left&&left.bitmapData){
		    	left.bitmapData.dispose();
		    	left.bitmapData=null;
		    	left=null;		    	
		    }
		    if(center&&center.bitmapData){
		    	center.bitmapData.dispose();
		    	center.bitmapData=null;	
		    	center=null; 
		    }
		     if(right&&right.bitmapData){
		    	right.bitmapData.dispose();
		    	right=null;
		    }
		    titleText=null;		   
		    if(this.content){
		    	while(content.numChildren>0)
		    	{
		    		var dis:DisplayObject=content.removeChildAt(0);
		    		try{
		    			Object(dis).dispose();
		    		}catch(e:Error){
		    			
		    		}	    		
		    	}	    	
		    }
		    content=null;
		    
	    }
	    /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{	if(!this.isDispose){
				setBground();
				if(this.titleText){
					this.setTitle();
				}
			}	
			if(this.contentMask){
				 var g:Graphics=contentMask.graphics;
				g.beginFill(0xffffff, 1);
				g.drawRect(0, this.titleHeight, width, height);
				g.endFill();
			}							
		}
	 
		public function CLDTab(id:String,bit:Array,titleHeight:int,width:int,height:int,x:int,y:int,title:String,isused:String,_isContent:Boolean)
		{
		  this.id=id;
	      if(this.x==0){
	      	 this.x=x;
	      }
	      if(this.y==0){
	      	 this.y=y;
	      }	 
		  this.width=width;
		  this.title=title;
		  if(isused=="true"){
		  	this.isUsed=true;	  	
		  }else{
		    this.isUsed=false;		    
		  }
		  this.height=height;
		  this.titleHeight=titleHeight;
		  this.bitList=bit;
		  this.addChildren();
		  this.invalidate();     
		  this.isContent=_isContent;
		    setContent(); 
		}		 
		 /**
		 * 绘制内容
		 */ 
 		 private  function  setContent():void{		 	 
 		 	       content.contentID=this.id;
 		 	       content.width=this.width;
 		 	       content.height=this.height-titleHeight;
 		 	       content.autoLoad=true;		
 		 	       content.y=titleHeight; 		 	            		 	       	 	       
 		 	       this.addChild(content); 	
 	    }
 	    
		/**
		 * 绘制标签背景图片
		 */ 
		 private function setBground():void{
		   left.height=titleHeight;
		   left.width=5;
		   left.x=0;
		   left.y=0;
		  // this.addChild(left);
		   center.height=titleHeight;
		   center.width=this.width-10;
		   center.x=5;
		   center.y=0;
		   //this.addChild(center);
		   right.height=this.titleHeight;
		   right.width=5;
		   right.x=width-5;
		   right.y=0;
		   //this.addChild(right);
		   logo.height=30;
		   logo.width=30;
		   logo.x=10;
		   logo.y=5;
		   //this.addChild(logo);	  
		 }  
		/**
		 * 激活
		 */ 
		 public function setUsed():void{
		  var bitmap:Bitmap=bitList[0] as  Bitmap;		   
		    left.bitmapData=bitmap.bitmapData.clone();
		    bitmap=bitList[1] as Bitmap;		   
		    center.bitmapData=bitmap.bitmapData.clone();
		    bitmap=bitList[2] as  Bitmap;		   
		    right.bitmapData=bitmap.bitmapData.clone();		    		    		  
		 }
		 /**
		 * 未激活
		 */ 
		 public function setNoUsed():void{
		    var bitmap:Bitmap=bitList[0] as  Bitmap;		   
		    left.bitmapData=bitmap.bitmapData.clone();		    
		    bitmap=bitList[1] as Bitmap;		  
		    center.bitmapData=bitmap.bitmapData.clone();
		    bitmap=bitList[2] as  Bitmap;
		    right.bitmapData=bitmap.bitmapData.clone();		    		    
		 }
		 /**
		 * 绘制标签标题
		 */ 
		 private function setTitle():void{		      		      	       	        	       
		        titleText.text=this.title;     
		        titleText.setTextFormat(Style.getWF());
		        titleText.width=width;
		        titleText.height=titleHeight;	
		 	 }
		 /**
		 * 标题点击事件
		 */ 
		 private function  titleClick(e:MouseEvent):void{
		 	 
		 	 this.dispatchEvent(new MouseEvent("titleClick"));		       
		 }
 
		  /**
		 * 绘制标签标识图片
		 */ 
		 public function setLogo():void{		 	
		        var bitmap:Bitmap=bitList[3] as  Bitmap;     		        
		 	     logo.bitmapData=bitmap.bitmapData.clone();	
		 	     this.graphics.clear();
	 	 }
		 /**
		 * 绘制激活标签标识图片
		 */ 
		 public function setLogo2():void{
		 	
		 	    var bitmap:Bitmap=bitList[4] as  Bitmap;   	 	     
		 	     logo.bitmapData=bitmap.bitmapData.clone();	  
		  }
		 public function getdis():DisplayObject
		{
			var sprite:Sprite=new Sprite;
			var g:Graphics=sprite.graphics;
			g.beginFill(0xffffff, 1);
			g.drawRect(0, this.titleHeight, width, height);
			g.endFill();
			return sprite;
		}
		  
	}
}