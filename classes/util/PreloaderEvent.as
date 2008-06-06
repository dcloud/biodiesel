//
//  PreloaderEvent
//
//  Created by Daniel Cloud on 2008-06-06.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.util {
	import flash.events.Event;

	public class PreloaderEvent extends Event{
		public static const CONTENT_INIT:String = "content_init";
		
		public var loaderInfo:Object;
		
		public function PreloaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, loaderInfo:* = null):void{
			// Pass constructor parameters to the superclass constructor
			super(type, bubbles, cancelable);

			this.loaderInfo = loaderInfo;
		
		}
		// Every custom event class must override clone(  )
		public override function clone(  ):Event {
			return new PreloaderEvent(type, bubbles, cancelable, loaderInfo);
		}

		// Every custom event class must override toString(  ). Note that
		// "eventPhase" is an instance variable relating to the event flow.
		public override function toString(  ):String {
			return formatToString("PreloaderEvent", "type", "bubbles", "cancelable", "eventPhase", "loaderInfo");
		}
	}
}
