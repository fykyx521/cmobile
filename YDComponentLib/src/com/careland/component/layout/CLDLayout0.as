package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	import com.careland.component.CLDWindowAdapter;
	import com.careland.event.CLDEvent;
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class CLDLayout0 extends CLDLayoutUI
	{
		
		private var cldw:CLDWindowAdapter;
		public function CLDLayout0(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval,false);
			
			this.config.addEventListener(CLDEvent.ALERTWIN,alertWin);
		}
		override public function dispose():void
		{
			this.config.removeEventListener(CLDEvent.ALERTWIN,alertWin);
			super.dispose();
		}
		
		private function alertWin(e:CLDEvent):void
		{
			 if(e.mouseClickData=="")
			 {
			 	return ;
			 }
			//this.winBoxData();
			   var winIDParams:Array=e.mouseClickData.split(",");
				if(winIDParams.length<5){
					return;
				}
				var winPoint:String="";
				if(winIDParams.length>6){
					winPoint=winIDParams[5];
				}
				
				this.buildAlert(winIDParams[2],winIDParams[3],winIDParams[0],winIDParams[1],
				false,false,null,winIDParams[4],winPoint);
				
		}
		//winState 窗体状态 1 可拖动  2可拖动 
		//winPoint 窗体坐标
		private function buildAlert(w:Number,h:Number,winID:String,params:String="",content:Boolean=false,
			isBack:Boolean=false,backWin:CLDWindowAdapter=null,winState:String="",winPoint:String=""):void
		{
			
			if(cldw)
			{
				try{
					cldw.removeEventListener(CLDEvent.WINUP,winUp);
					cldw.dispose();
					this.removeChild(cldw);//因为winUp方法 会导致窗口销毁 removeChild 会报错
					cldw=null;
				}catch(e:Error){
					
				}
				
			}
			cldw=new CLDWindowAdapter();
			//cldw.constom=!isBack;
			cldw.alpha=.5;
			cldw.alertWin=true;
			//cldw.setSize(w,h);
			if(isBack){
				cldw.setSize(this.width,this.height);
			}else{
				cldw.setSize(w,h);
			}
			var vconstom:Boolean=true;
			if(winState!=""){
				switch(winState){
					case "1":vconstom=true;break;
					case "2":vconstom=false;break;
				}
			}
			cldw.constom=vconstom;
			cldw.contentIDParam=params;
//			cldw.isBack=isBack;
			if(!vconstom)
			{
				cldw.showClose();
			}
		
			
			cldw.windowID=winID;//打开新窗口的ID
			cldw.contentTxt=content;//是否直接显示指定的内容
			cldw.autoLoad=true;
			this.addChild(cldw);
			if(isBack&&this.numChildren>1){
				this.setChildIndex(cldw,1);
			}
			
			cldw.addEventListener(CLDEvent.WINUP,winUp);
			if(winPoint!=""){
				var winPArr:Array=winPoint.split(":");
				var winp:Point=new Point(winPArr[0],winPArr[1]);
				cldw.x=winp.x;
				cldw.y=winp.y;
			}else{
				cldw.x=(this.width-cldw.width)/2;
				cldw.y=(this.height-cldw.height)/2
			}
			Tweener.addTween(cldw,{alpha:1,time:.5});
		}
		
		
		
		override protected function layout():void
		{
//			if(data){
//				var cld:CLDWindow=new CLDWindow;
//				this.addChild(cld);
//				cld.setSize(this.width,this.height);
//			}
			for(var i:int=0;i<this.numChildren;i++)
			{
				var dis:DisplayObject=this.getChildAt(i);
				
				if(dis!=cldw){
					dis.width=width;
					dis.height=height;
				}
				//Tweener.addTween(dis,{width:width,height:height,time:0.46});
				
			}
			
		}
		
	}
}