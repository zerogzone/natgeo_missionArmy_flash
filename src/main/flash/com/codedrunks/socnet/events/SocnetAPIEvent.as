package com.codedrunks.socnet.events
{
	import flash.events.Event;
	
	public class SocnetAPIEvent extends Event
	{
		public static const INITIALIZED:String = "initialized";
		public static const INITIALIZE_FAILED:String = "initializeFailed";
		
		public static const WALL_POST_SUCCESS:String = "wallPostSuccess";
		public static const WALL_POST_FAIL:String = "wallPostFail";
		
		public function SocnetAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}