package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.charts.series.Element;
	import uk.co.teethgrinder.charts.series.bars.GlassElement;
	import uk.co.teethgrinder.string.StringUtils;
	
	public class BarGlass extends BarBase {

		
		public function BarGlass( json:Object, group:Number ) {
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new GlassElement( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}