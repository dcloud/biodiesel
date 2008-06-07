//
//  IntroPane (exists in main.fla)
//
//  Created by Daniel Cloud on 2008-06-07.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.ui {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class IntroPane extends Sprite{
		/*
			Author time elements 
			intro_tf:TextField;
		*/
		public function IntroPane(p_text:String){
			setText(p_text);
		}
		
		public function setText(p_text:String):void{
			intro_tf.text = p_text;
		};
	}
}
