package com.codedrunks.socnet.events
{
	import flash.events.Event;
	
	public class SocnetAPIEvent extends Event
	{
		public static const INITIALIZED:String = "initialized";
		public static const INITIALIZE_FAILED:String = "initializeFailed";
		
		public function SocnetAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}