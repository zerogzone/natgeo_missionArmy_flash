/*
	www.video-flash.de
	
	
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.xml.syndication.rss {
	import com.adobe.xml.syndication.Namespaces;
	import com.adobe.xml.syndication.NewsFeedElement;
	import com.adobe.xml.syndication.rss.*;	

	/**
	 * Class that represents an Media RSS item.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 * 
	 * @see http://search.yahoo.com/mrss
	 */	
	public class MediaRSSItem20
		extends Item20
	
	{

		// media rss name space
		private var media:Namespace = Namespaces.MEDIA;		

		/**
		 * Create a new Media RSS Item20 instance.
		 * 
		 * @param x The XML with which to construct the item.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 */
		public function MediaRSSItem20(x:XMLList)
		{
			super(x);
			
			// define namespace for media rss
			media = x.namespace("media");
			
			// add name space to xmllist
			x.addNamespace(media);
		}


		
		/**
		 * Media RSS Part
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 8.5
		 * @tiptext
		 *
		 * @see http://search.yahoo.com/mrss
		 */
		

		public function get mediaContent():MediaContent	{
			var result:MediaContent = new MediaContent(x);
			return result;
		}
		
		public function get mediaGroup():MediaGroup {
			var result:MediaGroup = new MediaGroup(x);
			return result;	
		}

		public function get mediaThumbnail():MediaThumbnail	{
			var result:MediaThumbnail = new MediaThumbnail(x);
			return result;
		}
		
		public function get mediaCategory():MediaCategory	{
			var result:MediaCategory = new MediaCategory(x);
			return result;
		}
		
		public function get mediaRating():MediaRating	{
			var result:MediaRating = new MediaRating(x);
			return result;
		}
		
		public function get mediaCopyright():MediaCopyright	{
			var result:MediaCopyright = new MediaCopyright(x);
			return result;
		}
		
		public function get mediaCredit():MediaCredit	{
			var result:MediaCredit = new MediaCredit(x);
			return result;
		}
		
		public function get mediaDescription():MediaDescription	{
			var result:MediaDescription = new MediaDescription(x);
			return result;
		}
		
		public function get mediaHash():MediaHash	{
			var result:MediaHash = new MediaHash(x);
			return result;
		}

		public function get mediaKeywords():MediaKeywords	{
			var result:MediaKeywords = new MediaKeywords(x);
			return result;
		}
		
		public function get mediaPlayer():MediaPlayer	{
			var result:MediaPlayer = new MediaPlayer(x);
			return result;
		}
		
		public function get mediaRestriction():MediaRestriction	{
			var result:MediaRestriction = new MediaRestriction(x);
			return result;
		}
		
		public function get mediaTitle():MediaTitle	{
			var result:MediaTitle = new MediaTitle(x);
			return result;
		}
		

		
	}
}