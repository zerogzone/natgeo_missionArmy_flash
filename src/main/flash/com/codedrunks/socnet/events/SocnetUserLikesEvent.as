package com.codedrunks.socnet.events
{
	import flash.events.Event;
	
	public class SocnetUserLikesEvent extends Event
	{
		public static const USER_LIKES_APP:String = "userLikesApp";
		public static const USER_DISLIKES_APP:String = "userDislikesApp";
		
		public function SocnetUserLikesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}