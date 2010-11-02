package com.codedrunks.utilities
{
	public class StringUtil
	{
		public static function enableHyperLinks(text:String, underline:Boolean=false, itallics:Boolean=false, color:String=null):String
		{
			var temp:Array = text.split(" ");
			var result:String = "";
			for(var i:int=0; i< temp.length; i++)
			{
				var subStr:String = temp[i];
				var hasHttp:Boolean = (subStr.indexOf("http") >= 0)? true : false;
				if(hasHttp)
				{
					var start:String = "<a href='";
					var end:String = "</a>";
					if(underline)
					{
						start = "<u>"+start;
						end += "</u>";
					}
					if(itallics)
					{
						start = "<i>"+start;
						end += "</i>";	
					}
					if(color)
					{
						start = "<font color='"+color+"'>"+start;
						end += "</font>";	
					}
					subStr = start+subStr+"' target='_blank'>"+subStr+end;
				}
				result += subStr + " ";
			}
			
			return result;	
		}
	}
}