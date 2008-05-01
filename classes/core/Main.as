package classes.core{
	import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	import classes.util.Preloader;
		
	public class Main extends Sprite{
		private var bgLoader:Loader;
		private var bgRequest:URLRequest;
		private var preloader:Preloader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		
		private var testLoader1:Loader;
		private var testLoader2:Loader;
		
		public function Main(){
			preloader = new Preloader();
			bgLoader = new Loader();
			testLoader1 = new Loader();
			testLoader2 = new Loader();
			preloader.loadSite(this);
			preloader.queueItemToLoad(bgURL, bgLoader, this, "testcallback");
			preloader.queueItemToLoad("testloaderassets/2093869943_ea17832cfc_o.jpg", testLoader1, this);
			preloader.queueItemToLoad("testloaderassets/2093870245_1a64740b13_o.jpg", testLoader2, this);
/*			bgRequest = new URLRequest(bgURL);
			bgLoader.load(bgRequest);
*/			trace("Hello World");
			addChildAt(bgLoader, 0);
			/* test the preloader with a few sample images */
			testLoader1.x = 10;
			testLoader1.y = 10;
			testLoader2.x = 30;
			testLoader2.y =10;
			addChild(testLoader1);
			addChild(testLoader2);
			
			
		}
		
		public function testcallback():void{
			trace("Callback.");
		};
	}
}