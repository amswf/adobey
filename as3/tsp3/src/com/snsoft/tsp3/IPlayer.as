package com.snsoft.tsp3 {

	public interface IPlayer {

		function playMp3(url:String, title:String = ""):void;

		function playVideo(url:String, title:String = ""):void;

		function setVisible(visible:Boolean):void;
	}
}
