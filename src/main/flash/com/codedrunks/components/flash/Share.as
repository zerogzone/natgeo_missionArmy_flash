package com.codedrunks.components.flash
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class Share extends MovieClip
	{
		private var wildfireLoader:Loader;
		private var mcWF:MovieClip;
		
		public static const CLOSE_EVENT:String = "closeEvent";
		
		public function Share()
		{
			Security.allowDomain("cdn.gigya.com");
			Security.allowInsecureDomain("cdn.gigya.com");
			
			mcWF = new MovieClip();
			addChild(mcWF).name='mcWF';
			
		}
		 
		public function configure(embedCode:String, wfUIConfig:String, wfWidth:Number, wfHeight:Number):void
		{
			var cfg:Object = new Object();
			var ModuleID:String='GigyaModule';
			
			mcWF.x = (this.width-wfWidth)/2;
			mcWF.y = (this.height-wfHeight)/2;
			
			cfg['width']= wfWidth;
			cfg['height']= wfHeight;
			cfg['partner']='PARTNER-ID';
			cfg['UIConfig']= wfUIConfig;//'<config><display showEmail="false" showBookmark="false" showCloseButton="true" /></body></config>';
			cfg['defaultContent']= embedCode;
			cfg['onClose'] = onClose;
			
			wildfireLoader = new Loader();
			var url:String = 'http://cdn.gigya.com/Wildfire/swf/WildfireInAS3.swf?ModuleID=' + ModuleID;
			var urlReq:URLRequest = new URLRequest(url);
			mcWF[ModuleID] = cfg;
			wildfireLoader.load(urlReq);
			mcWF.addChild(wildfireLoader);
		}
		
		private function onClose(event:Object):void
		{
			dispatchEvent(new Event(CLOSE_EVENT, true));
		}
	}
}