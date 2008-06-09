//
//  VideoTimer
//
//  Created by Daniel Cloud on 2008-04-26.
//
package classes.video.view {
	import flash.text.TextField;
	import classes.video.base.VideoControl;

	public class VideoTimer extends VideoControl{
		public function VideoTimer(){
			var zeroed:String = "00:00";
			currentTime_tf.text = zeroed;
			totalTime_tf.text = zeroed;
		}
		
		// Set total time tf of video
		public function setTotalTime(pDuration:Number):void {
			totalTime_tf.text = secondsToTimeCode(pDuration);
		};
		
		// Set current time tf of video
		public function updateCurrentTime(pTime:Number):void{
			currentTime_tf.text = secondsToTimeCode(pTime);
		};
		
		// Convert a number in seconds to minutes and seconds
		private function secondsToTimeCode(pSeconds:Number):String {
			var fullMins:Number = Math.floor(pSeconds/60);
			var seconds:Number = Math.round(pSeconds%60);
			var minsString:String = "";
			var secString:String = "";
			
			if(fullMins < 10){
				minsString = '0' + String(fullMins);
			}else{
				minsString = String(fullMins);	
			}
			if(seconds < 10){
				secString = '0' + String(seconds);
			}else{
				secString = String(seconds);
			}
			var returnTime:String = minsString + ":" + secString;
			return returnTime;
		}
		
	}	
}