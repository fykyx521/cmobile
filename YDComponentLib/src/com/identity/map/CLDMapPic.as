package com.identity.map
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.ImgEvent;
	import com.identity.CLDFlash;
	import com.identity.CldPicture;
	import com.identity.Picture;
	import com.identity.radar.CLDRound;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	public class CLDMapPic extends CLDBaseComponent
	{
		private var imgPath:String="";
		private var bground:CLDFlash;
		private var sprite:Sprite;
		private var bulkLoader:BulkLoader;
		private var round:CLDRound;
		private var range:Number=0;
		private var angle:Number=2;
		private var Xsan:Number;
		private var Ysan:Number;
		 	override public function dispose():void
		{
			super.dispose();
			
			this.imgPath=null;
			this.bground=null;
			this.sprite=null;
			this.bulkLoader=null;
			this.round=null;
			this.range=null;
			this.angle=null;
			this.Xsan=null;
			this.Ysan=null;
		}
		public function CLDMapPic(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			setBground();
		}
		/**
		 * 设置背景
		 */ 
		private function setBground():void{
		   	  // bground=new CLDFlash();
		   	   var pic:CldPicture=new CldPicture();
	//	   		pic.autoSize=false;
		   		pic.loadImg("assets/全景视图背景图.jpg");
		   	    this.addChild(pic);
		      // bground.initLoad("CLDView.swf");
		      // this.addChild(bground);		      
		}
//		 	
       
	  
		/**
		* 标注点闪动，方向标旋转
		*/
		private function update(e:Event):void
		{		
			if (round != null)
			{
			  this.round.rotation=range;				 
				range+=angle;
				if (range >= 360)
				{
					range=0;
				}
			}
		}
		/**
		* 画方向标
		*/
		private function point():void
		{
			round=new CLDRound();
			round.width=this.height;
			round.height=this.height;
			round.x=this.width / 2;
			round.y=this.height / 2;
			this.addChild(round);
		}
		private function build():void{
		      Xsan=1920/1024;
			var xml:XML=XML(this.data); 
			 for(var i:int=0;i<xml.table[1].data.length();i++){
			 	 var path:String=xml.table[1].data[i].@标注图片;	
			 	 var width:Number=xml.table[1].data[i].@宽度;
		         var height:Number=xml.table[1].data[i].@高度;
		         var poi:String=xml.table[1].data[i].@坐标; 	
		         var mouseOverData=	xml.table[1].data[i].@鼠标经过数据; 
		         var po:Point=new Point(poi.split(",")[0],poi.split(",")[1]);  
			 	 var  point:CLDFlash=new CLDFlash();
		              point.initLoad(path);
		             // point.setSize(width,height);			 	
			 	      point.id=xml.table[1].data[i].@点击时窗口id; 			 	  			
			 	      point.x=po.x
			 	      point.y=po.y;	
			 	      point.mouseOverData=mouseOverData;
			 	      point.addEventListener(MouseEvent.CLICK,mouse_click);	 
			 	      point.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);		
			 	      point.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);	 	      	    
			 	    this.addChild(point);
			 }		
			 var id:int=xml.table[0].data[0].@颜色值
			var colorList:Array=[0x00CCCC,0xCC0099,0xFFFF33,0x0000FF]
			for(var i:int=0;i<4;i++){
				 if(id==i){
 				 //	var point:CLDMapPicPoint=new  CLDMapPicPoint(1,colorList[i]);
 			 	  //  point.setSize(40,50);
  			 	 //   point.x=this.width-200+i*40;
 				 //	    this.addChild(point);
				 }else{
				    this.graphics.beginFill(colorList[i],1);
				 	graphics.drawEllipse(i*40+this.width-200,0,40,50);
				 	graphics.endFill();
				 }
			} 		 
		}
		private function mouse_click(e:Event):void{
		  var point:Object=e.currentTarget as CLDFlash;
		  var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
		         imgevent.id=point.mouseClickData;   	
				 this.dispatchEvent(imgevent); 
		  	     this.dispatchEvent(new MouseEvent("pointClick"));
		}	
		private  function mouse_over(e:Event):void{
		   var entity:CLDFlash=e.currentTarget as CLDFlash;
 			sprite=new Sprite();
			sprite.alpha=.9;
			var overText:TextField=new TextField();
			overText.embedFonts=true;
			overText.text=entity.mouseOverData.split("<br/>").join("\n");
			overText.x=entity.x+entity.width + 10;
			overText.y=entity.y+entity.height + 10;		 
			overText.setTextFormat(Style.getTF());
			overText.width=400;
			overText.height=200;
			sprite.addChild(overText);
			sprite.graphics.beginFill(0xFFFFFF, 1);
			sprite.graphics.drawRect(overText.x, overText.y, overText.width, overText.height);
			sprite.graphics.endFill();
			this.addChildAt(sprite, this.numChildren - 1);
		}	
		private function mouse_out(e:Event):void
		{
			if(this.contains(sprite)){
				this.removeChild(sprite);
			}
		} 
		override public function draw():void
		{
			if(bground){
				//bground.setSize(this.width,this.height);
			}
		}
		 
	}
}