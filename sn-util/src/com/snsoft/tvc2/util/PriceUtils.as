package com.snsoft.tvc2.util 
{      
	
	
	
	/**  
	 * 把阿拉伯数字单位转换成语音文件序列
	 * @author marcoLee  
	 */    
	public class PriceUtils   
	{   
		//零壹贰叁肆伍陆柒捌镹万亿兆千百拾点元
		//1：个，2：十，3：百，4：千，5：万，6：十万，7：百万，8：千万，9：亿，10：十亿，11：百亿，12：千亿，13：兆, 14：十兆， 15：百兆， 16：千兆   
		public static const NUM_CN:Array = ["mp3/num/0.mp3", "mp3/num/1.mp3", "mp3/num/2.mp3", "mp3/num/3.mp3", "mp3/num/4.mp3", "mp3/num/5.mp3", "mp3/num/6.mp3", "mp3/num/7.mp3", "mp3/num/8.mp3", "mp3/num/9.mp3"];   
		public static const DECIMAL_UNITS:Array = ["角", "分"];   
		public static const LEVELS:Array = ["元", "mp3/num/wan.mp3", "mp3/num/yi.mp3", "mp3/num/zhao.mp3"];   
		public static const UNITS:Array = ["mp3/num/qian.mp3", "mp3/num/bai.mp3", "mp3/num/shi.mp3"];
		public static const POINT:String = "mp3/num/dian.mp3";
		public static const YUAN:String = "mp3/num/yuan.mp3";
		
		public function PriceUtils(){  
			
		}   
		
		/**
		 * 小于30的小数，用此优化算法，声音会好听点。
		 * 可增加语音文件，使本方法支持更大数值。 
		 * @param num
		 * @return 
		 * 
		 */		
		private static function toCNUpper30p00(num:Number):Vector.<String>{
			var v:Vector.<String> = new Vector.<String>();
			if(!isNaN(num)){
				if(0 <= num && num <= 30.00){
					var sn:String = String(num.toFixed(2));	
					var len:int = sn.length;
					var su:String = sn.substring(0,len - 3);
					var ss:String = sn.substring(len -2,len);
					
					var mp3u:String = "mp3/num/i" + su + ".mp3";
					var mp3s:String = "mp3/num/s" + ss + ".mp3";
					
					v.push(mp3u);
					v.push(mp3s);
					v.push(YUAN);
				}
			}
			return v;
		}
		
		/**
		 * 把数字转换成语音文件序列 
		 * @param num 要转换的数字
		 * @param fixed 小数点后保留位数，四舍五入截取
		 * @return 语音文件地址序列
		 * 
		 */		
		public static function toCNUpper( num:Number,fixed:int = 2 ):Vector.<String>   
		{ 
			var moneyVector:Vector.<String> = new Vector.<String>();
			if(0 <= num && num <= 30.00 && fixed == 2){
				moneyVector = toCNUpper30p00(num);
			}
			else {
				
				if( num == 0 ){   
					moneyVector.push(NUM_CN[0]);   
				}
				else {
					var count:int = getUnitCount( num );   
					var numStr:String = num.toFixed(fixed);   
					var pos:int = numStr.indexOf(".");   
					var dotLeft:String = pos == -1 ? numStr : numStr.substring(0, pos);   
					var dotRight:String = pos == -1 ? "" : numStr.substring(pos + 1, numStr.length); 
					
					if( dotLeft.length > 16 )   
						throw new Error("数字太大，无法处理！");   
					
					var integerVector:Vector.<String> = convertIntegerStr(dotLeft);
					var decimalVector:Vector.<String> = convertDecimalStr(dotRight);
					
					
					for(var i:int;i<integerVector.length;i++){
						moneyVector.push(integerVector[i]);
					}
					for(var j:int;j<decimalVector.length;j++){
						moneyVector.push(decimalVector[j]);
					}
				}
				moneyVector.push(YUAN);
				if(moneyVector.length > 0){
					if(moneyVector[0] == POINT){
						moneyVector.splice(0,0,NUM_CN[0]);
					}
				}
			}
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
			if(str.length > 0){
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
