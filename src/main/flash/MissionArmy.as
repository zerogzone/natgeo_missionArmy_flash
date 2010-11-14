package
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.codedrunks.components.flash.Image;
	import com.codedrunks.components.flash.Share;
	import com.codedrunks.components.flash.Twitter;
	import com.codedrunks.facebook.FacebookGraphAPI;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	
	import fl.controls.Button;
	import fl.events.SliderEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.sampler.pauseSampling;
	import flash.sensors.Accelerometer;
	import flash.system.*;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.describeType;
	
	import net.slideshowpro.slideshowpro.SSPModePlaybackEvent;
	import net.slideshowpro.slideshowpro.SSPVideoEvent;
	import net.slideshowpro.slideshowpro.SlideShowPro;
	import net.slideshowpro.slideshowpro.content.Content;
	import net.slideshowpro.slideshowpro.slideshowpro_ns;
	import net.slideshowpro.thumbgrid.TGThumbEvent;
	
	import sk.yoz.events.FacebookOAuthGraphEvent;
	import sk.yoz.net.FacebookOAuthGraph;
	
	public class MissionArmy extends MovieClip
	{
		private var flashvars:Object;
		private var applicationID:String = "153610078014709";
		private var secretKey:String = "4772b59f4bc07a941cf6b578c475a254";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://www.apptikka.com/ngc/mission_army/apps/callback.html";
		private var socnetAPI:SocnetAPI;
		private var profilePicLoader:Loader;
		private var player:Object;
		private var player2:Object;
		private var player3:Object;
		private var timer:Timer = new Timer(1000);
		private var url:String = "Yc2gW5K1s5Y";
		private var loader:Loader;
		private var loaderTwo:Loader;
		private var loaderThree:Loader;  
		private var playerNumber:Number = 1;
		
		private var share:Share;
		private var embedCode:String;
		private var wildfireUIConfig:String;
		private var memberId:String;
		private var twitter:Twitter;   
		[Bindable]
		private var shareImage:Image = new Image();
		private var image:Image = new Image();
		
		private var shareTimer:Timer = new Timer(2000);
		
		private var facebookWall:FacebookWall = new FacebookWall();
		 
		public function MissionArmy()
			
			 
		{
			super();
			initApp();
			//setFlashvars();
			trace("Constructor reached");
		}
		
		public function setFlashvars(parameters:Object):void
		{
			flashvars = parameters;
			init();
			trace("set flash vars");
		}
		
		private function init():void
		{
			trace("init()");
			loadConfig();
			
			//addToFacebookBtn.addEventListener(MouseEvent.CLICK, handleAddToFacebookBtnClick);
			shareBtn.addEventListener(MouseEvent.CLICK, handleShareBtnClick);
			//twitterBtn.addEventListener(MouseEvent.CLICK, handleTwitterBtnClick);
		}
		
		/**
		 @ loads the config xml	
		 
		 @ method dispose (private)
		 @ params .
		 @ usage <code></code>
		 @ return void
		 */
		private function loadConfig():void
		{
			trace("reachedload config");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleConfigLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleConfigLoadIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleConfigLoadSecurityError);
			urlLoader.load(new URLRequest(flashvars.configUrl));
		}
		/**
		 @ handles the load IO error event	
		 
		 @ method dispose (private)
		 @ params event:IOErrorEvent.
		 @ usage <code></code>
		 @ return void
		 */			
		private function handleConfigLoadIOError(event:IOErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to IO Error.");
		}
		
		/**
		 @ handles the load security error	event
		 
		 @ method dispose (private)
		 @ params event:SecurityErrorEvent.
		 @ usage <code></code>
		 @ return void
		 */			
		private function handleConfigLoadSecurityError(event:SecurityErrorEvent):void
		{
			trace("Error --> Failed loading 'url' due to security reasons.");
		}
		
		/**
		 @ handles the load complete event	
		 
		 @ method dispose (private)
		 @ params event:Event.
		 @ usage <code></code>
		 @ return void
		 */			
		private function handleConfigLoadComplete(event:Event):void
		{
			
			trace("reached handleload Complete");
			
			var xml:XML = XML(event.target.data);
			
			embedCode = xml.embedCode;
			wildfireUIConfig = xml.wildfireConfig;
			
			var tokens:XMLList = xml..token;
			for each (var token:XML in tokens) {
				var tokenValue:String = flashvars[token.@name];
				
				if (tokenValue == null) {
					tokenValue = token.@value;
				}
				/* *
				if (!httpRe.test(tokenValue as String) && urlTokens[token.@name] == true) {
				tokenValue = baseUrl + tokenValue;	
				}
				/* */
				
				flashvars[token.@name] = tokenValue;
			}
			
			initSocnet();
		}
		
		private function initSocnet():void
		{
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(flashvars, applicationID, secretKey, scope, redirectURI);
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
			
			fetchAuthorProfile();
		}
		
		private function fetchAuthorProfile():void
		{
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.addEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			socnetAPI.getProfileInfo();			
		}
		
		
		private function handleProfileInfoFetch(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
			
			profileMc.profileName.text = event.userName;
			
			image.source = event.userPic;
			image.width = profileMc.profilePicLoader.width;
			image.height = profileMc.profilePicLoader.height;
			profileMc.profilePicLoader.addChild(image);
			shareImage = image;
			//initApp();
		}
		
		private function handleProfileInfoFail(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
		}
		
		private function handleAddToFacebookBtnClick(event:MouseEvent):void
		{
			var onMindTxt:String = facebookWall.whatOnMind_txtInput.text;
			if(onMindTxt == "" || onMindTxt == "What's On your mind ?")
			{
				onMindTxt = "Nat Geo takes its cameras inside the Indian Army! Awesome!";
			}
			else
			{
				onMindTxt = facebookWall.whatOnMind_txtInput.text;
			}
			socnetAPI.publishToFeed(onMindTxt, null, "http://www.apptikka.com/ngc/mission_army/apps/assets/images/fb_wall_cover.png", "http://apps.facebook.com/natgeoindia/", "Idea Presents Nat Geo Mission Army", "http://apps.facebook.com/natgeoindia/" , "This is Nat Geo's biggest television event of the year. Enter Mission Army and live the life of a soldier. Five ordinary Indians will get the chance of a lifetime! And only one person will be a part of the Indian military training team abroad.", "http://www.apptikka.com/ngc/mission_army/apps/Container.swf");
			socnetAPI.addEventListener(SocnetAPIEvent.WALL_POST_SUCCESS,handleWallPostSuccess);
			socnetAPI.addEventListener(SocnetAPIEvent.WALL_POST_FAIL,handleWallPostFail);
		}
		
		private function handleWallPostSuccess(event:SocnetAPIEvent):void
		{
			facebookWall.successMsg.text = "Succesfully posted on your wall";
			shareTimer.addEventListener(TimerEvent.TIMER,handleTimerComplete);
			shareTimer.start();
		}
		
		private function handleWallPostFail(event:SocnetAPIEvent):void
		{
			facebookWall.successMsg.text = "Posting Failed";
			shareTimer.addEventListener(TimerEvent.TIMER,handleTimerComplete);
			shareTimer.start();
		}
		
		private function handleTimerComplete(event:TimerEvent):void
		{
			shareTimer.stop();
			removeChild(facebookWall);
			profileMc.profilePicLoader.addChild(image);
			trace("Hello Timer Stoped");
			
		}
		
		/*private function handleTwitterBtnClick(event:MouseEvent):void
		{
			if(!twitter)
			{
				var tweetrProxy:String = flashvars.twitterProxy;
				var tweetrUserName:String = flashvars.twitterUserName;
				
				twitter = new Twitter();
				twitter.addEventListener(Twitter.CLOSE_EVENT, handleTwitterClose);
				twitter.configure(tweetrUserName, tweetrProxy);
				this.addChild(twitter);
			}
			twitter.visible = true;
		}
		
		private function handleTwitterClose(event:Event):void
		{
			twitter.visible = false;			
		}*/
		
		//--------------------------------------------------
		
		private function initApp():void
		{
			//whatsOnUrMind.visible = false;
			removeEvents();
			removeEventsForMainPlayer();
			//Security.allow/ The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.Domain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);   
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				
				intro_mc.player_mc.addChild(loader); 
				loader.content.addEventListener("onReady", onPlayerReady);
				loader.content.addEventListener("onError", onPlayerError);
				loader.content.addEventListener("onStateChange", onPlayerStateChange);
				loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange); 
				loader.content.addEventListener(Event.COMPLETE,handleLoadeComplete);
			}
			
			function onPlayerReady(event:Event):void 
			{
				
				trace("KHJBFKNKEFBKNEFK KN BK I KLBIIFBEIBUEBFL N:IO IBLKF BHEVBFUGHFEB I LIBLJEFBIEFVBI EHIVEKG");
				
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player = loader.content;
				player.loadVideoById(url);
				
				// Set appropriate player dimensions for your application
				player.x = 0;
				player.y = 0;
				player.setSize(430, 240);
				playerNumber = 1;
				
				registerEvents();
				registerEventsForMainPlayer();
				
				timer.addEventListener(TimerEvent.TIMER,handleTimer);
				timer.start();
				
				
				loader.content.addEventListener("onStateChange", stateChangeHandler);
				
				
				intro_mc.player_mc.seekBar.addEventListener(SliderEvent.THUMB_PRESS,handleSliderChangeEvents);
				intro_mc.player_mc.seekBar.addEventListener(SliderEvent.THUMB_RELEASE,handleSliderChangeEvents);
			}
			
			function onPlayerError(event:Event):void 
			{
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
			function onPlayerStateChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
			function onVideoPlaybackQualityChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new video quality
				trace("video quality:", Object(event).data);
			}
			
			function handleLoadeComplete(event:Event):void
			{
				trace("Load Complete");
			}
			function handleSliderChangeEvents(event:Event):void 
			{ 
				switch(event.type)
				{
					case SliderEvent.THUMB_PRESS:
						player.pauseVideo();
						break;
					
					case SliderEvent.THUMB_RELEASE:
						player.seekTo(intro_mc.player_mc.seekBar.value,false);
						player.playVideo();
						break;
				}
			}
			
			
			
			
			
			function stateChangeHandler(event:Event):void
			{
				trace("player.getCurrentTime",event["data"]);
				intro_mc.player_mc.addChild(intro_mc.player_mc.seekBar);
				intro_mc.player_mc.seekBar.minimum = 0;
				intro_mc.player_mc.seekBar.maximum = player.getDuration();
				if(event["data"] == 1)
				{
					timer.addEventListener(TimerEvent.TIMER,handleTimer);
					timer.start();
				}
				else
				{ 
					timer.stop();
				} 
			}
			function handleTimer(event:TimerEvent):void
			{
				intro_mc.player_mc.seekBar.value = player.getCurrentTime();
			}
			
			//registerEvents();
			
		}
		
		
		//------------------------------getPlayer------------------------------
		
		
		private function getPlayer():void
		{
			removeEvents();
			removeEvetsForThumbs();
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			loaderTwo = new Loader();
			loaderTwo.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loaderTwo.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				intro_mc.addChild(loaderTwo);
				loaderTwo.content.addEventListener("onReady", onPlayerReady);
				loaderTwo.content.addEventListener("onError", onPlayerError);
				loaderTwo.content.addEventListener("onStateChange", onPlayerStateChange);
				loaderTwo.content.addEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange); 
			}
			
			function onPlayerReady(event:Event):void  
			{
				
				intro_mc.introBack_btn.addEventListener(MouseEvent.CLICK,handleintroBack_btnClicked);
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player2 = loaderTwo.content;
				player2.loadVideoById(url);
				// Set appropriate player dimensions for your application
				player2.x = 0;
				player2.y = 25;
				player2.setSize(200, 160);
				playerNumber = 2;
				loaderTwo.content.addEventListener("onStateChange", stateChangeHandlerLoaderTwo);
				registerEvents();
				registerEvetsForThumbs();
				registerEventsForPlayer2PlayPauseBtn();
			}
			
			function onPlayerError(event:Event):void
			{
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
			function onPlayerStateChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
			function onVideoPlaybackQualityChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new video quality 
				trace("video quality:", Object(event).data);
			}
			function stateChangeHandlerLoaderTwo(event:Event):void
			{
				trace("player.getCurrentTime",event["data"]);
				/*intro_mc.player_mc.addChild(intro_mc.player_mc.seekBar);
				intro_mc.player_mc.seekBar.minimum = 0;
				intro_mc.player_mc.seekBar.maximum = player.getDuration();*/
				if(event["data"] == 1)
				{
					/*timer.addEventListener(TimerEvent.TIMER,handleTimer);
					timer.start();*/
					
					//registerEventsForMainPlayer();
				}
				else
				{ 
					/*timer.stop();*/
				} 
			}
		}	
		
		
		//-------------------------------------getPlayerForPreviousWinners---------------------------
		private function getPlayerForPreviousWinners():void
		{
			play_btn.visible = false;
			removeEvents();
			removeEvetsForPreviousWinnersThumbs();
			removeEventsForPlayPauseBtn();
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			trace("1");
			// This will hold the API player instance once it is initialized.
			loaderThree = new Loader();
			loaderThree.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loaderThree.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				trace("2");
				previousWinners_mc.addChild(loaderThree);
				loaderThree.content.addEventListener("onReady", onPlayerReady);
				loaderThree.content.addEventListener("onError", onPlayerError);
				loaderThree.content.addEventListener("onStateChange", onPlayerStateChange);
				loaderThree.content.addEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange);
			}
			
			function onPlayerReady(event:Event):void 
			{
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player3 = loaderThree.content;
				player3.loadVideoById(url);
				// Set appropriate player dimensions for your application
				
				player3.x = 10;
				player3.y =10;
				player3.setSize(220,180);
				playerNumber = 3;
				
				registerEvents();
				registerEvetsForPreviousWinnersThumbs();
				registerEventsForPlayPauseBtn();
				pause_btn.visible = true;
				loaderThree.content.addEventListener("onStateChange", stateChangeHandlerLoaderThree);
			}
			
			function onPlayerError(event:Event):void
			{
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
			function onPlayerStateChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
			function onVideoPlaybackQualityChange(event:Event):void 
			{
				// Event.data contains the event parameter, which is the new video quality
				trace("video quality:", Object(event).data);
			}
			function stateChangeHandlerLoaderThree(event:Event):void
			{
				trace("player.getCurrentTime",event["data"]);
				/*intro_mc.player_mc.addChild(intro_mc.player_mc.seekBar);
				intro_mc.player_mc.seekBar.minimum = 0;
				intro_mc.player_mc.seekBar.maximum = player.getDuration();*/
				if(event["data"] == 1)
				{
					/*timer.addEventListener(TimerEvent.TIMER,handleTimer);
					timer.start();*/
					
					//registerEventsForMainPlayer();
				}
				else
				{ 
					/*timer.stop();*/
				} 
			}
		}
		//-------------------------------------Players ends---------------------------
		
		//----------------------  register events for social 
		
		function registerEvents_social():void
		{
			//share_btn.addEventListener(MouseEvent.CLICK,handleShareBtnClick);
		}
		
		private function handleShareBtnClick(event:MouseEvent):void
		{
			trace("share btn clicked");
			
			addChild(facebookWall);
			facebookWall.x = 0;
			facebookWall.y = 0;
			facebookWall.whatOnMind_txtInput.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDownWhatMind);
			//var shareProPic:shareProfilePic = new shareProfilePic();
			
			facebookWall.whatOnMind_txtInput.text ="What's On your mind ?";
			facebookWall.successMsg.text = "";
			facebookWall.shareProfilePic.profilePic.addChild(image);
			
			
			
			facebookWall.wallPostBtn.addEventListener(MouseEvent.CLICK,handleAddToFacebookBtnClick);
			facebookWall.cancelFacebookWallBtn.addEventListener(MouseEvent.CLICK,handleCancelFacebookWallBtnClicked);
			/*if(!share)
			{
				embedCode = StringUtil.replace(embedCode, "|userId|", memberId);
				share = new Share();
				share.addEventListener(Share.CLOSE_EVENT, handleShareClose);
				share.configure(embedCode, wildfireUIConfig, 400, 400);
				share.x = 0;
				share.y = 0;
				
				this.addChild(share);
			}
			share.visible = true;*/
		}
		
		private function handleMouseDownWhatMind(event:MouseEvent):void
		{
			facebookWall.whatOnMind_txtInput.text ="";
		}
		private function handleCancelFacebookWallBtnClicked(event:MouseEvent):void
		{
			profileMc.profilePicLoader.addChild(image);
			removeChild(facebookWall);
		}
		
		/*private function handleShareClose(event:Event):void
		{
			share.visible = false;
		}*/
		
	
		
		//-------------------------------------register events and handlers---------------------------
		
		
		function registerEvents():void
		{
			trace("");
			intro_btn.addEventListener(MouseEvent.CLICK,handleIntro_btnClicked);
			previousWinners_btn.addEventListener(MouseEvent.CLICK,handlePreviousWinners_btnClicked); 
			makeYourOwnVideo_btn.addEventListener(MouseEvent.CLICK,handleMakeYourOwnVideo_btnClicked);
			final5_btn.addEventListener(MouseEvent.CLICK,handleFinal5_btnClicked);
		}
		
		
		function removeEvents():void
		{
			intro_btn.removeEventListener(MouseEvent.CLICK,handleIntro_btnClicked);
			previousWinners_btn.removeEventListener(MouseEvent.CLICK,handlePreviousWinners_btnClicked); 
			makeYourOwnVideo_btn.removeEventListener(MouseEvent.CLICK,handleMakeYourOwnVideo_btnClicked);
			final5_btn.removeEventListener(MouseEvent.CLICK,handleFinal5_btnClicked);
			
		}
		
		private function handleIntro_btnClicked(event:MouseEvent):void
		{
			
			removeEvents();
			setPlayerNumber();
			intro_btn.enabled = true;
			trace("Intro Button Clicked"); 
			gotoAndStop("intro_frame");
			//whatsOnUrMind.visible = false;
			url = "Yc2gW5K1s5Y";
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			initApp();
			
		} 
		
		private function handlePreviousWinners_btnClicked(event:MouseEvent):void
		{
			
			//removeEvents();
			setPlayerNumber();
			//intro_btn.enabled = true;
			trace("previous Wnner Button Clicked");
			
			gotoAndStop("previousWinner_frame"); 
			//whatsOnUrMind.visible = false;
			moreInfo_mc.visible = false;
			previousWinners_thumbgrid.visible = false;
			episodeTitle.text = "";
			episodeDesccription.text = "Nat Geo's mission programs have always taken viewers inside places where cameras have rarely been. More importantly, for the people who took part in these missions - we changed their lives forever.They came in as ordinary citizens and they left with an experience that marked them for life! Meet our Nat Geo Mission Heroes.";
			moreInfo_btn.addEventListener(MouseEvent.CLICK,handleMoreInfoClicked);
			play_btn.visible = false;
			pause_btn.visible = true;
			url = "suoy_v6LTRI";
			getPlayerForPreviousWinners();
		} 
		private function handleMoreInfoClicked(event:MouseEvent):void
		{
			play_btn.visible = false;
			pause_btn.visible = false;
			moreInfo_btn.visible = false;
			previousWinners_thumbgrid.visible = false;
			moreInfo_btn.removeEventListener(MouseEvent.CLICK,handleMoreInfoClicked);
			moreInfo_mc.visible = true;
			if(playerNumber == 3)
			{
				player3.pauseVideo();
			}
			else if(playerNumber == 0)
			{
				
			}
			
			var tween:Tween = new Tween(moreInfo_mc,"alpha",None.easeIn,0,1,.3,true);
			moreInfo_mc.info.text = episodeDesccription.text;
			moreInfo_mc.close_btn.addEventListener(MouseEvent.CLICK,handleCloseBtnClicked);
		}
		
		private function handleCloseBtnClicked(event:MouseEvent):void
		{
			play_btn.visible = false;
			pause_btn.visible = false;
			moreInfo_btn.visible = true;
			
			moreInfo_mc.close_btn.removeEventListener(MouseEvent.CLICK,handleCloseBtnClicked);
			var tweenOut:Tween = new Tween(moreInfo_mc,"alpha",None.easeOut,1,0,.3,true);
			if(playerNumber == 3)
			{
				player3.playVideo();
				pause_btn.visible = true;
			}
			else if(playerNumber == 0)
			{
				previousWinners_thumbgrid.visible = true;
			}
			moreInfo_btn.addEventListener(MouseEvent.CLICK,handleMoreInfoClicked);
			pause_btn.addEventListener(MouseEvent.CLICK,handlePreviousWiinnerspause_btnClicked);
		}
		
		private function handleMakeYourOwnVideo_btnClicked(event:MouseEvent):void
		{
			
			//removeEvents();
			setPlayerNumber();
			trace("own video Button Clicked");
			gotoAndStop("makeYourOwnVideo_frame");
			//whatsOnUrMind.visible = false;
			intro_btn.enabled = true;
			//registerEvents();
			playerNumber = 4;
		}
		
		private function handleFinal5_btnClicked(event:MouseEvent):void
		{
			removeEvents();
			setPlayerNumber();
			playerNumber = 0;
			intro_btn.enabled = true;
			trace("Final5 Button Clicked");
			gotoAndStop("final5_frame");
			//whatsOnUrMind.visible = false;
			registerEvents();
			
			/*setPlayerNumber();
			gotoAndStop("final5_frame");*/
		}
		
		//-------------------------------------registerEvents For main Player and handlers ---------------------------
		
		function registerEventsForMainPlayer():void
		{
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			intro_mc.player_mc.play_btn.addEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
			intro_mc.player_mc.pause_btn.addEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
		}
		
		function removeEventsForMainPlayer():void
		{
			intro_mc.introMore_btn.removeEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			intro_mc.player_mc.play_btn.removeEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
			intro_mc.player_mc.pause_btn.removeEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
		}
		
		
		private function handleintroMore_btnClicked(event:MouseEvent):void
		{ 
			
			//removeEvents();
			setPlayerNumber();
			intro_btn.removeEventListener(MouseEvent.CLICK,handleIntro_btnClicked);
			intro_mc.gotoAndStop("moreContent");
			//intro_mc.whatsOnUrMind.visible = false;
			playerNumber = 0;
			registerEvetsForThumbs();
			intro_mc.play_btn.visible = false;
			intro_mc.pause_btn.visible = false;
			intro_mc.moreInfo_mc.visible = false;
			intro_mc.episodeTitle.text = "Episode 1: Inside the Indian Army";
			intro_mc.episodeDesccription.text = "Get an inside look at the second largest army in the world. Be a part of its history, customs, and its glorious traditions. Thousands of ordinary Indians from across the country endeavour to clear the specially designed SSB module that will give them a chance to enter this Mission. For the chosen few, a stringent medical examination is the next hurdle they need to cross. Fail that and they’re out of the Mission.";
			//url = "suoy_v6LTRI";
			intro_mc.introBack_btn.addEventListener(MouseEvent.CLICK,handleintroBack_btnClicked);
			intro_mc.moreInfo_btn.addEventListener(MouseEvent.CLICK,handleMoreInfoIntroClicked);
			//getPlayer(); 
		} 

		private function handleMoreInfoIntroClicked(event:MouseEvent):void
		{
			intro_mc.moreInfo_btn.removeEventListener(MouseEvent.CLICK,handleMoreInfoIntroClicked);
			intro_mc.moreInfo_btn.visible = false;
			intro_mc.moreInfo_mc.visible = true;
			var tweenStart:Tween = new Tween(intro_mc.moreInfo_mc,"alpha",None.easeIn,0,1,.3,true);
			intro_mc.moreInfo_mc.info.text = intro_mc.episodeDesccription.text;
			intro_mc.moreInfo_mc.close_btn.addEventListener(MouseEvent.CLICK,handleCloseBtnIntroClicked);
		}
		
		private function handleCloseBtnIntroClicked(event:MouseEvent):void
		{
			
			intro_mc.moreInfo_mc.close_btn.removeEventListener(MouseEvent.CLICK,handleCloseBtnIntroClicked);
			var tweenStop:Tween = new Tween(intro_mc.moreInfo_mc,"alpha",None.easeOut,1,0,.3,true);
			intro_mc.moreInfo_btn.visible = true;
			intro_mc.moreInfo_btn.addEventListener(MouseEvent.CLICK,handleMoreInfoIntroClicked);
		}
		
		private function handlePlayBtnClicked(event:MouseEvent):void
		{
			trace("handlePlayBtnClicked");
			player.playVideo();
			//registerEvents();
		}
		
		private function handlePauseBtnClicked(eevent:MouseEvent):void
		{
			trace("handlePauseBtnClicked");
			player.pauseVideo();
			//registerEvents();
			
		}
		
		
		
	//=-----------------------register events for PlayPauseBtn and handlers=----------------------------
		
		
		private function registerEventsForPlayPauseBtn():void
		{
			play_btn.addEventListener(MouseEvent.CLICK,handlePreviousWiinersPlayBtnClicked);
			pause_btn.addEventListener(MouseEvent.CLICK,handlePreviousWiinnerspause_btnClicked);
		}
		private function removeEventsForPlayPauseBtn():void
		{
			play_btn.removeEventListener(MouseEvent.CLICK,handlePreviousWiinersPlayBtnClicked);
			pause_btn.removeEventListener(MouseEvent.CLICK,handlePreviousWiinnerspause_btnClicked);
		}
		
		private function handlePreviousWiinersPlayBtnClicked(event:MouseEvent):void
		{
			player3.playVideo();
			play_btn.visible = false;
			pause_btn.visible = true;
			play_btn.removeEventListener(MouseEvent.CLICK,handlePreviousWiinersPlayBtnClicked);
			pause_btn.addEventListener(MouseEvent.CLICK,handlePreviousWiinnerspause_btnClicked);
		}
		private function handlePreviousWiinnerspause_btnClicked(event:MouseEvent):void
		{
			player3.pauseVideo()
			pause_btn.visible = false;
			play_btn.visible = true;
			pause_btn.removeEventListener(MouseEvent.CLICK,handlePreviousWiinnerspause_btnClicked);
			play_btn.addEventListener(MouseEvent.CLICK,handlePreviousWiinersPlayBtnClicked);
		}
		
		
		
		
		//------------------------- registerEventsForPlayer2PlayPauseBtn and handlers----------------------------------
		
		
		private function registerEventsForPlayer2PlayPauseBtn():void
		{
			intro_mc.play_btn.addEventListener(MouseEvent.CLICK,handleIntro_mcPlayBtnClicked);
			intro_mc.pause_btn.addEventListener(MouseEvent.CLICK,handleintro_mc_pause_btnClicked);
		}
		
		private function handleIntro_mcPlayBtnClicked(event:MouseEvent):void
		{
			player2.playVideo();
			intro_mc.play_btn.visible = false;
			intro_mc.pause_btn.visible = true;
			intro_mc.play_btn.removeEventListener(MouseEvent.CLICK,handleIntro_mcPlayBtnClicked);
			intro_mc.pause_btn.addEventListener(MouseEvent.CLICK,handleintro_mc_pause_btnClicked);
		}
		
		private function handleintro_mc_pause_btnClicked(event:MouseEvent):void
		{
			player2.pauseVideo()
			intro_mc.pause_btn.visible = false;
			intro_mc.play_btn.visible = true;
			intro_mc.pause_btn.removeEventListener(MouseEvent.CLICK,handleintro_mc_pause_btnClicked);
			intro_mc.play_btn.addEventListener(MouseEvent.CLICK,handleIntro_mcPlayBtnClicked);
		}
		
		//-------------------------------register Evets For Thumbs ------------------------
		
		
		
		private function registerEvetsForThumbs():void
		{
			intro_mc.thumbgrid.addEventListener(TGThumbEvent.CLICK_THUMB,onThumbClick);
			intro_mc.previous_btn.addEventListener("click",handlePrevious_btnClicked);
			intro_mc.next_btn.addEventListener("click",handleNext_btnClicked);
		}
		
		private function removeEvetsForThumbs():void
		{
			intro_mc.thumbgrid.removeEventListener(TGThumbEvent.CLICK_THUMB,onThumbClick);
			intro_mc.previous_btn.removeEventListener("click",handlePrevious_btnClicked);
			intro_mc.next_btn.removeEventListener("click",handleNext_btnClicked);
		}
		
		private function onThumbClick(event:TGThumbEvent):void
		{ 
			setPlayerNumber();
			//registerEventsForPlayPauseBtn();
			
			intro_mc.play_btn.visible = false;
			intro_mc.pause_btn.visible = false;
			trace("thumb hnbdjbejdb Clicked"); 
			intro_mc.episodeTitle.text = event.data.title;
			intro_mc.episodeDesccription.text = event.data.caption;
			trace("event.data.description",event.data.caption); 
			//url = event.data.link;
			//getPlayer();
		}
		
		private function handlePrevious_btnClicked(event:Event):void 
		{
			trace("previos Button Clicked");
		}
		
		private function handleNext_btnClicked(event:MouseEvent):void
		{
			trace("Next Button Clicked");
		}
		
		
		//-------------------------------------registerEvetsForPreviousWinnersThumbs------------------
		
		private function registerEvetsForPreviousWinnersThumbs():void
		{
			thumbgrid_previousWinners.addEventListener(TGThumbEvent.CLICK_THUMB,onpreviousWinners_thumbgrid);
			trace("registerEvetsForPreviousWinnersThumbs");
		}
		private function removeEvetsForPreviousWinnersThumbs():void
		{
			thumbgrid_previousWinners.removeEventListener(TGThumbEvent.CLICK_THUMB,onpreviousWinners_thumbgrid);
			trace("registerEvetsForPreviousWinnersThumbs");
		}
		
		private function onpreviousWinners_thumbgrid(event:TGThumbEvent):void
		{
			setPlayerNumber();
			playerNumber = 0;
			play_btn.visible = false;
			pause_btn.visible = false;
			previousWinners_thumbgrid.visible = true;
			//url = event.data.link;
			trace("event.data.link;",event.data.link);
			trace("k,hdknolvbik biibidc",event.data.title);
			trace("k,hdknolvbik biibidc",event.data.caption);
			episodeTitle.text = event.data.title;
			episodeDesccription.text = event.data.caption;
			//getPlayerForPreviousWinners();
		}
		
		
		//============================== set Player for destroing old player andd Loader=-------------------------
		
		
		private function setPlayerNumber():void 
		{	
			//intro_btn.addEventListener(MouseEvent.CLICK,handleIntro_btnClicked);
			//timer.stop();
			trace("playerNumber",playerNumber);
			if (playerNumber == 1)
			{
				player.destroy();
				intro_mc.player_mc.removeChild(loader);
			}
			else if(playerNumber == 2 )
			{ 
				trace("playerNumber",playerNumber);
				player2.destroy();  
				intro_mc.removeChild(loaderTwo);
			} 
			else if(playerNumber == 3)
			{ 
				player3.destroy();
				previousWinners_mc.removeChild(loaderThree);
			}
			else if(playerNumber == 0)
			{
				
			}
		}
		
		private function handleintroBack_btnClicked(event:MouseEvent):void	
		{
			playerNumber = 0;
			setPlayerNumber();
			intro_mc.gotoAndStop("mainContent");
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			url = "Yc2gW5K1s5Y";
			initApp();
			//registerEvents();
			//player2.visible = false;
		}
	}
}