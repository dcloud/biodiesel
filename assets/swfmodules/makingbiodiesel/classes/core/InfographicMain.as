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
	import classes.util.InfogXML;
	
	public class InfographicMain extends MovieClip{
		/*
			//// Author time elements ////
				(everything visual, essentially)
				textpane_sprite:TextPane;
				navarea_mc:NavPane;
		*/
		private var verbose:Boolean = true;
		
		private var baseURL:String;
		private var assetsURL:String;
		
		private var seek_to_label:String;
		
		private var xmlLoader:InfogXML;
		private var xmlFile:String = "assets/xml/makinginfog.xml";
		private var xmlInfo:XML;
		private var gotXML:Boolean;
		
		private var sectionsArr:Array;
		private var buttonArr:Array;
		private var currentSection:String;
		
		public function InfographicMain(){
			this.stop();
			gotXML = false;
			xmlLoader = new InfogXML(xmlFile, this);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
/*			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadErrorHandler);*/
			addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			addEventListener(InfogEvent.ANIMATION_COMPLETE, reachedLabel);
			sectionsArr = new Array();
			buttonArr = new Array();
		}
		
		private function xmlLoaded(e:Event):void{
			xmlInfo = e.target.xml;
/*			if (verbose) trace("xmlInfo: " + xmlInfo);*/
			if (verbose) trace("xmlLoaded...");
			if (gotXML) {
				sectionsArr = new Array();
				buttonArr = new Array();
			}
			for each ( var sectionID in  xmlInfo.sections.section.@id){
				sectionsArr.push(sectionID);
				buttonArr.push(sectionID + "_btn"); // can do this since I'm already enforcing a naming convention for NavButton
			};
			gotXML = true;
			currentSection = "overview";
			// Once xml is loaded, go to the first label we want to see
			playToLabel(currentSection); // *** shall change to 1.1 ***
		};
		
		public function set absoluteURL(p_absoluteURL:String):void{
			if (verbose) trace("set absoluteURL: " + p_absoluteURL);
			baseURL = p_absoluteURL;
			xmlFile = baseURL + xmlFile;
			gotXML = false;
			xmlLoader.loadXML(xmlFile);
			if (verbose) {
				trace("absoluteURL >> baseURL: " + baseURL);
				trace("absoluteURL >> xmlFile " + xmlFile);
			}
		};
		
		private function stageAdded(e:Event):void{
			addEventListener(InfogEvent.NAV_OVER, handleNavRollOver);
			addEventListener(InfogEvent.NAV_OUT, handleNavRollOut);
			addEventListener(InfogEvent.NAV_CLICK, handleNavClick);
		};
		
		/*
			Handle Nav related mouse events
		*/
		private function handleNavRollOver(e:InfogEvent):void{
/*			if (verbose) trace("rolled over: " + e.data);*/
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
			var chosenSection:String = e.data.toString();
			var chosenPos:int = findInSectionsArray(chosenSection);
			var currentPos:int = findInSectionsArray(currentSection);
			if (verbose) {
				trace("chosenSection: " + chosenSection);
				trace("chosenPos: " + chosenPos);
				trace("currentSection: " + currentSection);
				trace("currentPos: " + currentPos);
			}
						
			if (chosenSection != currentSection) {
				if (chosenPos == currentPos + 1) {
					playToLabel(chosenSection);					
				}else{
					goToLabel(chosenSection);
				}
			}
			
		};
		
		private function setNavText(pTitle:String):void{
			rollover_tf.text = pTitle;
		};
		
		private function findInSectionsArray(pSectionName:String):int{
			var itemPos:int = -1;
			for ( var j=0; j<sectionsArr.length; j++ ) {
				if (sectionsArr[j] == pSectionName) {
					itemPos = j;
					return itemPos;
				}
			};
			return itemPos;
		};
		
		private function setButtonsSelection(p_selection:String):void{
			// Tell each button what was selected
			for ( var m=0; m<buttonArr.length; m++ ) {
				this[buttonArr[m]].setSelection(p_selection);
			};
		};
			
		private function playToLabel(pLabel:String):void{
			seek_to_label = pLabel;
			if (verbose) trace("playToLabel: " + seek_to_label);
			if (this.currentLabel != seek_to_label) {
				this.addEventListener(Event.ENTER_FRAME, checkFrameLabel);
				this.play();
			}
		};
		
		private function goToLabel(pLabel:String):void{
			seek_to_label = pLabel;
			if (verbose) trace("goToLabel: " + seek_to_label);
			this.gotoAndStop(seek_to_label);
			reachedLabel();
		};

		private function reachedLabel():void{
			currentSection = seek_to_label;
			setButtonsSelection(currentSection);
			var newBody:String = xmlInfo.sections.section.(@id.toString() == currentSection).text;
			var newTitle:String = xmlInfo.sections.section.(@id.toString() == currentSection).title;
			textpane_sprite.setText(newTitle, newBody);
		};

		private function checkFrameLabel(e:Event):void{
			if (verbose) {
				trace("this.currentLabel: " + this.currentLabel);
				trace("seek_to_label: " + seek_to_label);
			}
			if (currentLabel == seek_to_label) {
				if (verbose) trace(this.name + ".stop();");
				this.stop();
				this.removeEventListener(Event.ENTER_FRAME, checkFrameLabel);
				reachedLabel();
			}
		};
	}
}