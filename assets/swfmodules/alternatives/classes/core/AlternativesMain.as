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

		private var baseURL:String;

		private var xmlLoader:LoadXML;
		private var xmlFile:String = "assets/xml/alternativefuels.xml";
		private var xmlInfo:XML;
		private var gotXML:Boolean;
		
		private var spacerY:Number = 5;
		private var dataMatrix:Array;
		private var dataCol:int;
		private var dataRowCount:int;
		private var maxRowHeights:Array;
		private var leftOverHpixels:Number;
		private var tableGraphics:Array;
		
		private var verbose:Boolean = true;
		
		public function AlternativesMain(){
			if (verbose) trace("AlternativesMain created.");
			gotXML = false;
			xmlLoader = new LoadXML(xmlFile, this);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			dataCol = 0;
			// root in AS3 will always refer to this swf's root...
			leftOverHpixels = root.height;
			if (verbose) trace("AlternativesMain >> leftOverHpixels " + leftOverHpixels);
			maxRowHeights = new Array(); // as we create InfoCells, we will store the tallest cell for each row
			tableGraphics = new Array();
		}
		
		private function xmlLoaded(e:Event):void{
			xmlInfo = e.target.xml;
			gotXML = true;
			initDataMatrix(); // must come before creating labels...
			createLabels();
			createDataColumn();
			resizeCells();
			placeData();
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
			var rowNum:int = 0;
			dataMatrix[dataCol][rowNum] = null;
			rowNum++;
			
			for each (var label:String in xmlInfo.labels.label){
/*				if (verbose) trace("createLabels >> label: " + label);*/
				var newCell = new InfoCell(InfoCell.LABEL, label);
				if (maxRowHeights[rowNum] == null || (maxRowHeights[rowNum] < newCell.cellHeight) ) {
					maxRowHeights[rowNum] = newCell.cellHeight;
					if (verbose) trace("createLabels >> newCell.cellHeight: " + newCell.cellHeight);
					if (verbose) trace("createLabels >> maxRowHeights[" + rowNum + "]: " + maxRowHeights[rowNum]);
				}
				dataMatrix[dataCol][rowNum] = newCell;
				rowNum++;
			}
			dataCol++
		};
		
		private function createDataColumn():void{
			for each (var singleSection:XML in xmlInfo.sections.section){
				var rowNum:int = 0;
				
				if (verbose) trace("section: " + singleSection.title);
				
				//make title cell
				var titleCell = new InfoCell(InfoCell.TITLE, singleSection.title);
				if (verbose) {
					trace("createDataColumn >> maxRowHeights[" + rowNum + "]: " + maxRowHeights[rowNum]);
					trace("createDataColumn >> titleCell.cellHeight: " + titleCell.cellHeight);
				}
				if (maxRowHeights[rowNum] == null || (maxRowHeights[rowNum] < titleCell.cellHeight) ) {
					maxRowHeights[rowNum] = titleCell.cellHeight;
					if (verbose) {
						trace("createDataColumn >> maxRowHeights[" + rowNum + "] changed to: " + maxRowHeights[rowNum]);
					}
				}
				dataMatrix[dataCol][rowNum] = titleCell;
				rowNum++;
				// make data rows
				for each (var cellInfo:XML in singleSection.item){
					var newCell = new InfoCell(InfoCell.BODY, cellInfo.data);

					if (verbose) {
						trace("createDataColumn >> maxRowHeights[" + rowNum + "]: " + maxRowHeights[rowNum]);
						trace("createDataColumn >> newCell.textHeight: " + newCell.textHeight);
					}
					if (maxRowHeights[rowNum] == null || (maxRowHeights[rowNum] < newCell.textHeight) ) {
						maxRowHeights[rowNum] = newCell.textHeight;
						if (verbose) {
							trace("createDataColumn >> maxRowHeights[" + rowNum + "] changed to: " + maxRowHeights[rowNum]);
						}
					}
					dataMatrix[dataCol][rowNum] = newCell;
					rowNum++;
				}
				dataCol++;
			}
		};
		
		private function resizeCells():void{
			for ( var col=0; col<dataMatrix.length; col++ ) {
				for ( var row=0; row<dataMatrix[col].length; row++ ) {
					if( dataMatrix[col][row] != null && (dataMatrix[col][row] is InfoCell) ){
						dataMatrix[col][row].cellHeight = maxRowHeights[row];
						if (col == 1) {
							leftOverHpixels -= dataMatrix[col][row].cellHeight;			
							spacerY = leftOverHpixels/dataMatrix[col].length;
							if (verbose) {
								trace("resizeCells >> leftOverHpixels: " + leftOverHpixels);							
								trace("resizeCells >> spacerY: " + spacerY);							
							}
						}
						if (verbose) {
							trace("maxRowHeights[row]: " + maxRowHeights[row]);
							trace("dataMatrix[" + col + "][" + row + "].cellHeight: " + dataMatrix[col][row].cellHeight);
						}
					}
				};
			};
		};
		
		private function placeData():void{
			var yOffset:Number = dataMatrix[1][0].cellHeight + (spacerY*2);
			// xOffset set after each row made
			var xOffset:Number = 0;
			// cycle through columns
			for ( var col=0; col<dataMatrix.length; col++ ) {
				if (col > 0) {
					yOffset = spacerY;
					// add columnar line
					tableGraphics.push( createGridLine(xOffset, 0, xOffset, root.height) );
					addChild(tableGraphics[tableGraphics.length -1]);
				}else{
					// add title bg
					tableGraphics.push( createBackgroundSprite(dataMatrix[1][1].cellWidth, 0, root.width, (dataMatrix[1][0].cellHeight + spacerY), 0xFFFFFF, 0.3) );
					addChildAt(tableGraphics[tableGraphics.length -1], 1);
				}
				// cycle through rows in a particular column
				for ( var row=0; row<dataMatrix[col].length; row++ ) {
					if( dataMatrix[col][row] != null && (dataMatrix[col][row] is InfoCell) ){
/*						if (verbose) trace("maxRowHeights[" + row + "]: " + maxRowHeights[row]);*/
						dataMatrix[col][row].y = yOffset;
						dataMatrix[col][row].x = xOffset;
						addChild(dataMatrix[col][row]);
						yOffset = dataMatrix[col][row].y + dataMatrix[col][row].cellHeight;
						if (row > 0) {
							yOffset += spacerY;
						}
						if (col > 0 && row < (dataMatrix[col].length-1) ) {
							// add row line	
							tableGraphics.push( createGridLine(0, yOffset, root.width, yOffset) );
							addChild(tableGraphics[tableGraphics.length -1]);							
						}else{
							// every other row create a background for the row
							if(row%2 != 0){
								if (verbose) trace("create table row");
								tableGraphics.push( createBackgroundSprite(0, dataMatrix[col][row].y- spacerY,  root.width, (dataMatrix[col][row].cellHeight + spacerY), 0xFFFFFF, 0.6) )
								addChildAt(tableGraphics[tableGraphics.length -1], 1);							
							}
						}
						
						if (verbose) {
							trace("dataMatrix[" + col + "][" + row + "].cellHeight: " + dataMatrix[col][row].cellHeight);
							trace("dataMatrix[" + col + "][" + row + "].x: " + dataMatrix[col][row].x);
							trace("dataMatrix[" + col + "][" + row + "].y: " + dataMatrix[col][row].y);
						}
					}else{
						if (verbose) trace("placeData >> dataMatrix[" + col + "][" + row + "] == null");
					}
				};
				if ( dataMatrix[col][1] != null && (dataMatrix[col][1] is InfoCell) ) {
					xOffset = dataMatrix[col][1].x + dataMatrix[col][1].cellWidth;
				}
			};
		};
		
		private function createGridLine(p_beginX:Number, p_beginY:Number, p_endX:Number, p_endY:Number):Sprite{
			if (verbose) trace("createGridLine");
			var newGridline:Sprite = new Sprite;
			newGridline.graphics.moveTo(p_beginX, p_beginY);
			newGridline.graphics.lineStyle(1, 0x000000);
			newGridline.graphics.lineTo(p_endX, p_endY);
			return newGridline;
		};
		
		private function createBackgroundSprite(p_beginX:Number, p_beginY:Number, p_width:Number, p_height:Number, p_color:uint=0xFFFFFF, p_alpha:Number=0.3):Sprite{
			var newBgSprite:Sprite = new Sprite();
			newBgSprite.graphics.beginFill(p_color, p_alpha);
			newBgSprite.graphics.drawRect(p_beginX, p_beginY, p_width, p_height);
			return newBgSprite;
		};
	}
}