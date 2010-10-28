package com.codedrunks.socnet.events
{
	import flash.events.Event;
	
	public class SocnetUserInfoEvent extends Event
	{
		public static const USER_INFO_FETCHED:String = "userInfoFetched";
		public static const USER_INFO_FAILED:String = "userInfoFailed";
		
		public var userId:String;
		public var userName:String;
		public var userPic:String;
		
		public function SocnetUserInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}