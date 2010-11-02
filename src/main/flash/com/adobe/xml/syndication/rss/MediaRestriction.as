/*
	www.video-flash.de
*/

package com.adobe.xml.syndication.rss
{
	/**
	*	Class that represents an Media RSS Copyright
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 8.5
	*	@tiptext
	* 
	* 	@see http://search.yahoo.com/mrss	
	*/	
	
	import com.adobe.xml.syndication.rss.*;
	import com.adobe.xml.syndication.*;
	
	public class MediaRestriction
	{
		
		// XMLList
		private var x:XMLList;
		
		// media rss name space
		private var media:Namespace = Namespaces.MEDIA;
		
	
		public function MediaRestriction(xl:XMLList) {
			
			// save XMLList in variable x
			x = xl;
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
			
		}
	
		public function get name():String {
			return ParsingTools.nullCheck(this.x..media::restriction);
		}
		
		public function get relationship():String {
			return ParsingTools.nullCheck(this.x..media::restriction.@relationship);
		}
		
		public function get type():String {
			return ParsingTools.nullCheck(this.x..media::restriction.@type);
		}	
		
		
	}
}
