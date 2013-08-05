package com.careland.component
{
	
	import com.careland.YDTouchComponent;
	import com.careland.component.util.Style;
	import com.careland.util.StyleDraw;
	import com.careland.util.UIConfig;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDMapTypeItem extends YDTouchComponent
	{
		
		private var maptypeitem:Bitmap;//点击的样式
		
		private var nx:Number;
		private var ny:Number;
		private var mapName:String;
		private var txtW:Number=207;//290-83;
		private var txtH:Number=56;
		private var center:Bitmap;
		private var centerData:BitmapData;
		private var isAdd:Boolean;
		private var _id:String;
		public function CLDMapTypeItem(c:Bitmap,bit:Bitmap,nx:Number,nx:Number,mapname:String,id:String,isAdd:Boolean=true)
		{
			super();
			this.center=c;
			this.centerData=c.bitmapData;
			maptypeitem=bit;
			this.nx=nx;
			this.ny=ny;
			this.mapName=mapname;
			this._id=id;
			this.isAdd=isAdd;
			init();
		}
		
		private function init():void
		{
			 if(this.isAdd)
			 {  
				 center=new Bitmap(centerData);
				 this.addChild(center);
			 }
			  
			  var bit:Bitmap=new Bitmap(this.maptypeitem.bitmapData.clone());
			  this.addChild(bit);//bit宽度=50
			  bit.y=3;
			  bit.x=30;

		      var txt:TextField=new TextField();
			  txt.selectable=false;
			  txt.multiline=false;
		      txt.wordWrap=false;
			  txt.defaultTextFormat=txtFormart();
			  txt.text=this.mapName;
			  this.addChild(txt);
			  txt.x=(txtW-txt.textWidth)/2+43;
			  txt.y=(txtH-txt.textHeight)/2;
			   
		}
		
		public function get id():Number
		{
			return Number(this._id);
		}
		
		private function txtFormart():TextFormat
		{
			var tf:TextFormat=Style.getTFMapType();
			return tf;
		}
	}
}