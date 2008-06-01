//
//  SiteXML
//
//  Created by Daniel Cloud on 2008-05-31.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.util{
	import flash.events.*;
	import flash.net.*;
	
	public class SiteXML extends EventDispatcher{
		// The variable to which the loaded XML will be assigned
	    private var siteInfo:XML;
	    // The object used to load the XML
	    private var urlLoader:URLLoader;
/*		// object of parsed siteInfo
		private var parsedInfo:Object;
*/	
		private var verbose:Boolean = true;
	
		public function SiteXML(pFile:String, pRef:Object=null, pCallback:String=null){
			if(verbose) trace("Create SiteXML");
			var urlRequest:URLRequest = new URLRequest(pFile);
			urlLoader = new URLLoader();
			createLoaderHandlers(urlLoader);
			urlLoader.load(urlRequest);
		}
		
		private function createLoaderHandlers(pLoader:URLLoader):void{
			pLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			pLoader.addEventListener(Event.OPEN, loadBegunHandler);
			pLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			pLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		};
		
		private function loadCompleteHandler(e:Event):void{
			if(verbose) trace(e);
			siteInfo = new XML(urlLoader.data);
			if(verbose) trace(siteInfo.toXMLString());
			dispatchEvent(new Event(Event.COMPLETE));
/*			parseXMLIntoObject();*/
		};
		
		private function loadBegunHandler(e:Event):void{
			if(verbose) trace(e);
		};
		
		private function httpStatusHandler(e:HTTPStatusEvent):void{
			if(verbose) trace(e);
		};
		
		private function ioErrorHandler(e:IOErrorEvent):void{
			if(verbose) trace(e);
		};
		
/*		// Function to parse the XML object into a data object for the site
		private function parseXMLIntoObject():void{
			parsedInfo = new Object();
			parsedInfo["siteurl"] = siteInfo.attribute("url");
			var counter = 0;
			for ( var section in siteInfo.sections ){
				parsedInfo["section"][counter]["title"] = section.title;
				counter++;
			};
		};
*/		
		// get XML data. Since XML is easy to access using E4X and is a top-level object,
		// there is no need to parse the XML object into an object. It is sort of redundant to do so.
		public function get xml():XML{
			if (siteInfo) {
				return siteInfo;
			}else{
				return undefined;
			}
		}
	}
}