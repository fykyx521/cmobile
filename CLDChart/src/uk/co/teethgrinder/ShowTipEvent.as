package uk.co.teethgrinder {
	import flash.events.Event;

	public class ShowTipEvent extends flash.events.Event {
		public static const SHOW_TIP_TYPE:String = "uk.co.teethgrinder.ShowTipEvent";

		// The amount we need to incrememnt by
		public var pos:Number;

		public function ShowTipEvent( pos:Number ) {
			super( SHOW_TIP_TYPE );
			this.pos = pos;
		}
	}
}