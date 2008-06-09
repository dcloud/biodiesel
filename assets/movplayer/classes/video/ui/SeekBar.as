package classes.video.ui {
	import classes.video.base.VideoControl;
	import classes.video.events.MovEvent;

	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import classes.test.EventTracer;
	
	public class SeekBar extends VideoControl{
		private var bounds:Rectangle;
		private var trackWidth:Number;
		private var percent:Number;
		private var isDragging:Boolean;
		private var uiControlArr:Array;
		private var bufferBar:Sprite;
		
		private var eTracer:EventTracer;
		
		public function SeekBar():void{
			bufferBar = new Sprite();
			bufferBar.graphics.beginFill(0x000000, 0.6);
			bufferBar.graphics.drawRect(seekBarProgress_mc.x, seekBarProgress_mc.y, 1, seekBarProgress_mc.height);
			addChild(bufferBar);
			swapChildren(bufferBar, seekHead_mc);
			
			trackWidth = seekBarProgress_mc.width;
			setSeekBarBoundary(0,0);
			trace("SeekBar >> seekBarProgress_mc.width: " + seekBarProgress_mc.width);
			
			eTracer = new EventTracer();
			
			uiControlArr = new Array(seekHead_mc, seekBarProgress_mc);
			
			seekHead_mc.x = 0;
			setPercent();
			
			isDragging = false;
			
/*			addEventListener(Event.ADDED_TO_STAGE, handleObjectAdd);*/
		};
		
		public function setSeekBarBoundary(pLoadRatio:Number, p_videoPosRatioLimit:Number):void{
			trace("setSeekBarBoundary >> pLoadRatio: " + pLoadRatio);
			seekBarProgress_mc.width = trackWidth * pLoadRatio;//(pLoadRatio >= 1 || pLoadRatio == 0) ? pLoadRatio : (pLoadRatio-0.2);
			var seekLimit:Number = trackWidth * p_videoPosRatioLimit;
			bufferBar.width = trackWidth - seekLimit;
			bufferBar.x = seekLimit;
			trace("setSeekBarBoundary >> bufferBar.width: " + bufferBar.width + " and x: " + bufferBar.x);
			bounds = new Rectangle(seekBarProgress_mc.x, (seekBarProgress_mc.y + seekBarProgress_mc.height/2), seekLimit, 0);
			if (isDragging) {
				seekHead_mc.startDrag(true, bounds);				
			}
		};
		
		private function handleObjectAdd(event:Event):void{
/*			trace("SeekBar >> handleObjectAdd");*/
/*			disable();*/
		};
		
		private function seekbarStageLeave(event:Event):void{
			/*eTracer.getEventInfo(event, "seekbarStageLeave");*/
			if (isDragging) {
				processStopDrag();				
			}
		};
		
		public function enable():void{
			setVideoControlStates(uiControlArr, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.addEventListener(Event.MOUSE_LEAVE, seekbarStageLeave);
			addEventListener(MovEvent.UPDATE_PLAYHEAD, updatePlayHead, true);
		};
		
		public function disable():void{
			setVideoControlStates(uiControlArr, false);
			removeEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.removeEventListener(Event.MOUSE_LEAVE, seekbarStageLeave);
			removeEventListener(MovEvent.UPDATE_PLAYHEAD, updatePlayHead, true);
		};
		
		private function onStartDrag(event:MouseEvent):void{
/*			eTracer.getEventInfo(event, "onStartDrag");*/
			if (event.currentTarget == this) {
				isDragging = true;
				seekHead_mc.startDrag(true, bounds);
				dispatchEvent(new MovEvent(MovEvent.START_DRAG, true, false));
			}
		};
		
		private function onStopDrag(event:MouseEvent):void{
/*			eTracer.getEventInfo(event, "onStopDrag");*/
			if (isDragging) {
				processStopDrag();
			}else{
/*				trace("Don't actually onStopDrag");*/
			}
		};
		
		private function processStopDrag():void{
			trace("process onStopDrag.");
			isDragging = false;
			seekHead_mc.stopDrag();
			setPercent();
			dispatchEvent(new MovEvent(MovEvent.STOP_DRAG, true, false));
		};
		
		private function setPercent():void{
			percent = (seekHead_mc.x/trackWidth)*100;
			trace("Seekbar >> percent: " + percent);
			dispatchEvent(new MovEvent(MovEvent.PERCENT_CHANGE, true, false, percent));
		};
		
		public function updatePlayHead(p_PosPct:Number):void{
			trace("SeekBar >> p_PosPct: " + p_PosPct);
			var newPos:Number = trackWidth * p_PosPct;
			trace("SeekBar >> newPos: " + newPos);
			seekHead_mc.x = newPos;
		};
	}
}