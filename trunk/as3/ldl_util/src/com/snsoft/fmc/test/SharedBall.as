package com.snsoft.fmc.test{
	/*
	* (C) Copyright 2007 Adobe Systems Incorporated. All Rights Reserved.
	*
	* NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
	* terms of the Adobe license agreement accompanying it.  If you have received this file from a 
	* source other than Adobe, then your use, modification, or distribution of it requires the prior 
	* written permission of Adobe. 
	* THIS CODE AND INFORMATION IS PROVIDED "AS-IS" WITHOUT WARRANTY OF
	* ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
	* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	* PARTICULAR PURPOSE.
	*
	*  THIS CODE IS NOT SUPPORTED BY Adobe Systems Incorporated.
	*
	*/
	
	import com.snsoft.util.SkinsUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	public class SharedBall extends MovieClip
	{
		private var so:SharedObject;
		private var nc:NetConnection;
		private var ball:MovieClip;
		
		public function SharedBall(){			
			nc = new NetConnection();
			nc.client = this;
			nc.connect("rtmp://192.168.0.22/oflaDemo");
			ball = SkinsUtil.createSkinByName("Ball");
			this.addChild(ball);
			addEventListeners(); 
		}
		
		 
		
		private function addEventListeners():void {
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ball.addEventListener(MouseEvent.MOUSE_DOWN, pickup);
			ball.addEventListener(MouseEvent.MOUSE_UP, place);
			ball.addEventListener(MouseEvent.MOUSE_MOVE, moveIt);
		}
		
		
		// handle connection events
		public function netStatusHandler(event:NetStatusEvent):void
		{
			trace("connected is: " + nc.connected );
			trace("event.info.level: " + event.info.level);
			trace("event.info.code: " + event.info.code);
			
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					trace("Congratulations! you're connected");
					so = SharedObject.getRemote("ballPosition", nc.uri, false);
					so.connect(nc); 
					so.addEventListener(SyncEvent.SYNC, syncHandler);
					break;
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.Failed":
					trace ("Oops! you weren't able to connect");
					break;
			}
		}
		
		
		// pick up the ball
		private function pickup( event:MouseEvent ):void {
			event.target.startDrag();
		}
		
		
		// move the ball
		private function moveIt( event:MouseEvent ):void {
			// update the shared object when a user moves the ball
			// this fires a sync event
			if( so != null )
			{
				so.setProperty("x", ball.x);
				so.setProperty("y", ball.y);
			}
		}
		
		
		// place the ball when finished moving
		private function place(event:MouseEvent):void {
			event.target.stopDrag();
		}
		
		
		// update clients when the shared object changes
		private function syncHandler(event:SyncEvent):void {
			// when a sync event is fired
			// update the position of the ball in clients
			ball.x = so.data.x;
			ball.y = so.data.y;
		}
		
		public function onBWDone():void{
			trace("onBWDone");
		} 
		
	}
}