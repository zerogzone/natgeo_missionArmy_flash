package com.codedrunks.components.flash
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class Image extends MovieClip
	{
		public static const NO_SCALE:String = "noScale";
		public static const SCALE_TO_FIT:String = "scaleToFit";
		
		private var imageMask:MovieClip;
		private var scale:String = SCALE_TO_FIT;
		private var sourceUrl:String;
		private var loader:Loader;
		
		public function Image()
		{
			super();
			
			drawMask();
		}
		
		/**
		@ draw mask	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function drawMask():void
		{
			imageMask = new MovieClip();
			imageMask.graphics.lineStyle(.1, 0xff0000, 0);
			imageMask.graphics.beginFill(0xff0000, 0);
			imageMask.graphics.drawRect(0,0, 100,100);
			imageMask.graphics.endFill();
			this.addChild(imageMask);
		}
		
		/**
		@ sets the source of the image	
				 	 
		@ method dispose (public)
		@ params url:String.
		@ usage <code>image.source(url:String)</code>
		@ return void
		*/
		public function set source(url:String):void
		{
			sourceUrl = url;
			loadImage();
		}
		
		public function get source():String
		{
			return sourceUrl;
		}
		
		/**
		@ sets the scale mode	
				 	 
		@ method dispose (public)
		@ params mode:String.
		@ usage <code>image.set scaleMode(mode:String)</code>
		@ return void
		*/
		public function set scaleMode(mode:String):void
		{
			scaleMode = mode;	
		}
		
		public function get scaleMode():String
		{
			return scaleMode;
		}
		
		override public function set width(value:Number):void
		{
			imageMask.width = value;	
		}
		
		override public function set height(value:Number):void
		{
			imageMask.height = value;
		}
		
		/**
		@ loads the image	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code></code>
		@ return void
		*/
		private function loadImage():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleProfilePicLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleProfilePicLoadError);
			loader.load(new URLRequest(sourceUrl));
		}
		
		/**
		@ handles the profile pic load complete event	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code></code>
		@ return void
		*/
		private function handleProfilePicLoadComplete(event:Event):void
		{
			this.addChild(loader);
			layoutImage();
		}
		
		/**
		@ handle the profile pic load error	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleProfilePicLoadError(event:IOErrorEvent):void
		{
			
		}
		
		/**
		@ scales and positions the image according to the scale mode	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function layoutImage():void
		{
			if(scale == SCALE_TO_FIT)
			{
				loader.width = imageMask.width;
				loader.scaleY = loader.scaleX;
				if(loader.height > imageMask.height)
				{
					loader.height = imageMask.height;
					loader.scaleX = loader.scaleY;
				}
			}
			loader.x = (imageMask.width-loader.width)/2;
			loader.y = (imageMask.height-loader.height)/2;
		}
	}
}