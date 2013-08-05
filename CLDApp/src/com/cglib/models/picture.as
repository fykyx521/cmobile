package com.cglib.models
{
	public class picture
	{
		public var path:String;
		public var minipic:String;
		public function picture(xml:XML)
		{
			path=xml.path;
			minipic=xml.minipic;
		}
	}
}