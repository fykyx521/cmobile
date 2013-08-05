package com.cglib.collections
{
	public class NullIterator implements IIterator
	{
		public function NullIterator()
		{
		}

		public function reset():void
		{
		}
		
		public function next():Object
		{
			return null;
		}
		
		public function hasNext():Boolean
		{
			return false;
		}
		public function count():uint{
			return 0;
		}
	}
}