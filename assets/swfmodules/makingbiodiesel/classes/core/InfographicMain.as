//
//  InfographicMain
//
//  Created by Daniel Cloud on 2008-06-01.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.core{
	import flash.display.MovieClip;
	import flash.events.*;
	import classes.events.AnimEvent;
	import classes.core.Animatable;
	
	public class InfographicMain extends Animatable{
		
		public function InfographicMain(){
			addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageAdded(e:Event):void{
			addEventListener(AnimEvent.ANIMATION_COMPLETE, animationComplete);
			playToLabel("SECTION2.1", this);
		};
		
		private function animationComplete(e:AnimEvent):void{
			if (verbose) {
				trace("e: " + e);
				trace("e.target: " + e.target);
				for ( var item in e.data ){
					trace("e.data[" + item + "]: " + e.data[item]);
				};
			}
			
			playToLabel("INSIDES", oilTank_mc);
			playToLabel("INSIDES", reactorTank_mc);
			if (oilTank_mc.currentLabel == "INSIDES") {
				if (verbose) trace("oilTank_mc at INSIDES");
				playToLabel("TRANSFER", oilTank_mc.insides_mc);
				
			}
			if (oilTank_mc.insides_mc.currentLabel == "TRANSFER") {
				if (verbose) trace("oil transferring");
				playToLabel("FULL", reactorTank_mc.insides_mc);
				playToLabel("EMPTY", oilTank_mc.insides_mc);
			}
		};
	}
}