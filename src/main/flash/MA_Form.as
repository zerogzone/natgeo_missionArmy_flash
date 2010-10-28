package  {
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserLikesEvent;
	
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MA_Form extends MovieClip {

		public var genderArray:Array;
		public var message:String;
		private var socnetAPI:SocnetAPI;
		private var applicationID:String = "155442984483491";
		private var secretKey:String = "94e365d702169396f836222cfa166fed";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/callback.html";
		private var fbPageId:String;
		
		public function MA_Form() 
		{
			genderArray = new Array();
			genderArray.push("male");
			genderArray.push("female");
			
			applicationID = loaderInfo.parameters.fbAppId;
			secretKey = loaderInfo.parameters.fbSek;
			redirectURI = loaderInfo.parameters.fbRedirectUrl;
			fbPageId = loaderInfo.parameters.fbPageId;
			
			initExternal();
			initSocnet();
		}
		
		private function initExternal():void
		{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("enableEntryForm", enableEntryForm);
			}
		}
		
		private function initSocnet():void
		{
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(loaderInfo.parameters, applicationID, secretKey, scope, redirectURI);
		}
		
		private function handleSocnetInitializeFail(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
		}
		
		private function handleSocnetInitialize(event:SocnetAPIEvent):void
		{
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			
			checkFBLike();
		}
		
		
		/**
		@ checks the fb like	
				 	 
		@ method dispose (private)
		@ params .
		@ usage <code>usage</code>
		@ return void
		*/
		private function checkFBLike():void
		{
			socnetAPI.addEventListener(SocnetUserLikesEvent.USER_LIKES_APP, handleUserLikesApp);
			socnetAPI.addEventListener(SocnetUserLikesEvent.USER_DISLIKES_APP, handleUserDislikesApp);
			socnetAPI.checkUserLikesApp(fbPageId);
		}
		
		private function enableEntryForm():void
		{
			trace("debug --> ENABLING ENTRY FORM", this);
			this.gotoAndStop(3);
			
			submit_btn.addEventListener(MouseEvent.CLICK,onClickSubmit);
			messageBox.ok_btn.addEventListener(MouseEvent.CLICK,onClickMessageOk);
			cmbGender.dataProvider = new DataProvider(genderArray);
		}
		
		/**
		@ user likes the app	
				 	 
		@ method dispose (private)
		@ params event:SocmetUserLikesEvent.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handleUserLikesApp(event:SocnetUserLikesEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserLikesEvent.USER_LIKES_APP, handleUserLikesApp);
			socnetAPI.removeEventListener(SocnetUserLikesEvent.USER_DISLIKES_APP, handleUserDislikesApp);
			
			trace("debug --> User LIKES the application", this);
			enableEntryForm();
		}
		
		/**
		@ user dis likes the app	
				 	 
		@ method dispose (private)
		@ params event:SocmetUserLikesEvent.
		@ usage <code>usage</code>
		@ return void
		*/
		private function handleUserDislikesApp(event:SocnetUserLikesEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserLikesEvent.USER_LIKES_APP, handleUserLikesApp);
			socnetAPI.removeEventListener(SocnetUserLikesEvent.USER_DISLIKES_APP, handleUserDislikesApp);
			
			trace("debug --> User DISLIKES the application", this);
			this.gotoAndStop(2);
		}
		
		/**
		@ handles the load IO error event	
				 	 
		@ method dispose (private)
		@ params event:IOErrorEvent.
		@ usage <code></code>
		@ return void
		*/			
		private function handleLoadIOError(event:IOErrorEvent):void
		{
			trace("Error --> Failed loading 'https://graph.facebook.com/me/likes' due to IO Error.");
		}
		
		/**
		@ handles the load security error	event
				 	 
		@ method dispose (private)
		@ params event:SecurityErrorEvent.
		@ usage <code></code>
		@ return void
		*/			
		private function handleLoadSecurityError(event:SecurityErrorEvent):void
		{
			trace("Error --> Failed loading 'https://graph.facebook.com/me/likes' due to security reasons.");
		}
		
		/**
		@ handles the load complete event	
				 	 
		@ method dispose (private)
		@ params event:Event.
		@ usage <code></code>
		@ return void
		*/			
		private function handleLoadComplete(event:Event):void
		{
			var xml:XML = XML(event.target.data);
			trace("debug --> load complete", this);
		}
		
		
		private function onClickMessageOk(e:MouseEvent):void
		{
			trace("message btn clicked");
			messageBox.visible = false;
		}
		
		private function onClickSubmit(e:MouseEvent):void
		{
			trace("clicked..");
			
			var email:String = email_txt.text; 
			
			if(firstName_txt.text == ""||lastName_txt.text == ""||weight_txt.text == ""||height_txt.text == ""||mobileNo_txt.text == ""||email_txt.text == "")
			{
				trace("message");
				messageBox.errorMessage.text = "Please fill all details";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if (firstName_txt.text.length <= 2)
			{
				messageBox.errorMessage.text = "Enter valid first name";
				trace("invalid name");
				
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if (lastName_txt.text.length <=2)
			{
				trace("invalid LastName");
				messageBox.errorMessage.text = "Enter valid last name";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if(weight_txt.text.length <2)
			{
				trace("invalid weight");
				messageBox.errorMessage.text = "Enter valid weight";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if (mobileNo_txt.text.length > 0 && mobileNo_txt.text.length <10)
			{
				trace("invalid mobile No.");
				messageBox.errorMessage.text = "Enter valid Mobile No.";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if(email.indexOf("@")<0)
			{
				trace("invalid email");
				trace("@"+email.indexOf("@"));
				messageBox.errorMessage.text = "Enter valid email";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if(email.indexOf("com")<0)
			{
				trace("invalid email");
				trace("com"+email.indexOf("com"));
				messageBox.errorMessage.text = "Enter valid email";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else if(email.indexOf(".")<0)
			{
				trace("invalid email");
				trace("."+email.indexOf("."));
				messageBox.errorMessage.text = "Enter valid email";
				messageBox.visible = true;
			}
			else
			{
				trace("valid name");
				trace("valid LastName");
				trace("valid weight:"+weight_txt.text.length);
				trace("valid email & mobile no");
			}
			
		}

	}
	
}
