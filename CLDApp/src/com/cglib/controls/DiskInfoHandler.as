package com.cglib.controls
{
	import com.cglib.collections.ArrayIterator;
	import com.cglib.collections.IIterator;
	import com.cglib.collections.NullIterator;
	import com.cglib.models.picture;
	
	public class DiskInfoHandler
	{
		public function DiskInfoHandler()
		{
			
		}
		public static function getPicsFromOpenFolderhHandler(xml:XML):IIterator{			
			if(xml.data.multimedia.pictures.children().length()==0)return new NullIterator();
			var xmllist:XMLList=XMLList(xml.data.multimedia.pictures.picture);
			var datas:Array=[];
			for each(var i:XML in xmllist){
				datas.push(new picture(i));				
			}
			
			return new ArrayIterator(datas);					
		}
	}
}