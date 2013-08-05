package uk.co.teethgrinder.charts.series.bars {
	
	import uk.co.teethgrinder.Properties;
	import uk.co.teethgrinder.ScreenCoords;
	import uk.co.teethgrinder.ScreenCoordsBase;
	
	public class BarElement extends BaseElement {
	
		public function BarElement( index:Number, props:Properties, group:Number ) {
			
			super(index, props, group);
		}
		
		public override function resize( sc:ScreenCoordsBase,w:Number,hh:Number):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
		
	}
}