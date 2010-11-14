package com.codedrunks.facebook.events
{
	import flash.events.Event;
	
	public class FacebookGraphAPIEvent extends Event
	{
		public var name:String;
		public var picture:String;
		
		public static const FB_API_INITIALIZED:String = "fbApiInitialized";
		public static const FB_API_INITIALIZATION_FAILED:String = "fbApiInitializationFailed";
		
		public static const USER_INFO_SUCCESS:String = "userInfoSuccess";
		public static const USER_INFO_FAIL:String = "userInfoFail";
		
		public static const USER_LIKES_APP:String = "userLikesApp";
		public static const USER_LIKES_APP_FAIL:String = "userLikesAppFail";
		
		public static const WALL_POST_SUCCESS:String = "wallPostSuccess";
		public static const WALL_POST_FAIL:String = "wallPostFail";
		
		public var userName:String;
		public var userPic:String;
		public var userId:String;
		
		public function FacebookGraphAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}