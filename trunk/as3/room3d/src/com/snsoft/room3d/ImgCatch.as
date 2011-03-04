package com.snsoft.room3d{
	import com.snsoft.util.HashVector;

	/**
	 * 图片缓存器，已经加载的图片就不再从服务器加载 
	 * @author Administrator
	 * 
	 */	
	public class ImgCatch{
		
		public static var imgHV:HashVector = new HashVector();
		
		public function ImgCatch()
		{
		}
	}
}