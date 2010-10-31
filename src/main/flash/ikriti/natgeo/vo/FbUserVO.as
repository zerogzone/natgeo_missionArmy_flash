package ikriti.natgeo.vo
{
	import flash.net.registerClassAlias;

	[RemoteClass(alias='ikriti.natgeo.vo.FbUserVO')]
	public class FbUserVO
	{
		public var accessToken:String;
		public var createDate:Date;
		public var facebookId:String;
		public var id:int;
		public var isValidAccessToken:Boolean;
		public var member:MemberVO;
		public var photoUrl:String;
		
		public function FbUserVO()
		{
			super()
		}
	}
}