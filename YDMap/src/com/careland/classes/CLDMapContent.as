package com.careland.classes
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * @private
	 * */
	public class CLDMapContent extends Sprite implements IMapContent
	{
		
		protected var _loadedImg:Array;
		
		protected var preLoaded:Dictionary=new Dictionary;
		
		//对象池
//		protected var objectpool:Vector.<CLDImgItem>=new Vector.<CLDImgItem>();
//		
//		protected var poolsize:int=20;
		
		public function CLDMapContent()
		{
			
			
		}
		
		public function get data():Object
		{
			return null;
		}
		
		public function addContent(img:CLDImgItem, point:Point):void
		{
			
		}
		protected function removePreLoaded():void
		{
			for(var key1:String in preLoaded){
				var img:CLDImgItem=preLoaded[key1];
				img.dispose();
				img.isUser=false;
				this.removeChild(img);
				delete this.preLoaded[key1];
			}
		}
		
		public function addContents(path:String, lp:Point, isRemove:Boolean=false):void
		{
			if(isRemove)
			{
				removePreLoaded();
			}
			
			var tempLoaded:Dictionary=new Dictionary; //临时列表
			for each(var obj:Object in this._loadedImg){
				var url:String=changeURL(path,obj.src);
				
				var imgItem:CLDImgItem=preLoaded[obj.id];
				if(imgItem)
				{
					delete preLoaded[obj.id];
					
					imgItem.x=obj.x+lp.x;
					imgItem.y=obj.y+lp.y;
					tempLoaded[obj.id]=imgItem;
				}else
				{
					addImgItem(obj,url,lp,tempLoaded);
				}
			}
			//删除不在当前加载范围的图片
			this.removePreLoaded();
			
			preLoaded=tempLoaded;
		}
		
		protected function addImgItem(obj:Object,url:String,lp:Point,tempLoaded:Dictionary):void
		{
				var item:CLDImgItem=new CLDImgItem(obj,url);
				item.isUser=true;
				item.load();
				item.x=item.info.x+lp.x;
				item.y=item.info.y+lp.y;
				tempLoaded[item.id]=item;
				this.addChild(item);
			//更新已存在的imgItem的坐标
			//销毁没用到的资源	
			
		}
//		protected function getItem():CLDImgItem
//		{
//			for(var i:int=0;i<this.objectpool.length;i++)
//			{
//				if(!objectpool[i].isUser)
//				{
//					return objectpool[i];
//				}
//			}
//			return null;
//		}
//		
		
		public function dispose():void
		{
			for(var key1:String in this.preLoaded)
			{
				var imgkey1:CLDImgItem=preLoaded[key1];
				if(imgkey1)
				{
					this.removeChild(imgkey1);
					imgkey1.dispose();
					imgkey1.isUser=false;
				}
			}
			preLoaded=null;
			_loadedImg.splice(0,_loadedImg.length-1);
			_loadedImg=null;
		}
		
		public function set loadedImg(value:Array):void
		{
			_loadedImg=value;
		}
		
		public function changeURL(path:String, src:String):String
		{
			return path+src;
		}
		
		public function get url():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
	}
}