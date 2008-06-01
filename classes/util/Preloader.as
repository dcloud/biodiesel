//
//	Preloader
//
//	Created by Daniel Cloud on 2008-04-28.
//	Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.util{
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;

	public class Preloader {
		private var loaderArr:Array;
		private var refObject:Object;
		private var callback:String;
		
		private var verbose:Boolean = false;
	
		public function Preloader(){
			if(verbose) trace("Preloader created.");
			loaderArr = new Array();
		}
		
		public function queueItemToLoad(pAssetURL:String, pLoader:Loader, pReferrer:Object=null, pCallback:String=null):void{
			var newrequest:URLRequest = new URLRequest(pAssetURL);
			var currentLoader = new Array()
			currentLoader["assetURL"] = pAssetURL;
			currentLoader["loader"] = pLoader;
			currentLoader["refObject"] = pReferrer;
			currentLoader["callback"] = pCallback;
			configureListeners(currentLoader["loader"].contentLoaderInfo);
			currentLoader["loader"].load(newrequest);
			
			loaderArr.push(currentLoader);
		};
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}

		private function completeHandler(event:Event):void {
/*			trace("completeHandler: " + event.target);*/
			var arrayPos = findLoaderInArray(event.target.loader);
			if (arrayPos is int) {
/*				trace("loaderArr[" + arrayPos + "][assetURL] is " + loaderArr[arrayPos]["assetURL"]);*/
				if (loaderArr[arrayPos]["refObject"] && loaderArr[arrayPos]["callback"]) {
/*					trace("loaderArr["+ arrayPos +"][callback] is " + loaderArr[arrayPos]["callback"]);*/
					loaderArr[arrayPos]["refObject"][loaderArr[arrayPos]["callback"]]();
				}
			}else{
/*				if(verbose) trace("loader is not in array");*/
			}
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void {
/*			if(verbose) trace("httpStatusHandler: " + event);*/
		}

		private function initHandler(event:Event):void {
/*			if(verbose) trace("initHandler: " + event);
			if(verbose) trace("event.target: " + event.target);
			if(verbose) trace("event.target.loader.callback = " + event.target.loader.callback);
*/		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			if(verbose) trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void {
			if(verbose) trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			if(verbose) trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}

		private function unLoadHandler(event:Event):void {
			if(verbose) trace("unLoadHandler: " + event);
		}
		
		private function findLoaderInArray(pLoader:Loader):*{
			for ( var j:int=0; j<loaderArr.length; j++ ) {
				if (loaderArr[j].loader == pLoader) {
					return j;
					break;
				}
			};
			return false;
		};
	}	
}

import flash.net.URLRequest;

internal class loadHandle {
	private var urlRequest:URLRequest;
	private var callback:String; 
	function loadHandle(pURL:String){
		urlRequest = new URLRequest(pURL);
	}
}