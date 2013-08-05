package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.charts.series.Element;
	import uk.co.teethgrinder.charts.series.bars.CylinderElement;

	public class BarCylinder extends BarBase {


		public function BarCylinder( json:Object, group:Number ) {

			super( json, group );
		}

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			return new CylinderElement( index, this.get_element_helper_prop( value ), this.group );
		}
	}
}