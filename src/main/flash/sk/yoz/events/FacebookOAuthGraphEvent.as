package sk.yoz.events
{
	import flash.events.Event;
	import com.adobe.serialization.json.JSON;
	
	public class FacebookOAuthGraphEvent extends Event
	{
		public static const ERROR:String = 
			"FacebookOauthGraphEventERROR";
		public static const DATA:String = 
			"FacebookOauthGraphEventDATA";
		public static const AUTHORIZED:String = 
			"FacebookOauthGraphEventAUTHORIZED";
		public static const UNAUTHORIZED:String = 
			"FacebookOauthGraphEventUNAUTHORIZED";
		
		protected var _rawData:Object;
		protected var _data:Object;
		
		public function FacebookOAuthGraphEvent(
			type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
			rawData:Object="")
		{
			super(type, bubbles, cancelable);
			
			_rawData = rawData;
		}
		
		public function get rawData():Object
		{
			return _rawData;
		}
		
		public function get data():Object
		{
			trace("debug --> rawData.toString() :: ", rawData.toString());
			return _data ? _data : _data = JSON.decode(rawData.toString());
		}
	}
}