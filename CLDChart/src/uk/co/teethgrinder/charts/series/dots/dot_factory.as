package uk.co.teethgrinder.charts.series.dots {
	import uk.co.teethgrinder.Properties;
	
	public class dot_factory {
		
		public static function make( index:Number, style:Properties ):PointDotBase {
			
			// tr.aces( 'dot factory type', style.get('type'));
			
			switch( style.get('type') )
			{
				case 'star':
					return new star(index, style);
					break;
					
				case 'bow':
					return new bow(index, style);
					break;
				
				case 'anchor':
					return new anchor(index, style);
					break;
				
				case 'dot':
					return new PointElement(index, style);
					break;
				
				case 'solid-dot':
					return new PointDotElement(index, style);
					break;
					
				case 'hollow-dot':
					return new HollowDotElement(index, style);
					break;
					
				default:
				//
				// copy out the bow tie and then remove
				//
					return new PointElement(index, style);
					// return new scat(style);
					break;
			}
		}
	}
}