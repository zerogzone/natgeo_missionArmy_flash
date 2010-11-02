package com.adobe.xml.syndication.rss {
	import com.adobe.xml.syndication.Namespaces;
	import com.hexagonstar.util.debug.Debug;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class MediaGroup {
		
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
		
		public function MediaGroup(xl:XMLList) {
			
			// save XMLList in variable x
			x = xl;
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
			
		}	
		
		public function get items():Array {
			var itemsArray:Array = new Array();
			var item:Object;
			var group:XMLList = x.media::group;

			if (group != null) {
				var mediaContentList:XMLList = group..media::content;
				var n:int = mediaContentList != null ? mediaContentList.length() : 0;
				
				var i:int;
				var child:XML;
				var childContent:XML;
				var mediaContent:MediaContent;
				var childList:XMLList;
				for (i = 0; i < n; i++) {
					child = mediaContentList[i];
					
					childList = XMLList(child);
					//Debug.trace("childList = " + childList.toXMLString());
					
					mediaContent = new MediaContent(childList);
					//Debug.trace("child at " + i + " = " + mediaContent.width);
					//Debug.traceObj(mediaContent);
					
					itemsArray.push(mediaContent);
				}
			}			
			
			return itemsArray;	
		}
		
		
	}
}
