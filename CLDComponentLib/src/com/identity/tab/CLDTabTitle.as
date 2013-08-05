package com.identity.tab
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDTextField;
	import com.careland.component.util.Style;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.ui.*;

	public class CLDTabTitle extends CLDBaseComponent
	{

		public var tilte:String;
		public var dataLength:int; //0代表单张图 1 代表图片组
		public var dataIndex:int;
		public var align:String="center";
		private var bulkLoader:BulkLoader;
		private var left:Bitmap;
		private var center:Bitmap;
		private var right:Bitmap;
		private var lineBitmap:Bitmap;
		private var line:Bitmap;
		private var cloumValue:TextField=new CLDTextField();
		public var textWidth:Number;

		public function CLDTabTitle(_dataIndex:int, _dataLength:int, _tilte:String)
		{
			this.dataLength=_dataLength;
			this.tilte=_tilte;
			this.dataIndex=_dataIndex;
			build();
		}
        
        private function build():void{
            setIMG();
			setTitle();
        }
		override public function dispose():void
		{
			super.dispose();
			this.align=null;
			this.dataIndex=null;
			this.dataLength=null;
			this.bulkLoader=null;
			this.tilte=null;

			this.left=null;
			this.center=null;
			this.right=null;
			this.lineBitmap=null;
			this.line=null;
			this.textWidth=null;
			this.cloumValue=null;
			this.removeEventListener(Event.RESIZE,resize);
		}

		override protected function addChildren():void
		{

			bulkLoader=BulkLoader.getLoader("main");
			if (!bulkLoader)
			{
				bulkLoader=new BulkLoader("main");
			}
			this.addEventListener(Event.RESIZE, resize);
		}

		private function resize(e:Event):void
		{

		}

		override public function draw():void
		{
			if (this.isDispose)
			{
				return;
			}
			reload();
		}

		public function reload():void
		{
			if (dataLength == 2)
			{
				left.width=11;
				left.height=this.height;
				center.x=11;
				center.width=this.width - 22;
				center.height=this.height;
				right.x=this.width - 11;
				right.width=11;
				right.height=this.height;
			}
			else
			{
				if (this.dataIndex == 0)
				{
					left.width=11;
					left.height=this.height;
					center.x=11;
					center.height=this.height;
					center.width=this.width - 12;
					right.visible=false;
				}
				if (this.dataIndex > 0 && this.dataIndex < this.dataLength - 2)
				{
					center.width=this.width - 1;
					center.height=this.height;
					left.visible=false;
					right.visible=false;
				}
				if (this.dataIndex == this.dataLength - 2)
				{
					center.width=this.width - 11;
					center.x=0;
					center.height=this.height;
					right.width=11;
					right.height=this.height;
					right.x=this.width - 12;
					left.visible=false;
				}
				if (dataIndex != dataLength - 2)
				{
					lineBitmap.x=this.width - 2;
					lineBitmap.width=2;
					lineBitmap.height=this.height;
				}

			}

			cloumValue.y=(this.height - cloumValue.textHeight) / 2-5;
			cloumValue.x=(this.width - cloumValue.textWidth-20) / 2;

		}

		public function getBitmap(key:*):Bitmap
		{
			return this.bulkLoader.getBitmap(key, false);
		}

		/**
		* 激活标签
		*/
		public function setUsed():void
		{

			this.left.bitmapData=getBitmap("leftbule").bitmapData //.clone();				 
			this.center.bitmapData=getBitmap("centerbule1").bitmapData //.clone();			 
			this.right.bitmapData=getBitmap("rightbule").bitmapData //.clone();
			this.cloumValue.setTextFormat(Style.getWF());
			reload();
		}

		/**
		* 设置不激活
		*/
		public function setNoUsed():void
		{
			this.left.bitmapData=getBitmap("leftdark1").bitmapData //.clone();
			this.center.bitmapData=getBitmap("center1").bitmapData //.clone();
			this.right.bitmapData=getBitmap("darkright1").bitmapData //.clone();
			this.cloumValue.setTextFormat(Style.getWF());
			 reload();
		}

		/**
		* 画标签
		*/
		private function setIMG():void
		{
			left=new Bitmap();
			this.addChild(left);
			center=new Bitmap();
			this.addChild(center);
			right=new Bitmap();
			this.addChild(right);
			if (this.dataLength != 2)
			{
				if (dataIndex != dataLength - 2)
				{
					lineBitmap=new Bitmap();
					lineBitmap.bitmapData=getBitmap("tabLine").bitmapData //.clone();					
					lineBitmap.width=1;
					this.addChild(lineBitmap);
				}
			}

		}

		/**
		* 设置标题
		*/
		private function setTitle():void
		{
			cloumValue=new CLDTextField();

			//	cloumValue.wordWrap=true;

			cloumValue.embedFonts=true;
			cloumValue.selectable=false;
			cloumValue.text=this.tilte;
			cloumValue.x=-3;
			cloumValue.y=-5;
			cloumValue.setTextFormat(Style.getTab());
			cloumValue.width=cloumValue.textWidth + 20;
			this.textWidth=cloumValue.textWidth + 20;
			this.width=cloumValue.textWidth + 20;
			this.addChild(cloumValue);
		}
	}
}