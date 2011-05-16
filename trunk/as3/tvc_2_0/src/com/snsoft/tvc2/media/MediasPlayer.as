package com.snsoft.tvc2.media {
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.util.PlaceType;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.rlm.rs.RSSwf;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 *  多媒体（图片、动画）组播放
	 * @author Administrator
	 *
	 */
	public class MediasPlayer extends Business {

		private var mediasDO:MediasDO;

		//当前播放序号
		private var playNum:int;

		private var mediaPlayer:MediaPlayer;

		public function MediasPlayer(mediasDO:MediasDO) {
			super();
			this.mediasDO = mediasDO;
		}

		/**
		 * 播放
		 * @return
		 *
		 */
		override protected function play():void {
			playNum = 0;
			playNextMedias();
		}

		private function playNextMedias():void {
			if (mediasDO != null && mediasDO.mediaDOHv != null) {
				if (playNum < mediasDO.mediaDOHv.length) {
					if (mediaPlayer != null) {
						this.removeChild(mediaPlayer);
					}
					var mediaDO:MediaDO = mediasDO.mediaDOHv[playNum];

					var mediaList:Vector.<DisplayObject> = new Vector.<DisplayObject>();

					var rsimg:RSImages = mediaDO.resSet as RSImages;
					var rsswf:RSSwf = mediaDO.resSet as RSSwf;

					var rdl:Vector.<DisplayObject> = null;
					if (rsimg != null) {
						var irdl:Vector.<BitmapData> = rsimg.imageBmdList;
						if (irdl != null) {
							for (var i:int = 0; i < irdl.length; i++) {
								var bmd:BitmapData = irdl[i];
								if (bmd != null) {
									var img:Bitmap = new Bitmap(bmd, "auto", true);
									mediaList.push(img);
								}
							}
						}
					}
					else if (rsswf != null) {
						var srdl:Vector.<MovieClip> = rsswf.swfList;
						if (srdl != null) {
							for (var i2:int = 0; i2 < srdl.length; i2++) {
								var swf:MovieClip = srdl[i2];
								if (swf != null) {
									mediaList.push(swf);
								}
							}
						}
					}

					mediaPlayer = new MediaPlayer(mediaList, mediaDO.timeOffset, mediaDO.timeLength, mediaDO.timeout);
					mediaPlayer.addEventListener(Event.COMPLETE, handlerMediaPlayerCMP);

					mediaPlayer.x = mediaDO.place.x;
					mediaPlayer.y = mediaDO.place.y;

					var placeType:String = mediaDO.placeType;
					if (StringUtil.isEffective(placeType)) {
						PlaceType.setSpritePlace(mediaPlayer, SystemConfig.stageSize, placeType);
					}
					this.addChild(mediaPlayer);
					this.dispatchEvent(new Event(EVENT_PLAYED));
				}
				else {
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}

		private function handlerMediaPlayerCMP(e:Event):void {
			playNum++;
			playNextMedias();
		}

		override protected function dispatchEventState():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
