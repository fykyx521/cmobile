package com.identity.QQWin
{
    import caurina.transitions.Tweener;
    
    import com.careland.component.CLDBaseComponent;
    import com.careland.event.ImgEvent;
    import com.touchlib.TUIOEvent;
    
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
	public class CLDList extends CLDBaseComponent
	{
		public function CLDList(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{	 
		}
		private var hasIMG:Boolean=false;
		private var xml:XML;
		public var  rowHeight:int=50;
		public var tabID:int=0;
		public var  factHeight:int=0;
    	private var touchUI:Sprite;	 
    	
    	private var listItem:Array=[];
        /***
		 * 
		 * 覆盖父类添加子例方法
		 */ 
	     override protected function addChildren():void
	    { 	  	    				
			touchUI=new Sprite;
			this.addChild(touchUI);
		    touchUI.visible=false
			this.addEventListener(Event.RESIZE,resize);	
	    }
	   private function resize(e:Event):void{
	    	if(this.data){
	    	   build();
	    	}    	
	    }
		public function getBitmap(key:*):Bitmap
		{
			
	      return this.config.getBitmap(key);
		}
	     //给该组件设置动态数据
		override public function set data(value:*):void
		{
			super.data=value;
			 build();
			this.dispatchEvent(new Event("ComponentInit"));
		}
		override public function draw():void
		{
			if(data&&this.dataChange){
				if(this.touchUI){
					var g:Graphics=this.touchUI.graphics;
					g.clear();
					g.lineStyle(1,0xccaabb,.5);
					g.beginFill(0xffaabb,.5);
			
					g.beginGradientFill(GradientType.LINEAR,[0xffaabb,0x112233],[.5,.2],[128,255]);
					g.drawRoundRect(0,0,this.width,this.rowHeight,10,10);
					g.endFill();
					
				}
				this.dataChange=false;
			}
		}
		
		public function initTouchUI():void
		{
			var g:Graphics=this.touchUI.graphics;
				g.clear();
				g.lineStyle(1,0xccaabb,.5);
				g.beginFill(0xffaabb,.5);			
				g.beginGradientFill(GradientType.LINEAR,[0xffaabb,0x112233],[.5,.2],[128,255]);
				g.drawRoundRect(0,0,this.width,this.rowHeight,10,10);
				g.endFill();
		}
		

		override public function get height():Number
		{
			return this.factHeight;
		}
  
		 /**
		 * 加载数据完成
		 */ 
		 private function build():void{
		 		 if(listItem&&this.listItem.length>0){
		 		 	for each(var row:CLDListItem in listItem)
		 		 	{
		 		 		row.removeEventListener(MouseEvent.CLICK,itemClick);
		 		 		row.dispose(); 
		 		 		try{
		 		 			this.removeChild(row);
		 		 		}catch(e:Error){
		 		 			
		 		 		}
		 		 	}
		 		 	listItem.splice(0,listItem.length);
		 		 //	throw new Error;
		 		 }
		 	  	  xml=XML(this.data);
		    	  var _y:int=0;	
		    	  this.factHeight=xml.data.length()*this.rowHeight;		    	  
		    	  for(var i:int=0;i<xml.data.length();i++){
		    	  	      var row:CLDListItem=new CLDListItem();
		    	  	      row.imgPath=xml.data[i].@图片路径;
		    	  	      row.content=xml.data[i].@content;
		    	  	      row.contentID=xml.data[i].@内容ID;
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
		    	  	      row.setSize(this.width,rowHeight);
		    	  	      row.autoLoad=true;		    	  	     
		    	  	      //row.addEventListener(TUIOEvent.TUIO_DOWN,clickHandler);
		    	  	      row.addEventListener(MouseEvent.CLICK,itemClick);		    	  	   
		    	  	      row.y=_y;
		    	  	      _y+=rowHeight;
		    	  	      listItem.push(row);
		    	  	      this.addChild(row);		    	  	      
		    	  }		  
		    	  this.initTouchUI(); 
		    	  this.disposeXML(xml);
		 }
		
		 
		 private function clickHandler(e:TUIOEvent):void
		 {
		 	var item:CLDListItem=e.currentTarget as CLDListItem;
		 	e.stopPropagation();
		 	if(item){
		 		 var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
		         imgevent.id=item.id;
		         imgevent.object=item.object; 
		         imgevent.stageX=e.stageX;
		         imgevent.stageY=e.stageY;		         
		    	// imgevent.data=item.object;
				 this.dispatchEvent(imgevent); 			 
				 this.touchUI.visible=true;
				// var lp:Point=this.globalToLocal(new Point(e.stageX,e.stageY));
				 Tweener.removeTweens(this.touchUI);
				 Tweener.addTween(this.touchUI,{x:item.x,y:item.y,time:.3});
		 	}		   	 		  
		 }
		 /**
		 * 标签点击事件
		 */ 
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
		    	// imgevent.data=item.object;
				 this.dispatchEvent(imgevent); 
		 	}		   	 		     		      	      
		 }	
		  override public function dispose():void
		 {
		 	 this.removeEventListener(Event.RESIZE,this.resize);
		 	
		 	 if(listItem&&this.listItem.length>0){
		 		 	for each(var row:CLDListItem in listItem)
		 		 	{
		 		 		row.removeEventListener(MouseEvent.CLICK,itemClick);
		 		 	}
		 		 //	throw new Error;
		 	 }
		 	 super.dispose();
		 	 this.graphics.clear();		 	 
		 	 this.touchUI=null;
		 } 
	}
}