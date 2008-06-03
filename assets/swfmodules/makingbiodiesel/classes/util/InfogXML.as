//
//  InfogXML
//
//  Created by Daniel Cloud on 2008-06-02.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.util{
	import flash.events.*;
	import flash.net.*;
	
	public class InfogXML extends EventDispatcher{
		// The variable to which the loaded XML will be assigned
	    private var xmlObject:XML;
	    // The object used to load the XML
	    private var urlLoader:URLLoader;

		private var verbose:Boolean = true;
	
		public function InfogXML(pFile:String, pRef:Object=null){
			if(verbose) trace("Create infogXML");
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
			xmlObject = new XML(urlLoader.data);
/*			if(verbose) trace(xmlObject.toXMLString());*/
			dispatchEvent(new Event(Event.COMPLETE));
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
		
		// get XML data. Since XML is easy to access using E4X and is a top-level object,
		// there is no need to parse the XML object into an object. It is sort of redundant to do so.
		public function get xml():XML{
			if (xmlObject) {
				return xmlObject;
			}else{
				return undefined;
			}
		}
	}
}