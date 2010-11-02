/*
	www.video-flash.de
*/

package com.adobe.xml.syndication.rss
{
	/**
	*	Class that represents an Media RSS Category
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 8.5
	*	@tiptext
	* 
	* 	@see http://search.yahoo.com/mrss	
	*/	
	
	import com.adobe.xml.syndication.rss.*;
	import com.adobe.xml.syndication.*;

	
	public class MediaCategory
	{
		

		// XMLList
		private var x:XMLList;
		
		// media rss name space
		private var media:Namespace = Namespaces.MEDIA;
		
	
		public function MediaCategory(xl:XMLList) {
			
			// save XMLList in variable x
			x = xl;
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
			
		}
		
		
		public function get scheme():String {
			return ParsingTools.nullCheck(this.x..media::category.@scheme);
		}
		
		public function get label():String {
			return ParsingTools.nullCheck(this.x..media::category.@label);
		}
		
		public function get name():String {
			return ParsingTools.nullCheck(this.x..media::category);
		}	
		
		
		
	}
}
