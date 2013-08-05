package com.identity.list
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDList extends CLDBaseComponent
	{
		
		
		private var prePoint:Point;
		
		private var state:String="none";
		private var blob1:Object={};
		
		private var curPoint:Point=new Point(0,0);
		
		private var dy:Number=0;
		private var preY:Number=0;
		
		private var velY:Number;
		
		public var rowHeight:Number=54;
		
		public var allRowHeight:Number=0;
		private var touchUI:Sprite;	 
		private var initData:Boolean=false;
		
		private var canDrag:Boolean=false;
		
		private var listItem:Array=[];
		
		protected var maskBit:Bitmap;
		public function CLDList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			touchUI=new Sprite;
			this.addChild(touchUI);
		    touchUI.visible=true;
		     maskBit=this.config.getBitmap("list_centerMask");
			 
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.addEventListener(Event.ENTER_FRAME,update);
			
		}
		
		private function downHandler(e:TUIOEvent):void
		{
			if(e.stageX==0||e.stageY==0)return;
			//if(blob1.id==undefined)return;
			prePoint=new Point(this.x,this.y);
//			prePoint=new Point(e.stageX,e.stageY);
			this.addEventListener(TUIOEvent.TUIO_UP,upHandler);
			
			e.stopPropagation();
			blob1={id: e.ID, origX: e.stageX, origY: e.stageY, myOrigX: x, myOrigY:y}
			state="dragging";
			curPoint.x=this.x;
			curPoint.y=this.y;
			preY=this.y;
		}
		
		public function listuiDown(e:TUIOEvent=null):void
		{
			var position:Number=this.y;
			if(position<0)
			{
				var num:int=Math.abs(position)/this.rowHeight+4;
			}else{
				var num:int=position/rowHeight;
			}
			
			num=(this.rowHeight*3-this.y)/rowHeight;

			if(num<0){
				num=0;
			}
			if(num>=this.listItem.length-1)
			{
				num=this.listItem.length-1;
			}
			var item:CLDListItem=this.listItem[num];
			this.dispatherItemEvent(item.id,item.object);
		         	 
			
		}
		public function dispatherItemEvent(id:Number,obj:Object)
		{
			var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
			imgevent.id=id;
			imgevent.object=obj; 
//			imgevent.stageX=e.stageX;
//			imgevent.stageY=e.stageY;	   
			this.dispatchEvent(imgevent);   
			
			//ImgEvent.mouseClick 和 layout12的 事件冲突  所以抛两个事件 来区分
			var imgevent0:ImgEvent=new ImgEvent(ImgEvent.listItemClick);
			
			imgevent0.id=id;
			imgevent0.object=obj; 
//			imgevent0.stageX=e.stageX;
//			imgevent0.stageY=e.stageY;	   
			this.dispatchEvent(imgevent0);   
		}
		
		private function upHandler(e:TUIOEvent=null):void
		{
			this.removeEventListener(TUIOEvent.TUIO_UP,upHandler);
			this.state="none";
			blob1={};
			if(e==null)return;
			var tuioobj:TUIOObject=TUIO.getObjectById(e.ID);
			if(tuioobj)
			{
//				var distance:Number=((tuioobj.oldX-tuioobj.x)*(tuioobj.oldX-tuioobj.x))+
//					((tuioobj.oldY-tuioobj.y)*(tuioobj.oldY-tuioobj.y));
//				if(distance<30*30&&this.parent)
//				{
//					var lp:Point=this.parent.globalToLocal(new Point(tuioobj.x,tuioobj.y));
//					var position:Number=lp.y+Math.abs(this.y);
//					var num:int=position/rowHeight+(position%rowHeight>35?1:0);
//					Tweener.addTween(this.touchUI,{y:num*this.rowHeight,time:.3});
//					
//					var item:CLDListItem=this.listItem[num];
//					if(item){
//						 var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
//		         		 imgevent.id=item.id;
//		        		 imgevent.object=item.object; 
//		         		 imgevent.stageX=e.stageX;
//		         		 imgevent.stageY=e.stageY;	   
//		         		 this.dispatchEvent(imgevent);   
//					}
//					
//					
//					
//				}
			}
			
			
		}
		private function update(e:Event):void
		{
			if(state=="dragging"&&this.canDrag){
				if(!blob1&&!blob1.id)return;
			    var tuioobj:TUIOObject=TUIO.getObjectById(blob1.id);

				// if not found, then it must have died..
				if (!tuioobj)
				{
					this.upHandler();
					return;
				}

				var newX:Number=this.curPoint.x+tuioobj.x-this.blob1.origX;
				var newY:Number=this.curPoint.y+tuioobj.y-this.blob1.origY;
				var old:Point=prePoint;
				var newP:Point=new Point(newX,newY);
				var disPoint:Point=newP.subtract(old);

				var dis:Number=Math.abs(disPoint.y);				
				
					//this.x=newX;
				this.y=newY;
				this.dy=this.y-this.preY;
				this.preY=this.y;
				this.addEventListener(Event.ENTER_FRAME,updateTweener);
			
			}else{
				if(dy!=0){
					trace("dy"+dy);
					this.released(dy);
					this.bottom=this.height*50;
					this.top=0;
					dy=0
				}
				
			}
		}
		public var friction:Number = 0.92;
        public var angFriction:Number = 0.9;
        private var border_size:Number = 10;
        public var left:Number = 0;
        public var right:Number = 60000;
        public var top:Number = 0;
        public var bottom:Number = 50000;
        
        private var isDown:Boolean=undefined;//是否向下运动
		private function updateTweener(e:Event):void
		{
			if (this.state == "none"){
              
                if (Math.abs(velY) < 1){
                    velY = 0;
                    this.removeEventListener(Event.ENTER_FRAME,updateTweener);
                  //  Tweener.addTween(this,{y:this.y-this.y%this.rowHeight,time:.3}); 
//                    this.y=(this.rowHeight*3-this.y)/this.rowHeight*this.rowHeight+this.rowHeight*3;
                    //this.y=this.y-this.y%this.rowHeight;
                    var vy:Number=Math.round((this.y/this.rowHeight))*this.rowHeight;
                    Tweener.addTween(this,{y:vy,time:.3});
                    return;
                } else {
                    y = (y + velY);
                    velY = (velY * friction);
                };
              
//                if ((((((((right == 0)) && ((left == 0)))) && ((bottom == 0)))) && ((top == 0)))){
//                    return;
//                };
                var tempNum:Number=this.allRowHeight-this.rowHeight*4-this.rowHeight;
			    if(allRowHeight!=0&&this.y<-(tempNum)){
					velY=0;
					Tweener.addTween(this,{y:-(tempNum),time:.3});
				}else if(this.y>this.top+this.rowHeight*3){
					velY=0;
               		Tweener.addTween(this,{y:this.top+this.rowHeight*3,time:.3});
    			}else{
    				
    			}
			
				 
          
            };
		}
		override public function draw():void
		{
			super.draw();
			if(data&&this.dataChange)
			{
				listItem=[];
				var ypos:Number=0;
				var xml:XML=XML(data);
				for(var i:int=0;i<xml.data.length();i++){
		    	  	      var row:CLDListItem=new CLDListItem();
		    	  	      row.imgPath=xml.data[i].@图片路径;
		    	  	      row.content=xml.data[i].@content;
		    	  	      row.contentID=xml.data[i].@内容ID;
		    	  	      row.param=xml.data[i].@参数;
		    	  	      row.data=xml.data[i];
		    	  	      row.object=new Object();
		    	  	      row.object.content=String(xml.data[i].@content);
		    	  	      row.object.contentID=String(xml.data[i].@内容ID);
		    	  	      row.object.winID=String(xml.data[i].@窗体编号);
		    	  	      row.object.eventChart=String(xml.data[i].@点击事件类型);
		    	  	      row.object.width=String(xml.data[i].@窗体宽度);
		    	  	      row.object.height=String(xml.data[i].@窗体高度);
		    	  	      row.object.imagePath=String(xml.data[i].@图片路径);
						  row.object.mapProp=String(xml.data[i].@地图属性);
						  row.object.param=String(xml.data[i].@参数);
						  row.object.winState=String(xml.data[i].@固定窗体);
						  row.object.winPoint=String(xml.data[i].@窗体位置);
						  row.object.clearLayer=String(xml.data[i].@清除图层);
		    	  	      row.setSize(this.width,rowHeight);
		    	  	      row.autoLoad=true;		    	  	     
		    	  	      //row.addEventListener(TUIOEvent.TUIO_DOWN,clickHandler);
		    	  	     
//		    	  	      row.addEventListener(MouseEvent.CLICK,itemClick);		   
		    	  	      //row.addEventListener(CLDEvent.ITEMCLICK,itemClick);		    	  	   
		    	  	      row.y=ypos;
		    	  	      ypos+=rowHeight;
		    	  	      listItem.push(row);
		    	  	      this.addChild(row);		    	  	      
		    	  }	
		    	allRowHeight=ypos+this.rowHeight;
		    	initData=true;
				this.dataChange=false;
				
			}
			this.canDrag=true;
//			if(allRowHeight>this.height){
//				this.canDrag=true;
//			}else{
//				this.canDrag=false;
//			}
			var g:Graphics=this.graphics;
			g.clear();
			
			g.beginFill(0x000000,0);
			g.drawRoundRect(0,0,this.width,this.height,10,10);
			g.endFill();
			if(this.touchUI){
				
					
//					var g:Graphics=this.touchUI.graphics;
//					g.clear();
//					g.beginBitmapFill(this.maskBit.bitmapData,null,true,false);
//					g.drawRoundRect(0,0,this.width,this.rowHeight,10,10);
//					g.endFill();
				
					
			}	  
		}
		 private function  itemClick(e:MouseEvent):void{	
		 	var item:CLDListItem=e.currentTarget as CLDListItem;
		 	if(item){
		 		 var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
		         imgevent.id=item.id;
		         imgevent.object=item.object; 
		         imgevent.stageX=e.stageX;
		         imgevent.stageY=e.stageY;	         
		         this.touchUI.visible=true;
				// var lp:Point=this.globalToLocal(new Point(e.stageX,e.stageY));
				 Tweener.removeTweens(this.touchUI);
				 Tweener.addTween(this.touchUI,{x:item.x,y:item.y,time:.3});
		    	 imgevent.data=item.object;
				 this.dispatchEvent(imgevent); 
		 	}		   	 		     		      	      
		 }	
		private function released(dy:Number):void
		{
//			 velY = (dy*2);
			  velY = dy;
		}
		override public function dispose():void
		{
			this.removeEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.removeEventListener(Event.ENTER_FRAME,update);
			this.removeEventListener(Event.ENTER_FRAME,updateTweener);
			super.dispose();
			this.touchUI=null;
		}
		
		
	}
}