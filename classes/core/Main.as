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
	import classes.ui.NavButton;
		
	public class Main extends Sprite{
		private var bgLoader:Loader;
		private var bgRequest:URLRequest;
		private var preloader:Preloader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		private var contentHider:Sprite;
		private var contentRevealTween:Tween;
		
		private var buttonArray:Array;
		
		private var tmpNameArr:Array;
		
		private var testLoader1:Loader;
		private var testLoader2:Loader;
		
		public function Main(){
			trace("Hello World");
			// temp name array should be replaced when XML loader is added
			tmpNameArr = ["Introduction", "Making Biodiesel", "Sustainable Biodiesel", "Comparing Alternatives"];
			
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
			
			// Create buttons
			buttonArray = new Array();
			for ( var j=0; j<tmpNameArr.length; j++ ) {
				var newButton = new NavButton(tmpNameArr[j]);
				newButton.name = "button" + j;
				buttonArray[j] = newButton;
			};
			
			for ( var b=0; b<buttonArray.length; b++ ) {
				if (b ==0) {
					buttonArray[b].x = 200;
				}else{
					buttonArray[b].x += buttonArray[b-1].x + buttonArray[b-1].width + 40;
				}
				buttonArray[b].y = 30;
				addChild(buttonArray[b]);
			};
			
/*			testButton = new NavButton("Sustainable Biodiesel");
			addChild(testButton);
			testButton.x = 100;
			testButton.y = 100;
			tst2 = new NavButton("Making Biodiesel");
			addChild(tst2);
			tst2.x = 100;
			tst2.y = 140;
*/			
			addChild(contentHider);
		};
		
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