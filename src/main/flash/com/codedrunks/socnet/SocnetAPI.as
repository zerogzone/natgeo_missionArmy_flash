package com.codedrunks.socnet
{
	import com.codedrunks.facebook.FacebookGraphAPI;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	import com.codedrunks.socnet.events.SocnetUserLikesEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ikriti.natgeo.vo.AttachmentVO;
	
	public class SocnetAPI extends EventDispatcher
	{
		private var facebookAPI:FacebookGraphAPI;
		private static var instance:SocnetAPI;
		
		private var flashvars:Object;
		private var userId:String;
		
		public function SocnetAPI(target:IEventDispatcher=null):void
		{
			
		}
		
		public static function getInstance():SocnetAPI
		{
			if(!instance)
			{
				instance = new SocnetAPI();
			}
			return instance;
		}
		
		/**
		 @ configures the socnet api	
		 
		 @ method dispose (public)
		 @ params parameters:Object.
		 @ usage <code>api.initalize(parameters:Object)</code>
		 @ return void
		 */
		public function initialize(parameters:Object, applicationID:String, secretKey:String, scope:String, redirectURI:String):void
		{
			flashvars = parameters;
			facebookAPI = new FacebookGraphAPI();
			facebookAPI.addEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZED, handleFBIntialized);
			facebookAPI.addEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZATION_FAILED, handleFBIntializationFailed);
			facebookAPI.initialize(flashvars.session, applicationID, secretKey, scope, redirectURI);
			
		}
		
		/**
		@ handles FBIntializationFailed event	
				 	 
		@ method dispose (private)
		@ params event:FacebookGraphAPIEvent.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handleFBIntializationFailed(event:FacebookGraphAPIEvent):void
		{
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZED, handleFBIntialized);
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZATION_FAILED, handleFBIntializationFailed);
			
			dispatchEvent(new SocnetAPIEvent(SocnetAPIEvent.INITIALIZE_FAILED));
		}
		
		/**
		 @ handles FBIntialization event	
		 
		 @ method dispose (private)
		 @ params event:FacebookGraphAPIEvent.
		 @ usage <code>usage</code>
		 @ return void
		 */
		private function handleFBIntialized(event:FacebookGraphAPIEvent):void
		{
			trace("debug --> SOCNET_FB_INITIALIZED", this);
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZED, handleFBIntialized);
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.FB_API_INITIALIZATION_FAILED, handleFBIntializationFailed);
			
			userId = facebookAPI.getUserId();
			
			dispatchEvent(new SocnetAPIEvent(SocnetAPIEvent.INITIALIZED));
		}
		
		/**
		@ returns the profile user info. If the application is in the app page, returns the user Info, else returns the profile info	
				 	 
		@ method dispose (public)
		@ params .
		@ usage <code>api.getProfileInfo()</code>
		@ return void
		*/
		public function getProfileInfo():void
		{
			disposeFacebookEvents();
			facebookAPI.addEventListener(FacebookGraphAPIEvent.USER_INFO_SUCCESS, handleUserInfoSuccess);
			facebookAPI.addEventListener(FacebookGraphAPIEvent.USER_INFO_FAIL, handleUserInfoFail);
			facebookAPI.getProfileInfo();
		}
		
		/**
		@ handles the user info success event	
				 	 
		@ method dispose (public)
		@ params event:FacebookGraphAPIEvent.
		@ usage <code>handleUserInfoSuccess(event:FacebookGraphAPIEvent)</code>
		@ return void
		*/
		private function handleUserInfoSuccess(event:FacebookGraphAPIEvent):void
		{
			disposeFacebookEvents();
			
			var e:SocnetUserInfoEvent = new SocnetUserInfoEvent(SocnetUserInfoEvent.USER_INFO_FETCHED);
			e.userName = event.userName;
			e.userId = event.userId;
			e.userPic = event.userPic;
			dispatchEvent(e);
		}
		
		/**
		 @ handles the user info success event	
		 
		 @ method dispose (public)
		 @ params event:FacebookGraphAPIEvent.
		 @ usage <code>handleUserInfoFail(event:FacebookGraphAPIEvent)</code>
		 @ return void
		 */
		private function handleUserInfoFail(event:FacebookGraphAPIEvent):void
		{
			disposeFacebookEvents();
			
			var e:SocnetUserInfoEvent = new SocnetUserInfoEvent(SocnetUserInfoEvent.USER_INFO_FAILED);
			dispatchEvent(e);
		}
		
		
		
		/**
		@ dispose facebook events	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function disposeFacebookEvents():void
		{
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.USER_INFO_SUCCESS, handleUserInfoSuccess);
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.USER_INFO_FAIL, handleUserInfoFail);
			
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.USER_LIKES_APP, handleUserLikesApp);
			facebookAPI.removeEventListener(FacebookGraphAPIEvent.USER_LIKES_APP_FAIL, handleUserLikesAppFail);
		}
		
		/**
		 @ publishs a message to the wall	
		 
		 @ method dispose (public)
		 @ params message:String, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null.
		 @ usage <code>className.publishToFeed(message:String, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null)</code>
		 @ return void
		 */
		/*public function publishToFeed(message:String, userId:String=null, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null):void
		{
			facebookAPI.publishToWall(message, userId, picture, link, name, caption, description, source);
			checkWallPosted();
		}*/
		
		public function publishToFeed(message:String, attachmentVO:Object, actionLinks:Array):void
		{
			facebookAPI.publishToProfile(message,attachmentVO,actionLinks);
			checkWallPosted();
		}
		
		
		
		/**
		@ checks if the user likes a particular application	
				 	 
		@ method dispose (public)
		@ params appId:String.
		@ usage <code>socnetApi.checkUserLikesApp(appId:String)</code>
		@ return void
		*/
		public function checkUserLikesApp(appId:String):void
		{
			facebookAPI.addEventListener(FacebookGraphAPIEvent.USER_LIKES_APP, handleUserLikesApp);
			facebookAPI.addEventListener(FacebookGraphAPIEvent.USER_LIKES_APP_FAIL, handleUserLikesAppFail);
			facebookAPI.checkUserLikesApp(appId);
		}
		
		public function checkWallPosted():void
		{
			facebookAPI.addEventListener(FacebookGraphAPIEvent.WALL_POST_SUCCESS, handleWallPostSuccess);
			facebookAPI.addEventListener(FacebookGraphAPIEvent.WALL_POST_FAIL, handleWallPostFail);
			trace("kichcha -->wall posting socnet API");
		}
		
		private function handleWallPostSuccess(event:FacebookGraphAPIEvent):void
		{
			var e:SocnetAPIEvent = new SocnetAPIEvent(SocnetAPIEvent.WALL_POST_SUCCESS);
			dispatchEvent(e);
		}
		
		private function handleWallPostFail(event:FacebookGraphAPIEvent):void
		{
			var e:SocnetAPIEvent = new SocnetAPIEvent(SocnetAPIEvent.WALL_POST_FAIL);
			dispatchEvent(e);
		}
		
		/**
		@ handles the user likes app event	
				 	 
		@ method dispose (private)
		@ params event:FacebookGraphAPIEvent.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handleUserLikesApp(event:FacebookGraphAPIEvent):void
		{
			disposeFacebookEvents();
			
			var e:SocnetUserLikesEvent = new SocnetUserLikesEvent(SocnetUserLikesEvent.USER_LIKES_APP);
			dispatchEvent(e);
		}
		
		/**
		 @ handles the user likes app fail event	
		 
		 @ method dispose (private)
		 @ params event:FacebookGraphAPIEvent.
		 @ usage <code>usage</code>
		 @ return void
		 */
		private function handleUserLikesAppFail(event:FacebookGraphAPIEvent):void
		{
			disposeFacebookEvents();
			
			var e:SocnetUserLikesEvent = new SocnetUserLikesEvent(SocnetUserLikesEvent.USER_DISLIKES_APP);
			dispatchEvent(e);
		}
		
		/**
		 @ returns the user id	
		 
		 @ method dispose (public)
		 @ params .
		 @ usage <code>api.getUserId()</code>
		 @ return String
		 */
		public function getUserId():String
		{
			return userId;
		}
	}
}