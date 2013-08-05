package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.charts.series.Element;
	import uk.co.teethgrinder.charts.series.bars.Round3DElement;
       
       public class BarRound3D extends BarBase {

          
          public function BarRound3D( json:Object, group:Number ) {
             
             super( json, group );
          }
          
          //
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new uk.co.teethgrinder.charts.series.bars.Round3DElement( index, this.get_element_helper_prop( value ), this.group );
		}
	   }
    }