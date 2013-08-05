package uk.co.teethgrinder.charts.series.dots {
	
	import uk.co.teethgrinder.charts.series.dots.PointDotBase;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import uk.co.teethgrinder.string.StringUtils;
	import uk.co.teethgrinder.Properties;
	
	public class PointDotElement extends PointDotBase {
		
		public function PointDotElement( index:Number, style:Properties ) {
			
			super( index, style );
			
			var colour:Number = uk.co.teethgrinder.string.StringUtils.get_colour( style.get('colour') );
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, style.get('dot-size') );
			this.graphics.endFill();
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, style.get('dot-size')+style.get('halo-size') );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
			
			this.attach_events();
		}
	}
}

