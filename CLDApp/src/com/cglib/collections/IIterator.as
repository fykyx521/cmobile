package com.cglib.collections
{
	public interface IIterator
	{
		function reset():void;
		function next():Object;
		function hasNext():Boolean;
		function count():uint;
	}
}