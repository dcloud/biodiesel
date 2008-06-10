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
		
		private var format:TextFormat;
		private var cellType:String;

		private var verbose:Boolean = false;
		
		public function InfoCell(p_type:String, p_text:String){
			if (verbose) trace("create InfoLabel of type: " + p_type);
			// wordWrap = true and autoSize = TextFieldAutoSize.LEFT mean resize from bottom
			info_tf.wordWrap = true;
			info_tf.autoSize = TextFieldAutoSize.LEFT;
			info_tf.antiAliasType = AntiAliasType.ADVANCED;
			
			cellType = p_type;
			applyTextFormat(cellType);
			this.cellText = p_text;
			this.cellHeight = this.textHeight;
		}
		
		public function set cellText(p_text:String):void{
			var textinput:String = p_text;
			if (cellType == LABEL || cellType == TITLE) {
				textinput = textinput.toUpperCase();
			}
			info_tf.text = textinput;
			positionText();
		};
		
		public function get cellText():String{
			return info_tf.text;
		};
		
		public function set cellHeight(p_heightNum:Number):void{
			bg_sprite.height = p_heightNum + 10;
			positionText();
		};
		
		public function get cellHeight():Number{
			return bg_sprite.height;
		};
		
		public function set cellWidth(p_width:Number):void{
			bg_sprite.width = p_width;
		};
		
		public function get cellWidth():Number{
			return bg_sprite.width;
		};
		
		public  function get textHeight():Number{
			return info_tf.textHeight;
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
					format.bold = true;
					format.size = 11;
					format.leading = 1;
					break;
				default :
					if (verbose) trace("format other");			
					format.align = TextFormatAlign.LEFT;
					format.leftMargin = 10;
					format.rightMargin = 10;
					format.bold = true;
					format.size = 10;
					format.leading = 0.6;
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