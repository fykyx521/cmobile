package com.identity.picBox
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.TUIOTouchObj;
	import com.careland.event.ImgEvent;
	import com.identity.CLDButtons;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.*;
	
	public class CLDPicBox extends CLDBaseComponent
	{
		 
        public var image:Bitmap=new Bitmap();
        private var picHeight:int=0;
        private var piclist:CLDPicList;
        private var ifclick:Boolean=false;
        private var list:Array=[];
        
        private var img:TUIOTouchObj;
        
        private var contentMask:Sprite;
        
        private var isInit:Boolean=false;
        private var listHeight:int=100;
        
        private var imgContainer:CLDPhoto;
        
        private var playStopBtn:CLDButtons;
		public function CLDPicBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
		    	 
		} 
		override public function dispose():void
		{
			super.dispose();
			
			if(piclist){
				piclist.removeEventListener(ImgEvent.photoClick,imageClick);
			}
			if(imgContainer){
				imgContainer.dispose();
			}
			
			contentMask=null;
			if(this.image!=null){
				this.image=null;
			}
			this.picHeight=null;
			this.piclist=null;
			this.ifclick=null;
			this.list=null;
			
		}
		/**
		*覆盖父类添加子例方法
		*/
		override protected function addChildren():void
		{
			    piclist=new CLDPicList();
		        piclist.height=100;
		        piclist.width=this.width;
		        piclist.x=0;
		        piclist.y=0;
			    piclist.addEventListener(ImgEvent.photoClick,imageClick);
//			    piclist.addEventListener("removeAllPhoto",removeAllPhone);
			 //   piclist.addEventListener(ImgEvent.mouseWheel,mouseWheel,true);
			   
			   
			     imgContainer=new CLDPhoto();
	      	    this.addChild(imgContainer);
	      	    
			    this.addChild(piclist);	
			  
			    contentMask=new Sprite;
	      	    this.addChild(contentMask);
	      	    piclist.mask=this.contentMask;
	      	  
	      	    
	      	    playStopBtn=new CLDButtons();
	      	    playStopBtn.lable="播放";
	      	    playStopBtn.setSize(100,40);
			    this.addChild(playStopBtn);
			    
			    
			    playStopBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		     // this.addEventListener(Event.RESIZE,resize);	         
	    }
	    private function clickHandler(e:MouseEvent):void
	    {
	    	if(this.piclist){
	    		piclist.isstart=!piclist.isstart;
	    		if(!piclist.isstart){
	    			playStopBtn.text="播放";
	    		}else{
	    			playStopBtn.text="停止";
	    		}
	    	}
	    }

        /**
		*
		* 覆盖父类画布方法
		*/
		override public function draw():void
		{
			 if(data&&this.dataChange)
			 {
			 	piclist.data=data;
			 	
			 	dataChange=false;
			 }
			 if(contentMask){
			 	 var g:Graphics=contentMask.graphics;
			 	 g.clear();
			     g.beginFill(0xffffff,1);
			     g.drawRect(0,0,width,height);
			     g.endFill();
			 }
			 if(piclist){
			 	 piclist.setSize(this.width,this.listHeight);
			 }
			 if(imgContainer)
			 {
			 	imgContainer.x=0;
			 	imgContainer.y=100;
			 }
			 if(this.playStopBtn){
			 	playStopBtn.x=this.width-100;
			 	playStopBtn.y=this.listHeight;
			 	
			 }
         
		}	
	
		/**
		 *添加图片集合 
		 */ 
		
		private function removeAllPhone(e:Event):void
		{
			if(list&&list.length>0){
				for(var i:int=0;i<this.list.length;i++)
				{
					try{
						var dis:DisplayObject=this.removeChild(list[i]);
						Object(dis).dispose();
					}catch(e:Error)
					{
						
					}
				}
			}
		}
		  private var initWH:Point=new Point(100,100);
		  private function imageClick(e:ImgEvent):void{ 
             
             e.stopPropagation();
             var spx:Number=(this.width-initWH.x)/2;
           	 var spy:Number=(this.height-this.listHeight-initWH.y)/2+this.listHeight;
             var showPoint:Point=new Point(spx,spy);
             
//             Tweener.addTween(imgContainer,{scaleX:1,rotation:0,scaleY:1,x:spx,y:spy,width:initWH.x,height:initWH.y,
//           	  time:.5,onComplete:onComplete});
           	  //onComplete();
           	    imgContainer.removeBit();
           	    var bit:Bitmap=null;
           	    try{
           	    	 bit=new Bitmap(e.img.bitmapData.clone());
           	    }catch(e:Error){
           	    	 bit=null;
           	    }
           	    if(!bit){
           	    	return;
           	    }
           	    
           	    var targetWidth:Number=Math.min(this.width,e._width);
           	    var targetHeight:Number=Math.min(this.height-listHeight,e._height);
             	 
             	 imgContainer.addBit(bit);
            	 imgContainer.width=initWH.x;
             	 imgContainer.height=initWH.y;
            	 imgContainer.alpha=.5;
            	 imgContainer.x=showPoint.x;
             	 imgContainer.y=showPoint.y;
             	  var toPoint:Point=new Point((this.width-targetWidth)/2,(this.height-this.listHeight-targetHeight)/2+listHeight);
                  Tweener.addTween(imgContainer,{x:toPoint.x,y:toPoint.y,width:targetWidth,height:targetHeight,alpha:1,time:.5,scaleX:1,scaleY:1,rotation:0});
             function onComplete(){
             	
             }
            
          	
             
             
             
           
             
            
           
//             this.addChild(imgContainer);
             
//             list.push(imgContainer);

//             var img=new TUIOTouchObj();
//             this.addChild(img);    
//             var bit:Bitmap=new Bitmap(e.img.bitmapData.clone());    
//             img.addChild(bit);            
//             img.width=e._width;
//             img.height=e._height;
//             img.y=100;
//             img.scaleX=1;
//            

 
        }
      
	}
}