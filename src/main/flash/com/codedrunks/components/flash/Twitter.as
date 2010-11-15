package com.codedrunks.components.flash
{
	import com.codedrunks.utilities.StringUtil;
	import com.swfjunkie.tweetr.Tweetr;
	import com.swfjunkie.tweetr.data.objects.StatusData;
	import com.swfjunkie.tweetr.events.TweetEvent;
	
	import fl.data.DataProvider;
	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Twitter extends MovieClip
	{
		public static const CLOSE_EVENT:String = "closeEvent";
		
		public function Twitter()
		{
			super();
		}
		
		public function configure(userName:String, tweetProxy:String):void
		{
			var tweetr:Tweetr = new Tweetr();
			trace("debug --> tweetProxy :: ", tweetProxy);
			tweetr.serviceHost = tweetProxy;
			tweetr.addEventListener(TweetEvent.COMPLETE, handleTweetLoadComplete);
			tweetr.addEventListener(TweetEvent.FAILED, handleTweetLoadError);
			tweetr.getUserTimeLine(userName);
			 
			closeBtn.addEventListener(MouseEvent.CLICK, handleCloseEvent);
		}
		
		private function handleTweetLoadComplete(event:TweetEvent):void
		{
			trace("debug --> event.responseArray.length :: ", event.responseArray.length);
			var tweets:Array = event.responseArray;
			var tweetDp:DataProvider = new DataProvider(); 
			for (var i:int = 0; i < tweets.length; i++)
			{ 
				var element:StatusData = tweets[i] as StatusData;
				var tweet:String = StringUtil.enableHyperLinks(element.text, true, true, "#336699");
				
				tweetDp.addItem({label:tweet});
			}
			tweetList.setStyle("cellRenderer", TwitterItemRenderer);
			tweetList.dataProvider = tweetDp;
		} 
		
		private function handleTweetLoadError(event:TweetEvent):void
		{
			trace("debug --> Tweet load error", this);
		}
		
		private function handleCloseEvent(event:MouseEvent):void
		{
			dispatchEvent(new Event(CLOSE_EVENT, false));
		}
	}
}