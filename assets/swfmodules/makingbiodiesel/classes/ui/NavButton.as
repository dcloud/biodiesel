//
//  NavButton
//
//  Created by Daniel Cloud on 2008-06-02.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.ui{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import classes.events.InfogEvent;
	
	public class NavButton extends Sprite{
		private var buttonID:String;
		
		public function NavButton(){
			buttonID = this.name.substr(7);
			buttonID = buttonID.replace("_", ".");
			
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
		};

		private function rollOutHandler(e:MouseEvent):void{
			dispatchEvent(new InfogEvent(InfogEvent.NAV_OUT, true, false, buttonID));
		};
		
		private function clickHandler(e:MouseEvent):void{
			trace("NavButton: " + buttonID);
			dispatchEvent(new InfogEvent(InfogEvent.NAV_CLICK, true, false, buttonID));
		};
	}
}
