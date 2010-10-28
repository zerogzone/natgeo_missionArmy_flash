package
{
	
	import com.adobe.serialization.json.JSON;
	import com.codedrunks.components.flash.Image;
	import com.codedrunks.facebook.FacebookGraphAPI;
	import com.codedrunks.facebook.events.FacebookGraphAPIEvent;
	import com.codedrunks.socnet.SocnetAPI;
	import com.codedrunks.socnet.events.SocnetAPIEvent;
	import com.codedrunks.socnet.events.SocnetUserInfoEvent;
	
	import fl.controls.Button;
	import fl.events.SliderEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
		private var applicationID:String = "155442984483491";
		private var secretKey:String = "94e365d702169396f836222cfa166fed";
		private var scope:String = "publish_stream,user_photos";
		private var redirectURI:String = "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/callback.html";
		private var socnetAPI:SocnetAPI;
		private var profilePicLoader:Loader;
		private var player:Object;
		private var player2:Object;
		private var playerPreviousWinners:Object;
		private var timer:Timer = new Timer(10);
		private var url:String = "http://youtu.be/xqsghiveYMQ";
		private var urlPreviousWinners:String = "http://youtu.be/xqsghiveYMQ";
		private var loader:Loader = new Loader();
		private var loaderTwo:Loader = new Loader();
		private var loaderPreviouWinners = new Loader();
		
		public function MissionArmy()
		{
			super();
			initApp();
			registerEvents();
		}
		
		private function initApp():void
		{
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				intro_mc.player_mc.addChild(loader);
				loader.content.addEventListener("onReady", onPlayerReady);
				loader.content.addEventListener("onError", onPlayerError);
				loader.content.addEventListener("onStateChange", onPlayerStateChange);
				loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			}
			
			function onPlayerReady(event:Event):void {
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player = loader.content;
				player.cueVideoById("1_hnTNlYCbw");
				
				
				
				// Set appropriate player dimensions for your application
				player.x = 0;
				player.y = 0;
				player.setSize(430, 240);
				loader.content.addEventListener("onStateChange", stateChangeHandler);
				
				intro_mc.player_mc.seekBar.addEventListener(SliderEvent.THUMB_PRESS,handleSliderChangeEvents);
				intro_mc.player_mc.seekBar.addEventListener(SliderEvent.THUMB_RELEASE,handleSliderChangeEvents);
			}
			
			function onPlayerError(event:Event):void {
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
			function onPlayerStateChange(event:Event):void {
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
			function onVideoPlaybackQualityChange(event:Event):void {
				// Event.data contains the event parameter, which is the new video quality
				trace("video quality:", Object(event).data);
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

		}
		
		private function registerEvetsForThumbs():void
		{
			intro_mc.thumbgrid.addEventListener(TGThumbEvent.CLICK_THUMB,onThumbClick);
			intro_mc.previous_btn.addEventListener("click",handlePrevious_btnClicked);
			intro_mc.next_btn.addEventListener("click",handleNext_btnClicked);
		}
		
		private function onThumbClick(event:TGThumbEvent):void
		{
			trace("thumb Clicked");
			intro_mc.episodeTitle.text = event.data.title;
			trace("event.data.description",event.data.description);
			//intro_mc.episodeDesccription.text = event.data.description;
			player2.destroy();
			url = event.data.link;
			getPlayer();
		}
		
		private function registerEvetsForPreviousWinnersThumbs():void
		{
			previousWinners_thumbgrid.addEventListener(TGThumbEvent.CLICK_THUMB,onpreviousWinners_thumbgrid);
		}
		
		private function onpreviousWinners_thumbgrid(event:TGThumbEvent):void
		{
			playerPreviousWinners.destroy();
			urlPreviousWinners = event.data.link;
			trace("event.data.link;",event.data.link);
			getPlayerForPreviousWinner();
		}
		
		private function handlePrevious_btnClicked(event:MouseEvent):void 
		{
			trace("previos Button Clicked");
		}
		
		private function handleNext_btnClicked(event:MouseEvent):void
		{
			trace("Next Button Clicked");
		}
		
		private function getPlayer():void
		{
			
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			loaderTwo.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loaderTwo.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				intro_mc.addChild(loaderTwo);
				loaderTwo.content.addEventListener("onReady", onPlayerReady);
				loaderTwo.content.addEventListener("onError", onPlayerError);
				loaderTwo.content.addEventListener("onStateChange", onPlayerStateChange);
				loaderTwo.content.addEventListener("onPlaybackQualityChange", 
				onVideoPlaybackQualityChange);
			}
			
			function onPlayerReady(event:Event):void 
			{
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player2 = loaderTwo.content;
				player2.cueVideoByUrl(url);
				// Set appropriate player dimensions for your application
				player2.x = 2;
				player2.y = 25;
				player2.setSize(200, 160);
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
			
		}
		
		private function getPlayerForPreviousWinner():void
		{
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
			// This will hold the API player instance once it is initialized.
			loaderPreviouWinners.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loaderPreviouWinners.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			function onLoaderInit(event:Event):void 
			{
				previousWinners_mc.addChild(loaderPreviouWinners);
				loaderPreviouWinners.content.addEventListener("onReady", onPlayerReady);
				loaderPreviouWinners.content.addEventListener("onError", onPlayerError);
				loaderPreviouWinners.content.addEventListener("onStateChange", onPlayerStateChange);
				loaderPreviouWinners.content.addEventListener("onPlaybackQualityChange", 
				onVideoPlaybackQualityChange);
			}
			
			function onPlayerReady(event:Event):void 
			{
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				playerPreviousWinners= loaderPreviouWinners.content;
				playerPreviousWinners.cueVideoByUrl(urlPreviousWinners);
				// Set appropriate player dimensions for your application
				playerPreviousWinners.x = 18;
				playerPreviousWinners.y = 24;
				playerPreviousWinners.setSize(200, 160);
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
		}
		
		private function registerEvents():void
		{
			intro_btn.addEventListener(MouseEvent.CLICK,handleIntro_btnClicked);
			previousWinners_btn.addEventListener(MouseEvent.CLICK,handlePreviousWinners_btnClicked); 
			makeYourOwnVideo_btn.addEventListener(MouseEvent.CLICK,handleMakeYourOwnVideo_btnClicked);
		    final5_btn.addEventListener(MouseEvent.CLICK,handleFinal5_btnClicked);
			
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			
			intro_mc.player_mc.play_btn.addEventListener(MouseEvent.CLICK,handlePlayBtnClicked);
			intro_mc.player_mc.pause_btn.addEventListener(MouseEvent.CLICK,handlePauseBtnClicked);
		}
		
		
		private function handleIntro_btnClicked(event:MouseEvent):void
		{
			trace("Intro Button Clicked"); 
			gotoAndStop("intro_frame");
			initApp();
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
		} 
		
		private function handlePreviousWinners_btnClicked(event:MouseEvent):void
		{
			trace("previous Wnner Button Clicked");
			gotoAndStop("previousWinner_frame");
			registerEvetsForPreviousWinnersThumbs();
			getPlayerForPreviousWinner();
		}
		
		private function handleMakeYourOwnVideo_btnClicked(event:MouseEvent):void
		{
			trace("own video Button Clicked");
			gotoAndStop("makeYourOwnVideo_frame");
		}
		
		private function handleFinal5_btnClicked(event:MouseEvent):void
		{
			trace("Final5 Button Clicked");	
			gotoAndStop("final5_frame");
		}
		
		private function handleintroMore_btnClicked(event:MouseEvent):void
		{
			player.destroy();
			intro_mc.gotoAndStop("moreContent");
			intro_mc.episodeTitle.text = "Episode 1";
			url = "http://youtu.be/xqsghiveYMQ";
			intro_mc.introBack_btn.addEventListener(MouseEvent.CLICK,handleintroBack_btnClicked);
			getPlayer();
			registerEvetsForThumbs();
		} 
		
		private function handleintroBack_btnClicked(event:MouseEvent):void	
		{
			player2.destroy();
			player2.visible = false;
			initApp();
			intro_mc.gotoAndStop("mainContent");
			intro_mc.introMore_btn.addEventListener(MouseEvent.CLICK,handleintroMore_btnClicked);
			registerEvents();
		}
		
		public function setFlashvars(parameters:Object):void
		{
			flashvars = parameters;
			init();
		}
		
		private function handlePlayBtnClicked(event:MouseEvent):void
		{
			trace("handlePlayBtnClicked");
			player.playVideo();
			registerEvents();
		}
		
		private function handlePauseBtnClicked(eevent:MouseEvent):void
		{
			trace("handlePauseBtnClicked");
			player.pauseVideo();
			registerEvents();
			
		}
		
		private function init():void
		{
			socnetAPI = SocnetAPI.getInstance();
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZED, handleSocnetInitialize);
			socnetAPI.addEventListener(SocnetAPIEvent.INITIALIZE_FAILED, handleSocnetInitializeFail);
			socnetAPI.initialize(flashvars, applicationID, secretKey, scope, redirectURI);
			
			addToFacebookBtn.addEventListener(MouseEvent.CLICK, handleAddToFacebookBtnClick);
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
			var image:Image = new Image();
			image.source = event.userPic;
			image.width = profileMc.profilePic.width;
			image.height = profileMc.profilePic.height; 
			
			profileMc.profilePic.addChild(image);
		}
		
		private function handleProfileInfoFail(event:SocnetUserInfoEvent):void
		{
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FETCHED, handleProfileInfoFetch);
			socnetAPI.removeEventListener(SocnetUserInfoEvent.USER_INFO_FAILED, handleProfileInfoFail);
		}
		
		private function handleAddToFacebookBtnClick(event:MouseEvent):void
		{
			socnetAPI.publishToFeed("This is a test message", null, "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/assets/images/cover.png", "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/index.html", "Container Test", "FB Container and Template", "This is to test the FB Container and the Template application", "http://dev.collectivezen.com/fbtestbed/fb/manu/containerTest/Container.swf");
		}
	}
}