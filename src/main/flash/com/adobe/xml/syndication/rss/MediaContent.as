/*
	www.video-flash.de
*/

package com.adobe.xml.syndication.rss
{
	/**
	*	Class that represents an Media RSS Content Tag
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 8.5
	*	@tiptext
	* 
	* 	@see http://search.yahoo.com/mrss
	 */
	
	import trace;
	import com.adobe.xml.syndication.*;
	import com.adobe.xml.syndication.rss.*;
	import com.hexagonstar.util.debug.Debug;	

	public class MediaContent
	{
		
		
		public var thumbnail:MediaThumbnail;
		
		public var category:MediaCategory;
		
		public var rating:MediaRating;
		
		public var copyright:MediaCopyright;
		
		public var credit:MediaCredit;
		
		public var description:MediaDescription;
		
		public var hash:MediaHash;
		
		public var keywords:MediaKeywords;
		
		public var player:MediaPlayer;
		
		public var restriction:MediaRestriction;
		
		public var title:MediaTitle;
		
		// XMLList
		private var x:XMLList;
		
		// media rss name space
		private var media:Namespace = Namespaces.MEDIA;


		/**
		 * Constructor
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 *
		 */
		
		public function MediaContent(xl:XMLList):void {
			
			// save XMLList in variable x
			x = xl;
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
			
		}	
		
		
		
		public function get url():String {
			if (ParsingTools.nullCheck(this.x.@url) != null) {
				return ParsingTools.nullCheck(this.x.@url);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@url);
		}
		
		public function get fileSize():Number {
			if (ParsingTools.nullCheck(this.x.@fileSize) != null) {
				return ParsingTools.nanCheck(this.x.@fileSize);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@fileSize);
		}
		
		public function get type():String {
			if (ParsingTools.nullCheck(this.x.@type) != null) {
				return ParsingTools.nullCheck(this.x.@type);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@type);
		}
		
		public function get medium():String {
			if (ParsingTools.nullCheck(this.x.@medium) != null) {
				return ParsingTools.nullCheck(this.x.@medium);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@medium);
		}
		
		public function get isDefault():String {
			if (ParsingTools.nullCheck(this.x.@isDefault) != null) {
				return ParsingTools.nullCheck(this.x.@isDefault);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@isDefault);
		}
		
		public function get expression():String {
			if (ParsingTools.nullCheck(this.x.@expression) != null) {
				return ParsingTools.nullCheck(this.x.@expression);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@expression);
		}
	
		public function get bitrate():Number {
			if (ParsingTools.nullCheck(this.x.@bitrate) != null) {
				return ParsingTools.nanCheck(this.x.@bitrate);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@bitrate);
		}
		
		public function get framerate():Number {
			if (ParsingTools.nullCheck(this.x.@framerate) != null) {
				return ParsingTools.nanCheck(this.x.@framerate);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@framerate);
		}
		
		public function get samplingrate():Number {
			if (ParsingTools.nullCheck(this.x.@samplingrate) != null) {
				return ParsingTools.nanCheck(this.x.@samplingrate);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@samplingrate);
		}
		
		public function get channels():Number {
			if (ParsingTools.nullCheck(this.x.@channels) != null) {
				return ParsingTools.nanCheck(this.x.@channels);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@channels);
		}
		
		public function get duration():Number {
			if (ParsingTools.nullCheck(this.x.@duration) != null) {
				return ParsingTools.nanCheck(this.x.@duration);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@duration);
		}
		
		public function get width():Number {
			if (ParsingTools.nullCheck(this.x.@width) != null) {
				return ParsingTools.nanCheck(this.x.@width);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@width);
		}
		
		public function get height():Number {
			if (ParsingTools.nullCheck(this.x.@height) != null) {
				return ParsingTools.nanCheck(this.x.@height);
			}
			
			return ParsingTools.nanCheck(this.x..media::content.@height);
		}
		
		public function get lang():String {
			if (ParsingTools.nullCheck(this.x.@lang) != null) {
				return ParsingTools.nullCheck(this.x.@lang);
			}
			
			return ParsingTools.nullCheck(this.x..media::content.@lang);
		}
		
	}
	

	

	
}
