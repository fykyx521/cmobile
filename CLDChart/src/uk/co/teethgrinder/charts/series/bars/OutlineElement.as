package uk.co.teethgrinder.charts.series.bars {
	
	import flash.display.Sprite;
	import uk.co.teethgrinder.charts.series.bars.BaseElement;
	import uk.co.teethgrinder.Properties;
	import uk.co.teethgrinder.ScreenCoords;
	import uk.co.teethgrinder.ScreenCoordsBase;
	
	public class OutlineElement extends BaseElement {
		private var outline:Number;
		
		public function OutlineElement( index:Number, props:Properties, group:Number )	{
			
			super(index, props, group);
			//super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
			this.outline = props.get_colour('outline-colour');
		}
		
		public override function resize(sc:ScreenCoordsBase,w:Number,hh:Number):void {
			
			var h:Object = this.resize_helper( sc as ScreenCoords );
			
			this.graphics.clear();
			this.graphics.lineStyle(1, this.outline, 1);
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