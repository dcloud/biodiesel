//
//  InfoCell
//
//  Created by Daniel Cloud on 2008-06-09.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package classes.view {
	import flash.display.Sprite;
	import flash.text.*;
	
	public class InfoCell extends Sprite{
		/*
			//// Author time elements ////
				bg_sprite:Sprite;
				info_tf:TextField;
		*/
		
		public static const LABEL:String = "label";
		public static const TITLE:String = "title";
		public static const BODY:String = "body";
		
		public static const DEFAULT_HEIGHT:Number = 80;
		public static const TITLE_HEIGHT:Number = 20;
		
		private var format:TextFormat;
		private var cellType:String;

		private var verbose:Boolean = true;
		
		public function InfoCell(p_type:String, p_text:String){
			if (verbose) trace("create InfoLabel of type: " + p_type);
			// wordWrap = true and autoSize = TextFieldAutoSize.LEFT mean resize from bottom
			info_tf.wordWrap = true;
			info_tf.autoSize = TextFieldAutoSize.LEFT;
			
			cellType = p_type;
			applyTextFormat(cellType);
			setHeight(cellType);
			this.cellText = p_text;
		}
		
		public function set cellText(p_text:String):void{
			info_tf.text = p_text;
			positionText();
		};
		
		public function get cellText():String{
			return info_tf.text;
		};
		
		public function set cellHeight(p_heightNum:Number):void{
			bg_sprite.height = p_heightNum;
		};
		
		public function get cellHeight():Number{
			return bg_sprite.height;
		};
		
		private function setHeight(p_type:String):void{
			switch ( p_type ) {
				case LABEL :
					cellHeight = DEFAULT_HEIGHT;
					break;
				case TITLE :
					cellHeight = TITLE_HEIGHT;
					break;
				default :
				cellHeight = DEFAULT_HEIGHT;
				break;
			}
		};
		
		private function applyTextFormat(p_type:String):void{
			format = new TextFormat();
			switch ( cellType ) {
				case TITLE :
					if (verbose) trace("format title");			
					format.align = TextFormatAlign.CENTER;
					format.leftMargin = 2;
					format.rightMargin = 2;
					format.bold = true;
					format.size = 14;
					break;
				case LABEL :
					format.align = TextFormatAlign.RIGHT;
					format.leftMargin = 5;
					format.rightMargin = 5;
					format.bold = false;
					format.size = 14;
					break;
				default :
					if (verbose) trace("format other");			
					format.align = TextFormatAlign.LEFT;
					format.leftMargin = 5;
					format.rightMargin = 5;
					format.bold = true;
					format.size = 10;
			}
			info_tf.defaultTextFormat = format;
		};
		
		
		private function positionText():void{
			switch ( cellType ) {
				case TITLE :
					info_tf.y = bg_sprite.height - info_tf.textHeight - 2;
					break;
				case LABEL :
					info_tf.y = (bg_sprite.height - info_tf.textHeight)/2;
				default :
					info_tf.y = (bg_sprite.height - info_tf.textHeight)/2;
			}
		};
	}
}