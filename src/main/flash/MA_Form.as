package  {
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	import com.codedrunks.socnet.events.SocnetUserLikesEvent;
	import com.codedrunks.utilities.RemotingService;
	
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.utils.Timer;
	
	import ikriti.natgeo.vo.EnumGenderVO;
	import ikriti.natgeo.vo.EnumMemberStatusVO;
	import ikriti.natgeo.vo.FbUserVO;
	import ikriti.natgeo.vo.MaParticipantVO;
	import ikriti.natgeo.vo.MemberVO;
	
	public class MA_Form extends MovieClip { 

		public var genderArray:Array;
		public var message:String; 
		private var socnetAPI:SocnetAPI;
		private var applicationID:String = "153610078014709";
		private var secretKey:String = "4772b59f4bc07a941cf6b578c475a254";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://apptikka.com/natgeoindia/fb/missionarmy/pages/natgeo_site/option1/callback.html";
		private var fbPageId:String;
		private var rs:RemotingService;
		
		private var fbUser:FbUserVO;
		private var member:MemberVO;
		private var maParticipant:MaParticipantVO;
		private var isInitializing:Boolean;
		
		public function MA_Form() 
		{
			trace("in the document class constructor");
			genderArray = new Array();
			genderArray.push("male");
			genderArray.push("female"); 
			applicationID = loaderInfo.parameters.fbAppId;
			secretKey = loaderInfo.parameters.fbSek;
			redirectURI = loaderInfo.parameters.fbRedirectUrl;
			fbPageId = loaderInfo.parameters.fbPageId;
			
			if (ExternalInterface.available) {
				try {
					
					
					if (checkJavaScriptReady()) {
						//output.appendText("JavaScript is ready.\n");
					} else {
						//output.appendText("JavaScript is not ready, creating timer.\n");
						var readyTimer:Timer = new Timer(100, 0);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				} catch (error:SecurityError) {
					//output.appendText("A SecurityError occurred: " + error.message + "\n");
				} catch (error:Error) {
					//output.appendText("An Error occurred: " + error.message + "\n");
				}
			} else {
				//output.appendText("External interface is not available for this container.");
			}
			
			isInitializing = true;
			
			messageBox.ok_btn.addEventListener(MouseEvent.CLICK,onClickMessageOk);
			disablerMc.addEventListener(MouseEvent.CLICK, handleDisablerClick);
			//disablerMc.mouseEnabled = false;
			disablerMc.useHandCursor = false;
			
			messageBox.errorMessage.text = "If you have popup blocker enabled on your browser, please click OK to continue";
			messageBox.x = 320;
			messageBox.y = 50;
			messageBox.visible = true;
			
			initRemoting();
			initExternal();
			initSocnet();
			//enableEntryForm();
			mobileNo_txt.text = "91-";
		}
		
		private function handleDisablerClick(event:MouseEvent):void
		{
			
		}
		
		
        private function checkJavaScriptReady():Boolean {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
        private function timerHandler(event:TimerEvent):void {
            //output.appendText("Checking JavaScript status...\n");
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
               // output.appendText("JavaScript is ready.\n");
                Timer(event.target).stop();
            }
        }
		
		private function initRemoting():void
		{
			var remotingDestination:String = "http://www.apptikka.com/natgeoindia/messagebroker/amf";
			rs = new RemotingService(remotingDestination);
			registerRemoteVOs();
			/* *
			member = new MemberVO();
			member.firstname = "Manu George";
			
			fbUser = new FbUserVO();
			fbUser.photoUrl = "http://www.google.com";
			fbUser.facebookId = "1288328160165";
			fbUser.member = member;
			
			saveFbUserDetails();
			/* */
		}
		
		private function registerRemoteVOs():void
		{      
			registerClassAlias("ikriti.natgeo.vo.FbUserVO", ikriti.natgeo.vo.FbUserVO);      
			registerClassAlias("ikriti.natgeo.vo.MemberVO", ikriti.natgeo.vo.MemberVO);      
			registerClassAlias("ikriti.natgeo.vo.EnumGenderVO", ikriti.natgeo.vo.EnumGenderVO);      
			registerClassAlias("ikriti.natgeo.vo.EnumMemberStatusVO", ikriti.natgeo.vo.EnumMemberStatusVO);      
			registerClassAlias("ikriti.natgeo.vo.MaParticipantVO", ikriti.natgeo.vo.MaParticipantVO);      
		}
		
		private function initExternal():void
		{
			if (ExternalInterface.available) {
				trace("external interface available")
				ExternalInterface.addCallback("enableEntryForm", enableEntryForm);
			}
		} 
		
		private function initSocnet():void
		{
			trace("init socNet....");
			
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
			isInitializing = false;
			messageBox.visible = false;
				
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.removeEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			
			getFbUserDetails();
			//unlike_msg.visible = false;
		}
		
		private function getFbUserDetails():void
		{
			trace("debug --> getting fb user details", this);
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleFbUserInfo);
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleFbUserInfoFail);
			socnetAPI.getProfileInfo();
		}
		
		private function handleFbUserInfo(event:SocnetUserInfoEvent):void
		{
			trace("debug --> fb user details fetched", this);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleFbUserInfo);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleFbUserInfoFail);
			
			member = new MemberVO();
			member.firstname = event.userName;
			
			fbUser = new FbUserVO();
			fbUser.photoUrl = event.userPic;
			fbUser.facebookId = event.userId;
			fbUser.member = member
			
			saveFbUserDetails();
			checkFBLike();
		}
		
		private function handleFbUserInfoFail(event:SocnetUserInfoEvent):void
		{
			trace("debug --> fb user details fetch failed", this);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleFbUserInfo);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleFbUserInfoFail);
			
			checkFBLike();
		}
		
		private function saveFbUserDetails():void
		{
			var responder:Responder = new Responder(handleAssociateFbResult, handleAssociateFbFault);
			rs.call("remoteMemberService.associateFB", responder, fbUser);
		}

		private function handleAssociateFbResult(result:Object):void
		{
			trace("debug --> result", result);
			
			fbUser = result as FbUserVO;
			member = fbUser.member;
			
			//saveMaParticipant();
		}
		 
		private function handleAssociateFbFault(fault:Object):void
		{
			trace("debug --> fault", fault);
		}
		
		
		/**
		@ checks the fb like	
				 	 
		@ method dispose (private)
		@ params 
		@ usage <code>usage</code>
		@ return void
		*/
		private function checkFBLike():void
		{
			trace("in the FB check..");
			socnetAPI.addEventListener(SocnetUserLikesEvent.USER_LIKES_APP, handleUserLikesApp);
			socnetAPI.addEventListener(SocnetUserLikesEvent.USER_DISLIKES_APP, handleUserDislikesApp);
			socnetAPI.checkUserLikesApp(fbPageId);
		}
		
		private function enableEntryForm():void
		{
			trace("debug --> ENABLING ENTRY FORM", this);
			//this.gotoAndStop(3);
			this.gotoAndStop(2);
			
			disablerMc.mouseEnabled = false;  
			unlike_msg.x = 270;
			unlike_msg.y = -54;
			//unlike_msg.visible = false;
			
			//ExternalInterface.call("removeAlertText");
			submit_btn.addEventListener(MouseEvent.CLICK,onClickSubmit);
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
			
			trace("debug --> User LIKES the application wow..", this);
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
			disablerMc.mouseEnabled = true;
			//unlike_msg.visible = true;
			unlike_msg.x = 261;
			unlike_msg.y = 121;
			ExternalInterface.call("displayAlertText");
			//disableForm();
			
		}
		
		/*private function disableForm()
		{
			firstName_txt.visible = false;
		}*/
		
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
			
			if(isInitializing)
			{
				initSocnet();
			}
		}
		
		private function onClickSubmit(e:MouseEvent):void
		{
			gotoAndStop("1");
			trace("clicked..");
			
			var email:String = email_txt.text; 
			var userHeight:String = height_txt.text;
			var mobileNo:String = mobileNo_txt.text;
			
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
			else if(userHeight.indexOf(".")== -1 && height_txt.text.length !=3)
			{
				trace("invalid height");
				messageBox.errorMessage.text = "Enter valid height";
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
			else if ( mobileNo.indexOf("-")!= -1 && mobileNo_txt.text.length > 0 && mobileNo_txt.text.length <13 ||mobileNo.indexOf("-")==-1 && mobileNo_txt.text.length > 0 && mobileNo_txt.text.length <10)
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
			else if(userHeight.indexOf(".")!=-1 && userHeight.indexOf(".")<=2)
			{
				trace("invalid height index ."+userHeight.indexOf("."));
				messageBox.errorMessage.text = "Enter valid height";
				messageBox.x = 320;
				messageBox.y = 50;
				messageBox.visible = true;
			}
			else
			{
				trace("valid name");
				trace("valid LastName");
				trace("valid weight:"+weight_txt.text.length);
				trace("valid email & mobile no");
				
				saveMaParticipant();
			}
			
		}
		
		private function saveMaParticipant():void
		{
			var gender:EnumGenderVO = new EnumGenderVO();
			gender.id = (cmbGender.selectedLabel == genderArray[0])? EnumGenderVO.MALE : EnumGenderVO.FEMALE;
			
			member.email = email_txt.text;
			member.gender = gender;
			member.mobile = mobileNo_txt.text;
			member.lastname = lastName_txt.text;
			member.firstname = firstName_txt.text;
			
			maParticipant = new MaParticipantVO();
			maParticipant.age = String(ageStepper.value);
			maParticipant.height  = height_txt.text;
			maParticipant.weight = weight_txt.text;
			maParticipant.member = member;
			
			var responder:Responder = new Responder(handleRegisterParticipantResult, handleRegisterParticipantFault);
			rs.call("remoteMemberService.registerMissionArmyParticipant", responder, maParticipant);
		}
		
		private function handleRegisterParticipantResult(result:Object):void
		{
			gotoAndStop("2");
			messageBox.errorMessage.text = "Thank you for participating in Idea Presents Nat Geo Mission Army. We will get back to you regarding the next stage shortly.";
			messageBox.x = 320;
			messageBox.y = 50;
			messageBox.visible = true;
		}
		
		private function handleRegisterParticipantFault(fault:Object):void
		{
			gotoAndStop("2");
			messageBox.errorMessage.text = "We are  sorry, we couldnt complete the request. Please try again.";
			messageBox.x = 320;
			messageBox.y = 50;
			messageBox.visible = true;
		}

	}
	
}
