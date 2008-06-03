//
//  NavButton
//
//  Created by Daniel Cloud on 2008-06-02.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.ui{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import classes.events.InfogEvent;
	
	public class NavButton extends Sprite{
		private var buttonID:String;
		private var overTint:ColorTransform;
		private var defaultTint:ColorTransform;
		
		private var verbose:Boolean = false;
		
		public function NavButton(){
			// remove _btn from instance name, and you have buttonID
			buttonID = this.name.slice(0,-4);
			
			defaultTint = this.transform.colorTransform;
			var offset:Number = 0;
			var tintMultliplier:Number = 1.3;
			overTint = new ColorTransform(tintMultliplier, tintMultliplier, tintMultliplier, 1, offset, offset, offset, 0);
			
			this.buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function get id():String{
			return buttonID;
		};
		
		private function rollOverHandler(e:MouseEvent):void{
			dispatchEvent(new InfogEvent(InfogEvent.NAV_OVER, true, false, buttonID));
			this.transform.colorTransform = overTint;
		};

		private function rollOutHandler(e:MouseEvent):void{
			dispatchEvent(new InfogEvent(InfogEvent.NAV_OUT, true, false, buttonID));
			this.transform.colorTransform = defaultTint;
		};
		
		private function clickHandler(e:MouseEvent):void{
			if(verbose) trace("NavButton: " + buttonID);
			dispatchEvent(new InfogEvent(InfogEvent.NAV_CLICK, true, false, buttonID));
		};
	}
}
