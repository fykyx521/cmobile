package fr.mazerte.controls.openflow.utils
{
	public class ArrayUtil
	{
		public function ArrayUtil()
		{
			
		}
		public static function toArray(obj:Object):Array
		{
			if (obj == null) 
				return [];
				
			else if (obj is Array)
				return obj as Array;
				
			else
				return [ obj ];
		}
		
		public static function getItemIndex(item:Object, source:Array):int
		{
			var n:int = source.length;
			for (var i:int = 0; i < n; i++)
			{
				if (source[i] === item)
					return i;
			}
			
			return -1;           
		}
	}
}