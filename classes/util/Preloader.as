//
//	Preloader (visual)
//
//	Created by Daniel Cloud on 2008-04-28.
//	Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.util{
	import flash.display.Loader;
    import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.*;
	import flash.net.URLRequest;

	public class Preloader extends Sprite{
		private var loaderArr:Array;
		private var refObject:Object;
		private var hidden:Boolean;

		private var contentHider:Sprite;
		private var contentRevealTween:Tween;
		
		private var verbose:Boolean = true;
		
		// can specify whether the Preloader is visible when created: default is true
		public function Preloader(p_startVisible=true){
			if(verbose) trace("Preloader created.");
			if (p_startVisible) {
				contentHider = new Sprite();
				contentHider.alpha = 1;
				hidden = true;
			}
			
			loaderArr = new Array();
			
			addEventListener(Event.ADDED_TO_STAGE, stageAdd);
		}
		
		private function stageAdd(e:Event):void{
			if (verbose) trace("Preloader >> stageAdd >> e: " + e);
			contentHider.graphics.beginFill(0xF1EFDE);
			contentHider.graphics.drawRect(0,0, this.stage.stageWidth, this.stage.stageHeight);
			addChild(contentHider);
			
			contentRevealTween = new Tween(contentHider, "alpha", Regular.easeOut, contentHider.alpha, contentHider.alpha, 1.6, true);
			contentRevealTween.fforward();
			contentRevealTween.addEventListener(TweenEvent.MOTION_START, tweenStarted);
			contentRevealTween.addEventListener(TweenEvent.MOTION_RESUME, tweenStarted);
			contentRevealTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinished);
		};
		
		public function queueItemToLoad(pAssetURL:String, pLoader:Loader, pHideContent:Boolean=false):void{
			var newrequest:URLRequest = new URLRequest(pAssetURL);
			var currentLoader = new Array()
			currentLoader["assetURL"] = pAssetURL;
			currentLoader["loader"] = pLoader;
			currentLoader["hideContent"] = pHideContent;
			configureListeners(currentLoader["loader"].contentLoaderInfo);
			currentLoader["loader"].load(newrequest);
			
			loaderArr.push(currentLoader);
			if(!hidden && currentLoader["hideContent"]){
				hideContent();
			}
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
			var arrayPos = findLoaderInArray(event.target.loader);
			var stayHidden = setHiddenStatus();
			loaderArr.splice(arrayPos, 1);
			if (verbose) trace("completeHandler >> loaderArr.length: " + loaderArr.length);
			// If no loader needs content to stay hidden, then reveal content
			if ( !stayHidden || (loaderArr.length < 1) ) {
				revealContent();
			}
		}
		
		// find out if any loaded in array needs content hidden
		private function setHiddenStatus():Boolean{
			for ( var j:int=0; j<loaderArr.length; j++ ) {
				if (loaderArr[j]["hideContent"] == true) {
					return true;
				}
			};
			return false;
		};
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
/*			if(verbose) trace("httpStatusHandler: " + event);*/
		}

		private function initHandler(event:Event):void {
			if(verbose) trace("initHandler: " + event);
			if(verbose) trace("event.target: " + event.target);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			if(verbose) trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void {
			if(verbose) trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			if(verbose) {
				trace("progressHandler: target=" + event.target + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			}
		}

		private function unLoadHandler(event:Event):void {
			if(verbose) trace("unLoadHandler: " + event);
		}
		
		private function hideContent():void{
			contentRevealTween.begin = contentHider.alpha;
			contentRevealTween.finish = 1;
			contentRevealTween.start();
		};
		
		private function revealContent():void{
			contentRevealTween.begin = contentHider.alpha;
			contentRevealTween.finish = 0;
			contentRevealTween.start();
		};
		
		private function tweenStarted(event:TweenEvent):void{
			if(verbose) trace("revealContent tween started");
			if(contentHider.alpha == 0){
				contentHider.visible = true;
			}
		};
		
		private function tweenFinished(event:TweenEvent):void{
			if(verbose) trace("revealContent tween finished");
			if(contentHider.alpha == 0){
				contentHider.visible = false;
				hidden = false;
			}else{
				contentHider.visible = true;
				hidden = true;
			}
		};
		
		private function findLoaderInArray(pLoader:Loader):*{
			if(verbose) trace("PreLoader >> findLoaderInArray-> pLoader.name: " + pLoader.name);
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