//
//  NavButton
// For the buttons in the infographic
//
//  Created by Daniel Cloud on 2008-06-02.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.ui{
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import com.gskinner.geom.ColorMatrix;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import classes.events.InfogEvent;
	
	public class InfogButton extends Sprite{
		private var buttonID:String;
		
		private var selectedButton:Boolean;
		
		private var cm:ColorMatrix;
		private var deselectedState:ColorMatrixFilter;
		private var overState:ColorMatrixFilter;
		
		private var verbose:Boolean = false;
		
		public function InfogButton(){
			// remove _btn from instance name, and you have buttonID
			buttonID = this.name.slice(0,-4);
			
			cm = new ColorMatrix();
			cm.adjustColor(20, 0, -100, 0);
			deselectedState = new ColorMatrixFilter(cm);
			cm.reset();
			cm.adjustColor(-20,0,0,0);
			overState = new ColorMatrixFilter(cm);
			
			this.filters =[deselectedState];
			
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
			this.filters = [overState];
/*			this.transform.colorTransform = overTint;*/
		};

		private function rollOutHandler(e:MouseEvent):void{
			dispatchEvent(new InfogEvent(InfogEvent.NAV_OUT, true, false, buttonID));
			if (!selectedButton) {
				this.filters =[deselectedState];
			}else{
				this.filters = [];
			}
/*			this.transform.colorTransform = defaultTint;*/
		};
		
		private function clickHandler(e:MouseEvent):void{
			if(verbose) trace("NavButton: " + buttonID);
			dispatchEvent(new InfogEvent(InfogEvent.NAV_CLICK, true, false, buttonID));
/*			selected(this.buttonID);*/
		};
		
		//class-wide function for setting the selected button
		public function setSelection(p_selectionID:String):void{
			if (this.buttonID == p_selectionID) {
				this.selectedButton = true;
				this.filters = [];
			}else{
				this.selectedButton = false;
				this.filters = [deselectedState];
			}
		};
		
	}
}
