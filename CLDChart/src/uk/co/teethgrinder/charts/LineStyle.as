package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.object_helper;

	public class LineStyle extends Object
	{
		public var style:String;
		public var on:Number;
		public var off:Number;
		
		public function LineStyle( json:Object ) {
		
			// tr.ace(json);
			
			// default values:
			this.style = 'solid';
			this.on = 1;
			this.off = 5;
			
			object_helper.merge_2( json, this );
		}
	}
}