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
		
	public class Main extends Sprite{
		private var bgLoader:Loader;
		private var bgRequest:URLRequest;
		private var preloader:Preloader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		private var contentHider:Sprite;
		private var contentRevealTween:Tween;
		
		private var testLoader1:Loader;
		private var testLoader2:Loader;
		
		public function Main(){
			preloader = new Preloader();
			bgLoader = new Loader();
			testLoader1 = new Loader();
			testLoader2 = new Loader();
			preloader.loadSite(this);
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
			/* test the preloader with a few sample images */
/*			preloader.queueItemToLoad("testloaderassets/2093869943_ea17832cfc_o.jpg", testLoader1, this);*/
/*			preloader.queueItemToLoad("testloaderassets/2093870245_1a64740b13_o.jpg", testLoader2, this);*/
			trace("Hello World");
			addChildAt(bgLoader, 0);
			addChild(contentHider);
			testLoader1.x = 10;
			testLoader1.y = 100;
			testLoader2.x = 30;
			testLoader2.y = 100;
			addChild(testLoader1);
			addChild(testLoader2);
			
			
		}
		
		public function testcallback():void{
			trace("Callback.");
		};
		
		private function garbageListener(event:Event):void{
			// Display the amount of memory occupied by this program
/*			trace("System memory used by this program: " + System.totalMemory);*/
			trace("contentRevealTween.time: " + contentRevealTween.time);
		};
		
		public function backgroundLoaded():void{
			trace("background loaded");
			contentRevealTween.start();
			trace("contentRevealTween.position: " + contentRevealTween.position);
		};
		
		public function tweenStarted(event:TweenEvent):void{
			trace("tweenStarted");
		};
		
		private function tweenFinished(event:TweenEvent):void{
			trace("tweenFinished target: " + event.target);
			removeChild(event.target.obj);
		};
	}
}