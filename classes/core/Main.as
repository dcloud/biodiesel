package classes.core{
	import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	
	import classes.util.Preloader;
	import classes.util.PreloaderEvent;
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
		
		private var preloader:Preloader;
	
		private var bgLoader:Loader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		
		private var overlayLdr:Loader
		private var overlayURL = "assets/img/overlay_texture.jpg"
		
		private var buttonArray:Array;
		
		private var verbose:Boolean = true;
		
		public function Main(){
			preloader = new Preloader();
			preloader.addEventListener(PreloaderEvent.CONTENT_INIT, preloadedItemInit);
			
			addEventListener(MouseEvent.CLICK, handleMouseClick);
			addEventListener(Event.ADDED, displayListAdd);
			if(verbose) trace("Hello World");
			getSiteXML = new SiteXML(sitexmlURL, this);
			getSiteXML.addEventListener(Event.COMPLETE, siteXMLLoadedHandler);
						
			bgLoader = new Loader();
			overlayLdr = new Loader();
						
			assetsURLs = new Object();
			loadedAssets = new Array();
			
			addChildAt(bgLoader, 0);
			overlayLdr.y= topMargin;
			addChild(overlayLdr);
			addChild(preloader);
			preloader.queueItemToLoad(bgURL, bgLoader, true);
			preloader.queueItemToLoad(overlayURL, overlayLdr, true);
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
				buttonArray[j].y = 40;
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
		
		// Need to work on contentLoaderInfo...
		public function preloadedItemInit(e:PreloaderEvent):void{
			if (verbose) {
				trace("preloadedItemInit >> target: " + e.target);
				trace("preloadedItemInit >> loaderInfo: " + e.loaderInfo);
				trace("preloadedItemInit >> loaderInfo.contentType: " + e.loaderInfo.contentType);
				trace("preloadedItemInit >> loaderInfo.content has absoluteURL: " +("absoluteURL" in e.loaderInfo.content));
				trace("preloadedItemInit >> loaderInfo.url: " + e.loaderInfo.url);
			}
/*			var fileURL: String = e.loaderInfo.url;
			var fileNamePattern:RegExp = /\w+\.swf/;
			var fileNamePos:int = fileURL.search(fileNamePattern);
			var filePath:String = fileURL.slice(0,fileNamePos);
			if (verbose) {
				trace("preloadedItemInit >> fileNamePos: " + fileNamePos);
				trace("preloadedItemInit >> filePath: " + filePath);
			}
*/			// If we are loading an external swf, attempt to give it an absolute url 
			// so it knows where to find its assets.
			if (e.loaderInfo.contentType == "application/x-shockwave-flash" && "absoluteURL" in e.loaderInfo.content) {
				var filePath:String = getSWFLocation(e.loaderInfo.url)
				e.loaderInfo.content.absoluteURL = filePath;
			}
		};
		
		// using a contentLoader url, find the swf filename, split it off and get its absolute url
		private function getSWFLocation(p_SwfURL:String):String{
			var swfURL:String = p_SwfURL;
			var swfNamePattern:RegExp = /\w+\.swf/;
			var swfNamePos:int = swfURL.search(swfNamePattern);
			var swfPath:String = swfURL.slice(0,swfNamePos);
			if (verbose) {
				trace("getSWFLocation >> swfNamePos: " + swfNamePos);
				trace("getSWFLocation >> swfPath: " + swfPath);
			}
			return swfPath;
		};
		
	}
}