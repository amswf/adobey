package com.snsoft.tvc2.text{
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 静态特效文字类 
	 * @author Administrator
	 * 
	 */	
	public class EffectText{
		public function EffectText()
		{
		}
		
		/**
		 * 创建一个带阴影的文本
		 * 
		 * @param text 显示文字
		 * @param textFormat 文本格式化对象
		 * @param inSColor 内阴影颜色
		 * @param outSColor 外阴影颜色
		 * @param isEmbedFont 是否用嵌入字体
		 * @return 
		 * 
		 */		
		public static function creatShadowTextField(text:String,textFormat:TextFormat,inSColor:uint = 0xffffff,outSColor:uint = 0x000000,isEmbedFont:Boolean = false):TextField{
			var dsf:DropShadowFilter = new DropShadowFilter(0,45,inSColor,1,3,3,1000,1);
			var dsf2:DropShadowFilter = new DropShadowFilter(0,45,outSColor,1,5,5,1,1);
			
			var tfd:TextField = Text.creatTextField(text,textFormat,isEmbedFont);
			var filterAry:Array = new Array();
			filterAry.push(dsf,dsf2);
			tfd.filters = filterAry;
			return tfd;
		}
		
		public static function creatTextByStyle(text:String,textStyle:TextStyle):TextField{
			var tfd:TextField = creatShadowTextField(text,textStyle.textFormat,textStyle.inSColor,textStyle.outSColor,textStyle.isEmbedFont);
			return tfd;
		}
		public static function creatTextByStyleName(text:String,styleName:String):TextField{
			var tfd:TextField = creatTextByStyle(text,TextStyles.getTextStyle(styleName));
			return tfd;
		}
	}
}