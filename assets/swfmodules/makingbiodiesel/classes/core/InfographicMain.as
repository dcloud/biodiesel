//
//  InfographicMain
//
//  Created by Daniel Cloud on 2008-06-01.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.core{
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.*;
	import classes.events.InfogEvent;
	import classes.core.Animatable;
	import classes.util.InfogXML;
	
	public class InfographicMain extends Animatable{
		/*
			//// Author time elements ////
				(everything visual, essentially)
				textpane_sprite:TextPane;
				navarea_mc:NavPane;
		*/
		private var xmlLoader:InfogXML;
		private var xmlFile:String = "assets/xml/makinginfog.xml";
		private var xmlInfo:XML;
		
		public function InfographicMain(){
			xmlLoader = new InfogXML(xmlFile, this);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			addEventListener(InfogEvent.ANIMATION_COMPLETE, reachedLabel);
		}
		
		private function xmlLoaded(e:Event):void{
			xmlInfo = e.target.xml;
			if (verbose) trace("xmlInfo: " + xmlInfo);
			// Once xml is loaded, go to the first label we want to see
			playToLabel("1.1", this); // *** shall change to 1.1 ***
		};
		
		private function stageAdded(e:Event):void{
			addEventListener(InfogEvent.NAV_OVER, handleNavRollOver);
			addEventListener(InfogEvent.NAV_OUT, handleNavRollOut);
			addEventListener(InfogEvent.NAV_CLICK, handleNavClick);
		};
		
		private function reachedLabel(e:InfogEvent):void{
			if (verbose) {
				trace("e: " + e);
				trace("e.target: " + e.target);
				for ( var item in e.data ){
					trace("e.data[" + item + "]: " + e.data[item]);
				};
			}
			var currentLabel:String = e.data["label"];
			var newBody:String = xmlInfo.sections.section.(@id.toString() == currentLabel).text;
			var newTitle:String = xmlInfo.sections.section.(@id.toString() == currentLabel).title;
			trace("Text for this section: " + newBody);
			textpane_sprite.setText(newTitle, newBody);
/*			textpane_sprite.title = newTitle;
			textpane_sprite.body = newBody;
*/		};
		
		/*
			Handle Nav related mouse events
		*/
		private function handleNavRollOver(e:InfogEvent):void{
			if (verbose) trace("rolled over: " + e.data);
			var buttonLabel:String = e.data.toString();
			var buttonTitle:String = xmlInfo.sections.section.(@id.toString() == buttonLabel).title;
			setNavText(buttonTitle);
		};
		
		private function handleNavRollOut(e:InfogEvent):void{
/*			if (verbose) trace("rolled out from: " + e.data);*/
			setNavText(" ");
		};
		
		private function handleNavClick(e:InfogEvent):void{
/*			var chosenLabel:String =  e.data.toString();*/
			if (verbose) trace("Heard NavButton: " + e.data);
			playToLabel(e.data.toString(), this); // *** shall
		};
		
		private function setNavText(pTitle:String):void{
			rollover_tf.text = pTitle;
		};		
	}
}