package sk.yoz.net
{
	import com.adobe.serialization.json.JSON;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import sk.yoz.events.FacebookOAuthGraphEvent;
	
	public class FacebookOAuthGraph extends EventDispatcher
	{
		public var clientId:String;
		public var redirectURI:String;
		public var scope:String;
		
		public var jsConfirm:String = "confirmFacebookConnection";
		public var jsWindowName:String = "facebookConnector";
		public var apiSecuredPath:String = "https://graph.facebook.com";
		public var apiUnsecuredPath:String = "http://graph.facebook.com";
		public var useSecuredPath:Boolean = true;
		
		protected var tokenCallbackDefined:Boolean;
		protected var _authorized:Boolean;
		protected var _token:String;
		protected var _savedSession:SharedObject;
		protected var _me:Object;
		
		public function FacebookOAuthGraph():void
		{
			super();
			
			Security.loadPolicyFile(apiSecuredPath + "/crossdomain.xml");
			Security.loadPolicyFile(apiUnsecuredPath + "/crossdomain.xml");
		}
		
		public function get token():String
		{
			return _token;
		}
		
		public function get authorized():Boolean
		{
			return _authorized;
		}
		
		public function get me():Object
		{
			return _me;
		}
		
		public function get authorizationURL():String
		{
			return apiPath + "/oauth/authorize"
				+ "?client_id=" + clientId 
				+ "&redirect_uri=" + redirectURI
				+ "&type=user_agent"
				+ "&scope=" + scope
				+ "&display=popup";
		}
		
		public function get apiPath():String
		{
			return useSecuredPath ? apiSecuredPath : apiUnsecuredPath;
		}
		
		protected function get savedSession():SharedObject
		{
			if(_savedSession)
				return _savedSession;
			
			var name:String = "FBContainerTest" + clientId;
			_savedSession = SharedObject.getLocal(name);
			return _savedSession;
		}
		
		public function verifySavedToken():URLLoader
		{
			return savedSession.data.token
				? verifyToken(savedSession.data.token)
				: null;
		}
		
		public function verifyToken(token:String):URLLoader
		{
			var loader:URLLoader = call("me", null, "", token);
			loader.addEventListener(FacebookOAuthGraphEvent.DATA, 
				function(event:FacebookOAuthGraphEvent):void
				{
					EventDispatcher(event.currentTarget).removeEventListener(event.type, arguments.callee);
					verifyTokenSuccess(event, token);
				});
			loader.addEventListener(FacebookOAuthGraphEvent.ERROR, handleVerifyError);
			return loader;
		}
		
		private function handleVerifyError(event:FacebookOAuthGraphEvent):void
		{
			trace("debug --> verify error", this);
			savedSession.data.token = null;
			savedSession.flush();
			connect();
		}
		
		protected function verifyTokenSuccess(event:FacebookOAuthGraphEvent, 
											  token:String):void
		{
			_me = event.data;
			_token = token;
			_authorized = true;
			
			savedSession.data.token = token;
			savedSession.flush();
			
			trace("debug --> veryfying token success :: _me.name :: ", _me.name);
			
			if(_me.name != null)
			{
				var type:String = FacebookOAuthGraphEvent.AUTHORIZED;
				dispatchEvent(new FacebookOAuthGraphEvent(type));
			}
			else
			{
				savedSession.data.token = null;
				savedSession.flush();
				connect();
			}
		}
		
		public function connect():void
		{
			try
			{
				if(!verifySavedToken())
				{
					if(!tokenCallbackDefined)
					{
						tokenCallbackDefined = true;
						ExternalInterface.addCallback(jsConfirm, confirmConnection);
					}
					
					var id:String = ExternalInterface.objectID;
					var url:String = authorizationURL;
					var name:String = jsWindowName;
					var props:String = "width=670,height=370";
					var js:String = ''
						+ 'if(!window.' + jsConfirm + '){'
						+ '    window.' + jsConfirm + ' = function(hash){'
						+ '        var flash = document.getElementById("' + id + '");'
						+ '        flash.' + jsConfirm + '(hash);'
						+ '    }'
						+ '};'
						+ 'window.open("' + url + '", "' + name + '", "' + props + '");'
					
					ExternalInterface.call("function(){" + js + "}");
				}
			}
			catch(error:Error)
			{
				trace("kichcha --> error External Interface",error);
			}
		}
		
		public function confirmConnection(hash:String):void
		{
			if(hash)
				verifyToken(hashToToken(hash));
		}
		
		public function autoConnect(parameters:Object=null):URLLoader
		{
			if(parameters && parameters.hasOwnProperty("session"))
			{
				var session:Object = JSON.decode(parameters.session);
				if(session.access_token)
					return verifyToken(session.access_token);
			}
			
			return verifySavedToken();
		}
		
		public function call(path:String, data:URLVariables=null, 
							 method:String="", token:String=null, apiPath:String=null):URLLoader
		{
			trace("debug --> fetching me", this);
			if(!data)
				data = new URLVariables();
			data.access_token = token || this.token;
			
			var url:String = (apiPath || this.apiPath) + '/' + path;
			var request:URLRequest = new URLRequest(url);
			request.data = data;
			request.method = method || URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader();
			loaderAddListeners(loader);
			loader.load(request);
			return loader;
		}
		
		protected function loaderComplete(event:Event):void
		{
			trace("debug --> load complete", this);
			var loader:URLLoader = URLLoader(event.currentTarget);
			loaderRemoveListeners(loader);
			
			var type:String = FacebookOAuthGraphEvent.DATA;
			loader.dispatchEvent(new FacebookOAuthGraphEvent(
				type, false, false, loader.data));
		}
		
		protected function loaderError(event:IOErrorEvent):void
		{
			trace("Error --> load error", this);
			var loader:URLLoader = URLLoader(event.currentTarget);
			loaderRemoveListeners(loader);
			
			var type:String = FacebookOAuthGraphEvent.ERROR;
			loader.dispatchEvent(
				new FacebookOAuthGraphEvent(type, false, false, event.text));
		}
		
		protected function loaderSecurityError(event:SecurityErrorEvent):void
		{
			var loader:URLLoader = URLLoader(event.currentTarget);
			loaderRemoveListeners(loader);
			
			var type:String = FacebookOAuthGraphEvent.ERROR;
			loader.dispatchEvent(
				new FacebookOAuthGraphEvent(type, false, false, event.text));
		}
		
		protected function loaderAddListeners(loader:URLLoader):void
		{
			var type:String = Event.COMPLETE;
			loader.addEventListener(type, loaderComplete, false, int.MAX_VALUE);
			
			type = IOErrorEvent.IO_ERROR;
			loader.addEventListener(type, loaderError, false, int.MAX_VALUE);
			
			type = SecurityErrorEvent.SECURITY_ERROR;
			loader.addEventListener(type, loaderSecurityError, false, 
				int.MAX_VALUE);
		}
		
		protected function loaderRemoveListeners(loader:URLLoader):void
		{
			var type:String = Event.COMPLETE;
			loader.removeEventListener(type, loaderComplete, false);
			
			type = IOErrorEvent.IO_ERROR;
			loader.removeEventListener(type, loaderError, false);
			
			type = SecurityErrorEvent.SECURITY_ERROR;
			loader.removeEventListener(type, loaderSecurityError, false);
		}
		
		protected function hashToToken(hash:String):String
		{
			hash = hash.substr(0, 1) == "#" ? hash.substr(1) : hash;
			var data:URLVariables = new URLVariables(hash);
			return data.access_token;
		}
		
		protected function tokenToExpiration(token:String):Date
		{
			var chunks:Array = token.split(".");
			var matches:Array = String(chunks[3]).match(/^([0-9]+)\-[0-9]/);
			return new Date(Number(String(matches[1])) * 1000);
		}
	}
}