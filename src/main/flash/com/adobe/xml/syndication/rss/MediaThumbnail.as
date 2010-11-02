/*
	www.video-flash.de
*/

package com.adobe.xml.syndication.rss
{
	/**
	*	Class that represents an Media RSS Thumbnail
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 8.5
	*	@tiptext
	* 
	* 	@see http://search.yahoo.com/mrss	
	*/	
	
	import com.adobe.xml.syndication.rss.*;
	import com.adobe.xml.syndication.*;
	
	public class MediaThumbnail
	{
		
	
		// XMLList
		private var x:XMLList;
		
		// media rss name space
		private var media:Namespace = Namespaces.MEDIA;
		
	
		public function MediaThumbnail(xl:XMLList) {
			
			// save XMLList in variable x
			x = xl;
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
			
		}
		
		public function get url():String {
			return ParsingTools.nullCheck(this.x..media::thumbnail.@url);
		}
		
		public function get width():Number {
			return ParsingTools.nanCheck(this.x..media::thumbnail.@width);
		}
		
		public function get height():Number {
			return ParsingTools.nanCheck(this.x..media::thumbnail.@height);
		}
		
		public function get time():String {
			return ParsingTools.nullCheck(this.x..media::thumbnail.@time);
		}
		
	}
	
	
	
}
