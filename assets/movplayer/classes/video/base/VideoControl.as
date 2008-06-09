//
//  VideoControl
//
//  Created by Daniel Cloud on 2008-04-25.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
// 
//

package classes.video.base {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
    import flash.events.*;
	import classes.video.events.MovEvent;
	
	public class VideoControl extends Sprite{
		public static const purpose:String = "video_control";
		protected static var supportedLanguages:Array = new Array("en", "es");
		protected static var movPlayerLanguage:String = supportedLanguages[0];
		protected static var controlsEnabled:Boolean = false;
		
		public function VideoControl(){

		}
		
		// For settine button states, whether it is a SimpleButton, Sprite, or MovieClip based button
		// Pass an array of objects or a single object, and the butonness state will be set
		protected static function setVideoControlStates(pObj:*, pState:Boolean):void{
			if (pObj is Array) {
				for ( var j=0; j<pObj.length; j++ ) {
					var tmpObj:Object = pObj[j];
					handleVideoControlType(tmpObj, pState);
				};
			}else if(pObj is Object){
				handleVideoControlType(pObj, pState);
			}
			// don't know how to handle 
		};
		
		protected static function handleVideoControlType(pObj:Object, pState:Boolean):void{
			if((pObj is Sprite) || (pObj is MovieClip)){
				pObj.buttonMode = pState;
			}else if (pObj is SimpleButton) {
				pObj.enabled = pState;
			}				
		};
	}	
}