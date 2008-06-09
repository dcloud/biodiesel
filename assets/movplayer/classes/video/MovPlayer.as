//
//  MovPlayer
//
//  Created by Daniel Cloud on 2008-04-15.
//
package classes.video {
	// MovPlayer classes
	import classes.video.base.VideoControl;
	import classes.video.events.MovEvent;

	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Timer;

	import classes.test.EventTracer;

	import flash.net.*;
	import flash.media.Video;
	import flash.media.SoundTransform;
	
	public class MovPlayer extends VideoControl{
		private var videoURL:String;

		private var videoScreen:Video;
		private var vidMaxWidth:Number;
		private var vidMaxHeight:Number;
		private var connection:NetConnection;
		private var stream:NetStream;
		private var videoInfo:Object;
		private var soundController:SoundTransform;
		
		private var videoTimer:Timer;
		private const updateInterval:uint = 250;
		private var videoDuration:Number;
		private var videoInitialized:Boolean;
		private var videoReset:Boolean;
		private var isPlaying:Boolean;
		private var scrubberDragging:Boolean;
		private var seekbarPercent:Number;
		private var newTime:Number;
		private var currVolume:Number;
		private var lastVolume:Number;
		private var bytesLoaded:Number;
		private var bytesTotal:Number;
		private var	loadedPct:Number;
		private var videoPositionPct:Number;
		private var downloadBufferPct:Number = 0.06; // try this pct first
		private var videoPositionLimitPct:Number;
		private var bytesLoadedTimer:Timer;
		
		private var videoY_max:Number;
		
		private var uiArr:Array;
				
		private var eTracer:EventTracer;
		private var verbose:Boolean = true;
		
		public function MovPlayer():void{
			loadedPct = 0;
			videoPositionPct = 0;
			videoPositionLimitPct = loadedPct -  downloadBufferPct;
			
			videoScreen = videoPlayback;
			videoScreen.smoothing = true;
			// start with screen invisible so we can control how video appears
			videoScreen.visible = false; 
			vidMaxWidth = videoScreen.width;
			vidMaxHeight = videoScreen.height;
			
			connection = new NetConnection();
			connection.connect(null);
			stream = new NetStream(connection);
			videoInfo = new Object();
			videoInfo.onMetaData = handleMetadata;
			stream.client = videoInfo;
			connection.client = videoInfo;
			videoScreen.attachNetStream(stream);
			soundController = new SoundTransform();
							
/*			stream.bufferTime = 10;*/
			
			newTime = 0;
			seekbarPercent = 0;
			
			videoTimer = new Timer(updateInterval);
			videoTimer.addEventListener(TimerEvent.TIMER, handleVideoUpdates);
			
/*			bufferFillTimer = new Timer(updateInterval);
			bufferFillTimer.addEventListener(TimerEvent.TIMER, watchBufferFill);
*/			
			bytesLoadedTimer = new Timer(updateInterval);
			bytesLoadedTimer.addEventListener(TimerEvent.TIMER, watchBytesLoad);
			
            connection.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            stream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
            stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);

			addEventListener(Event.ADDED_TO_STAGE, handleStageAdd);
			addEventListener(Event.REMOVED_FROM_STAGE, handleStageRemove);

			eTracer = new EventTracer();
						
			bufferingMsg_mc.visible = false;	
			currVolume = lastVolume = soundController.volume;	
			isPlaying = false;
			videoInitialized = false;
			videoReset = false;
			
			toggleMute(false);
		};
		
		// Run when netstream gets metadata from the video
		private function handleMetadata(vidInfo:Object):void {
			if (vidInfo.duration) {
/*				for ( var prop in vidInfo ){
					if (verbose) trace("vidInfo[" + prop + "]: " + vidInfo[prop]);
				};
*/				if (verbose) trace("metadata: duration=" + vidInfo.duration);
				if (verbose) trace("metadata: width=" + vidInfo.width);
				if (verbose) trace("metadata: height=" + vidInfo.height);
				if (verbose) trace("MovPlayer >> handleMetadata >> time: " + stream.time);
				if (vidInfo.height && vidInfo.width) {
					// If metadata includes height of the video, change the screen size to match
					setVideoScreenSize(vidInfo.width, vidInfo.height);					
				}else if (videoScreen.videoHeight && videoScreen.videoWidth) {
					setVideoScreenSize(videoScreen.videoWidth, videoScreen.videoHeight);					
				}
				videoDuration = vidInfo.duration;
				timer_mc.setTotalTime(videoDuration);
				if (!videoInitialized || videoReset) {
					initVideo();
				}
				if(!isPlaying){
					videoTimer.stop();
				}
			}else{
				if (verbose) trace("Got metadata, but I don't know what kind.");
			}
		}
		
		private function handleStageAdd(event:Event):void{
			if (verbose) trace("Stage.height: " + stage.height);
			if (verbose) trace("language: " + movPlayerLanguage);
			uiArr = registerUIElements();
			videoY_max = seekBar_mc.y;
			disable();
		};
		
		private function handleStageRemove(event:Event):void{
			if(verbose) trace("stage remove.");
			connection.close();
			stream.close();
			videoScreen.clear();
			videoTimer.stop();
			bytesLoadedTimer.stop();
			disable();
		};
		
		// Function that should run in constructor to make array of ui objects to disable/alpha/whatever
		// I don't know AS3 well enough to have to identify children of the same class
		private function registerUIElements():Array{
			var tmpArr:Array = new Array();
			tmpArr.push(playPause_mc);
			tmpArr.push(seekBar_mc);
			tmpArr.push(volumeBar_mc);
			tmpArr.push(mute_btn);
			tmpArr.push(timer_mc);
			
			return tmpArr;
		};

		private function enable():void{
/*			dispatchEvent(new MovEvent(MovEvent.ENABLE_UI, true));*/

			addEventListener(MouseEvent.CLICK, handleClickEvent, true);
			// seekBar_mc has custom event, percentChange, and that does not bubble up,
			// so we need to have seekBar_mc listen for percentChange
			addEventListener(MovEvent.PERCENT_CHANGE, handleSeekBarChange);
/*			addEventListener(MovEvent.SEEKBAR_CLICK, handleSeekBarChange);*/
			addEventListener(MovEvent.START_DRAG, handleStartDrag);
			addEventListener(MovEvent.STOP_DRAG, handleStopDrag);
			// need MovPlayer to listen for volume change since it is ancestor of VolumeBar, but our FLVPlayback is not
			addEventListener(MovEvent.VOLUME_PERCENT_CHANGE, volumePercentChange);
			addEventListener(MovEvent.AUDIOBAR_CLICK , volumePercentChange);
			addEventListener(MovEvent.PLAY_PAUSE_CLICK, handlePlayPause);
			volumeBar_mc.enable();
			seekBar_mc.enable();
			playPause_mc.enable();
			mute_btn.addEventListener(MouseEvent.CLICK, muteClick);
			unmute_btn.addEventListener(MouseEvent.CLICK, unmuteClick);
			setVideoControlStates(mute_btn, true);
			setVideoControlStates(unmute_btn, true);

			for ( var i=0; i<uiArr.length; i++ ) {
				uiArr[i].alpha = 1;
			};
		};

		private function disable():void{
/*			dispatchEvent(new MovEvent(MovEvent.DISABLE_UI, true));*/
			
			removeEventListener(MouseEvent.CLICK, handleClickEvent, true);

			removeEventListener(MovEvent.PERCENT_CHANGE, handleSeekBarChange);
/*			removeEventListener(MovEvent.SEEKBAR_CLICK, handleSeekBarChange);*/
			removeEventListener(MovEvent.START_DRAG, handleStartDrag);
			removeEventListener(MovEvent.STOP_DRAG, handleStopDrag);
			// need MovPlayer to listen for volume change since it is ancestor of VolumeBar, but our FLVPlayback is not
			removeEventListener(MovEvent.VOLUME_PERCENT_CHANGE, volumePercentChange);
			removeEventListener(MovEvent.AUDIOBAR_CLICK , volumePercentChange);
			seekBar_mc.disable();
			volumeBar_mc.disable();
			playPause_mc.disable();
			mute_btn.removeEventListener(MouseEvent.CLICK, muteClick);
			unmute_btn.removeEventListener(MouseEvent.CLICK, unmuteClick);
			setVideoControlStates(mute_btn, false);
			setVideoControlStates(unmute_btn, false);

			for ( var i=0; i<uiArr.length; i++ ) {
				uiArr[i].alpha = .4;
			};
		};
		
		private function initVideo():void{
			if (verbose) trace("MovPlayer >> initVideo @ stream.time: " + stream.time);
			if (stream.time >= 1 || loadedPct >= 1) {
				if (verbose) {
					trace("MovPlayer >> initVideo run.");
					trace("MovPlayer >> initVideo stream.time: " + stream.time);
					trace("MovPlayer >> initVideo loadedPct: " + loadedPct);
				}
				stream.seek(0);
				stream.pause();
				isPlaying = false;
				this.enable();
				seekBar_mc.updatePlayHead(0);
				playPause_mc.dispatchEvent(new MovEvent(MovEvent.TOGGLE, true, false, isPlaying));
				videoInitialized = true;
				videoReset = false;
				soundController.volume = 1;
				stream.soundTransform = soundController;
				// videoScreen should become visible after possible transformations to the video dimensions
				videoScreen.visible = true;
			}
		};

		/* 
			Public functions/getters/setters for use when MovPlayer is loaded into other swfs
			Mostly this replicates the getters/setters for an FLVPlayback
		*/
		
		
			// Getting/Setting video and caption source files
			
		public function get source():String{
			return videoURL;
		};
		
		public function set source(param_path:String):void{
			if (verbose) trace("video source set to: " + param_path);
			// Start with volume at zero & video as uninitialized
			// once video gets initialized (seeked to 0, really), we set volume at 1			
			soundController.volume = 0;
			stream.soundTransform = soundController;
			if (verbose) trace("set source >> stream.soundTransform.volume: " + stream.soundTransform.volume);
			videoInitialized = false;
			videoURL = param_path;
			stream.play(videoURL);
			setBuffering(true);
		};
		
		public function set reset(p_Reset:Boolean):void{
			videoReset = true;
			initVideo();
		};
		
			// Video playback controls
		
		public function play():void{
			isPlaying = true;
/*			bufferFillTimer.start();*/
		};
		
		public function pause():void{
			stream.pause();
		};
		
		public function stop():void{
			stream.close();
		};
		
		public function get volume():Number{
			return soundController.volume;
		};
		
		public function set volume(param_volume:Number):void{
			soundController.volume = param_volume;
			stream.soundTransform = soundController;
		};
		
		/* Private functions of the MovPlayer class */
		
		// Set video screen size, but don't go bigger than 
		// design-time settings bc this version of player not handling multiple video sizes
		private function setVideoScreenSize(pWidth:Number, pHeight:Number):void{
			if (verbose) trace("set video height to: " + pHeight);
			if (verbose) trace("set video width to: " + pWidth);
			if (pWidth <= vidMaxWidth && pHeight <= vidMaxHeight) {
				videoScreen.height = pHeight;
				videoScreen.width = pWidth;
			}else {
				var maxWidth = videoScreen.width;
				var reducePct:Number = maxWidth/pWidth;
				videoScreen.height *= reducePct;
			}
			var vidScrNewY:Number = (videoY_max/2) - (videoScreen.height/2);
			if (vidScrNewY < 5) {
				videoScreen.y = 5;					
			}else{
				videoScreen.y = vidScrNewY;					
			}
		};
		
		// This function runs on a MovEvent.PERCENT_CHANGE event
		private function handleSeekBarChange(event:MovEvent):void{
			/*eTracer.getEventInfo(event, "handleSeekBarChange");*/
			seekbarPercent = event.pData;
			videoPositionPct = seekbarPercent/100;
			if (verbose) trace("MovPlayer >> handleSeekBarChange >> seekbar gave seekbarPercent: " + seekbarPercent);
			traceLoadingAndPlackbackInfo();			
			newTime = videoDuration * videoPositionPct;
			if (verbose) trace("MovPlayer >> handleSeekBarChange >> newTime: " + newTime);
			if (verbose) trace("MovPlayer >> handleSeekBarChange >> stream.time: " + stream.time);
			stream.seek(newTime);
/*			event.target.updatePlayHead(percent);*/
			timer_mc.updateCurrentTime(newTime);
		};
		
		private function handleStopDrag(event:MovEvent):void{
			// if the video was playing before we started dragging, make it play again
			if (verbose) trace("MovPlayer >> handleStopDrag");
			if(isPlaying){
				stream.resume();
/*				bufferFillTimer.start();*/
				videoTimer.start();
			}
			scrubberDragging = false;
			timer_mc.updateCurrentTime(newTime);
		};
		
		private function handleStartDrag(event:MovEvent):void{
			if (verbose) trace("MovPlayer >> handleStartDrag");
			scrubberDragging = true;
			stream.pause();
			videoTimer.stop();
		};
		
		private function handleVideoUpdates(event:TimerEvent):void{
			if(verbose) trace("MovPlayer >> videoTimer running.");
			timer_mc.updateCurrentTime(stream.time);
			videoPositionPct = stream.time/videoDuration;
			traceLoadingAndPlackbackInfo();
			seekBar_mc.updatePlayHead(videoPositionPct);
			if(videoReset){
				videoTimer.stop();
				this.pause();
				initVideo();
			}
		};
		
		private	function traceLoadingAndPlackbackInfo():void{
			if (verbose){
				trace("MovPlayer >> loadedPct: " + loadedPct);
				trace("MovPlayer >> videoPositionPct: " + videoPositionPct);
				trace("MovPlayer >> downloadBufferPct: " + downloadBufferPct);
				trace("MovPlayer >> videoPositionLimitPct: " + videoPositionLimitPct);
				trace("MovPlayer >> stream.time: " + stream.time);
			} 
		};
		
		private function watchBytesLoad(event:TimerEvent):void{
			if (verbose) {
				trace("watchBytesLoad.");
				trace("watchBytesLoad >> stream.time: " + stream.time);
			}
			// loadedPct must be calculated before we can run initVideo();
			loadedPct = stream.bytesLoaded/stream.bytesTotal;
			if(!videoInitialized || videoReset){
				if (verbose) trace("MovPlayer >> watchBytesLoad >> video either reset of not yet initialized.");
				initVideo();
/*				stream.pause();
				isPlaying = false;
				playPause_mc.dispatchEvent(new MovEvent(MovEvent.TOGGLE, true, false, isPlaying));
*/			}
			// figure out the limitation on how far video position can be.
			setVideoPositionLimit();
/*			videoPositionLimitPct = loadedPct -  downloadBufferPct;*/
			
			traceLoadingAndPlackbackInfo();
			seekBar_mc.setSeekBarBoundary(loadedPct, videoPositionLimitPct);
			// If our video position is less than the limit, buffering is false. If it isn't less than limit,
			// check first to see if video isn't fully loaded, and if it isn't, set buffering to true.
			if (videoInitialized && (videoPositionPct < videoPositionLimitPct)) {
				setBuffering(false);
				if (loadedPct >= 1) {
					bytesLoadedTimer.stop();
				}
				// this second condition is checked only if we are past videoPositionLimitPct and need to possibly set buffering
			}else if(loadedPct < 1){
				setBuffering(true);
			}
		};
		
		private function setVideoPositionLimit():void{
			videoPositionLimitPct = loadedPct -  downloadBufferPct;
			if (videoPositionLimitPct < 0) {
				videoPositionLimitPct = 0;
			}else if (loadedPct >= 1) {
				videoPositionLimitPct = 1;
			}
		};
		
		private function setBuffering(p_buffering:Boolean):void{
			if (verbose) trace("MovPlayer >> setBuffering: " + p_buffering);
			if(p_buffering){
				bufferingMsg_mc.visible = true;
				if (isPlaying) {
					videoTimer.stop();
					stream.pause();
				}
			}else{
				bufferingMsg_mc.visible = false;
				if (isPlaying && !scrubberDragging) {
					videoTimer.start();
					stream.resume();
				}
			}
		};
		
		private function toggleMute(isMuted:Boolean):void{
			if (isMuted) {
				mute_btn.visible = false;
				unmute_btn.visible = true;
			}else{
				mute_btn.visible = true;
				unmute_btn.visible = false;
			}
		};
			
		private function handleNetStatusEvent(event:NetStatusEvent):void{
            switch (event.info.code) {
                case "NetStream.Play.Start":
                    if (verbose) trace("NetStream.Play.Start");
					isPlaying = false;
					bytesLoadedTimer.start();
                    break;
				case "NetStream.Play.StreamNotFound":
                    if (verbose) trace("Stream not found: " + videoURL);
                    break;
				case "NetStream.Play.Stop" :
					if (verbose) trace("NetStream.Play.Stop");
					videoReset = true;
					break;
				default :
					if (verbose) trace("event.info.code: " + event.info.code);
					break;
            }
		};
		
		private function handleIOError(event:IOErrorEvent):void{
			if (verbose) trace("Error: " + event.text);
		};
		
		private function handleAsyncError(event:AsyncErrorEvent):void{
			if (verbose) trace(event);
			if (verbose) trace(event.type);
		};
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			if (verbose) trace("securityErrorHandler: " + event);
		};
		
		// Set volume
		private function volumePercentChange(event:MovEvent):void{
			/*eTracer.getEventInfo(event, "volumePercentChange");*/
			currVolume = event.pData/100;
			soundController.volume = currVolume;
			stream.soundTransform = soundController;
			if (currVolume >= 1) {
				currVolume = 1;
				toggleMute(false);
			}else if (currVolume <= 0) {
				currVolume = 0;
				toggleMute(true);
			}else if (currVolume > 0 && currVolume < 1) {
				toggleMute(false);
			}
			if (verbose) trace("currVolume: " + currVolume);
			if (verbose) trace("soundController.volume: " + soundController.volume);
		};
				
		private function handleClickEvent(event:MouseEvent):void{
			/*eTracer.getEventInfo(event, "handleClickEvent");*/
			if (verbose) trace("event.target.parent.name: " + event.target.parent.name);
			if(event.target.name == "play_btn" || event.target.name == "pause_btn"){
				// We have a play/pause click to handle
				if (verbose) trace(event.target.name + " was clicked.");
				handlePlayPause();
			}
		};
		
		private function handlePlayPause():void{
			if (verbose) trace("MovPlayer >> handlePlayPause >> stream.bufferLength: " + stream.bufferLength);
			if (verbose) trace("MovPlayer >> handlePlayPause >> stream.bufferTime " + stream.bufferTime);
			if (verbose) trace("MovPlayer >> handlePlayPause >> wasPlaying: " + isPlaying);
			if (isPlaying) {
				stream.pause();
				videoTimer.stop();
				isPlaying = false;				
			}else{
				videoTimer.start();
				stream.resume();
				isPlaying = true;
			}
			if (verbose) trace("MovPlayer >> handlePlayPause >> isPlaying: " + isPlaying + " >> time: " + stream.time);
/*			stream.togglePause();*/
			playPause_mc.dispatchEvent(new MovEvent(MovEvent.TOGGLE, true, false, isPlaying));
		};
		
		/*
			Button functions
		*/
				
		private function muteClick(event:MouseEvent):void{
/*			eTracer.getEventInfo(event, "muteClick");*/
			lastVolume = soundController.volume;
			if(soundController.volume != 0){
				soundController.volume = 0;
				stream.soundTransform = soundController;
				toggleMute(true);
				event.target.dispatchEvent(new MovEvent(MovEvent.MUTE_UNMUTE_CLICK, true, false, soundController.volume));
			}
		};
		
		private function unmuteClick(event:MouseEvent):void{
			/*eTracer.getEventInfo(event, "unmuteClick");*/
			if (soundController.volume != lastVolume) {
				soundController.volume = lastVolume;
				stream.soundTransform = soundController;
				toggleMute(false);
				event.target.dispatchEvent(new MovEvent(MovEvent.MUTE_UNMUTE_CLICK, true, false, soundController.volume));				
			}
		};
	}
}