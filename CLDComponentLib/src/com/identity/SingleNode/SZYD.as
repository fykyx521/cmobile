package  com.identity.SingleNode
{
	import com.identity.SingleNode.*;
	 
	//import com.fairycomic.FMScrollBar.FMScrollBar;
	//import com.warmforestflash.ui.FullScreenScrollBar;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SZYD extends AbstractSZYD
	{
	
		
		protected var lineSprite:Sprite;
		protected var firstSprite:Sprite;
		private  var groupSprite:Sprite;
	//	private var _scrollBar:FullScreenScrollBar;
		private var testNode:SingleNode;//测试用的虚拟Node
		
		//private var loadURL:String="http://localhost/xml/Default.aspx";
		private var loadURL:String="assert/config.xml";
		private var group:GroupNode;
	
		private var params:Object;
		private var linePoint:Array;
		public function SZYD()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onATStage);
		}
		private function onATStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onATStage);
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//解决ie初始化stageWidth 为0;
			if(this.stage.stageWidth==0&&this.stage.stageHeight==0){
				this.stage.addEventListener(Event.RESIZE,onResize);
			}else{
				init();
			}
			
		}
		private function onResize(e:Event):void{
			if(this.stage.stageWidth!=0&&this.stage.stageHeight!=0){
				this.stage.removeEventListener(Event.RESIZE,onResize);
				init();
			}
			 
		}
		public function initParam():void 
		{
			params=this.loaderInfo.parameters; 
			this.loadURL=params["loadURL"]; 
			if(this.loadURL==null||this.loadURL==""){
				//this.loadURL="../FlashServer/FlashTopology.aspx";  
				this.loadURL="assets/config.xml"; 
			}
			
			
		}
		private function init():void
		{   
			initParam();
			this.lineSprite=new Sprite();
			this.firstSprite=new Sprite();
			this.groupSprite=new Sprite();
			this.addChild(firstSprite);
			this.addChild(lineSprite);//用于画线的Sprite
			this.addChild(groupSprite);
			load(this.loadURL,onLoaderXML);
		}
		
		
		
		protected function onLoaderXML(e:Event):void{
			var xml:XML=XML(xmlLoader.data);
			var child:XMLList=xml.node;
			var length:int=child.length();
			var step:int=SingleNode.Sheight+2;//每个Node 间隔20
			var i:int=0;
			var linePoint:Array=[];
			for each(var node:XML in child)
			{
				var singleNode:SingleNode=new SingleNode();
				singleNode.x=140;
				singleNode.y=step*i;
				lineSprite.addChild(singleNode);
				singleNode.id=node.@id;
				singleNode.text=node.@label;
				singleNode.doubleClickEnabled=true;
				singleNode.addEventListener(MouseEvent.DOUBLE_CLICK,onNodeClick);
				
				linePoint.push(step*(i+1)-2-53);
				i++;
				
			}
			
		//	_scrollBar=new FullScreenScrollBar(lineSprite, 0x000000, 0xff4400, 0x05b59a, 0xffffff, 20, 20, 4, true,300,this.stage.stageHeight);
		//	this.addChild(_scrollBar);
			
		//	_scrollBar.adjustSize();//重置滚动条的大小
			
			this.linePoint=linePoint;
		//	_scrollBar.addEventListener("stopScroll",stopScroll);
			drawLine(linePoint);
			
	
		}
		
		private function stopScroll(e:Event):void
		{
			drawLine2(this.linePoint);
		}
		protected function drawLine(linePoint:Array):void
		{
			this.testNode=new SingleNode();
			//this.testNode.x=-30;
			this.testNode.y=this.stage.stageHeight/2-70;//-SingleNode.Sheight/2;//40 是字体部分的
			testNode.showClose();
			firstSprite.addChild(testNode);
			drawLine2(linePoint);
			
		} 
		private function drawLine2(linePoint:Array):void
		{
			var lineY:Number=Math.abs(this.lineSprite.y);
			var source:int=this.testNode.y+70+(-this.lineSprite.y);
			var g:Graphics=this.lineSprite.graphics;
			g.clear();
			g.lineStyle(1,0x000099);
			
			g.moveTo(21,source); 

			for(var i:int=0;i<linePoint.length;i++){
				g.lineTo(161,Number(linePoint[i]));
				g.moveTo(21,source);
			}
			g.endFill();
		}
		//重绘 ,根据判断之连接在显示范围的线
		private function drawLine2_bak(linePoint:Array):void
		{
			 
			//只连接可视范围内的线条
			var lineY:Number=Math.abs(this.lineSprite.y);
			var index:int=lineY/(SingleNode.Sheight+2);
			if(index==0)
				index=0;
			
			var num:int=this.stage.stageHeight/(SingleNode.Sheight+2);
			num=num+2;//多连 两条线
			
			var toIndex:int=index+num;
			if(toIndex>linePoint.length){
				toIndex=linePoint.length;
			}
			var source:int=this.testNode.y+(-this.lineSprite.y);
			var g:Graphics=this.lineSprite.graphics;
			g.clear();
			g.lineStyle(1,0x000099);
			
			g.moveTo(0,source); 

			for(var i:int=index;i<toIndex;i++){
				g.lineTo(230,(SingleNode.Sheight+2)*(i+1)-20-55);
				g.moveTo(0,source);
			}
			g.endFill();
			
		}
		private function onNodeClick(e:MouseEvent):void
		{
			if(e.target is SingleNode){
				var target:SingleNode=e.target as SingleNode;
			    var id:String=target.id;		  
			    if(group){
			    	this.groupSprite.removeChild(group);
			    	group=null;
			    }
			    if(!group){
			    	 group=new GroupNode();
	 		    	 groupSprite.addChild(group);
			    }
			    group.clear();
			    group.visible=true;
				group.loadURL(this.loadURL+"?id="+id+"&name="+target.text);
				group.x=300;
				group.y=target.y+this.lineSprite.y;
			    target.addEventListener(MouseEvent.MOUSE_OUT,onNodeOut);
			}
			
		}
		private function onNodeOut(e:Event):void
		{
			if(e.target is SingleNode){
				 e.target.removeEventListener(MouseEvent.MOUSE_OUT,onNodeOut);
			}
			
		}
		public function showClose():void{
			
		}
		private function onLoadChild(e:Event):void
		{
			
		
		}
		
	}
}
