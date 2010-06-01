﻿package com.snsoft.tvc2.util 
{      
	
	
	
	/**  
	 * 主要功能把阿拉伯数字单位转换成中文大写  
	 * @author marcoLee  
	 */    
	public class PriceUtils   
	{   
		//零壹贰叁肆伍陆柒捌镹元万亿兆千百拾点
		//1：个，2：十，3：百，4：千，5：万，6：十万，7：百万，8：千万，9：亿，10：十亿，11：百亿，12：千亿，13：兆, 14：十兆， 15：百兆， 16：千兆   
		public static const NUM_CN:Array = ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "镹"];   
		public static const DECIMAL_UNITS:Array = ["角", "分"];   
		public static const LEVELS:Array = ["元", "万", "亿", "兆"];   
		public static const UNITS:Array = ["千", "百", "拾"];
		public static const POINT:String = "点";
		public static const YUAN:String = "元";
		
		public function PriceUtils(){   
		}   
		
		/**  
		 * 把阿拉伯数字单位转换成中文大写  
		 * @param num 阿拉伯数字  
		 * @return 中文大写  
		 */        
		public static function toCNUpper( num:Number ):Vector.<String>   
		{   
			if( num == 0 )   
				return NUM_CN[0];   
			
			var count:int = getUnitCount( num );   
			var numStr:String = num.toFixed(2);   
			var pos:int = numStr.indexOf(".");   
			var dotLeft:String = pos == -1 ? numStr : numStr.substring(0, pos);   
			var dotRight:String = pos == -1 ? "" : numStr.substring(pos + 1, numStr.length); 
			
			if( dotLeft.length > 16 )   
				throw new Error("数字太大，无法处理！");   
			
			var integerVector:Vector.<String> = convertIntegerStr(dotLeft);
			var decimalVector:Vector.<String> = convertDecimalStr(dotRight);
			var moneyVector:Vector.<String> = new Vector.<String>();
			
			for(var i:int;i<integerVector.length;i++){
				moneyVector.push(integerVector[i]);
			}
			for(var j:int;j<decimalVector.length;j++){
				moneyVector.push(decimalVector[j]);
			}
			moneyVector.push(YUAN);   
			return moneyVector;   
		}   
		
		/**  
		 * 把数字中的整数部分进行转换  
		 * @param str  
		 * @return   
		 */        
		public static function convertIntegerStr( str:String ):Vector.<String>   
		{   
			var tCount:int = Math.floor( str.length / 4 );   
			var rCount:int = str.length % 4;   
			var nodes:Array = [];   
			if( rCount > 0 )   
				nodes.push( convertThousand(str.substr(0, rCount), tCount ));   
			
			for( var i:int = 0; i < tCount; i++ )   
			{   
				var startIndex:int = rCount + i*4;   
				var num:String = str.substring( startIndex, startIndex + 4 );   
				nodes.push( convertThousand(num, tCount - i - 1) );   
			}   
			return convertNodes( nodes );   
		}   
		
		private static function convertNodes( nodes:Array ):Vector.<String>   
		{   
			var str:Vector.<String> = new Vector.<String>();   
			var beforeZero:Boolean;   
			for( var i:int = 0; i < nodes.length; i++)   
			{   
				var node:ThousandNode = nodes[i] as ThousandNode;   
				if( ( beforeZero && node.desc.length > 0 ) ||   
					( node.beforeZero && node.desc.length > 0 && str.length > 0))   
					str.push(NUM_CN[0]);   
				
				for( var j:int =0;j<node.desc.length;j++){
					str.push(node.desc[j]);
				}
				if( node.afterZero && i < nodes.length - 1 )   
					beforeZero = true;   
				else if( node.desc.length > 0 )   
					beforeZero = false;   
			}   
			
			return str;   
		}   
		
		/**  
		 * 对四位数进行处理，不够自动补起  
		 * @param num  
		 * @param level  
		 * @return   
		 */        
		private static function convertThousand( num:String, level:int):ThousandNode   
		{   
			var node:ThousandNode = new ThousandNode();   
			var len:int = num.length;   
			
			for( var i:int = 0; i < 4 - len; i++ )   
				num = "0" + num;   
			
			var n1:int = int( num.charAt(0) );   
			var n2:int = int( num.charAt(1) );   
			var n3:int = int( num.charAt(2) );   
			var n4:int = int( num.charAt(3) );   
			
			if( n1 + n2 + n3 + n4 == 0 )   
				return node;   
			
			if( n1 == 0 )   
				node.beforeZero = true;   
			else   
				node.desc.push(NUM_CN[n1],UNITS[0]); 
			
			if( n2 == 0 && node.desc.length > 0 && n3 + n4 > 0)   
				node.desc.push( NUM_CN[0]);   
			else if( n2 > 0 )   
				node.desc.push(NUM_CN[n2],UNITS[1]);   
			
			if( n3 == 0 && node.desc.length > 0 && n4 > 0)   
				node.desc.push( NUM_CN[0]);
			else if( n3 > 0 )   
				node.desc.push( NUM_CN[n3],UNITS[2] );
			if( n4 == 0 )   
				node.afterZero = true;   
			else if( n4 > 0 )   
				node.desc.push( NUM_CN[n4] );  
			//level > 0 去掉元字。
			if( node.desc.length > 0 && level >0 ) 
				node.desc.push( LEVELS[level] );   
			return node;   
		}   
		
		/**  
		 * 把数字中的小数部分进行转换  
		 * @param str  
		 * @return   
		 */        
		public static function convertDecimalStr( str:String ):Vector.<String> {   
			var newStr:Vector.<String>  = new Vector.<String>();  
			if(str.length > 0 && Number(str) > 0){
				newStr.push(POINT);
				for( var i:int = 0; i < str.length; i++ )   
				{   
					var n:int = int(str.charAt(i));   
					if( n >= 0 )   
						newStr.push(NUM_CN[n]);   
				}   
			}
			return newStr;   
		}   
		
		/**  
		 * 用数据方法得到数字整数部分长度  
		 * @param num  
		 * @return   
		 */        
		public static function getUnitCount( num:Number ):int  
		{   
			return Math.ceil( Math.log( num ) / Math.LN10 );   
		}   
		
	}   
}   

class ThousandNode   
{   
	public function ThousandNode()   
	{   
		
	}   
	
	public var beforeZero:Boolean;   
	public var afterZero:Boolean;   
	public var desc:Vector.<String> = new Vector.<String>();   
}  
