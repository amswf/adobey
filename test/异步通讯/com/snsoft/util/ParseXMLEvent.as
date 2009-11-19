package com.snsoft.util
{
	import flash.events.Event;

	public class ParseXMLEvent extends Event
	{
		public static const var PARSEXML:String = "parsexml";
		public function ParseXMLEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}