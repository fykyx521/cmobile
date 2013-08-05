package com.careland.viewer
{
	import com.bit101.components.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import __AS3__.vec.Vector;
	
	import com.bit101.components.Component;
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
	public class CLDDOCBASE extends Component
	{
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
		private var snap:TextSnapshot;
		public function CLDDOCBASE(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		
		private function allSwfLoaded(e:Event):void
		{
			e.target.removeEventListener("allSwfLoaded",allSwfLoaded);
			var target:LoaderManager=e.target as LoaderManager;
			
			
		}
		public function initView():void
		{
			
			
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
			
			loadManage.loadSwfs(dataArray);
		}
		
		override protected function addChildren():void
		{
			content=new Component;
			contentMask=new Sprite;
			this.addChild(content);
			this.addChild(contentMask);
			content.mask=contentMask;
			
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
				
				this.pointChange=false;
			}
			if(this.content){
				this.content.x=(this.width-this.content.width)/2
			}
			if(contentMask)
			{
				var g:Graphics=contentMask.graphics;
				g.beginFill(0x000000,0);
				g.drawRect(0,0,this.width-50,this.height);
				g.endFill();
			}
		}
	}
}