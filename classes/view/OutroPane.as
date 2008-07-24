/*
*	OutroPane
*	Description: 
*	
*	Created by Daniel Cloud on 2008-07-24.
*	Copyright (c) 2008 Daniel Cloud. All rights reserved.
*/

package classes.view {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.*;
	import flash.display.Bitmap;
    import flash.display.BitmapData;	
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.*;
	
	public class OutroPane extends Sprite{
		/*
			Author time elements 
			outro_tf:TextField;
			photoFrame_sp:MovieClip
		*/
		private var loader:Loader;
		private var scrollTimer:Timer;
		private var scrollDown:Boolean;
		private var scrollLines:int;

		private var verbose:Boolean = false;
				
		public function OutroPane(p_text:String, p_loader:Loader){
			setText(p_text);
			loader = p_loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
			scrollDown = true;
			scrollLines = 1;
			
			scrollUp_btn.buttonMode = true;
			scrollDown_btn.buttonMode = true;
			
			scrollUp_btn.addEventListener(MouseEvent.MOUSE_DOWN, scrollUpHandler);	
			scrollDown_btn.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
			scrollUp_btn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);	
			scrollDown_btn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);	
			scrollTimer = new Timer(300,0);
			scrollTimer.addEventListener(TimerEvent.TIMER, timeToScroll);	
		}
	
		private function scrollUpHandler(e:MouseEvent):void{
			if (verbose) trace("scroll the text up");
			scrollDown = false;
			scrollText();
			scrollTimer.start();
		};
	
		private function stopScroll(e:MouseEvent):void{
			scrollTimer.reset();
			scrollLines = 1;
		};
	
		private function scrollDownHandler(e:MouseEvent):void{
			if (verbose) trace("scroll the text down");
			scrollDown = true;
			scrollText();
			scrollTimer.start();
		};
	
		private function timeToScroll(e:TimerEvent):void{
			switch ( scrollTimer.currentCount ) {
				case (6) :
					scrollLines = 2;
					break;
				case (8) :
					scrollLines = 4;
					break;
				case (10) :
					scrollLines = 8;
					break;
				default:
					break;
			}
			scrollText();
			if (verbose) {
				trace("scrollTimer.currentCount: " + scrollTimer.currentCount);
				trace("scrollLines: " + scrollLines);
				trace("outro_tf.scrollV: " + outro_tf.scrollV);
				trace("outro_tf.maxScrollV: " + outro_tf.maxScrollV);
			}
		};
	
		private function scrollText():void{
			if (scrollDown) {
				outro_tf.scrollV += scrollLines;
			}else{
				outro_tf.scrollV -= scrollLines;
			}
		};

		public function setText(p_text:String):void{
			outro_tf.text = p_text;
		};
		
		private function completeHandler(event:Event):void{
			var loader:Loader = Loader(event.target.loader);
            var image:Bitmap = Bitmap(loader.content);
			image.smoothing = true;
			photoFrame_sp.addChild(image);
		};
	}
}