package ikriti.natgeo.vo
{
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias='ikriti.natgeo.vo.MicroliteFlightEntryVO')]
	public class MicroliteFlightEntryVO
	{
		
/*variables*/
		
		public var id:int;
		public var member:MemberVO;
		public var question:String;
		public var entry:String;
		
		public function MicroliteFlightEntryVO()
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
		
		public function getQuestion():String
		{
			return question;
		}
		
		public function setQuestion(question:String):void
		{
			this.question = question;
		}
		
		public function getEntry():String
		{
			return entry;
		}
		
		public function setEntry(entry:String):void
		{
			this.entry = entry;
		}
	}
}