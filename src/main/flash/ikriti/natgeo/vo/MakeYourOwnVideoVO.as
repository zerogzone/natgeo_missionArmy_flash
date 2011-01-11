package ikriti.natgeo.vo
{
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias='ikriti.natgeo.vo.MakeYourOwnVideoVO')]
	public class MakeYourOwnVideoVO
	{
		
/*variables*/
		
		public var id:int;
		public var videoXml:String;
		public var videoPath:String;
		public var member:MemberVO;
		
		public function MakeYourOwnVideoVO()
		{
			super()
		}
/* Setters and getters*/
		
		public function getId():int
		{
			return id;
		}
		
		public function setId(id:int):void
		{
			this.id = id;
		}
		
		public function getMember():MemberVO
		{
			return member;
		}
		
		public function setMember(member:MemberVO):void
		{
			this.member = member;
		}
		
		public function getVideoXml():String
		{
			return videoXml;
		}
		
		public function setVideoXml(videoXml:String):void
		{
			this.videoXml = videoXml;
		}
		
		public function getVideoPath():String
		{
			return videoPath;
		}
		
		public function setVideoPath(videoPath:String):void
		{
			this.videoPath = videoPath;
		}
	}
}