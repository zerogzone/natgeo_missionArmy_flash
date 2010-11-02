package com.codedrunks.util
{
	import com.footprints.Footprints;
	import com.footprints.ShareService;
	import com.footprints.config.TrackerConfig;
	import com.footprints.constants.TrackerConstants;
	import com.footprints.message.TrackerMessage;
	import com.footprints.sqs.config.SQSConfig;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class FootprintsUtil
	{
		public static const NAME:String = getQualifiedClassName(FootprintsUtil);
		
		public static const AWS_SECRET_KEY:String = "TDWZ9zQm+ocueF7WC7LJGDbTpFL7n05zwJgjywhD";
		public static const AWS_ACCESS_KEY:String = "AKIAILE3DBMFFTBKGRFA";
		public static const AWS_QUEUE_URL:String = "https://queue.amazonaws.com/220572930944/NatgeoMomentAwards";
		
		public static var tracker:Footprints;
		public static var shareService:ShareService;
		public static var initFootprints:Boolean = true;
		
		private static var app:DisplayObject;
		
		public function FootprintsUtil()
		{
		}
		
		public static function initTracker(app:DisplayObject):Footprints
		{
			FootprintsUtil.app = app;
			
			tracker = Footprints.getInstance("footprints");
			trace("debug --> Initializing tracker", tracker);
			shareService = new ShareService(tracker, ShareService.GIGYA);
			return tracker;
		}
		
		public static function configTracker(params:Object):void
		{
            var config : TrackerConfig = new TrackerConfig();
            var sqsConfig : SQSConfig = new SQSConfig(AWS_SECRET_KEY, AWS_ACCESS_KEY, AWS_QUEUE_URL);
            
            config.setQueDispatchLength(100);
            config.setQueDispatchTimer(10000);
            config.sqsConfig = sqsConfig;
          	
            try
            {
				trace("debug --> CONFIGURING FOOTPRINTS:: APP", app, "PARAMS", params, tracker);
	            tracker.setConfig(config, app);
            }
            catch(error:Error)
            {
            	trace("Error --> :: [", getQualifiedClassName(FootprintsUtil),']', error.getStackTrace());
            }
            
            tracker.addEventListener(Footprints.TRACKER_READY, trackerReadyEventListener);
            tracker.addEventListener(Footprints.TRACKER_FAILED, trackerFailedEventListener);
		}
		
		public static function track(eventName:String, messageType:String, componentName:String, componentType:String=null, resourse:String=null, videoPlaybackPercent:int=-1, isInteraction:Boolean=false, interactionCategory:String=null):void
		{
			if(initFootprints)
			{
				try
				{
					
					trace("debug --> MESSAGE NAME", eventName);
					var message : TrackerMessage = new TrackerMessage(eventName, 0, messageType);
		            message.componentName = componentName;
		            message.isInteraction = (isInteraction)? 1 : 0 ;
		            message.interactionCatgory = interactionCategory;
					if(componentType)
		            {
		            	message.eventAttributes.put(TrackerConstants.COMPONENT_TYPE, componentType);
					}
					if(resourse)
					{
						message.eventAttributes.put(TrackerConstants.RESOURCE, resourse);
					}
					if(videoPlaybackPercent != -1)
					{
						message.eventAttributes.put(TrackerConstants.PLAYBACK_PERCENT, videoPlaybackPercent);
					}
					tracker.trackMessage(message);	
				}
				catch(error:Error)
				{
					trace("Error --> :: [", getQualifiedClassName(FootprintsUtil),']', error.getStackTrace());
				}
			}
			else
			{
				trace("debug --> NO MESSAGES TRACKING. initFootprints set to FALSE", eventName);
			}
		}

		public static function getTracker():Footprints
		{
			return tracker;			
		}
		
		private static function trackerReadyEventListener(e:Event):void
		{
			trace(NAME+ ": trackerReadyEventListener() ");
		}				

		private static function trackerFailedEventListener(e:Event):void
		{
			trace(NAME+ ": trackerFailedEventListener() ");
		}				
	}
}