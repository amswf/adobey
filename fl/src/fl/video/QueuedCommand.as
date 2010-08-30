// Copyright © 2004-2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.video {

	/**
     * @private
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	public class QueuedCommand {

		// values for command types for _cmdQueue
		public static const PLAY:uint = 0;
		public static const LOAD:uint = 1;
		public static const PAUSE:uint = 2;
		public static const STOP:uint = 3;
		public static const SEEK:uint = 4;
		public static const PLAY_WHEN_ENOUGH:uint = 5;

		public var type:uint;
		public var url:String;
		public var isLive:Boolean;
		public var time:Number;
		public var startTime:Number;
		public var duration:Number;

		public function QueuedCommand(type:uint, url:String, isLive:Boolean, time:Number, startTime:Number, duration:Number) {
			this.type = type;
			this.url = url;
			this.isLive = isLive;
			this.time = time;
			this.startTime = startTime;
			this.duration = duration;
		}

	} // class QueuedCommand

} // package fl.video
