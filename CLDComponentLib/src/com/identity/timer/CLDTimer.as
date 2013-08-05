package com.identity.timer
{
   import br.com.stimuli.loading.BulkLoader;
   
   import com.careland.component.CLDBaseComponent;
   import com.careland.component.util.Style;
   import com.careland.event.TimerEvent;
   
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
	//时间轴
	public class CLDTimer  extends CLDBaseComponent 
	{
		private var bulkLoader:BulkLoader;
		private var logo:Bitmap;
		private var line:Bitmap;
	    private var mouseMove:Boolean;
	    private var beginTime:Date;
	    private var endTime:Date;
	    private var title:TextField;
	    private var sprite:Sprite;
	    private var diff:Number;
	    private var currentTime:Date;
	    private var currentDiff:int;	    
	    private var nowSeconds:int;
	    private var ratio:Number;
	    
	    private var ismouseDown:Boolean=false;
		public function CLDTimer()
		{		 	
			this.addEventListener(Event.RESIZE,resize);	
		}
	 
		private function resize(e:Event):void{
		     buildLogo();
		}
        public function getBitmap(key:*):Bitmap
		{
			return this.config.getBitmap(key);
		}		
		/***
		* 添加子类
		*
		***/
		override protected function addChildren():void
		{
			 logo=new Bitmap();
			 line=new Bitmap();
			 logo.bitmapData=getBitmap("timerLogo").bitmapData.clone();
			 line.bitmapData=getBitmap("timerLine").bitmapData.clone();
			 this.addChild(line);
			 this.addChild(logo);
			 this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			 
			 sprite=new Sprite();
			 this.addChild(sprite);
		}
        public function setLogoValue(_value:Number):void{
            logo.x=_value*this.width/100;
        }
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0x000000,0);
			g.drawRect(0,0,width,height);
			g.endFill();		    
		}
		private function build():void{
		
		}
		private function buildLine():void{
		
		}
		private function buildLogo():void{
			
		    logo.x=5;
		    logo.y=-5;		   	  
		    line.width=this.width;
		    line.x=5;
		    line.y=5;	
		    title=new TextField();		  
		    title.embedFonts=true;
		    //title.text=this.beginTime.toString();
		    title.setTextFormat(Style.getTF());
		    title.x=30;
		    title.y=30+(50-title.textHeight)/2;
		    title.width=200;	
		    	   
		    sprite.graphics.clear();
		    sprite.graphics.beginFill(0xFFFFFF,1);
		    sprite.graphics.drawRect(30,30,200,50);
		    sprite.graphics.endFill();		     	    
		    sprite.addChild(title);	    
		    sprite.visible=false;
		   

		}
	    private function mouseOut(e:MouseEvent):void{
	    	if(!this.ismouseDown){
	    		this.mouseUp(e);
	    	}
			 
		}
		private function mouseUp(e:MouseEvent):void{
		 	this.ismouseDown=false;
			 mouseMove=false;
		 	
		 	  var timeEvent:TimerEvent=new TimerEvent(TimerEvent.timerEvent);
		      timeEvent.millisecond=this.nowSeconds;	
		      timeEvent.ratio=this.ratio; 		 
		    	           
		      this.dispatchEvent(timeEvent); 
		     this.removeEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			 this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			 this.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);	
		     if(stage){
		     	stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
		     }
			
		}
		private function mouseDown(e:MouseEvent):void{
			this.ismouseDown=true;
			 mouseMove=true;
			 this.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			 this.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			 this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			 if(stage){
			 	stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			 }
		   
		}
		private function MouseMove(e:MouseEvent):void
		{	
			 	
		     ratio=logo.x/this.width*100;
			if(mouseMove){
				 if(logo.x<=this.width&&logo.x>=0){
				 	  logo.x=this.mouseX;				      
				      if(logo.x>this.width){
				         logo.x=this.width;
				      }				     				      
				 }			
			}			 			
		    currentDiff=diff*(logo.x-5)/(this.width-5);
		}
		override public function dispose():void
		{
		    super.dispose();
		   
			this.bulkLoader=null;
			this.logo=null;
			if(line) line.bitmapData.dispose();
			this.line=null;
			this.mouseMove=null;
			this.beginTime=null;
			this.endTime=null;
			this.title=null;
			this.sprite=null;
			this.diff=null;
			this.currentTime=null;
			this.currentDiff=null;
			this.nowSeconds=null;
			this.ratio=null;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
		    this.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);	
		    this.removeEventListener(MouseEvent.MOUSE_MOVE,MouseMove);	
		    this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);		    
		    this.title=null;
		    if(this.logo){
		    	this.logo.bitmapData.dispose();
		    	this.logo=null;
		    }
		    sprite=null;
		}
		 
	}
}