//
//  Animatable
//	
//	These are MovieClips that have frame labels that we want to play to and then react.
//
//  Created by Daniel Cloud on 2008-06-01.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package	classes.core{
	import flash.display.MovieClip;
	import flash.events.*;

	public class Animatable extends MovieClip{
		private var verbose:Boolean = true;
		
		private var seekToLabel:String;
		
		public function Animatable(){

		}
		
		private function playToLabel(pLabel:String, target_mc:MovieClip):void{
			seekToLabel = pLabel;
			target_mc.addEventListener(Event.ENTER_FRAME, checkFrameLabel);
		};
		
		private function labelReached(pLabel:String, target_mc:MovieClip):void{
			trace("labelReached >> pLabel: " + pLabel);
		};
		
		private function checkFrameLabel(e:Event):void{
			if (verbose) {
				trace("e.target.name: " + e.target.name);
				trace("e.target.currentLabel: " + e.target.currentLabel);
			}
			if (e.target.currentLabel == seekToLabel) {
				e.target.stop();
				e.target.removeEventListener(Event.ENTER_FRAME, checkFrameLabel);
				labelReached(e.target.currentLabel, MovieClip(e.target));
			}
		};
	}
}
