package ikriti.natgeo.vo
{
	[Bindable]
	[RemoteClass(alias='ikriti.natgeo.vo.MaParticipantVO')]
	public class MaParticipantVO
	{
		public var age:String;
		public var height:String;
		public var id:int;
		public var member:ikriti.natgeo.vo.MemberVO;
		public var weight:String;
		
		public function MaParticipantVO()
		{
			super()
		}
	}
}