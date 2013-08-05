/**
 * 选项卡组件的低层子类（主要是呈现选项卡的标签）
 * code by xiaolb  2011-4-21
 * */

package com.identity
{
	import com.careland.component.CLDBaseComponent;
	import com.identity.QQWin.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	public class CLDTabs  extends CLDBaseComponent
	{
		 public var titleText:TextField;	
		 public var titleHeight:int;
		 private  var _tabTitle:TextField=null;
		 private var _tf:TextFormat=null;
		 private var _titleText:String;
	  	 private var title:String;
		
		 public var titleSize:int=15;//标题字体大小
		 public var titleColor:uint=0xFF9900;
		 public var bitobject:Bitmap;
		 public var titleStyle:String="楷体";  //标题字体	
		 public var bit:Bitmap;	
		 public var bitnew:Bitmap;
	     private var fmt:TextFormat;
	     public var bitlist:Array=new Array(6);
	     public var location:String;
	     private var left:Bitmap=new Bitmap();
	     private var right:Bitmap=new Bitmap();
	     public var center:Bitmap=new Bitmap();
	     public var _widths:int=0;
	     public var ifused:Boolean=false;
	     private var type:int=0;
	 
	   	
	   	//构造函数
		public function CLDTabs(bitlist:Array,titleHeight:int,width:int,x:int,y:int,title:String,ifused:Boolean,t:int)
		{
		this.x=x;
		this.y=y;
	    this.width=width;
	    this.title=title;
	    this.bitobject=bit;
	    this.titleHeight=titleHeight;
	    this.bitlist=bitlist;
	    this.ifused=ifused;
	    this.type=t;
	    this.addChildren();
	    this.invalidate();	   
		}

		override protected function init():void
		{
			
		
		}
		//给该组件增加子类
		override protected function addChildren():void
		{
			setTitle();
		 	
           if(ifused){
           	setUsed();
           }else{
            setNoUsed();
           }
           drawIMG();    
		}
		 /**
		 * 主要的画标签的方法
		 * type  是要画标签的位置 0为最走边的标签
		 */ 
		
		public function drawIMG():void
		{	
			//只有一个标签 	
		if(type==4)
			{							
				left.x=0;
				left.width=18;
				left.y=0;		 
				left.height=this.titleHeight;				
			 	center.x=left.width;
			 	center.y=0;
			 	center.height=this.titleHeight;	
			 	center.width=titleText.textWidth+2;	 
				right.x=center.width+left.width;
				right.y=0;	
				right.width=18;	 
				right.height=titleHeight;
				this.addChild(left);
				this.addChild(center);
				this.addChild(right);
				this.addChild(titleText);
			}
			//画最左边的标签
			if(type==0){
				left.width=18;
				right.width=this._widths-18;
				left.x=0;
			    left.y=0;		 
			    left.height=this.titleHeight;	
				this.addChild(left);
				
				right.x=left.width;
			    right.y=0;		 
			    right.height=titleHeight;
			    this.addChild(right);
			    this.addChild(titleText);
			}
			//化中间的标签
			if(type==1){
				left.width=0;
				right.width=this._widths;
				left.x=0;
			    left.y=0;		 
			    left.height=this.titleHeight;	
				right.x=left.width;
				right.y=0;		 
				right.height=titleHeight;
				this.addChild(right);
				this.addChild(titleText);
			}
			//画最右边的标签
			if(type==2){
				left.width=this._widths;				
				right.width=18;
				this.addChild(left);
				
				left.x=0;
				left.y=0;		 
				left.height=this.titleHeight;		
			 				 
				right.x=left.width;
				right.y=0;		 
				right.height=titleHeight;
				this.addChild(right);
				this.addChild(titleText);
			}	   
		}
		//激活标签的方法 就是更换绘画对象图片而已
		public function setUsed():void{
			  var bitmap:Bitmap=bitlist[3] as  Bitmap;
		       left.bitmapData=bitmap.bitmapData.clone();
		        bitmap=bitlist[4] as Bitmap;
		        right.bitmapData=bitmap.bitmapData.clone();
		        bitmap=bitlist[5] as Bitmap;
		        center.bitmapData=bitmap.bitmapData.clone();
		}
		// 不激活标签 将蓝色的图片标签更换为黑色
		public  function setNoUsed():void{
		       var bitmap:Bitmap=bitlist[0] as  Bitmap;
		       left.bitmapData=bitmap.bitmapData.clone();
		       trace(left);
		        bitmap=bitlist[1] as Bitmap;
		        right.bitmapData=bitmap.bitmapData.clone();
		        bitmap=bitlist[2] as Bitmap;
		       // center.bitmapData=bitmap.bitmapData.clone();
		}
		private function setTitle():void{
		  //增加该组件的标题按纽上的TITLE
		         fmt = new TextFormat(); 
              	 fmt.color=titleColor;
               	 fmt.size=titleSize;
               	 fmt.font=titleStyle;
               	 fmt.align=TextFormatAlign.CENTER;
                 titleText=new TextField();
		 	     titleText.text=title;
    
		 	     titleText.defaultTextFormat=fmt;
		 	     titleText.x=18;
		 	     titleText.y=0; 
		 	     titleText.selectable=false;
		 	     titleText.addEventListener(MouseEvent.CLICK,titleClick); 
		 	     if(this.width<titleText.textWidth+18){
		 	     	 this._widths=titleText.textWidth-18;
		 	   
		 	     }else{
		 	        this._widths=this.width;
		 	       
		 	     }		 	    
		 	     this.addChild(titleText);	
		} 
		//标签点击事件
       public function titleClick(e:Event):void
       {
       	  this.dispatchEvent(new MouseEvent("titleClick"));	
       
       }
		override public function get width():Number
		{
			if(this.titleText){
				return Math.max(titleText.textWidth,70);
			}
			return 70;
		}
		public override function draw():void
		{
	    
		}
		 
		 
	}
}