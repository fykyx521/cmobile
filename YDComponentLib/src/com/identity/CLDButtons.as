package com.identity
{
	/**
	 * add by cbb(2011-06-14)
	 */ 
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.*; 
	public class CLDButtons  extends CLDBaseComponent
	{
		private var bulkLoader:BulkLoader;
		public  var dataIndex:int=0;
	    public  var lable:String;
	    public var left:Bitmap;
	    public var center:Bitmap;
	    public var right:Bitmap;
	    private var ifFinish:Boolean=true;
	    private var title:TextField;
	    public var value:String;
        public var xml:XML;	   
        public var ifLoad:Boolean=false;
		public function CLDButtons()
		{
		}
		override public function dispose():void{
		  super.dispose();
		  if(center&&center.bitmapData){
		  		center.bitmapData.dispose();
		  }
		  this.bulkLoader=null;
		  this.dataIndex=null;
		  this.lable=null;
		  this.left=null;
		  this.center=null;
		  this.right=null;
		  this.ifFinish=null;
		  this.title=null;
		  this.value=null;
		  this.xml=null;
		  this.ifLoad=null;
		  this.removeEventListener(Event.RESIZE,resize);
		}
		public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}
		
		override protected function addChildren():void
		{
			this.addEventListener(Event.RESIZE, resize);			 
		}
        override public function draw():void
		{
			 if(ifFinish){
			     build();			    	
			 }
			 if(this.title){
			 	 title.text=this.lable;
			 	 title.width=this.width;
			 	 title.height=this.height;
			 	 title.setTextFormat(Style.getTFTXTButton());
			 }
			 if(center){
			 	 center.width=this.width;
			 	 center.height=this.height;
			 }
		}
		public function set text(value:String):void
		{
			this.lable=value;
			this.invalidate();
		}
		
		private function reload():void{
		    center.width=this.width;
		    center.height=this.height;
		    center.x=0;
		    title.width=this.width;
		    title.height=this.height;
		    title.x=(this.width-title.textWidth)/2;
		    title.y=(this.height-title.textHeight)/2;
		}
		private function resize(e:Event):void{
		
		}
		private function build():void{

		    center=new Bitmap();
		    center.bitmapData=getBitmap("button").bitmapData.clone();
		    center.width=this.width;
		    center.height=this.height;
		    center.x=0;
		    this.addChild(center);

		    title=new TextField();
		   var tf:TextFormat=new TextFormat();
		       tf.size=12;	    
		       //tf.font="msyh";
		       tf.color=0x000000;			     
		       title.embedFonts=true;
		       title.text=this.lable;	
		       title.width=this.width;	
		       title.height=this.height;		           		     
		       title.setTextFormat(Style.getTFTXTButton());
		      
		       title.selectable=false;
		       //title.height=this.height;
		       
		    this.addChild(title); 
		    ifFinish=false;		    
		} 
	}
}