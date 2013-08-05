package com.identity.picBox
{
	
	
	import com.careland.component.touch.TUIOSwipe;
	import com.careland.event.ImgEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.ui.*;
	import flash.utils.getTimer;
	public class CLDPicList extends TUIOSwipe
	{
		private var xml:XML;	 
		private var loader:URLLoader;
		private var img:Bitmap;
		private var bitList:Array=new Array(5);
		private var list:Array=[];
      	private var index:int=0;
		private var preTime:int=0;
		private var start:Boolean=false;
		private var speed:Number = 3;		
		private var directionX:Boolean=false;		
		private var pre:Object;
		public function CLDPicList()
		{

			super.vh="h";

		}
       override public function dispose():void
		{ 
			super.dispose();
			this.index=null;
			this.preTime=null;
			this.speed=null;
		    if(this.img!=null){
		    	this.img=null;
		    }
		    if(list&&list.length>0){
				for(var i:int=0;i<this.list.length;i++)
				{
					try{
						var dis:DisplayObject=this.removeChild(list[i]);
						dis.removeEventListener(ImgEvent.mouseClick,imgClick);
						Object(dis).dispose();
					}catch(e:Error)
					{
						
					}
				}
			}
		    
		    this.bitList=null;
		    this.list=null;
			this.xml=null;
			this.stopStep();
		}
		/***
		*
		* 覆盖父类添加子例方法
		*/
		override protected function addChildren():void
		{
		   // this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown); 
		}
        
	

		/**
		*
		* 覆盖父类画布方法
		*/
		override public function draw():void
		{
			super.draw();
			if(data&&this.dataChange){
				this.build();
				this.dataChange=false;
			}
			
			
		} 
		
		
		 

		override public function set data(value:*):void
		{
			this.stopStep();
			super.data=value;
			this.xml=XML(data);
		}

		/**
		 * 加载数据
		 */
		private function loadDatas():void
		{  
		   
			var url=produceurl + "?SpName=" + encodeURI("P_查询QQ相册");	
			 
			this.loadTxt(url, null, loadDatasComplete);	
		    
		}

		/**
		* 加载数据完成>开始设置标签
		*/
		private function loadDatasComplete(e:Event):void
		{
			this.dataLoader.removeEventListener(Event.COMPLETE,loadDatasComplete);
			this.dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
			var url:URLLoader=e.target as URLLoader;
			xml=XML(url.data);
			build();
		}

        private function reload():void{
          for(var i:int=0;i<list.length;i++){
             var pic:ClDPicBorder= list[i] as ClDPicBorder;
               pic.width=158;
               pic.height=102;
          }
        
        }

		/**
		 * 构建QQ相册
		 */
		private var size:int;
		
		private function build():void
		{
			if(!xml){
				return;
			}
			size=xml.data.length();
			 
			var piceSize:int=168;
			var _x:int=0;
			var url:String;
//			
			while(this.numChildren>0){
				var obj:Object=this.removeChildAt(0);
				if(obj is ClDPicBorder)
				{
					obj.removeEventListener(ImgEvent.photoClick,imgClick);
					obj.dispose();
				}
			}
			this.list.splice(0,this.list.length);
			
			for (var i:int; i < size; i++)
			{
				var pic:ClDPicBorder=new ClDPicBorder(xml.data[i].@图片路径);
 				pic.height=this.height;
 				pic.width=piceSize-10;		
 				pic.y=0; 
 				pic.x=_x;
 				this.addChild(pic);
 				list.push(pic);
				_x+=piceSize;
				pic.addEventListener(ImgEvent.photoClick,imgClick);
			}
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0x000000,0);
			if(this.width>0){
				g.drawRect(0,0,_x+piceSize,this.height);
			}
			g.endFill();
			
			
		} 
		
		private function imgClick(e:ImgEvent):void
		{
			this.dispatchEvent(e.clone());
			e.stopPropagation();	
		}
		public function set isstart(value:Boolean):void
		{
			if(value){
				this.startStep();
			}else{
				this.stopStep();
			}
		}
		public function get isstart():Boolean
		{
			return start;
		}
		
		public function startStep():void
		{
			start=true;
			preTime=flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME,enter);
		}
		public function stopStep():void
		{
			start=false;
			preTime=flash.utils.getTimer();
			this.removeEventListener(Event.ENTER_FRAME,enter);
		}
		private function get filter():BitmapFilter
		{
			return new GlowFilter();
		}
		private function enter(e:Event):void
		{
			if(!this.start)return;
			if(list.length==0)return;
			var newTime:int=flash.utils.getTimer();
			
//			if(this.x <= -this.size*168+this.width|| this.x >=0){
//  				directionX = !directionX;
// 			}
// 
//			 if(directionX){
// 				 this.x -= speed;
//			 }else{
// 				 this.x += speed;
// 			  }
			if(newTime-preTime>int(config.getProperties("photoTimeStep"))*1000)
			{
				
				var imgevent:ImgEvent=new ImgEvent(ImgEvent.photoClick);
				imgevent.img=this.list[index].img;
				
				
				imgevent._width=this.list[index]._withs;
				imgevent._height=this.list[index]._heights;
				this.dispatchEvent(imgevent);
				index++;
				if(index>=this.list.length)
				{
					//this.dispatchEvent(new Event("removeAllPhoto"));
					index=0;
				}
				this.preTime=newTime;
				
			}
		}
		
		
		private function mouseDown(e:MouseEvent):void{    
		 	      
		 	  this.start=false;
              this.startDrag(false,new  Rectangle(0,0,-10000,0));  
//               this.startDrag(false,new  Rectangle(0,0,-10000,0));      
              this.addEventListener(MouseEvent.MOUSE_OUT,this.mouseUp);
        }
        private function mouseUp(e:MouseEvent):void{
        	 start=true;
           	  this.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseUp);
        	  this.stopDrag();
        } 
	}
}