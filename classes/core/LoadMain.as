//
//  LoadMain
//	For loading main.swf and having a preloader
//
//  Created by Daniel Cloud on 2008-05-25.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.core{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.text.TextField;;
	import flash.events.*;
	import flash.net.URLRequest;
	
	public class LoadMain extends Sprite{
		private var loadSite:Loader;
		private var siteURL:URLRequest;
		private const siteSwf:String = "main.swf";
		private var loadbarFullWidth:Number;
		private var	verbose:Boolean;
		
		function LoadMain(){
			verbose = true;
			siteURL = new URLRequest(siteSwf);
			loadSite = new Loader();
			configureListeners(loadSite.contentLoaderInfo);
			loadSite.load(siteURL);
			addChild(loadSite);
			// Set properties of our preloader bar and textfield
			loadbarFullWidth = loadbar_mc.width;
			loadbar_mc.width = 0;
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
/*			dispatcher.addEventListener(Event.OPEN, openHandler);*/
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function completeHandler(event:Event):void {
            if(verbose) trace("LoadMain >> completeHandler: " + event);
/*			removeChild(loadbar_mc);*/
			loadbar_mc.visible = false;
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            if(verbose) trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            if(verbose) trace("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            if(verbose) trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
/*            if(verbose) trace("openHandler: " + event);*/
      }

        private function progressHandler(event:ProgressEvent):void {
          if(verbose) trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			var loadRatio:Number = event.bytesLoaded/event.bytesTotal;
			var loadPct:Number = Math.floor(loadRatio*100);

			loadbar_mc.width = loadbarFullWidth * loadRatio;
 			if(verbose) trace("initHandler: loadbar_mc.width=" + loadbar_mc.width);
       }

        private function unLoadHandler(event:Event):void {
			if(verbose) trace("unLoadHandler: " + event);
        }
	}
        
}
