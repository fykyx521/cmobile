package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.charts.series.Element;
	import uk.co.teethgrinder.charts.elements.PointBarFade;
	
	public class BarFade extends BarBase {
		
		public function BarFade( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBarFade( index, value, this.colour, this.group );
		}
	}
}