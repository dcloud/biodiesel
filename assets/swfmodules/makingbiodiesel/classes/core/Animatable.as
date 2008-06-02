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
	import classes.events.InfogEvent;

	public class Animatable extends MovieClip{
		protected var verbose:Boolean = true;
		
		protected var seek_to_label:String;
		protected var target_mc:MovieClip;
		protected var dataObj:Object;
		
		public function Animatable(){
			this.stop();
			dataObj = new Object();
		}
		
		protected function playToLabel(pLabel:String, pTarget:MovieClip):void{
			setDataArray(pLabel, pTarget);
			if (target_mc.currentLabel != seek_to_label) {
				target_mc.addEventListener(Event.ENTER_FRAME, checkFrameLabel);
				target_mc.play();
			}
		};
		
		protected function goToLabel(pLabel:String, pTarget:MovieClip):void{
			setDataArray(pLabel, pTarget);
			if (verbose) trace("target_mc: " + target_mc.name);
			target_mc.gotoAndStop(seek_to_label);
		};
		
		protected function setDataArray(pLabel:String, pTarget:MovieClip):void{
			seek_to_label = pLabel;
			target_mc = pTarget;
			dataObj["target_mc"] = target_mc;
			dataObj["label"] = seek_to_label;
		};
		
		protected function labelReached():void{
			if (verbose) trace("labelReached >> seek_to_label: " + seek_to_label);
			dispatchEvent(new InfogEvent(InfogEvent.ANIMATION_COMPLETE, false, false, dataObj));
		};
		
		protected function checkFrameLabel(e:Event):void{
			if (verbose) {
				trace("target_mc.name: " + target_mc.parent.name + "." + target_mc.name);
				trace("target_mc.currentLabel: " + target_mc.currentLabel);
				trace("seek_to_label: " + seek_to_label);
			}
			if (target_mc.currentLabel == seek_to_label) {
				if (verbose) trace(target_mc.name + ".stop();");
				target_mc.stop();
				target_mc.removeEventListener(Event.ENTER_FRAME, checkFrameLabel);
				labelReached();
			}
		};
	}
}
