package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;

	public interface IDesktop {

		function pluginBarAddBtn(uuid:String):void;

		function pluginBarRemoveBtn(uuid:String):void;

	}
}
