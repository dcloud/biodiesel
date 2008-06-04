package classes.core{
	import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	
	import classes.util.Preloader;
	import classes.util.SiteXML;
	import classes.ui.NavButton;
		
	public class Main extends Sprite{
		private const topMargin:Number = 85; // a design decision has everything at y= topMargin or lower
		
		private var getSiteXML:SiteXML;
		private var sitexmlURL:String = "assets/xml/siteinfo.xml";
		private var siteInfo:XML;
		
		private var siteURL:String;
		private var assetsURLs:Object;
		private var loadedAssets:Array;
		
		private var bgLoader:Loader;
		private var bgRequest:URLRequest;
		private var preloader:Preloader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		
		private var buttonArray:Array;
		
		private var verbose:Boolean = true;
		
		public function Main(){
			preloader = new Preloader();
			preloader.addEventListener(Event.INIT, preloadedItemInit);
			
			addEventListener(MouseEvent.CLICK, handleMouseClick);
			addEventListener(Event.ADDED, displayListAdd);
			if(verbose) trace("Hello World");
			getSiteXML = new SiteXML(sitexmlURL, this);
			getSiteXML.addEventListener(Event.COMPLETE, siteXMLLoadedHandler);
						
			bgLoader = new Loader();
						
			assetsURLs = new Object();
			loadedAssets = new Array();
			
			addChildAt(bgLoader, 0);
			addChild(preloader);
			preloader.queueItemToLoad(bgURL, bgLoader, true);
		};
		
		private function siteXMLLoadedHandler(e:Event):void{
			if (verbose) trace("siteXMLLoadedHandler: " + e);
			if (verbose) trace("e.target.xml.attribute('url'): " + e.target.xml.attribute("url"));
			siteInfo = new XML();
			siteInfo = e.target.xml;
			if (siteInfo) {
				createNavButtons();
				getURLInfo();
			}else{
				if (verbose) trace("XML was not loaded, so can't generate rest of the site.");
			}
		};
		
		private function displayListAdd(e:Event):void{
		};
		
		// Get url info for this site
		private function getURLInfo():void{
			siteURL = siteInfo.@url ? siteInfo.@url : null;
			if (verbose) trace("siteURL: " + siteURL);
			if(siteInfo.info.assets.asset){
				if (verbose) trace("siteInfo has assets urls. Save in object");
				for each ( var item:XML in siteInfo.info.assets.asset){
					if (verbose) {
						trace("asset url: " + item.@url);
					}
					assetsURLs[item.@medium] = siteInfo.info.assets.@url + item.@url;
					if (verbose) trace("assetsURLs[" + item.@medium + "] " + assetsURLs[item.@medium]);
				};
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
				var preloaderIndex:int = getChildIndex(preloader);
				addChildAt(buttonArray[j], preloaderIndex);
				if (verbose) {
					trace("preloaderIndex before addChild: " + preloaderIndex);
					trace("preloader index after addChild: " + getChildIndex(preloader));
					trace("buttonArray[j] index: " + getChildIndex(buttonArray[j]));
					trace("numChildren: " + this.numChildren);
				}
				j++;
			};
		};
		
		private function handleMouseClick(e:MouseEvent):void{
			if(verbose) trace("handleMouseClick e: " + e);
			if (e.target is NavButton) {
				if(verbose) {
					trace("e.target is NavButton");
					trace("e.target.id: " + e.target.id);
					trace("Load: " + siteInfo.sections.section.(title == e.target.id).content.url);
				}
				loadSectionContent(e.target.id);
			}else{
				if(verbose) trace("e.target NOT NavButton");
			}
		};
		
		private function loadSectionContent(p_contentID):void{
			var sectionInfo:XMLList = siteInfo.sections.section.(title == p_contentID);
			if (verbose) {
				trace("sectionInfo.content.url: " + sectionInfo.content.url);
				trace("sectionInfo.content.length: " + sectionInfo.content.length);
			}
			if (sectionInfo.content.@loc.toString() == "external") {
				if (verbose) trace("external content");
				var tmpLoader:Loader = new Loader();
				var assetloc:String = assetsURLs[sectionInfo.content.@medium];
				var tmpURL:String = assetloc + sectionInfo.content.url;
				trace("tmpURL: " + tmpURL);
				loadedAssets.push(tmpLoader);
				loadedAssets[loadedAssets.length -1].y = topMargin;
				var topPosition:uint = this.numChildren - 1;
				setChildIndex( preloader, topPosition);
				addChildAt( loadedAssets[loadedAssets.length -1], getChildIndex(preloader) );
				preloader.queueItemToLoad(tmpURL, loadedAssets[loadedAssets.length -1], true);
			}else{
				// handle non-external content?!?
			}
			
		};
		
		public function preloadedItemInit():void{
			if (verbose) trace("preloadedItemInit");
		};
		
	}
}