package com.codedrunks.components.flash
{
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ImageCell;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TwitterItemRenderer extends ImageCell implements ICellRenderer
	{
		private var tweetText:TextField;
		
		public function TwitterItemRenderer()
		{
			super();
			
			setStyle("upSkin", CustomCellBg);
			setStyle("downSkin", CustomCellBg);
			setStyle("overSkin", CustomCellBgOver);
			
			setStyle("selectedUpSkin", CustomCellBgSelected);
			setStyle("selectedDownSkin", CustomCellBgSelected);
			setStyle("selectedOverSkin", CustomCellBgSelected); 
			
			/* *
			tweetText = new TextField();
			tweetText.autoSize = TextFieldAutoSize.LEFT;
			//title.defaultTextFormat = styles.Arial_11_white;
			tweetText.antiAliasType = AntiAliasType.ADVANCED;
			//title.embedFonts = StyleManager.getStyle("embedFonts");
			tweetText.x = 4;
			tweetText.y = 4
			tweetText.width = this.width - 8;
			tweetText.height = this.height - 8;
			tweetText.multiline = true;
			tweetText.wordWrap = true;
			tweetText.selectable = false;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Verdana";
			tf.color = 0xFFFFFF;
			
			tweetText.setTextFormat(tf);
			
			addChild(tweetText);
			/* */
		}
				
		override protected function drawLayout():void
		{
			//tweetText.htmlText = data.label;
			background.width = width;
			background.height = height;
			textField.text = data.label;
			textField.visible = false;
		}
	}
}
