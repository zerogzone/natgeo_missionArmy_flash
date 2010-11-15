package com.codedrunks.facebook
{
	import com.adobe.serialization.json.JSON;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import ikriti.natgeo.vo.AttachmentVO;
	
	import sk.yoz.events.FacebookOAuthGraphEvent;
	import sk.yoz.net.FacebookOAuthGraph;

	public class FacebookGraphAPI extends EventDispatcher
	{
		
		public static const USER_INFO:String = "userInfo";
		public static const USER_PICTURE:String = "userPicture";
		public static const PUBLISH_TO_WALL:String = "publishToWall";
		public static const USER_LIKES_APP:String = "userLikesApp";
		
		public var apiSecuredPath:String = "https://graph.facebook.com/";
		public var apiUnsecuredPath:String = "http://graph.facebook.com/";
		
		private var accessToken:String;
		private var userId:String;
		
		private var loader:URLLoader;
		
		private var currentRequest:String;
		private var currentEvent:Event;
		
		private var fbAuthGraph:FacebookOAuthGraph;
		
		private var applicationID:String;
		private var secretKey:String;
		private var scope:String;
		private var redirectURI:String;
		
		private var tempAppId:String;
		
		public function FacebookGraphAPI()
		{
			super();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadSecurityError);
		}
		
		/**
		@ initializes the application	
				 	 
		@ method dispose (private)
		@ params fbSessionStr:String, applicationID:String, secretKey:String, scope:String, redirectURI:String, useSecure:Boolean=true.
		@ usage <code>api.initialize((flashvars.session, applicationID, secretKey, scope, redirectURI);</code>
		@ return void
		*/
		public function initialize(fbSessionStr:String, applicationID:String, secretKey:String, scope:String, redirectURI:String, useSecure:Boolean=true):void
		{
			var fbTokens:Object = parseFBSession(fbSessionStr);
			if(fbTokens)
			{
				if(fbTokens.access_token != null)
				{
					accessToken = fbTokens.access_token;
					userId = fbTokens.uid;
					dispatchEvent(new FacebookGraphAPIEvent(FacebookGraphAPIEvent.FB_API_INITIALIZED));
					trace("debug --> FB_INITIALIZED", this);
				}
			}
			else
			{
				fbAuthGraph = new FacebookOAuthGraph();
				fbAuthGraph.clientId = applicationID;
				fbAuthGraph.redirectURI = redirectURI;
				fbAuthGraph.scope = scope;
				fbAuthGraph.useSecuredPath = useSecure;
				fbAuthGraph.addEventListener(FacebookOAuthGraphEvent.AUTHORIZED, handleFBAuthGraphAuthorize);
				fbAuthGraph.connect();
			}
		}
		
		/**
		@ handles the security error for the facebook call	
				 	 
		@ method dispose (private)
		@ params event:SecurityErrorEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleLoadSecurityError(event:SecurityErrorEvent):void
		{
			handleErrorEvent();
		}
		
		/**
		@ handles the load IO error	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleLoadError(event:IOErrorEvent):void
		{
			handleErrorEvent();
		}
		
		/**
		@ handles the FBAuthGraph authorize event	
				 	 
		@ method dispose (private)
		@ params event:FacebookOAuthGraphEvent.
		@ usage <code></code>
		@ return void
		*/
		private function handleFBAuthGraphAuthorize(event:FacebookOAuthGraphEvent):void
		{
			accessToken = fbAuthGraph.token;
			userId = fbAuthGraph.me.id;
			
			dispatchEvent(new FacebookGraphAPIEvent(FacebookGraphAPIEvent.FB_API_INITIALIZED));
		}
		
		/**
		@ handles the error events	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function handleErrorEvent():void
		{
			var e:FacebookGraphAPIEvent;
			switch(currentRequest)
			{
				case USER_INFO:
					e = new FacebookGraphAPIEvent(FacebookGraphAPIEvent.USER_INFO_FAIL);								
					break;
				
				case PUBLISH_TO_WALL:
					e = new FacebookGraphAPIEvent(FacebookGraphAPIEvent.WALL_POST_FAIL);
					trace("Error --> PUBLISH TO WALL FAILED", this);
					break;
				
				case USER_LIKES_APP:
					e = new FacebookGraphAPIEvent(FacebookGraphAPIEvent.USER_LIKES_APP_FAIL);					
					break;
			}
			if(e)
			{
				dispatchEvent(e);
			}
		}
		
		/**
		@ handles the load complete of the facebook call	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code></code>
		@ return void
		*/
		private function handleLoadComplete(event:Event):void
		{
			var e:FacebookGraphAPIEvent;
			switch(currentRequest)
			{
				case USER_INFO:
					e = new FacebookGraphAPIEvent(FacebookGraphAPIEvent.USER_INFO_SUCCESS);
					var res:String = event.target.data;
					var resObj:Object = JSON.decode(res);
					for (var i:String in resObj)
					{
						trace("debug --> i :: ", i, ", resObj[i] :: ", resObj[i]);
					}
					trace("debug --> resObj.name :: ", resObj.name);
					e.userName = resObj.name;
					e.userId = resObj.id;
					e.userPic = apiUnsecuredPath + e.userId + "/picture";
					break;
				
				case PUBLISH_TO_WALL:
					e = new FacebookGraphAPIEvent(FacebookGraphAPIEvent.WALL_POST_SUCCESS);
					trace("debug --> PUBLISH TO WALL COMPLETE", this);
					break;
				
				case USER_LIKES_APP:
					e = checkIfUserLikesTheApp(event);					
					break;
			}
			if(e)
			{
				dispatchEvent(e);
			}
		}
		
		/**
		@ checks if the user likes the application	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function checkIfUserLikesTheApp(event:Event):FacebookGraphAPIEvent
		{
			var res:String = event.target.data;
			var resObj:Object = JSON.decode(res);
			var likesList:Array = resObj.data as Array;
			for (var i:int = 0; i < likesList.length; i++)
			{
				var element:Object = likesList[i] as Object;
				if(element.id == tempAppId)
				{
					return new FacebookGraphAPIEvent(FacebookGraphAPIEvent.USER_LIKES_APP);
				}
			}
			return new FacebookGraphAPIEvent(FacebookGraphAPIEvent.USER_LIKES_APP_FAIL);
		}
		
		/**
		@ parses the Facebook Session string and generates JSON object	
				 	 
		@ method dispose (private)
		@ params session:String.
		@ usage <code>usage</code>
		@ return Object
		*/
		private function parseFBSession(session:String):Object
		{
			if(session)
			{
				var tokens:Object = JSON.decode(session, false);
				for (var i:String in tokens)
				{
					trace("debug --> i :: ", i, ", tokens[i] :: ", tokens[i]);
				}
				return tokens;
			}
			else
			{
				return null;
			}
		}
		
		/**
		@ returns the profile owner info	
				 	 
		@ method dispose (public)
		@ params .
		@ usage <code>api.getProfileInfo()</code>
		@ return void
		*/
		public function getProfileInfo():void
		{
			currentRequest = USER_INFO;
			
			var url:String = apiUnsecuredPath+userId;
			loader.load(new URLRequest(url));
		}
		
		/**
		@ publishs a message to the wall	
				 	 
		@ method dispose (public)
		@ params message:String, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null.
		@ usage <code>className.publishToWall(message:String, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null)</code>
		@ return void
		*/
		
		public function publishToProfile(message:String, attachment:Object, actionLinks:Array):void
		{
			currentRequest = PUBLISH_TO_WALL;
			
			var data:URLVariables = new URLVariables();
			data.message = message;
			data.attachment = JSON.encode(attachment);
			data.action_links = JSON.encode(actionLinks);
			data.access_token = accessToken;
			
			var url:String = "https://api.facebook.com/method/stream.publish";
			var request:URLRequest = new URLRequest(url);
			request.data = data;	
			request.method = URLRequestMethod.POST;
			loader.load(request);
		}
		
		public function publishToWall(message:String, userId:String=null, picture:String=null, link:String=null, name:String=null, caption:String=null, description:String=null, source:String=null):void
		{
			currentRequest = PUBLISH_TO_WALL;
			/* *
			var uid:String = (userId)? userId : this.userId;
			var url:String = apiSecuredPath+uid+"/feed";
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			requestVars.access_token = accessToken;
			requestVars.message = message;
			requestVars.picture = picture;
			requestVars.link = link;
			requestVars.name = name;
			requestVars.caption = caption;
			requestVars.description = description;
			requestVars.source = source;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			loader.load(request);
			/* */
			
			trace("debug --> publishing to wall", this);
			
			/* */
			var media:Object = {};
			media.type = "flash";
			media.swfsrc = source;
			media.imgsrc = picture;
			media.width = "132";
			media.height = "100";
			media.expanded_width = "460";
			media.expanded_height = "460";
			
			var attachment:Object = {};
			attachment.name = name;
			attachment.link = link;
			attachment.description = description;
			attachment.caption = caption;
			attachment.media = [media];
			
			var data:URLVariables = new URLVariables();
			data.message = message;
			data.attachment = JSON.encode(attachment);
			data.access_token = accessToken;
			
			var url:String = "https://api.facebook.com/method/stream.publish";
			var request:URLRequest = new URLRequest(url);
			request.data = data;
			request.method = URLRequestMethod.POST;
			loader.load(request);
			/* */
		}
		
		/**
		@ checks if the user likes an application	
				 	 
		@ method dispose (public)
		@ params appId:String.
		@ usage <code>api.checkUserLikesApp(appId:String)</code>
		@ return void
		*/
		public function checkUserLikesApp(appId:String):void
		{
			currentRequest = USER_LIKES_APP;
			tempAppId = appId;
			
			var url:String = apiSecuredPath+userId+"/likes?access_token="+accessToken;
			var request:URLRequest = new URLRequest(url);
			loader.load(request);
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