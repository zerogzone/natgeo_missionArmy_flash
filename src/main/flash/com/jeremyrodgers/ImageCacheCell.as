package com.jeremyrodgers
{
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ImageCell;
	import fl.controls.TileList;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;
	import flash.events.EventDispatcher;
	import flash.text.*;
	import flash.events.*;
	import fl.containers.UILoader;
	import flash.display.Bitmap;
	
	public class ImageCacheCell extends ImageCell implements ICellRenderer
	{  
		public function ImageCacheCell() 
		{
			super();
			loader.addEventListener(Event.COMPLETE, completeHandler);
    	}
		
		private function completeHandler(event:Event):void 
		{
			trace("kichcha --> tracing loader image Cell Cache");
			var uiLdr:UILoader = event.currentTarget as UILoader;
            var image:Bitmap = Bitmap(uiLdr.content);
			// inject the loaded bitmap into the dataProvider
			data._$cachedImage = image;
		}
		
		override public function set source(value:Object):void
		{
			var image = data._$cachedImage;
			// either load image from supplied value 
			if (image == null)
			{
				loader.source = value;
			}
			// or load from store reference to bitmap
			else
			{
				loader.source = image;
			}
		}
	}
}