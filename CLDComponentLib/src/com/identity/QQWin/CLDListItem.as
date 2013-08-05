package com.identity.QQWin
{
    import com.careland.component.CLDBaseComponent;
    import com.careland.component.util.Style;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.ui.*;
	public class CLDListItem  extends CLDBaseComponent
	{
		public function CLDListItem( )
		{
			  	     
		}
		public var imgPath:String;
		public var content:String;
		public var id:int;
		public var rowHeight:int=40;
		public var object:Object;
		private var bit:Bitmap;
		private var img:Bitmap;
		public var _id:int;
		private var contentText:TextField;
		private var finished:Boolean=true;	
		 override public function dispose():void
		 {
		 	super.dispose();
		 	// this.removeEventListener(Event.RESIZE,this.resize);
		 	if(img){
		 		img.bitmapData.dispose();
		 	}
		 	this.contentText=null;
		 	this.object=null;
		 	this.imgPath=null;
		 	this.content=null;
		 	this.id=null;
		 	this.rowHeight=null;
		 	this.bit=null;
		 	this.contentText=null;
		 	this.finished=null;		 	
		 }	  
        /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	          
	         contentText=new TextField();
	    } 
	    public function getBitmap(key:*):Bitmap
		{			
	      return this.config.getBitmap(key);
		} 
	      /**
	    * 
	    * 覆盖父类画布方法
	    */ 
		override public function draw():void
		{			
			if(finished){
				build();
			}
		}
		private function build():void{
		    if(!this.isDispose){
		    	loadIMG();
		     	setContent();
		     	finished=false;
		    }
		     	
		}
		 /**
		 * 加载图片
		 */ 
		 private function loadIMG():void{
		    if(this.imgPath!=""){
		    var	request:URLRequest=new URLRequest(imgPath);	
		    var loader:Loader=new Loader();
			    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);			 
			    loader.load(request);	
		    }
		 }
		 /**
		 * 加载图片完成
		 */ 
		 private function complete(e:Event):void{	 		 	
		 	    bit=e.target.content;		 	       
		 	       bit.x=10;
		 	       bit.y=10;
		 	       bit.width=this.rowHeight;
		 	       bit.height=this.rowHeight;		 	       
		        this.addChild(bit);	     	 		
		 }
		 /**
		 *画内容
		 */ 
		 private function setContent():void{
		        
		        contentText.width=this.width-40;
		        contentText.height=this.rowHeight;
		        contentText.x=40;
		        contentText.text=this.content;
		        contentText.y=10;	
		        contentText.selectable=false;
		        contentText.embedFonts=true;
		        contentText.setTextFormat(Style.getTF());
		        this.addChild(contentText);
       	       		       	     		 
		 }
		 private function mouseOver(e:MouseEvent):void{	 
		 		//img.visible=false;	     
		 }
		 private function mouseOut(e:MouseEvent):void{	  
		 		//img.visible=false;	  
		 }
		 
		
		 
		 
		 
		 
	}
}