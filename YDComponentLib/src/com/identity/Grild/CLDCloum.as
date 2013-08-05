package com.identity.Grild
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
  /**
  * 表头单元格
  */ 
	public class CLDCloum extends CLDBaseComponent
	{
		public function CLDCloum(_dataLength:Number,_dataIndex:Number,_title:String){
			this.dataLength=_dataLength;
			this.dataIndex=_dataIndex;
			this.title=_title;
			build();
		}	 
		private var leftBit:Bitmap;
		private var centerBit:Bitmap;
		private var rightBit:Bitmap;
		private var tableLine:Bitmap;
		public var dataIndex:Number;
		private var bulkLoader:BulkLoader;
		private var dataLength:Number;
		private var text:TextField=new TextField();
		private var title:String;
		private var rowHeight:Number=34;
		public var scale:Number;//宽度比例
		public var colID:int=0;
		override public function dispose():void{
		   super.isDispose;
		   this.leftBit=null;
		   this.centerBit=null;
		   this.rightBit=null;
		   this.tableLine=null;
		   this.dataIndex=null;
		   this.bulkLoader=null;
		   this.dataLength=null;
		   this.text=null;
		   this.title=null;
		   this.rowHeight=null;
		   this.scale=null;
		   this.colID=null;
		}
		override protected function addChildren():void{
		   bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}		         
	       this.addEventListener(Event.RESIZE,resize);
		}
		override public function draw():void{
		
		}
		
		private function build():void{
			centerBit=new Bitmap();
			centerBit.bitmapData=getBitmap("tableCenter").bitmapData;
			leftBit=new Bitmap();
			leftBit.bitmapData=getBitmap("tableLeft").bitmapData;
			rightBit=new Bitmap();
			rightBit.bitmapData=getBitmap("tableRight").bitmapData;
	  		this.addChild(centerBit);	 
			if(this.dataIndex==0){		    
				this.addChild(leftBit);						        
			}if(this.dataIndex==this.dataLength-1){				 
				this.addChild(rightBit);
			} 	
			if(dataIndex>0){
			 tableLine=new Bitmap();
		     tableLine.bitmapData=getBitmap("tableLine").bitmapData;
		     this.addChild(tableLine);
			}	 
			text.embedFonts=true;
			text.selectable=false;
			text.text=this.title;
			text.setTextFormat(Style.getHead());
			text.width=this.width;
			text.height=this.rowHeight;			 
			this.addChild(text); 
			 
		}
		private function resize(e:Event):void{
		     this.reload();
		}
		private function reload():void{
			  
		   if(this.dataIndex==0){
		   	 this.leftBit.width=6;	
		   	 leftBit.height=34;	  
		   	 this.centerBit.x=6;
		   	 this.centerBit.width=this.width-6; 
		   }if(this.dataIndex>0&&this.dataIndex<this.dataLength-1){
		   	  centerBit.x=1;
		      this.centerBit.width=this.width-1;
		      this.centerBit.height=34;;	   	  	 
		   }if(this.dataIndex==this.dataLength-1){		  	   	 
		   	 this.centerBit.x=1;
		   	 this.centerBit.width=this.width-7;
		   	  centerBit.height=34;
		   	 this.rightBit.x=this.width-7;
		   	 this.rightBit.width=7;
		   	  rightBit.height=34;
		   }
		   if(this.dataIndex>0){
		   	 tableLine.x=0;
		   	 tableLine.width=1;
		   	 tableLine.height=34;
 		   }		   
		   this.text.width=this.width;

		}
		public function  setNoUsed():void{
		  this.leftBit.bitmapData=this.getBitmap("tableLeft").bitmapData.clone();
		  this.rightBit.bitmapData=this.getBitmap("tableRight").bitmapData.clone();
		  this.centerBit.bitmapData=this.getBitmap("tableCenter").bitmapData.clone();
		}
		public function setUsed():void{
		  this.leftBit.bitmapData=this.getBitmap("tableLeft1").bitmapData.clone();
		  this.centerBit.bitmapData=this.getBitmap("tableCenter1").bitmapData.clone();
		  this.rightBit.bitmapData=this.getBitmap("tableRight1").bitmapData.clone();
		}
		 
		public function getBitmap(key:*):Bitmap
		{
			return this.bulkLoader.getBitmap(key, false);
		}
		
	}
}