package com.identity.map
{
	import com.careland.component.CLDBaseComponent;
	import com.identity.CldPicture;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.ui.*;
	
	import org.bytearray.gif.player.GIFPlayer;

	public class CLDPoint extends CLDBaseComponent
	{
		private var imgPath:String;
		private var loader:Loader=new Loader();
		public var _x:Number;
		public var _y:Number;
		public var mouseClikcData:String;
		public var parm:String;
		public var mouseOverData:String;

		public function CLDPoint(url:String)
		{
			this.imgPath=url;
			loadPoint(); 
		}
	    override public function dispose():void
		{
			super.dispose();
			this.mouseOverData=null;
			this._y=null;
			this._x=null;
			this.loader=null;
			this.imgPath=null;
			
		}
		/***
		* 添加子类
		*
		***/
		override protected function addChildren():void
		{
		}

		override public function draw():void
		{

		}

		/**
		 * 加载点logo
		 */
		private function loadPoint():void
		{
			if(imgPath.indexOf(".gif",0)!=-1){
				var gif:GIFPlayer=new GIFPlayer();
			    var request:URLRequest=new URLRequest(imgPath);
			    gif.load(request);
			    this.addChild(gif);
			}else{
			   var pic:CldPicture=new CldPicture();
			       pic.imgUrl= imgPath;
			       pic.loadImg(pic.imgUrl);
			       this.addChild(pic);
			  	   pic.addEventListener("rightClick",rightclick,true);
			}
			
		}
		private function rightclick(e:Event):void
		{
			e.stopPropagation();
			this.dispatchEvent(e);
		}
	}
}