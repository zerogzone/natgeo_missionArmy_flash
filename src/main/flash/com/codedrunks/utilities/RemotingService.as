package com.codedrunks.utilities
{
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
		 
	public class RemotingService extends NetConnection
	{		
		function RemotingService(url:String)
		{
			// Set AMF version for AMFPHP
			objectEncoding = ObjectEncoding.AMF0;
			// Connect to gateway
			connect(url);
		}
	}
}