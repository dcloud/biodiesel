package classes.ui {
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class NavButton extends SimpleButton{
		
		public function NavButton(){
			trace(this.name);
			setHandlers();
		}
		
		private function setHandlers():void{
			addEventListener(MouseEvent.CLICK, clickHandler);
		};
		
		private function clickHandler(event:MouseEvent):void{
			trace("Got click.");
		};
	}
}