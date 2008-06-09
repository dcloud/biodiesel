//
//	Preloader (visual)
//
//	Created by Daniel Cloud on 2008-04-28.
//	Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.util{
	import flash.display.Loader;
    import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.Font;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import classes.util.PreloaderEvent;

	public class Preloader extends Sprite{
		private var loaderArr:Array;
		private var refObject:Object;
		private var hidden:Boolean;

		private var allBytesLoaded:Number;
		private var allBytesTotal:Number;
		
/*		private var loading_tf:TextField;*/
		
/*		private var contentHider_sp:Sprite;*/
		private var contentRevealTween:Tween;
		
		private var verbose:Boolean = false;
		
		// can specify whether the Preloader is visible when created: default is true
		public function Preloader(p_startVisible=true){
			if(verbose) trace("Preloader created.");
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for ( var i=0; i<embeddedFonts.length; i++ ) {
				if(verbose) trace("Preloader >> embeddedFonts[" + i + "]: " + embeddedFonts[i].fontName + " type: " + embeddedFonts[i].fontType);
			};
/*			loading_tf = createTextLabel(0x333333, embeddedFonts[1].fontName);*/
			loading_tf.autoSize = TextFieldAutoSize.LEFT;
			
			allBytesLoaded = 0;
			allBytesTotal = 0;
			
			if (p_startVisible) {
/*				contentHider_sp = new Sprite();*/
/*				contentHider_sp.alpha = 1;*/
				hidden = true;
			}
			
			loaderArr = new Array();
			
			addEventListener(Event.ADDED_TO_STAGE, stageAdd);
		}
		
		private function stageAdd(e:Event):void{
			if (verbose) trace("Preloader >> stageAdd >> e: " + e);
/*			contentHider_sp.graphics.beginFill(0xF1EFDE);
			contentHider_sp.graphics.drawRect(0,0, this.stage.stageWidth, this.stage.stageHeight);
			addChild(contentHider_sp);
*/			
			loading_tf.x = this.stage.stageWidth/2 - loading_tf.width/2;
			loading_tf.y = this.stage.stageHeight/2 - loading_tf.height/2;
			addChild(loading_tf);
			
			contentRevealTween = new Tween(contentHider_sp, "alpha", Regular.easeOut, contentHider_sp.alpha, contentHider_sp.alpha, 1.6, true);
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
		// allow someone to resize the preloader area without scaling the textField inside
		public function resize(p_width:Number, p_height:Number):void{
			contentHider_sp.width = p_width;
			contentHider_sp.height = p_height;
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
			dispatchEvent(new PreloaderEvent(PreloaderEvent.CONTENT_INIT, true, false, event.target));
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			if(verbose) trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void {
			if(verbose) trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			setLoadingText();
			if(verbose) {
/*				trace("progressHandler: target=" + event.target + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);*/
			}
		}
		
		// not used currently...
		private function setAllBytesNumbers():void{
			allBytesLoaded = 0;
			allBytesTotal = 0;
			
			for ( var n=0; n<loaderArr.length; n++ ) {
				allBytesLoaded += loaderArr[n]["loader"].contentLoaderInfo.bytesLoaded;
				allBytesTotal += loaderArr[n]["loader"].contentLoaderInfo.bytesTotal;
			};
			if (verbose) {
				trace("allBytesLoaded=" + allBytesLoaded + "  allBytesTotal=" + allBytesTotal);
			}
		};

		private function setLoadingText():void{
			var loadingStatus:String = "";
			for ( var m=0; m<loaderArr.length; m++ ) {
				var assetLoadedBytes:Number = loaderArr[m]["loader"].contentLoaderInfo.bytesLoaded;
				var assetLoadedTotal:Number = loaderArr[m]["loader"].contentLoaderInfo.bytesTotal;
				var assetLoadedPct:Number = Math.floor(assetLoadedBytes/assetLoadedTotal *100);
				loadingStatus += "Loading asset " + (m+1) + " of " + loaderArr.length + ": " + assetLoadedPct + "%\n";
			};
			loading_tf.text = loadingStatus;
			loading_tf.x = this.width/2 - loading_tf.width/2;
			loading_tf.y = (this.height/5)*2;
			if(verbose) {
				traceTfInfo();
			}
		};
		
		private function unLoadHandler(event:Event):void {
			if(verbose) trace("unLoadHandler: " + event);
		}
		
		private function hideContent():void{
			contentRevealTween.begin = contentHider_sp.alpha;
			contentRevealTween.finish = 1;
			contentRevealTween.start();
		};
		
		private function revealContent():void{
			contentRevealTween.begin = contentHider_sp.alpha;
			contentRevealTween.finish = 0;
			contentRevealTween.start();
		};
		
		private function tweenStarted(event:TweenEvent):void{
			if(verbose) {
				trace("revealContent tween started");
			}
			if(contentHider_sp.alpha == 0){
				contentHider_sp.visible = true;
				loading_tf.visible = true;
			}else{
				loading_tf.visible = false;
			}
		};
		
		private function tweenFinished(event:TweenEvent):void{
			if(verbose) {
				trace("revealContent tween finished");
			}
			if(contentHider_sp.alpha == 0){
				contentHider_sp.visible = false;
				hidden = false;
				loading_tf.text = "";
				dispatchEvent(new PreloaderEvent(PreloaderEvent.CONTENT_REVEALED, true, false));
			}else{
				contentHider_sp.visible = true;
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
		
		private function traceTfInfo():void{
			trace("loading_tf's index: " + getChildIndex(loading_tf));
			trace("contentHider_sp's index: " + getChildIndex(contentHider_sp));
			trace("loading_tf.visible: " + loading_tf.visible);
			trace("loading_tf.text: " + loading_tf.text);
			trace("loading_tf.x: " + loading_tf.x);
			trace("loading_tf.y: " + loading_tf.y);
    		trace("loading_tf.autoSize: " + loading_tf.autoSize);
			trace("loading_tf.width: " + loading_tf.width);
    		trace("loading_tf.height: " + loading_tf.height);
    		trace("loading_tf.textWidth: " + loading_tf.textWidth);
			trace("loading_tf.textHeight: " + loading_tf.textHeight);
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