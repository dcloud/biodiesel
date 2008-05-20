package classes.ui {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class NavButton extends SimpleButton{
		private var labelText:String;
		
		public function NavButton(pName:String){
			this.labelText = pName;
			upState = createUpState();
			overState = createOverState();
			downState = createDownState();
			hitTestState = upState;
			setHandlers();
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for ( var i=0; i<embeddedFonts.length; i++ ) {
				trace("embeddedFonts[" + i + "]: " + embeddedFonts[i].fontName);
			};
		}
		
		private function createTextLabel(pColor:uint):TextField{
			var txtLabel = new TextField();
			txtLabel.autoSize = TextFieldAutoSize.LEFT;
			txtLabel.background = false;
			txtLabel.border = false;
			txtLabel.antiAliasType = AntiAliasType.ADVANCED;
			txtLabel.embedFonts = true;
			txtLabel.text = labelText;
			
			var format:TextFormat = new TextFormat();
			format.font = "Avenir LT Std 65 Medium";
			format.size = 18;
			format.color = pColor;
			
			txtLabel.setTextFormat(format);
			
			return txtLabel;
		};
		
		
		private function createUpState():Sprite{
			var sprite:Sprite = new Sprite();
			var txtField:TextField = createTextLabel(0xFFFFFF);
			var filtersArr:Array = [createDropShadow(0x000000, 1, 1, 45, 0.8)];
			sprite.filters = filtersArr;

			sprite.addChild(txtField);
			return sprite;
		};

		private function createOverState():Sprite{
			var sprite:Sprite = new Sprite();
			var txtField:TextField = createTextLabel(0xF1EFDE);
			var filtersArr:Array = [createDropShadow(0x000000, 1, 1, 45, 1)];
			sprite.filters = filtersArr;

			sprite.addChild(txtField);
			return sprite;
		};
		
		private function createDownState():Sprite{
			var sprite:Sprite = new Sprite();
			var txtField:TextField = createTextLabel(0xF1EFDE);
			var filtersArr:Array = [createDropShadow(0x000000, 1, 1, 45, .4)];
			sprite.filters = filtersArr;
			
			sprite.addChild(txtField);
			txtField.x += 1;
			txtField.y += 1;
			return sprite;
		};
		
		private function createDropShadow(pColor:uint, pDistance:Number, pBlur:Number, pAngle:Number, pStrength:Number):DropShadowFilter{
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.color = pColor;
			dropShadow.distance = pDistance;
			dropShadow.blurX = pBlur;
			dropShadow.blurY = pBlur;
			dropShadow.angle = pAngle;
			dropShadow.strength = pStrength;
			dropShadow.quality = BitmapFilterQuality.HIGH;
			return dropShadow;
		};
		
		private function setHandlers():void{
			addEventListener(MouseEvent.CLICK, clickHandler);
		};
		
		private function clickHandler(event:MouseEvent):void{
			trace(this.labelText + " got click.");
		};
	}
}