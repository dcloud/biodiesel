//
//  InfogEvent
//
//  Created by Daniel Cloud on 2008-06-01.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.events {
	import flash.events.Event;

	public class InfogEvent extends Event{
		public static const	ANIMATION_COMPLETE:String = "animation_complete";
		public static const NAV_OVER:String = "nav_over";
		public static const NAV_OUT:String = "nav_out";
		public static const NAV_CLICK:String = "nav_click";
		public static const REGISTER_BUTTON = "register_button"
		
		public var data:Object;
		
		public function InfogEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null):void{
			// Pass constructor parameters to the superclass constructor
			super(type, bubbles, cancelable);

			this.data = data;
		
		}
		// Every custom event class must override clone(  )
		public override function clone(  ):Event {
			return new InfogEvent(type, bubbles, cancelable, data);
		}

		// Every custom event class must override toString(  ). Note that
		// "eventPhase" is an instance variable relating to the event flow.
		public override function toString(  ):String {
			return formatToString("InfogEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
