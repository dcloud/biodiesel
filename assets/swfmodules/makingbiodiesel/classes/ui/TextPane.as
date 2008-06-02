//
//  TextPane
//
//  Created by Daniel Cloud on 2008-06-02.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//

package	classes.ui{
	import flash.display.Sprite;
	import flash.text.TextField;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class TextPane extends Sprite{
		/*
			//// Author time elements ////
				textfields_sp.title_tf:TextField;
				textfields_sp.body_tf:TextField;
		*/
		private var bodyTxt:String = "";
		private var titleTxt:String = "";
		private var tfTween:Tween;
		private const tweenTime:Number = .75;
		private const useSeconds:Boolean = true;
		
		public function TextPane(){
			tfTween = new Tween(textfields_sp, "alpha", Strong.easeOut, 1, 1, tweenTime, useSeconds);
			tfTween.addEventListener(TweenEvent.MOTION_FINISH, handleTweenComplete);
		}
		
		public function setText(pTitle:String, pBody:String):void{
			bodyTxt = pBody;
			titleTxt = pTitle;
			tfTween.begin = tfTween.obj.alpha;
			tfTween.finish = 0;
			tfTween.start();
		};
		
		public function set title(pTitle:String):void{
			textfields_sp.title_tf.text = pTitle;
		};
		
		public function get title():String{
			return textfields_sp.title_tf.text;
		};
		
		public function set body(pText:String):void{
			textfields_sp.body_tf.text = pText;
		};
		
		public function get body():String{
			return textfields_sp.body_tf.text;
		};
		
		private function handleTweenComplete(e:TweenEvent):void{
			if (e.position == 0) {
				textfields_sp.title_tf.text = titleTxt; 
				textfields_sp.body_tf.text = bodyTxt;
				e.target.begin = e.position;
				e.target.finish = 1;
				e.target.start();
			}
		};
		
	}
}

