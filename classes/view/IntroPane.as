//
//  IntroPane (exists in main.fla)
//
//  Created by Daniel Cloud on 2008-06-07.
//  Copyright (c) 2008 Daniel Cloud. All rights reserved.
//
package classes.view {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.*;
	import flash.display.Bitmap;
    import flash.display.BitmapData;	
	import flash.text.TextField;
	
	public class IntroPane extends Sprite{
		/*
			Author time elements 
			intro_tf:TextField;
			photoFrame_sp:MovieClip
		*/
		private var loader:Loader;
		
		public function IntroPane(p_text:String, p_loader:Loader){
			setText(p_text);
			loader = p_loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
		}
		
		public function setText(p_text:String):void{
			intro_tf.text = p_text;
		};
		
		private function completeHandler(event:Event):void{
			var loader:Loader = Loader(event.target.loader);
            var image:Bitmap = Bitmap(loader.content);
			image.smoothing = true;
			photoFrame_sp.addChild(image);
		};
	}
}
