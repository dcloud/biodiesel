//
//  AnimEvent
//
//  Created by Daniel Cloud on 2008-06-01.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.events {
	import flash.events.Event;

	public class AnimEvent extends Event{
		public static const	ANIMATION_COMPLETE:String = "animation_complete";
		
		public var data:Object;
		
		public function AnimEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null):void{
			// Pass constructor parameters to the superclass constructor
			super(type, bubbles, cancelable);

			this.data = data;
		
		}
		// Every custom event class must override clone(  )
		public override function clone(  ):Event {
			return new AnimEvent(type, bubbles, cancelable, data);
		}

		// Every custom event class must override toString(  ). Note that
		// "eventPhase" is an instance variable relating to the event flow.
		public override function toString(  ):String {
			return formatToString("AnimEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
