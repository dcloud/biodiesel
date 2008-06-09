package classes.test {
	import flash.events.*;

	public class EventTracer extends Object{
		public function EventTracer(){
		}
		
		// Test event stuff
		public function getEventInfo(event:Event, handler:String="unknown"):void{
			var phase:String;
			switch ( event.eventPhase ) {
				case EventPhase.CAPTURING_PHASE :
				phase = "Capture";
				break;

				case EventPhase.AT_TARGET :
				phase = "Target";
				break;

				case EventPhase.BUBBLING_PHASE :
				phase = "Bubbling";
				break;
			}

			trace("***** Eventhandler: " + handler  + " *****");
			trace("event.type: " + event.type);
			trace("event.eventPhase: " + phase);
			trace("event.target: " + event.target);
			if(event.type != "timer"){
				trace("event.target.name: " + event.target.name);
			}
			trace("event.currentTarget: " + event.currentTarget);
			trace("event.bubbles: " + event.bubbles);
			trace("=======================================");
		};
		
	}
}