package com.jeremyrodgers
{
	import fl.containers.UILoader;
	import fl.controls.Button;
	import fl.controls.TileList;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ImageCell;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;
	
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.text.*;
	
	public class CustomImageCell extends ImageCacheCell implements ICellRenderer
	{  
		private var title	:	TextField;
		private var tf		: 	TextFormat;
		private var friendImage:Image;
		
    	public function CustomImageCell() 
		{
			super();
			
			// set skins
			setStyle("upSkin", CustomCellBg);
			setStyle("downSkin", CustomCellBg);
     	    setStyle("overSkin", CustomCellBgOver);
			
     	    setStyle("selectedUpSkin", CustomCellBgSelected);
    		setStyle("selectedDownSkin", CustomCellBgSelected);
    	    setStyle("selectedOverSkin", CustomCellBgSelected);
			
			friendImage = new Image();
			friendImage.width = 32;
			friendImage.height = 22;
			//friendImage.y = 3;
			
			addChild(friendImage);
			
			
    	}
	
		override protected function drawLayout():void
		{
			var dat:Object = data;
			friendImage.source = data.tn;
			
			
			for (var key:String in dat) 
			{
				trace("tracing datatatatatata",key + " = " + dat[key]);
				
			}
			/*var imagePadding:Number = getStyleValue("imagePadding") as Number;
			loader.move(11, 5);
			
			var w:Number = width-(imagePadding*2);
			var h:Number = height-imagePadding*2;
			if (loader.width != w && loader.height != h)
			{
				loader.setSize(w,h);
			}
			loader.drawNow(); // Force validation!

			title.text = data.label;
			title.setTextFormat(tf);
			
			background.width = width;
			background.height = height;
			textField.visible = false;*/
		}
	}
}