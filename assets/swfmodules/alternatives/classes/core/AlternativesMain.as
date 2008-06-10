//
//  AlternativesMain
//
//  Created by Daniel Cloud on 2008-06-09.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.core{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.*;
	
	import classes.util.LoadXML;
	import classes.view.InfoCell;
	
	public class AlternativesMain extends Sprite{
		/*
			//// Author time elements ////
				infoCell:InfoCell; (has class file, but also exists in swf to get around potential font embedding issues)
		*/
		private var xmlLoader:LoadXML;
		private var xmlFile:String = "assets/xml/alternativefuels.xml";
		private var xmlInfo:XML;
		private var gotXML:Boolean;
		
		private var xOffset:Number;
		private var dataMatrix:Array;
		private var dataCol:int;
		private var dataRowCount:int;
		private var maxRowHeights:Array;
		
		private var verbose:Boolean = true;
		
		public function AlternativesMain(){
			if (verbose) trace("AlternativesMain created.");
			gotXML = false;
			xmlLoader = new LoadXML(xmlFile, this);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xOffset = 0;
			dataCol = 0;
			maxRowHeights = new Array; // as we create InfoCells, we will store the tallest cell for each row
		}
		
		private function xmlLoaded(e:Event):void{
			xmlInfo = e.target.xml;
			gotXML = true;
			initDataMatrix(); // must come before creating labels...
			createLabels();
			createDataColumn();
			placeData();
		};
		
		private function initDataMatrix():void{
			dataMatrix = new Array();
			var sectionLabels:XMLList = xmlInfo.labels.label;
			trace("sectionLabels:" + sectionLabels);
			dataRowCount = sectionLabels.length() + 1; // the plus one is for the column titles
			trace("rowCount: " + dataRowCount);
			for ( var j=0; j<dataRowCount; j++ ) {
				dataMatrix[j] = new Array();
			};
		};
		
		private	function createLabels():void{
/*			var yOffset:Number = 0;
			var yOffsetInit:Boolean = false;
			dataMatrix[dataCol] = new Array();
*/			var rowNum:int = 0;
			dataMatrix[dataCol][rowNum] = null;
			rowNum++;
			
			for each (var label:String in xmlInfo.labels.label){
				if (verbose) trace("label: " + label);
				var newCell = new InfoCell(InfoCell.LABEL, label);
/*				newCell.x = 0;
				if (!yOffsetInit) {
					yOffset = InfoCell.TITLE_HEIGHT;
					yOffsetInit = true;
				}
				newCell.y = yOffset;
*/				dataMatrix[dataCol][rowNum] = newCell;
/*				addChild(dataMatrix["label"][label]);*/
/*				xOffset = newCell.x + newCell.width;
				yOffset = newCell.y + newCell.cellHeight;
*/				rowNum++;
			}
			dataCol++
		};
		
		private function createDataColumn():void{
			for each (var singleSection:XML in xmlInfo.sections.section){
/*				var yOffset:Number = 0;*/
				var rowNum:int = 0;

				if (verbose) trace("section: " + singleSection.title);
				
				//make title cell
				var titleCell = new InfoCell(InfoCell.TITLE, singleSection.title);
/*				titleCell.x = xOffset;*/
/*				titleCell.y = yOffset;*/
				dataMatrix[dataCol][rowNum] = titleCell;
				rowNum++;
/*				addChild(dataMatrix[singleSection.title]["title"])
				yOffset = titleCell.y + titleCell.cellHeight;
*/				
				// make data cells
				for each (var cellInfo:XML in singleSection.item){
					var newCell = new InfoCell(InfoCell.BODY, cellInfo.data);
/*					newCell.x = xOffset;
					newCell.y = yOffset;
					yOffset = newCell.y + newCell.cellHeight;
*/
					dataMatrix[dataCol][rowNum] = newCell;
/*					addChild(newCell);*/
					rowNum++;
				}
/*				xOffset = titleCell.x + titleCell.width;*/
				dataCol++;
			}
		};
		
		private function placeData():void{
			var yOffset:Number = 0;
			
			for ( var v=0; v<dataMatrix.length; v++ ) {
				for ( var d=0; d<dataMatrix[v].length; d++ ) {
					if(dataMatrix[v][d] != null){
						if ("cellText" in dataMatrix[v][d]) {
							trace("dataMatrix[" + v + "][" + d + "].cellText: " + dataMatrix[v][d].cellText);
						}else{
							trace("dataMatrix[" + v + "][" + d + "]: " + dataMatrix[v][d]);
						}
					}else{
						trace("dataMatrix[" + v + "][" + d + "] == null");
					}
				};
			};
		};
	}
}