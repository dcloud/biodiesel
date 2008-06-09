//
//  MovEvent is a custom event for MovPlayer
//
//  Created by Daniel Cloud on 2008-04-15.
//
package classes.video.events {
	import flash.events.Event;

	public class MovEvent extends Event{
		public static const	INITIALIZE:String = "initialize";
		public static const INITIALIZE_BUTTONS:String = "initialize_buttons";
		public static const PERCENT_CHANGE:String = "percent_change";
		public static const START_DRAG:String = "start_drag";
		public static const STOP_DRAG:String = "stop_drag";
		public static const UPDATE_PLAYHEAD = "update_playhead";
		public static const ENABLE_UI = "enable_ui";
		public static const DISABLE_UI = "disable_ui";
		public static const TOGGLE = "toggle";
		public static const TOGGLE_CAPTIONS = "toggle_captions";
		public static const SEEKBAR_CLICK = "seekbar_click";
		public static const VOLUME_PERCENT_CHANGE = "volume_percent_change";
		public static const PLAY_PAUSE_CLICK = "play_pause_click";
		public static const AUDIOBAR_CLICK = "audiobar_click";
		public static const MUTE_UNMUTE_CLICK = "mute_unmute_click";
		
		public var pData:*;

		public function MovEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, pData:* = null):void{
			// Pass constructor parameters to the superclass constructor
			super(type, bubbles, cancelable);

			this.pData = pData;
		};

		// Every custom event class must override clone(  )
		public override function clone(  ):Event {
			return new MovEvent(type, bubbles, cancelable, pData);
		}

		// Every custom event class must override toString(  ). Note that
		// "eventPhase" is an instance variable relating to the event flow.
		// See Chapter 21.
		public override function toString(  ):String {
			return formatToString("MovEvent", "type", "bubbles", "cancelable", "eventPhase", "pData");
		}
	}
}
