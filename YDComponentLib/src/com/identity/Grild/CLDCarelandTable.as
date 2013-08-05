package com.identity.Grild
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.CLDLoding;
	import com.careland.event.RowEvent;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.*;

	/**
	 * 表格主体
	 */
	public dynamic class CLDCarelandTable extends CLDBaseComponent
	{
		/**
		* 表头
		*/
		private var head:CLDTableHeader;
		private var body:CLDTableBody;
		private var dis:DisplayObject;
		private var cloums:Array=[];
		private var list:Array=[];
		private var oldY:Number=0;
		private var newY:Number=0;
		private var oldX:Number=0;
		private var newX:Number=0;
		private var headHeight:int=34;
		private var distance:Number=0;
		private var sprite:Sprite;
		private var ifMoving:Boolean=false;
		private var maxY:Number=0;
		private var distanceX:Number=0;
		private var left:Bitmap;
		private var right:Bitmap;
		private var up:Bitmap;
		private var down:Bitmap;
		private var locationLoad:BulkLoader;
		private var direction:String="";
	    private var ifDis:Boolean=false;
	    private var ifLoad:Boolean=false;
	    private var directions:Number=0;//计算Y轴移动的所有距离
//	    private var loading:GIFPlayer;
	    private var _timeInteval:Number;
	    private var cols:Array;
	    private var rowEvent:RowEvent;
	    private var contentType:int;
	    private var ifCheck:Boolean=false;
	    override public function dispose():void
		{
			if(config){
				config.removeEventListener(RowEvent.btnClick,findLocation);
			}
			super.dispose();
			if(this.locationLoad){
				locationLoad.removeEventListener(BulkProgressEvent.COMPLETE,loadLocationResutlt);
				locationLoad.clear();
			}
			locationLoad=null;
			this.removeEventListener(Event.ENTER_FRAME,this.enter);
			this.cloums=null;
			this.list=null;
			this.oldY=null;
			this.newY=null;
			this.oldX=null;
			this.newX=null;
			this.headHeight=null;
			this.distance=null;
			this.sprite=null;
			this.ifMove=null;
			this.maxY=null;
			this.distanceX=null;
			this.left=null;
			this.right=null;
			this.up=null;
			this.down=null;
			this.locationLoad=null;
			this.direction=null;
			this.ifLoad=null;
			this.directions=null;
			this.head=null;
			this.body=null;
			this.dis=null;
			this.removeEventListener(TUIOEvent.TUIO_UP,mouseUp);
			this.removeEventListener(TUIOEvent.TUIO_MOVE,mouseMove);
			this.removeEventListener(TUIOEvent.TUIO_DOWN,mouseDown);
		}
		
		
		
		private var loding:CLDLoding;
		/***
		 *
		 * 覆盖父类添加子例方法
		 */
		override protected function addChildren():void
		{
			locationLoad=BulkLoader.getLoader("locationLoad");
			if(!locationLoad)
			{
				locationLoad=new BulkLoader("locationLoad");
			}
			this.addEventListener(Event.RESIZE,resize);
			
			loding=new CLDLoding();
			this.addChild(loding);
			loding.visible=false;
			 
			config.addEventListener(RowEvent.btnClick,findLocation);		
		}
	   
	   public function findLocation(e:RowEvent):void
	   {
	   		
	   		var itemIndex:int=0;
	   		switch(e.GPS){
	   			case 0: locationLoad.add(e.value,{id:"locationLoad"+itemIndex});break;
	   			case 1: pgps(e.cols);break;
	   		}
	   		
	   		function pgps(gpsValues:Array):void{
	   			for each(var obj:Object in gpsValues){
	   				 locationLoad.add(obj.value,{id:"locationLoad"+itemIndex});
	   				 itemIndex++;
	   			}
	   		}
	   		
	   		if(!locationLoad.hasEventListener(BulkProgressEvent.COMPLETE))
	   		{
	   			locationLoad.addEventListener(BulkProgressEvent.COMPLETE,loadLocationResutlt);
	   		}
	   		this.ShowLoading();
	   		locationLoad.start();
	   }
	   private function loadLocationResutlt(e:BulkProgressEvent):void
	   {
	   		this.hideLoading();
	   		if(this.config){
	   			var rowEvent:RowEvent=new RowEvent(RowEvent.locationResult);	         
	   			var data:Array=[];
	   			for(var i:int=0;i<this.locationLoad.itemsLoaded;i++){
	   				var xml:XML=XML(this.locationLoad.getContent("locationLoad"+i,true));
	   				data.push(xml);
	   				locationLoad.remove("locationLoad"+i);
	   			}
	   					    	   	       
		    	rowEvent.data=data;
 		    	rowEvent.GPS=2;//
	   			this.config.dispatchEvent(rowEvent);
	   		}
	   		
	   }
		
       private function resize(e:Event):void{
          if (dis)
			{
				//dis=this.getdis();
			}
       }
		public function getdis():DisplayObject
		{
			sprite=new Sprite;
			var g:Graphics=sprite.graphics;
			g.beginFill(0xffffff, 1);
			g.drawRect(0, this.headHeight, width, 10000);
			g.endFill();
			return sprite;
		}

		override public function draw():void
		{
			super.draw();
			if (head)
			{
				head.width=this.width;
			}
			if (body)
			{
				body.width=this.width;
				body.height=this.height;
			}
			if (sprite)
			{
				var g:Graphics=sprite.graphics;
				g.beginFill(0xffffff, 1);
				g.drawRect(0, this.headHeight, width, 10000);
				g.endFill();
			}
			if (left)
			{
				this.initUI();
			}		
			if(this.loding){
				this.loding.setSize(this.width,this.height);
			}	 
		}
         
         private function initUI():void{        
            if (this.maxY < this.height)
			{
				down.y=this.maxY - down.height;				 
				left.y=(maxY-left.height)/2;			 
			    right.y=(maxY-right.height)/2;
			 
			}
			else
			{
				down.y=this.height - down.height-this.headHeight;
				left.y=(this.height-left.height)/2;
			    right.y=(this.height-right.height)/2;
			}
			down.x=(this.width-down.width)/2;
			up.x=(this.width-up.width)/2;
 		    right.x=this.width-right.width;
// 		    loading.y=this.maxY/2;
// 		    loading.x=this.width/2;
         } 
		public function CLDCarelandTable(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			this._timeInteval=timeInteval;
			this.addEventListener(Event.ENTER_FRAME,enter);
		}

		private function build():void
		{
			left=new Bitmap();
			left.bitmapData=getBitmap("leftPoint").bitmapData;
			left.y=(this.height - left.height) / 2;
			left.visible=false;
			this.addChild(left);
			right=new Bitmap();
			right.bitmapData=getBitmap("rightPoint").bitmapData;
			right.visible=false;
			right.x=this.width - right.width;
			right.y=(this.height - right.height) / 2;
			this.addChild(right);
			up=new Bitmap();
			up.bitmapData=getBitmap("downPoint").bitmapData;
			up.visible=false;
			up.y=this.headHeight;
			up.x=(this.width - up.width) / 2;
			this.addChild(up);
			down=new Bitmap();
			down.bitmapData=getBitmap("upPoint").bitmapData;
			down.visible=false;
			down.y=this.maxY;
			down.x=(this.width - down.width) / 2;
			this.addChild(down);
			
			
		}

		override protected function loadComponentData(id:String, datas:*):void
		{           
			head=new CLDTableHeader(XML(datas), this.width, 20);
			head.setSize(this.width, 34);
			head.addEventListener(RowEvent.rowClick, rowClick);
			this.addChild(head);
			body=new CLDTableBody(null,0,0,false,_timeInteval);
			body.contentIDParam=this.contentIDParam;
			body.contentID=this.contentID;
			body.setSize(this.width, 20);
			body.data=datas;
		//	this.addEventListener(TUIOEvent.TUIO_DOWN, TUTODown);
		//	this.addEventListener(TUIOEvent.TUIO_UP, TUTIUp);
//			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
//			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
//			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
		//	this.addEventListener(TUIOEvent.TUIO_OUT, TUTIMouseOut);
			body.addEventListener(RowEvent.initHeight, initHeight);
			body.addEventListener(RowEvent.loadDataFinish, loadDataFinish); 			
			body.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			//body.addEventListener(TUIOEvent.TUIO_MOVE,moveHandler);
			body.addEventListener(TUIOEvent.TUIO_UP,upHandler);
 
 			this.addChild(body);
			dis=this.getdis();
			this.addChild(dis);
			this.body.mask=dis;
			build();
		}
		
		var prePoint:Point=new Point(0,0);
		private var blobs:Array=[];
		private var isMove:Boolean=false;
		private var state:String="none";
		private var blob1:Object={};
		private var blob2:Object={};
		//private var direction:String="";//默认横向
		private function downHandler(e:TUIOEvent):void
		{
			
			e.stopPropagation();
			for(var i:int=0;i<this.blobs.length;i++)
			{
				if(blobs.id==e.ID)
				{
					return;
				}
			}
			blobs.push({id:e.ID,origX:e.stageX,origY:e.stageY});
			if(blobs.length==1){
				state="topdown";
				
				blob1=blobs[0];
			}
			if(blobs.length==2){
				state="leftright";
				blob1=blobs[0];
				blob2=blobs[1];
			}
			
			prePoint=new Point(this.body.x,this.body.y);
			stage.addEventListener(TUIOEvent.TUIO_UP,upHandler);
		}
		
		private function enter(e:Event):void
		{
			
//			switch(state){
//				case "leftright":leftright();break;
//				case "topDown":topDown();break;
//			}
 				if(state=="none")return;
				
			    var tuioobj:TUIOObject=TUIO.getObjectById(blob1.id);

				// if not found, then it must have died..
				if (!tuioobj)
				{
					removeBlobs(blob1.id);
					return;
				}
				
//				/var curPt:Point=parent.globalToLocal(new Point(tuioobj.x, tuioobj.y)); //得到当前触点坐标
				var newX:Number=this.prePoint.x+tuioobj.x-this.blob1.origX;
				var newY:Number=this.prePoint.y+tuioobj.y-this.blob1.origY;
				
				var old:Point=this.prePoint;
				var newP:Point=new Point(newX,newY);
				var disPoint:Point=newP.subtract(old);				
				var dis:Number=Math.sqrt(Math.abs(disPoint.x*disPoint.x+disPoint.y*disPoint.y));				
				if(dis>40){
					 if(state=="topdown"){
					 	this.body.y=newY;
					 	if(body.y>100){
					 		this.up.visible=true;
					 	}
					 	if(this.body.y+this.maxY<this.height-100){
					 		this.down.visible=true;
					 	}
//					 	if(body.y<-100){
//					 		this.down.visible=true;
//					 	}
//					 	if(body.y<100&&body.y>-100)
//					 	{
//					 		this.down.visible=this.up.visible=false;
//					 	}
			 			
					 }else{
			 			this.body.x=newX;
			 			
					 	if(body.x>100){
					 		this.left.visible=true;
					 	}
					 	if(body.x<-100){
					 		this.right.visible=true;
					 	}
					 	if(body.x<100&&body.x>-100)
					 	{
					 		this.right.visible=this.left.visible=false;
					 	}
			 		 }
					
				}
				if(this.state=="leftright")
				{
					var tuioobj1:TUIOObject=TUIO.getObjectById(blob2.id);

				// if not found, then it must have died..
					if (!tuioobj)
					{
						removeBlobs(blob2.id);
						return;
					}
				}
				
			
			
			function leftright():void
			{
				
			}
			function topDown():void
			{
				
			}
//			for(var i:int=0;i<this.blobs.length;i++)
//			{
//				var obj:int=blobs[i].id;
//				
//				var tuio:TUIOObject=TUIO.getObjectById(obj);
//				if(!tuio){
//					this.removeBlobs(obj);
//				}
//			}
		}
			
		
		private function upHandler(e:TUIOEvent):void
		{
			removeBlobs(e.ID);
			stage.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
			e.stopPropagation();
			
		}
		private function removeBlobs(id:int):void
		{
			for(var i:int=0;i<this.blobs.length;i++)
			{
				if(blobs[i].id==id){
					this.blobs.splice(i,1);
				}
			
			}
			if(this.blobs.length==0){
				
				var direction:String="";
				if(this.state=="topdown"){
					if(body.y>100){
						direction="down";
					}
					if(this.body.y+this.maxY<this.height-100){
						direction="up";
					}
//					var direction=body.y<0?"up":"down";
					
//					Alert.show("leftRight");
				}else if(this.state=="leftright"){
					
					if(body.x<-100){
						direction="left";
					}
					if(body.x>100){
						direction="right";
					}
					//=body.x<0?"left":"right";
//					Alert.show("topDown");
				}
				
				this.hiddenUI();
				if(direction!=""){
					this.loadPage(direction);
					
					Tweener.addTween(body, {x: 0,y:0,time: 0.3, onComplete: onComplete});
				}
				
				this.state="none";
				
				
				
			}
			
			
		}
        
		private function loadDataFinish(e:RowEvent):void
		{
			hiddenUI();
			ifMoving=false;
			ifDis=false;
			this.left.visible=false;
			this.right.visible=false;
			this.down.visible=false;
			this.up.visible=false;
			hideLoading();
		}
        private function hiddenUI():void{
            left.visible=false;
			right.visible=false;
			down.visible=false;
			up.visible=false;
        }


		private function initHeight(e:RowEvent):void
		{
			this.maxY=e.max;
			this.initUI();		
		}
  
		private function mouseDown(e:MouseEvent):void
		{
			//hiddenUI();		
			oldX=e.stageX;
			oldY=e.stageY;
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
      
		private function mouseMove(e:MouseEvent):void
		{
			 if(ifMoving){
			     return ;
			 }			 
				newX=e.stageX;
				newY=e.stageY;
				distance=newY - oldY;
				directions+=distance;
				distanceX=newX - oldX;
				if (direction == "")
				{
					if (newX - oldX > 5)
					{
						direction="right";						 
						this.left.visible=true;						 
					}
					if (oldX - newX > 5)
					{
						direction="left"						 
					    this.right.visible=true;						
					}
					if (newY - oldY > 5)
					{
						direction="down";						 
						up.visible=true;						 
					}
					if (oldY - newY > 5)
					{
						direction="up";
					    down.visible=true;
					}
				}
				if (direction == "down" || direction == "up")
				{
					Tweener.addTween(body, {y: distance, time: 0.1, onComplete: onComplete});
				}
				if (direction == "left" || direction == "right")
				{
					Tweener.addTween(body, {x: distanceX, time: 0.1, onComplete: onComplete});
				}			 
		}

		private function onComplete(e:Event):void
		{

		}
	
        private function  mouseOut(e:MouseEvent):void{
      
          this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
           
        }
     
		private function mouseUp(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
		 
			//loadPage();
		}
		
		private function loadPage(direction:String):void
		{
			if(body==null){
			   return;
			}		  
			//if(Math.abs(distance)>100||Math.abs(distanceX)>100){			
				switch (direction)
				{
					case "down":					  
						body.next(); //下一页
						this.down.visible=true;
						break;
					case "up":
						body.back();
						this.up.visible=true;
						break;
					case "right":
						body.last();
						this.right.visible=true;
						break;
					case "left":
						body.first();
						this.left.visible=true;
						break;
				}
			 //} 
			 if (direction != "")
			 {
			   	   ifMoving=true;
			   	   ShowLoading();
				   body.loadDataById();				 
			 }else{
			       hiddenUI();
			}	 
			Tweener.addTween(body, {x:0,y:0,time: 0.3, onComplete: onComplete});
			
			direction="";
		}

		public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}
        private function ShowLoading():void{
        	if(this.loding)this.setChildIndex(this.loding,this.numChildren-1);this.loding.visible=true;
           
        }
        private function hideLoading():void{
          if(this.loding)loding.visible=false;
        }
 
 
 
		private function rowClick(e:RowEvent):void
		{
            
			cloums=body.cloums;
			cols=[];
			for (var i:int=0; i < cloums.length; i++)
			{
				list=cloums[i] as Array;
				for (var j:int=0; j < list.length; j++)
				{
					var row:CLDRow=list[j] as CLDRow;
					if (e.colID == row.colID)
					{
						row.bgroundColor=e.mouseClickColor;
						this.contentType=row.contentType;
						cols.push(row);
						 if(contentType==2){	
						 	 if(row.check.selected){
						 	 	row.check.selected=false;
						 	 }else{
						 	     row.check.selected=true;
						 	  }				 							   						 						
						}
					}
					else
					{						
						row.bgroundColor=e.mouseOutColor;
					}
					row.setBground();
				}
			}			 
			if(this.contentType!=0){
				 rowEvent=new RowEvent(RowEvent.btnClick);	         		    	   	       
		         rowEvent.cols=cols;
		         if(this.contentType==2){
		         	rowEvent.GPS=4;//checkbox用到
		         }
 		         rowEvent.GPS=1; //button用到
		         this.config.dispatchEvent(rowEvent);	  
			}
			
			    
		}

		

		


	}
}