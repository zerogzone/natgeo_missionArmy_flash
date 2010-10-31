package ikriti.natgeo.vo
{
	[RemoteClass(alias='ikriti.natgeo.vo.EnumGenderVO')]
	public class EnumGenderVO
	{
		public static const MALE:int = 1;
		public static const FEMALE:int = 2;
		
		public var description:String;
		public var gender:String;
		public var id:int;
		
		public function EnumGenderVO()
		{
			super()
		}
	}
}