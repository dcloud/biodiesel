//
//  PlayPauseButton
//
//  Created by Daniel Cloud on 2008-04-23.
//
package classes.video.ui {
	import classes.video.base.VideoControl;
	import classes.video.events.MovEvent;

	import flash.display.SimpleButton;
	import flash.events.*;
	import classes.test.EventTracer;

	public class PlayPauseButton extends VideoControl{
		private var isPlaying:Boolean;
		private var buttonArr:Array;
		private var eTracer:EventTracer;
		
		public function PlayPauseButton():void{
			eTracer = new EventTracer();
			isPlaying = false;
			buttonArr = new Array(play_btn, pause_btn);
			togglePlayPause();
		}
		
		private function togglePlayPause():void{
			if (isPlaying) {
				this["pause_btn"].visible = true;
				this["play_btn"].visible = false;
			}else{
				this["pause_btn"].visible = false;
				this["play_btn"].visible = true;
			}
		};
		
		private function toggleEvent(event:MovEvent):void{
			/*eTracer.getEventInfo(event, "PlayPauseButton >> testToggle");*/
			isPlaying = event.pData;
			togglePlayPause();
		};
		
/*		private function handleClickEvent(event:MouseEvent):void{
			dispatchEvent(new MovEvent(MovEvent.PLAY_PAUSE_CLICK, true, false, isPlaying));
		};
*/		
		public function enable():void{
			addEventListener(MovEvent.TOGGLE, toggleEvent);
/*			addEventListener(MouseEvent.CLICK, handleClickEvent);			*/
			setVideoControlStates(buttonArr, true);
		};
		
		public function disable():void{
			removeEventListener(MovEvent.TOGGLE, toggleEvent);
/*			removeEventListener(MouseEvent.CLICK, handleClickEvent);*/
			setVideoControlStates(buttonArr, false);			
		};
		
	}	
}