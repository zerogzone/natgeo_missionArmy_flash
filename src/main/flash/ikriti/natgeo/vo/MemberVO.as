package ikriti.natgeo.vo
{
	[RemoteClass(alias='ikriti.natgeo.vo.MemberVO')]
	public class MemberVO
	{
		public var createDate:Date;
		public var dob:Date;
		public var email:String;
		public var fbUsers:Array;
		public var firstname:String;
		public var gender:ikriti.natgeo.vo.EnumGenderVO;
		public var guid:String;
		public var id:int;
		public var lastname:String;
		public var memberStatus:ikriti.natgeo.vo.EnumMemberStatusVO;
		public var mobile:String;
		public var photoUrl:String;
		public var privateKey:String;
		
		public function MemberVO()
		{
			super()
		}
	}
}