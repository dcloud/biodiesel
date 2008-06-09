/*
	Author: Daniel Cloud
	This is basically the same as SeekBar, but for audio
	Note: could redo Seekbar and AudioBar to be implentations/subclasses of a SeekUI class
*/
package classes.video.ui {
	import classes.video.base.VideoControl;
	import classes.video.events.MovEvent;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import classes.test.EventTracer;
	
	public class VolumeBar extends VideoControl{
		private var trackWidth:Number;
		private var dragTimer:Timer;
		private var bounds:Rectangle;
		private var percent:Number;
		private var isDragging:Boolean;
		private var uiElements:Array;
		
		private var eTracer:EventTracer;
		
		public function VolumeBar():void{
			eTracer = new EventTracer();
			addEventListener(Event.ADDED_TO_STAGE, handleObjectAdd);
			
			uiElements = new Array(volumeBarProgress_mc, audioSeekHead_mc);
			
			var timeInterval:uint = 300; 
			dragTimer = new Timer(timeInterval);
			dragTimer.addEventListener(TimerEvent.TIMER, updateVolume);
			trackWidth = volumeBarProgress_mc.width;
			bounds = new Rectangle(volumeBarProgress_mc.x, (volumeBarProgress_mc.y + volumeBarProgress_mc.height/2), volumeBarProgress_mc.width, 0);
			audioSeekHead_mc.x = trackWidth;
			
			isDragging = false;
			//addEventListener(MovEvent.DISABLE_SEEKBAR, disableSeekBarHandler, true);
		};
		
		private function handleObjectAdd(event:Event):void{
			trace("VolumeBar >> handleObjectAdd");
			disable();			
		};
		
		public function enable():void{
			addEventListener(MouseEvent.MOUSE_DOWN, audioStartDrag);
			addEventListener(MouseEvent.MOUSE_UP, audioStopDrag, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, audioStopDrag);
			stage.addEventListener(Event.MOUSE_LEAVE, audioStageLeave);
/*			volumeBarProgress_mc.addEventListener(MouseEvent.CLICK, volumeBarProgressClick);*/
			root.addEventListener(MovEvent.MUTE_UNMUTE_CLICK , volChangeHandler);
			setVideoControlStates(uiElements, true);
			setPercent();
		};

		private function disableSeekBarHandler(event:MovEvent):void{
			/*eTracer.getEventInfo(event, "disableVolumeBarHandler");*/
			disable();
		};
		
		public function disable():void{
			removeEventListener(MouseEvent.MOUSE_DOWN, audioStartDrag);
			removeEventListener(MouseEvent.MOUSE_UP, audioStopDrag, true);
			stage.removeEventListener(MouseEvent.MOUSE_UP, audioStopDrag);
			stage.removeEventListener(Event.MOUSE_LEAVE, audioStageLeave);
/*			volumeBarProgress_mc.removeEventListener(MouseEvent.CLICK, volumeBarProgressClick);*/
			root.removeEventListener(MovEvent.MUTE_UNMUTE_CLICK , volChangeHandler);
			setVideoControlStates(uiElements, false);
		};
		
		private function audioStartDrag(event:MouseEvent):void{
			isDragging = true;
			/*eTracer.getEventInfo(event, "audioStartDrag");*/
			if (event.currentTarget == this) {
				audioSeekHead_mc.startDrag(true, bounds);
			}
			dragTimer.start();
		};
		
		private function audioStopDrag(event:MouseEvent):void{
/*			eTracer.getEventInfo(event, "audioStopDrag");*/
			var audioDragTarget:*;
			try {
				audioDragTarget = this.getChildByName(event.target.name);
			}catch(error:TypeError){
/*				trace("Got a type error.");*/
				audioDragTarget = false;
			}
/*			if (event.target.name != null) {
				var audioDragTarget = this.getChildByName(event.target.name);				
			}else{
				var audioDragTarget = null;
			}
*/			if (audioDragTarget || event.currentTarget == this.stage) {
				trace("audioStopDrag -> processAudioStopDrag");
				processAudioStopDrag();
			}else{
				trace("audioStopDrag -> Don't process stop drag");
			}
		};
		
		private function audioStageLeave(event:Event):void{
			/*eTracer.getEventInfo(event, "audioStageLeave");*/
			if (isDragging) {
				processAudioStopDrag();				
			}
		};
		
		private function processAudioStopDrag():void{
			isDragging = false;
			audioSeekHead_mc.stopDrag();
			setPercent();
			dragTimer.stop();
		};
		
		private function volumeBarProgressClick(event:MouseEvent):void{
			/*eTracer.getEventInfo(event, "volumeBarProgressClick");*/
			var seekBarPercent:Number = (event.currentTarget.mouseX/event.currentTarget.width)*100;
			dispatchEvent(new MovEvent(MovEvent.AUDIOBAR_CLICK, true, false, seekBarPercent));			
		};
		
		private function updateVolume(event:TimerEvent):void{
			setPercent();
			event.stopImmediatePropagation();
		};
		
		private function setPercent():void{
			percent = (audioSeekHead_mc.x/trackWidth)*100;
			dispatchEvent(new MovEvent(MovEvent.VOLUME_PERCENT_CHANGE, true, false, percent));
		};
		
		private function volChangeHandler(event:MovEvent):void{
			/*eTracer.getEventInfo(event, "volChangeHandler");*/
			if (event.pData == 0) {
				audioSeekHead_mc.x = 0;
			}else {
				audioSeekHead_mc.x = event.pData * volumeBarProgress_mc.width;
			}
		};
		
	}

}