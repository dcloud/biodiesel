﻿package classes.core{
	import flash.display.DisplayObject;
	import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	
	import classes.util.Preloader;
	import classes.util.PreloaderEvent;
	import classes.util.SiteXML;
	import classes.ui.NavButton;
	import classes.view.IntroPane;
	import classes.view.OutroPane;
	import classes.view.VideoPane;
		
	public class Main extends Sprite{
		private const topMargin:Number = 85; // a design decision has everything at y= topMargin or lower
		
		private var getSiteXML:SiteXML;
		private var sitexmlURL:String = "assets/xml/siteinfo.xml";
		private var siteInfo:XML;
		
		private var siteURL:String;
		private var assetsURLs:Object;
		private var loadedAssets:Object;
		
		private var preloader:Preloader;
		private var introPane:IntroPane;
		private var outroPane:OutroPane;
		private var videoPane:VideoPane;
	
		private var bgLoader:Loader;
		private var bgURL:String = "assets/img/bg_texture.jpg";
		
		private var overlayLdr:Loader
		private var overlayURL = "assets/img/overlay_texture.jpg"
		
		private var buttonArray:Array;
		
		private var verbose:Boolean = false;
		
		public function Main(){
			if(verbose) trace("Hello World");
			addEventListener(MouseEvent.CLICK, handleMouseClick);
			addEventListener(Event.ADDED, displayListAdd);

			preloader = new Preloader();
			preloader.addEventListener(PreloaderEvent.CONTENT_INIT, preloadedItemInit);
			preloader.addEventListener(PreloaderEvent.CONTENT_REVEALED, contentRevealedHandler);
			
			getSiteXML = new SiteXML(sitexmlURL, this);
			getSiteXML.addEventListener(Event.COMPLETE, siteXMLLoadedHandler);
						
			bgLoader = new Loader();
			overlayLdr = new Loader();
						
			assetsURLs = new Object();
			loadedAssets = new Object();
						
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
				getURLInfo();
				loadIntroPane(siteInfo.sections.section.(title=="Introduction"));
				loadOutroPane(siteInfo.sections.section.(title=="Looking Ahead"));
				createNavButtons();
				showSectionContent("Introduction");
				markCurrentSection("Introduction");
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
					if (true) {
						trace("asset url: " + item.@url);
					}
					assetsURLs[item.@medium] = siteInfo.info.assets.@url + item.@url;
					if (verbose) trace("assetsURLs[" + item.@medium + "] " + assetsURLs[item.@medium]);
				};
			}
		};
		
		//This will place an object at the top the the display index, though
		// still under the preloader, which should always be on top
		private function putAtTopOfDisplayIndex(p_Object:DisplayObject):void{
			addChild(preloader); // ensure preloader is at top of display list.
			var preloaderIndex:int = getChildIndex(preloader);
			addChildAt(p_Object, preloaderIndex);
			if (verbose) {
				trace("preloaderIndex before addChild: " + preloaderIndex);
				trace("preloader index after addChild: " + getChildIndex(preloader));
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
					buttonArray[j].x = 210;
				}else{
					buttonArray[j].x += buttonArray[j-1].x + buttonArray[j-1].width + 55;
					
				}
				buttonArray[j].y = 25;
				putAtTopOfDisplayIndex(buttonArray[j]);
/*				var preloaderIndex:int = getChildIndex(preloader);
				addChildAt(buttonArray[j], preloaderIndex);
*/				if (verbose) {
					trace("buttonArray[j] index: " + getChildIndex(buttonArray[j]));
					trace("numChildren: " + this.numChildren);
				}
				j++;
			};
		};
		
		// Currently does something only if a NavButton is an event target
		private function handleMouseClick(e:MouseEvent):void{
			if(verbose) trace("handleMouseClick e: " + e);
			if (e.target is NavButton) {
				if(verbose) {
					trace("e.target is NavButton");
					trace("e.target.id: " + e.target.id);
				}
				if (loadedAssets[e.target.id]) {
					if (verbose) {
						trace("loadedAssets[e.target.id] already exists.");
					}
					showSectionContent(e.target.id);
				}else{
					loadSectionContent(e.target.id);
				}
				resetNonCurrentSections(e.target.id);
				markCurrentSection(e.target.id);
			}else{
				if(verbose) trace("e.target NOT NavButton");
			}
		};
		
		// This is run if content is not yet loaded
		private function loadSectionContent(p_contentID):void{
			var sectionInfo:XMLList = siteInfo.sections.section.(title == p_contentID);
			if (verbose) {
				trace("sectionInfo.type: " + sectionInfo.type);
				trace("sectionInfo.content.url: " + sectionInfo.content.url);
			}
			switch ( sectionInfo.type.toString() ) {
				case "InfographicPane" :
					loadInfographicPane(sectionInfo);
					break;
				case "VideoPane" :
					loadVideoPane(sectionInfo);
					break;
				case "IntroPane" :
					loadIntroPane(sectionInfo);
					break;
				case "AlternativePane" :
					loadInfographicPane(sectionInfo);
					break;
				default:
					trace("Section class not found!");
			}
		};
		
		// This is run if content is already loaded.
		private function showSectionContent(p_contentID:String):void{
			setSectionsVisibility(p_contentID);
		};
		
		// This should be run right after xml is loaded, and not need to run again
		private function loadIntroPane(p_sectionInfo:XMLList):void{
			if (verbose) ("loadIntroPane run.");
			// check for Introduction in  loaded assets
			if(!loadedAssets[p_sectionInfo.title]){
				var introText:String = p_sectionInfo.content.(@medium == "text").data;
				var loaderURL:String = assetsURLs["image"] + p_sectionInfo.content.(@medium == "image").url.toString();
				trace("Load: " + loaderURL);
				var introImgLoader:Loader = new Loader();
				preloader.queueItemToLoad(loaderURL, introImgLoader, true);
				introPane = new IntroPane(introText, introImgLoader);
				setSectionsVisibility(p_sectionInfo.title);
				loadedAssets[p_sectionInfo.title] = introPane;
				loadedAssets[p_sectionInfo.title].y = topMargin;
				introPane.visible = false;
			}
		};
		
		// This should be run right after xml is loaded, and not need to run again
		private function loadOutroPane(p_sectionInfo:XMLList):void{
			if (verbose) ("loadOutroPane run.");
			// check for Introduction in  loaded assets
			if(!loadedAssets[p_sectionInfo.title]){
				var introText:String = p_sectionInfo.content.(@medium == "text").data;
				var loaderURL:String = assetsURLs["image"] + p_sectionInfo.content.(@medium == "image").url.toString();
				trace("Load: " + loaderURL);
				var introImgLoader:Loader = new Loader();
				preloader.queueItemToLoad(loaderURL, introImgLoader, true);
				outroPane = new OutroPane(introText, introImgLoader);
				setSectionsVisibility(p_sectionInfo.title);
				loadedAssets[p_sectionInfo.title] = outroPane;
				loadedAssets[p_sectionInfo.title].y = topMargin;
				outroPane.visible = false;
			}
		};
		
		private function loadVideoPane(p_sectionInfo:XMLList):void{
			if (verbose) ("loadVideoPane run.");
			// check for Introduction in  loaded assets
			if(!loadedAssets[p_sectionInfo.title]){
				var videoText:String = p_sectionInfo.content.(@medium == "text").data;
				var tmpLoader:Loader = new Loader();
				var assetloc:String = assetsURLs["movplayer"];
				var tmpURL:String = assetloc + p_sectionInfo.content.(@medium=="movplayer").url;
				var videoloc:String = assetsURLs["video"];
				var videoURL:String =  videoloc + p_sectionInfo.content.(@medium=="video").url;
				videoPane = new VideoPane(tmpLoader,videoURL, videoText);
				loadedAssets[p_sectionInfo.title] = videoPane;
				loadedAssets[p_sectionInfo.title].y = topMargin;
				setSectionsVisibility(p_sectionInfo.title);
				preloader.queueItemToLoad(tmpURL, tmpLoader, true);
			}else{
				// is already loaded and chouldn't need to load.
			}
		};
		
		private function loadInfographicPane(p_sectionInfo:XMLList):void{
			if (p_sectionInfo.content.@loc.toString() == "external") {
				if (!loadedAssets[p_sectionInfo.title]) {
					if (verbose) trace("InfographicPane external");
					var tmpLoader:Loader = new Loader();
					var assetloc:String = assetsURLs[p_sectionInfo.content.@medium];
					var tmpURL:String = assetloc + p_sectionInfo.content.url;
					loadedAssets[p_sectionInfo.title] = tmpLoader;
					loadedAssets[p_sectionInfo.title].y = topMargin;
					preloader.queueItemToLoad(tmpURL, loadedAssets[p_sectionInfo.title], true);
					setSectionsVisibility(p_sectionInfo.title);
				}
			}else{
				// handle non-external content?!?
				if (verbose) trace("InfographicPane is internal.");
			}
		};
		
		// Sets the visibilty of items in loadedAssets object based on the id of the content chosen for display
		private function setSectionsVisibility(p_chosenContentID:String):void{
			for ( var section:String in loadedAssets ){
				if (section == p_chosenContentID) {
					if (verbose) {
						trace("loadedAssets[" + section +  "] is chosen")
					}
					putAtTopOfDisplayIndex(loadedAssets[section])
					loadedAssets[section].visible = true;
					
				}else{
					if (verbose) {
						trace("loadedAssets[" + section +  "] is NOT chosen")
					}
					loadedAssets[section].visible = false;
				}
			};
		};
		
		private function markCurrentSection(p_ClickedID:String):void{
			for ( var b=0; b<buttonArray.length; b++ ) {
				if (buttonArray[b].id == p_ClickedID) {
					buttonArray[b].setSelected(true);
				}else{
					buttonArray[b].setSelected(false);
				}
			};
		};
		
		// if the section isn't the currently chosen section, it may need resetting
		private function resetNonCurrentSections(p_ChosenContentID:String):void{
			for ( var item in loadedAssets ){
				if (item != p_ChosenContentID) {
					if (verbose) trace("resetNonCurrentSections >> reset " + loadedAssets[item]);
					if ( (loadedAssets[item] is Loader) && ("reset" in loadedAssets[item].content) ) {
						loadedAssets[item].content.reset = true;
					}else if("reset" in loadedAssets[item]){
						loadedAssets[item].reset = true;
					}
				}
			};
		};
		
		// Need to work on contentLoaderInfo...
		public function preloadedItemInit(e:PreloaderEvent):void{
			if (verbose) {
				trace("preloadedItemInit >> target: " + e.target);
				trace("preloadedItemInit >> loaderInfo: " + e.loaderInfo);
				trace("preloadedItemInit >> loaderInfo.loader: " + e.loaderInfo.loader);
				trace("preloadedItemInit >> loaderInfo.contentType: " + e.loaderInfo.contentType);
				trace("preloadedItemInit >> loaderInfo.content has absoluteURL: " +("absoluteURL" in e.loaderInfo.content));
				trace("preloadedItemInit >> loaderInfo.url: " + e.loaderInfo.url);
			}
			// If we are loading an external swf, attempt to give it an absolute url 
			// so it knows where to find its assets.
			if (e.loaderInfo.contentType == "application/x-shockwave-flash" && "absoluteURL" in e.loaderInfo.content) {
				var filePath:String = getSWFLocation(e.loaderInfo.url)
				e.loaderInfo.content.absoluteURL = filePath;
			}
		};
		
		// If the background is loaded and revealed, 
		// change the size of the preloader so it doesn't cover up the nav buttons
		private function contentRevealedHandler(e:PreloaderEvent):void{
			if (bgLoader.loaderInfo.bytesLoaded == bgLoader.loaderInfo.bytesTotal) {
				preloader.y = topMargin;
				var newHeight:Number = this.stage.stageHeight - topMargin;
				preloader.resize(preloader.width, newHeight);
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