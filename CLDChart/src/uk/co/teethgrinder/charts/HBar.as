﻿package uk.co.teethgrinder.charts {
	import uk.co.teethgrinder.ScreenCoordsBase;
	import uk.co.teethgrinder.charts.series.Element;
	import uk.co.teethgrinder.charts.series.bars.HorizontalElement;
	import uk.co.teethgrinder.object_helper;
	import uk.co.teethgrinder.string.StringUtils;
	
	public class HBar extends Base {
		
		protected var group:Number;
		protected var style:Object;
		
		public function HBar( json:Object ) {
			
			this.style = {
				values:				[],
				colour:				'#3030d0',
				text:				'',		// <-- default not display a key
				'font-size':		12,
				tip:				'#val#'
			};
			
			object_helper.merge_2( json, style );
			
			//this.alpha = Number( vals[0] );
			this.colour = uk.co.teethgrinder.string.StringUtils.get_colour( style.colour );
			this.key = json.text;
			this.font_size = json['font-size'];
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = 0;
			
			this.values = json['values'];
			
			this.style['on-click'] = json['on-click'];
			
			this.add_values();
		}
		
		//
		// called from the base object, in this case the
		// value is the X value of the bar and the index
		// is the Y positiont
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			var default_style:Object = {
					colour:		this.style.colour,
					tip:		this.style.tip,
					'on-click': this.style['on-click']
			};
			
			if( value is Number )
				default_style.top = value;
			else
				object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = StringUtils.get_colour( default_style.colour );
			
			return new HorizontalElement( index, default_style, this.group );
		}
		
		public override function resize( sc:ScreenCoordsBase ,w:Number,h:Number): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var p:HorizontalElement = this.getChildAt(i) as HorizontalElement;
				p.resize( sc,w,h );
			}
		}
		
		public override function get_max_x():Number {
			
			var x:Number = 0;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is HorizontalElement ) {
					
					var h:HorizontalElement = this.getChildAt(i) as HorizontalElement;
					x = Math.max( x, h.get_max_x() );
					
				}
	
			return x;
		}
		
		public override function get_min_x():Number {
			return 0;
		}

	}
}