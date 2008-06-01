package classes.core{
	import flash.display.Loader;
    import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
    import flash.events.*;
	import flash.system.System;
    import flash.net.URLRequest;
	
	import classes.util.Preloader;
	import classes.util.SiteXML;
	import classes.ui.NavButton;
		
	public class Main extends Sprite{
		private var getSiteXML:SiteXML;
		private var sitexmlURL:String = "assets/xml/siteinfo.xml";
		private var siteInfo:XML;
		
		private var bgLoader:Loader;
		private var bgRequest:URLRequest;
		private var preloader:Preloader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		private var contentHider:Sprite;
		private var contentRevealTween:Tween;
		
		private var buttonArray:Array;
		
		private var verbose:Boolean = true;
		
		
		private var testLoader1:Loader;
		private var testLoader2:Loader;
		
		public function Main(){
			addEventListener(MouseEvent.CLICK, handleMouseClick);
			if(verbose) trace("Hello World");
			getSiteXML = new SiteXML(sitexmlURL, this);
			getSiteXML.addEventListener(Event.COMPLETE, siteXMLLoadedHandler);
			
			preloader = new Preloader();
			bgLoader = new Loader();
			
			testLoader1 = new Loader();
			testLoader2 = new Loader();

			contentHider = new Sprite();
			contentHider.graphics.beginFill(0xF1EFDE);
			contentHider.graphics.drawRect(0,0, this.stage.stageWidth, this.stage.stageHeight);
			contentRevealTween = new Tween(contentHider, "alpha", Regular.easeOut, 100, 0, 1.5, true);
			contentRevealTween.stop();
			contentRevealTween.rewind();
			contentRevealTween.addEventListener(TweenEvent.MOTION_START, tweenStarted);
			contentRevealTween.addEventListener(TweenEvent.MOTION_RESUME, tweenStarted);
			contentRevealTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinished);
			
			preloader.queueItemToLoad(bgURL, bgLoader, this, "backgroundLoaded");
			addChildAt(bgLoader, 0);
			/* test the preloader with a few sample images */
			preloader.queueItemToLoad("testloaderassets/2093869943_ea17832cfc_o.jpg", testLoader1, this);
			preloader.queueItemToLoad("testloaderassets/2093870245_1a64740b13_o.jpg", testLoader2, this);
			testLoader1.x = 10;
			testLoader1.y = 100;
			testLoader2.x = 30;
			testLoader2.y = 100;
			addChild(testLoader1);
			addChild(testLoader2);
			
			addChild(contentHider);
		};
		
		public function testcallback():void{
			if(verbose) trace("Callback.");
		};
		
		private function garbageListener(event:Event):void{
			// Display the amount of memory occupied by this program
/*			trace("System memory used by this program: " + System.totalMemory);*/
			if(verbose) trace("contentRevealTween.time: " + contentRevealTween.time);
		};
		
		private function siteXMLLoadedHandler(e:Event):void{
			if (verbose) trace("siteXMLLoadedHandler: " + e);
			if (verbose) trace("e.target.xml.attribute('url'): " + e.target.xml.attribute("url"));
			siteInfo = new XML();
			siteInfo = e.target.xml;
			if (siteInfo) {
				trace("siteInfo: " + siteInfo.toXMLString());
				createNavButtons();
			}else{
				if (verbose) trace("XML was not loaded, so can't generate rest of the site.");
			}
		};
		
		// Create buttons (after XML has been loaded)
		private function createNavButtons():void{
			buttonArray = new Array();
			var j:int =0;
			for each ( var section:XML in siteInfo.sections.section ){
				trace("section.title: " + section.title);
				var newButton = new NavButton(section.title);
				newButton.name = "button" + j;
				buttonArray[j] = newButton;
				if (j == 0) {
					buttonArray[j].x = 200;
				}else{
					buttonArray[j].x += buttonArray[j-1].x + buttonArray[j-1].width + 40;
					
				}
				buttonArray[j].y = 30;
				addChildAt(buttonArray[j], getChildIndex(contentHider));
				j++;
			};
		};
		
		private function handleMouseClick(e:MouseEvent):void{
			if(verbose) trace("handleMouseClick e: " + e);
			if (e.target instanceof NavButton) {
				if(verbose) trace("e.target is NavButton");
				if(verbose) trace("e.target.id: " + e.target.id);
			}else{
				if(verbose) trace("e.target NOT NavButton");
			}
		};
		
		public function backgroundLoaded():void{
			if(verbose) trace("background loaded");
			contentRevealTween.start();
			if(verbose) trace("contentRevealTween.position: " + contentRevealTween.position);
		};
		
		public function tweenStarted(event:TweenEvent):void{
			if(verbose) trace("tweenStarted");
		};
		
		private function tweenFinished(event:TweenEvent):void{
			if(verbose) trace("tweenFinished target: " + event.target);
			removeChild(event.target.obj);
		};
	}
}