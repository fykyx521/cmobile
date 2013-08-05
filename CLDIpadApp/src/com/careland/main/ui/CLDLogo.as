package com.careland.main.ui
{
	import caurina.transitions.Tweener;
	
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.remote.CLDRemoteEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CLDLogo extends CLDBaseUI
	{
		
		[Embed(source="../assets/logo.png")]
		private var logo:Class;
		
		[Embed(source="../assets/logoTxt.png")]
		private var logoTxt:Class;
		
		[Embed(source="../assets/logoinfo.png")]
		private var logoinfo:Class;
		
		
		private var logoBit:Bitmap;
		private var prePoint:Point;
		private var isHide:Boolean=false;
		public function CLDLogo()
		{
			super();
		}
		override protected function addChildren():void
		{
			 logoBit=new logo as Bitmap;
			 this.addChild(logoBit);
			 this.addChild(new logoTxt as Bitmap);
			 this.addChild(new logoinfo as Bitmap);
			 this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			 
		}
		private function downHandler(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			prePoint=new Point(e.localX,e.localY);
		}
		private function moveHandler(e:MouseEvent):void
		{
			 var np:Point=new Point(e.localX,e.localY);
			 var dis:Number=Point.distance(prePoint,np);
			
			 if(Math.abs(dis)>500)
			 {
				this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				this.hide();
			}
		}
		
		public function hide():void
		{
			 this.command(CMD.LOGOHIDE);
			 isHide=true;
			 Tweener.addTween(this,{y:-111,time:.5});
			 if(stage)
			 {
				 stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
			 }
		}
		
		public function show():void
		{
			this.command(CMD.LOGOSHOW);
			isHide=false;
			Tweener.addTween(this,{y:0,time:.5});
		}
		private var stagePre:Point;//全局坐标位置
		private var isTopPoint:Boolean=false;
		private function stageDownHandler(e:MouseEvent):void
		{
			stagePre=new Point(this.mouseX,this.mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
			isTopPoint=false;
			if(this.mouseY<180)
			{
				isTopPoint=true;
			}
		}
		private function stageMoveHandler(e:MouseEvent):void
		{
			if(this.isTopPoint)
			{
				 if((this.mouseY-stagePre.y)>150)
				 {
					 isTopPoint=false;
					 this.show();
					 stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
					 stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMoveHandler);
					 stage.removeEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
				 }
			}
			
		}
		private function stageUpHandler(e:MouseEvent):void
		{
			isTopPoint=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
		}
	
		
		override public function draw():void
		{
			 if(logoBit)
			 {
				 logoBit.width=this.width;
			 }
		}
	}
}