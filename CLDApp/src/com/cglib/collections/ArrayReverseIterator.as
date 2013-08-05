package com.cglib.collections
{
	public class ArrayReverseIterator implements IIterator
	{
		private var _index:uint=0;
		private var _collection:Array;
		
		public function ArrayReverseIterator(collection:Array)
		{
			_collection=collection;
			_index=_collection.length-1;
		}

		public function reset():void
		{
			_index=_collection.length-1;
		}
		
		public function next():Object
		{
			return _collection[_index--];
		}
		
		public function hasNext():Boolean
		{
			return _index>=0;
		}
		public function count():uint{
			return _collection.length;
		}
	}
}