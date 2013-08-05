package com.careland.viewer
{
	import __AS3__.vec.Vector;
	
	import com.bit101.components.Component;
	import com.careland.viewer.events.CLDSwfEvent;
	import com.careland.viewer.model.CLDImage;
	import com.careland.viewer.model.DOCData;
	import com.careland.viewer.util.LoaderManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextSnapshot;
	import flash.utils.Dictionary;

	public class CLDDocView extends Component
	{
		public function CLDDocView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,
		  autoLoad:Boolean=false, timeInteval:int=0)
		{
			//super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		private var loadedList:Array=[];
		
		
		private var currentMovie:MovieClip;
		
		public var _scale:Number=1;
		
		private var prePoint:Point=new Point(0,0);
		
		public var loadManage:LoaderManager;
		
		public var content:Component
		
		public var contentMask:Sprite;
		
		private var pointChange:Boolean=false;//坐标变了
	
		private var clipImages:Vector.<CLDImage>=new Vector.<CLDImage>();
		
		private var dicImage:Dictionary=new Dictionary;
		
		public var isinit:Boolean=false;
		
		public var findSprite:Sprite;
		public var  mc:MovieClip;
		private var snap:TextSnapshot;
		private var index:int;
		private var lastIndex:int=0;
		private var event:CLDSwfEvent;
		public function initView():void
		{
			
			mc=new MovieClip();
			mc.visible=false;
			this.addChild(mc);	
			loadManage=new LoaderManager;
			var dataArray:Array=[];
			for(var i:int=0;i<7;i++){				
				var docData:DOCData=new DOCData;
				docData.url="assets/"+(i+1)+".swf";
//				if(i==0){
//					docData.url="assets/Paper1.swf";
//				}
				docData.index=i;
				dataArray.push(docData);
			}
			loadManage.addEventListener("allSwfLoaded",allSwfLoaded);
			loadManage.loadSwfs(dataArray);
		}


		public function reset():void{
			 mc.visible=false;
		  
		}

		
		
		var fontIndex:int=-1;
		var pageIndex:int=1;

		
		var prevYsave:int=0;
		//全选

		public function search(text:String):void{	
			
			out:for(var i:int=1;i<=loadManage.loaded.length;i++){				
			    mc=loadManage.loaded[i-1].mc;
			  	var index:int=0;  
			  	this.content.addChild(mc);
			    while(pageIndex<mc.framesLoaded){
			    	
			    	pageIndex++;
			    	var frame:int=pageIndex%pageofsingle;//page索引		
			    	
					if(frame==0&&pageIndex!=0){
						
						frame=pageofsingle;
					}	
					mc.gotoAndStop(frame);	
			    	
			    	
			    	mc.scaleX=this.scale;
			    
			    	snap=mc.textSnapshot;
			    	fontIndex=snap.findText((fontIndex==-1?0:fontIndex),text,false);
			    	if(fontIndex>0)
			    	{
			    		var sm:ShapeMarker=new ShapeMarker();
			    		sm.PageIndex=i*pageIndex;
			    		sm.scaleX=sm.scaleY=this.scale;
			    		this.clipImages[i*pageIndex-1].addChild(sm);
			    		var fonttextRun:Array=snap.getTextRunInfo(fontIndex,fontIndex+text.length-1);
						if(fonttextRun.length>0){
							prevYsave = fonttextRun[0].matrix_ty;
							drawCurrentSelection(0x0095f7,sm,fonttextRun,false,0.25);
			    			fontIndex=fontIndex+text.length-1;
			    			this.gotoPage(sm.PageIndex-1);
			    			this.pageIndex=sm.PageIndex-1;
			    			break out;
						}
			    		
			    	}
			    	
			    }
			    this.content.removeChild(mc);
			    
			}

		}
		public function set data(data:Array):void
		{
			loadManage.loadSwfs(data);
		}
		public function set scale(value:Number):void
		{
			if(value!=this._scale){
				this._scale=value;
			}
		}
		public function get scale():Number
		{
			return this._scale;
		}
		
		public function get swfwidth():Number
		{
			return (this.loadManage.width==0?800:this.loadManage.width)*this.scale;
		}
		public function get swfheight():Number
		{
//			return this.loadManage.height;
			return (this.loadManage.height==0?800:this.loadManage.height)*this.scale;
		}
		
		
		override protected function addChildren():void
		{
			content=new Component;
			contentMask=new Sprite;
			this.addChild(content);
			this.addChild(contentMask);
			content.mask=contentMask;
			this.initEvent();
			loadManage=new LoaderManager;
			loadManage.addEventListener("allSwfLoaded",allSwfLoaded);			
			findSprite=new Sprite;
			this.addChild(findSprite);
		}
		override public function draw():void
		{
			super.draw();		
			if(this.pointChange)
			{
				drawPage();
				this.pointChange=false;
			}
			if(this.content){
				this.content.x=(this.width-this.content.width)/2;	
							
			}
			if(contentMask)
			{
				var g:Graphics=contentMask.graphics;
				g.beginFill(0x000000,0);
				g.drawRect(0,0,this.width,this.height);
				g.endFill();
			}
		}
		
		public function dispose():void
		{
			if(this.loadManage){
				this.loadManage.dispose();
				loadManage=null;
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			
			if(content){
				while(content.numChildren>0){
					var dis:DisplayObject=this.content.removeChildAt(0);
					if(dis is CLDImage){
						Object(dis).dispose();
					}
				}
			}
			content=null;
			contentMask=null;
			this.currentMovie=null;
			clipImages=null;
			prePoint=null;
		}
		
		private function getMcByIndex(index:int):void
		{
			
		}
		
		public function get totalPage():int
		{
			return this.loadManage.totalPage;
		}
		
		public function gotoPage(pageNo:int):void
		{
			if(pageNo<=1){
				pageNo=0;
			}
			if(pageNo>this.loadManage.totalPage)
			{
				pageNo=this.loadManage.totalPage;
			}
			this.content.y=-(pageNo*this.swfheight);
			this.updatePoint();
		}
		
		private function allSwfLoaded(e:Event):void
		{
			e.target.removeEventListener("allSwfLoaded",allSwfLoaded);
			var target:LoaderManager=e.target as LoaderManager;
			reflushContent();
			isinit=true;
			trace(target.totalPage);
			
			this.dispatchEvent(new Event("clddocinit"));
			
		}
		private function deleteDicImg():void
		{
			for(var key in this.dicImage){
				
				var img:CLDImage=dicImage[key];
				img.disposeBit();
			}
		}
		
		public function reflushContent():void
		{
			var oldContentY:Number=this.content.y;
			//content.y=0;
			
			while(content.numChildren>0){
				var ct:DisplayObject=content.removeChildAt(0);
				if(ct is CLDImage)
				{
					(Object(ct)).dispose();
				}
			}

			for(var key in this.dicImage){
				delete dicImage[key];
			}						

			
			deleteDicImg();
			

			this.clipImages.splice(0,clipImages.length);
			var ypos:int=0;
			var num:Number=0;
			for(var i:int=0;i<this.loadManage.loadedLength;i++)
			{
				//var mc:MovieClip=target.loaded[i].mc;
				var length:int=loadManage.loaded[i].totalPage;				
				var clip:Boolean=false;
				for(var j:int=0;j<length;j++)
				{
					//mc.gotoAndStop(j+1);

					var img:CLDImage=this.createPage(j,this.swfwidth,this.swfheight,ypos);
					ypos=(j+1)*this.swfheight+num; 

					this.clipImages.push(img);
					
				}
				num+=length*this.swfheight;
			}

			content.width=this.swfwidth;

			content.height=ypos;

			 
			//content.x=Math.abs((this.width-content.width)/2);

			content.y=oldContentY*this.scale;
			content.x=(this.width-content.width)/2;
			this.updatePoint();
			
		}
		//
		protected function updateScroll():void
		{
			
		}
		
		public function updatePoint():void
		{
			this.pointChange=true;
			this.invalidate();
		}
		
		private function createPage(index:int,w:Number,h:Number,ypos:int,
			clip:Boolean=false):CLDImage
		{
			var cldimage:CLDImage=new CLDImage;
			
			cldimage.width=w;
			cldimage.height=h;
			cldimage.index=index;
			cldimage.y=ypos;
			cldimage.x=0;
			this.content.addChild(cldimage);
			return cldimage;

		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
		}
		protected function downHandler(e:MouseEvent):void
		{
			this.prePoint=new Point(e.stageX,e.stageY);
			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,upHandler);	
		}
		protected function moveHandler(e:MouseEvent):void
		{
			var newpoint:Point=new Point(e.stageX,e.stageY);			
			var subPoint:Point=newpoint.subtract(this.prePoint);			
			this.content.y+=subPoint.y;
			if(this.content.y>0){
				this.content.y=0;
			}			
			prePoint=newpoint;
	 	}
		protected function upHandler(e:MouseEvent):void
		{
			if(this.content.y<-content.height-this.swfheight)
			{
				content.y=content.height-this.swfheight;
			}
			var pageNum:int;
			 
			if(Math.abs(content.y)%this.swfheight==0){
				pageNum=Math.abs(content.y)/this.swfheight
			}else{
			   pageNum=Math.abs(content.y)/this.swfheight+1;
			}
			 if(pageNum==0){
			 	pageNum=1;
			 }
			 if(pageNum>=this.totalPage){
			 	pageNum=this.totalPage;
			 }
			 event=new CLDSwfEvent(CLDSwfEvent.getPageIndex);
			 event.currentPage=pageNum;
			 this.dispatchEvent(event);
			this.prePoint=new Point(e.stageX,e.stageY);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			this.updatePoint();
		}
		

//		}
		
		private function drawPage():void
		{
			if(!this.content)return;
			
			deleteDicImg();
			
			var contentY:Number=content.y;
			
			var numPage:int=Math.abs(Math.floor(contentY/this.swfheight));
			
			var nextPage:int=numPage+1;
			
			var prePage:int=numPage-1; 
			
			drawPageByNo(numPage);
			drawPageByNo(nextPage);
			drawPageByNo(prePage);
			
			//content.y-=this.prevYsave;
			
			

			
		}
		public static var pageofsingle:int=30
		private function drawPageByNo(pageNo:int):void
		{
			if(pageNo>0&&pageNo<=this.loadManage.totalPage)
			{
				var swfIndex:int=Math.floor((pageNo)/pageofsingle);//swf索引
				
				var frame:int=pageNo%pageofsingle;//page索引				
				if(frame==0&&pageNo!=0){
					swfIndex--;
					frame=pageofsingle;
				}				
				var mc:MovieClip=this.loadManage.loaded[swfIndex].mc;				
				mc.gotoAndStop(frame);				
						 	 
 					var bit:BitmapData=new BitmapData(this.swfwidth,this.swfheight,true,0xfffeee);
					    bit.draw(mc,new Matrix(this.scale,0,0,this.scale));
					 this.clipImages[pageNo-1].bitdata=bit;
					 this.clipImages[pageNo-1].x=0;
												
				this.dicImage[pageNo]=clipImages[pageNo-1];
				
				
			}
			
		}
		public function drawCurrentSelection(color:uint, shape:Sprite, tri:Array, strikeout:Boolean=false, alpha:Number=0.3):void{
			var ly:Number=-1;
			var li:int;var lx:int;
			var miny:int=-1;
			var minx:int=-1;
			var maxy:int=-1;
			var maxx:int=-1;
			snap.setSelected(1,snap.charCount,false);
			
			shape.graphics.beginFill(color,(strikeout)?0.5:alpha);
			var rect_commands:Vector.<int>;
			rect_commands = new Vector.<int>((tri.length) * 5, true);
			
			var rect_coords:Vector.<Number>;
			rect_coords = new Vector.<Number>((tri.length) * 10, true);
			
			for(var i:int=0;i<tri.length-1;i++){
				if(miny==-1||miny>tri[i].corner1y){miny=tri[i].corner1y;}
				if(minx==-1||minx>tri[li].corner3x){minx=tri[li].corner3x;}
				if(maxy==-1||maxy<tri[i].corner3y){maxy=tri[i].corner3y;}
				if(maxx==-1||maxx<tri[i].corner1x){maxx=tri[i].corner1x;}
				

				if(ly==-1){ly=tri[i].corner1y;li=0;}

				
				rect_commands[i*5] = 1;
				rect_commands[i*5 + 1] = 2;
				rect_commands[i*5 + 2] = 2;
				rect_commands[i*5 + 3] = 2;
				rect_commands[i*5 + 4] = 2;
				
				rect_coords[i*10] = tri[li].corner3x;
				rect_coords[i*10 + 1] = tri[i].corner1y + (strikeout?(tri[i].corner3y-tri[i].corner1y)/3:0);
				
				rect_coords[i*10 + 5] = rect_coords[i*10 + 1] + (tri[i].corner3y-tri[i].corner1y) / ((strikeout)?5:1); //h
				
				if(i!=tri.length-2 && tri[i].corner1x>tri[li].corner3x)
					rect_coords[i*10 + 2] = rect_coords[i * 10] + tri[i].corner1x-tri[li].corner3x;
				else if(i==tri.length-2 && tri[i+1].corner1x > tri[li].corner3x)
					rect_coords[i*10 + 2] = rect_coords[i * 10] + tri[i+1].corner1x-tri[li].corner3x;
				else if(i==tri.length-2 && tri[i+1].corner1x < tri[li].corner3x){
					rect_coords[i*10 + 2] = rect_coords[i * 10] + tri[li].corner1x-tri[li].corner3x;
					rect_coords[i*10] = tri[li].corner3x;	
					
					/* add an extra struct for the last char*/
					rect_commands[(i+1)*5] = 1;
					rect_commands[(i+1)*5 + 1] = 2;
					rect_commands[(i+1)*5 + 2] = 2;
					rect_commands[(i+1)*5 + 3] = 2;
					rect_commands[(i+1)*5 + 4] = 2;
					
					rect_coords[(i+1)*10] = tri[(i+1)].corner3x;
					rect_coords[(i+1)*10 + 1] = tri[(i+1)].corner1y;
					rect_coords[(i+1)*10 + 2] = rect_coords[(i+1) * 10] + tri[i+1].corner1x-tri[i+1].corner3x;
					rect_coords[(i+1)*10 + 3] = rect_coords[(i+1)*10 + 1];
					rect_coords[(i+1)*10 + 4] = rect_coords[(i+1)*10 + 2];
					rect_coords[(i+1)*10 + 5] = rect_coords[(i+1)*10 + 1] + tri[i+1].corner3y-tri[i+1].corner1y;
					rect_coords[(i+1)*10 + 6] = rect_coords[(i+1)*10];
					rect_coords[(i+1)*10 + 7] = rect_coords[(i+1)*10 + 5];
					rect_coords[(i+1)*10 + 8] = rect_coords[(i+1)*10];
					rect_coords[(i+1)*10 + 9] = rect_coords[(i+1)*10 + 1]; 
				}
				
				rect_coords[i*10 + 3] = rect_coords[i*10 + 1]; 
				rect_coords[i*10 + 4] = rect_coords[i*10 + 2];
				rect_coords[i*10 + 6] = rect_coords[i*10];
				rect_coords[i*10 + 7] = rect_coords[i*10 + 5];
				rect_coords[i*10 + 8] = rect_coords[i*10];
				rect_coords[i*10 + 9] = rect_coords[i*10 + 1];
				
				ly=tri[i+1].corner1y;lx=tri[i+1].corner3x;li=i+1;
			}
			shape.graphics.drawPath(rect_commands,rect_coords,"nonZero");
			shape.graphics.endFill();
			
			// draw a transparent box covering the whole area to increase hitTest accuracy on mousedown
			shape.graphics.beginFill(0xffffff,0);
			shape.graphics.drawRect(minx,miny,maxx-minx,maxy-miny);
			shape.graphics.endFill();
		}
		
		

		
		
		
		
	}
}