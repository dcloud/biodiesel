//
//  VideoPane
//
//  Created by Daniel Cloud on 2008-06-09.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.view{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.events.*;
	
	public class VideoPane extends Sprite{
		private var introTxt:String;
		private var playerLdr:Loader;
		private var videoURL:String;
		
		private var verbose:Boolean = false;
		/*
			Author time elements 
			intro_tf:TextField;
			
			Loader should be placed at x:10, y:40 
			based on visual guide created at author time
		*/
		public function VideoPane(p_playerLoader:Loader, p_video:String, p_text:String=""){
			if (verbose) trace("Video: " + p_video + " will load after player is initialized.");
			playerLdr = p_playerLoader;
			configureLoaderInfoListeners();
			videoURL = p_video;
			this.text = p_text;
		}
		
		private function configureLoaderInfoListeners(){
			playerLdr.contentLoaderInfo.addEventListener(Event.INIT , playerInitialized);
			playerLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			playerLdr.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusEventHandler);
/*			playerLdr.contentLoaderInfo.addEventListener();*/
		}
		
		private function playerInitialized(e:Event):void{
			if (verbose) {
				trace("player initialized");
				trace(e);
			}
			positionAndDisplayPlayer();
			e.target.content.source = videoURL;
		};
		
		private function ioErrorHandler(e:Event):void{
			if (verbose) trace(e);
		};
		
		private function httpStatusEventHandler(e:Event):void{
			if (verbose) trace(e);
		};
		
		private function positionAndDisplayPlayer():void{
			playerLdr.x = 10;
			playerLdr.y = 40;
			this.addChild(playerLdr);
		};
		
		public function set text(p_text:String):void{
			introTxt = p_text;
			intro_tf.text = introTxt;
		};
		
		public function get text():String{
			return introTxt;
		};
		
		public function set reset(p_Reset:Boolean):void{
			if (p_Reset) {
				// reinitialize the video
				if ("reset" in playerLdr.content) {
					Object(playerLdr.content).reset = p_Reset;
				}
			}
		};
	}
}
