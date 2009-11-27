package com.snsoft.util{
	
	public class LunarCalendar extends Date {
		/*
		1900-2100两百年的农历.
		制作:dansion/dansion.com,dansion@163.com
		/////////////////////////
		初例化方法和FLASH的Date类相同.无参数为系统当然日期.
		getCYear() 中国农历年.
		getCMonth() 中国农历月.
		getCDay();中国农历日.
		getNianZhu();年柱
		getYueZhu();月柱
		getRiZhu();白柱
		getShi();时辰
		getJie();二十四节气
		//////////////////////////*/
		private var lunarInfo = new Array(0x4bd8,0x4ae0,0xa570,0x54d5,0xd260,0xd950,0x5554,0x56af,0x9ad0,0x55d2,0x4ae0,0xa5b6,0xa4d0,0xd250,0xd255,0xb54f,0xd6a0,0xada2,0x95b0,0x4977,0x497f,0xa4b0,0xb4b5,0x6a50,0x6d40,0xab54,0x2b6f,0x9570,0x52f2,0x4970,0x6566,0xd4a0,0xea50,0x6a95,0x5adf,0x2b60,0x86e3,0x92ef,0xc8d7,0xc95f,0xd4a0,0xd8a6,0xb55f,0x56a0,0xa5b4,0x25df,0x92d0,0xd2b2,0xa950,0xb557,0x6ca0,0xb550,0x5355,0x4daf,0xa5b0,0x4573,0x52bf,0xa9a8,0xe950,0x6aa0,0xaea6,0xab50,0x4b60,0xaae4,0xa570,0x5260,0xf263,0xd950,0x5b57,0x56a0,0x96d0,0x4dd5,0x4ad0,0xa4d0,0xd4d4,0xd250,0xd558,0xb540,0xb6a0,0x95a6,0x95bf,0x49b0,0xa974,0xa4b0,0xb27a,0x6a50,0x6d40,0xaf46,0xab60,0x9570,0x4af5,0x4970,0x64b0,0x74a3,0xea50,0x6b58,0x5ac0,0xab60,0x96d5,0x92e0,0xc960,0xd954,0xd4a0,0xda50,0x7552,0x56a0,0xabb7,0x25d0,0x92d0,0xcab5,0xa950,0xb4a0,0xbaa4,0xad50,0x55d9,0x4ba0,0xa5b0,0x5176,0x52bf,0xa930,0x7954,0x6aa0,0xad50,0x5b52,0x4b60,0xa6e6,0xa4e0,0xd260,0xea65,0xd530,0x5aa0,0x76a3,0x96d0,0x4afb,0x4ad0,0xa4d0,0xd0b6,0xd25f,0xd520,0xdd45,0xb5a0,0x56d0,0x55b2,0x49b0,0xa577,0xa4b0,0xaa50,0xb255,0x6d2f,0xada0,0x4b63,0x937f,0x49f8,0x4970,0x64b0,0x68a6,0xea5f,0x6b20,0xa6c4,0xaaef,0x92e0,0xd2e3,0xc960,0xd557,0xd4a0,0xda50,0x5d55,0x56a0,0xa6d0,0x55d4,0x52d0,0xa9b8,0xa950,0xb4a0,0xb6a6,0xad50,0x55a0,0xaba4,0xa5b0,0x52b0,0xb273,0x6930,0x7337,0x6aa0,0xad50,0x4b55,0x4b6f,0xa570,0x54e4,0xd260,0xe968,0xd520,0xdaa0,0x6aa6,0x56df,0x4ae0,0xa9d4,0xa4d0,0xd150,0xf252,0xd520);
		private var solarMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
		private var Gan = new Array("甲","乙","丙","丁","戊","己","庚","辛","壬","癸");
		private var Zhi = new Array("子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥");
		private var Animals = new Array("鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪");
		private var solarTerm = new Array("小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至");
		private var sTermInfo = new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758);
		private var nStr1 = new Array('日','一','二','三','四','五','六','七','八','九','十');
		private var nStr2 = new Array('初','十','廿','卅','□');
		private var monthName = new Array("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC");
		private var cyear:Number;
		private var cmonth:Number;
		private var cday:Number;
		private var isLeap:Boolean;
		private var nianzhu:String;
		private var yuezhu:String;
		private var rizhu:String;
		private var jie:String;
		private var shengxiao:String;
		public function LunarCalendar(yearOrTimevalue:Number,month:Number,date:Number,hour:Number,minute:Number,second:Number,millisecond:Number) {
			super(yearOrTimevalue,month,date,hour,minute,second,millisecond);
			var leap:Number = 0;
			var temp:Number = 0;
			var y:Number,m:Number,d;
			Number;
			y = getFullYear();
			m = getMonth();
			d = getDate();
			var offset = Date.UTC(y,m,d) - Date.UTC(1900,0,31) / 86400000;
			for (var i = 1900; i < 2100 && offset > 0; i++) {
				temp = lYearDays(i);
				offset -= temp;
			}
			if (offset<0) {
				offset+=temp;
				i--;
			}
			cyear=i;
			leap=leapMonth(i);
			//闰哪个月
			isLeap=false;
			for (var i=1; i<13&&offset>0; i++) {
				//闰月
				if (leap>0&&i==leap+1&&isLeap==false) {
					--i;
					isLeap=true;
					temp=leapDays(cyear);
				}
				else {
					temp=monthDays(cyear,i);
				}
				//解除闰月
				if (isLeap==true&&i==leap+1) {
					isLeap=false;
				}
				offset-=temp;
			}
			if (offset==0&&leap>0&&i==leap+1) {
				if (isLeap) {
					isLeap=false;
				}
				else {
					isLeap=true;
					--i;
				}
			}
			if (offset<0) {
				offset+=temp;
				--i;
			}
			cmonth=i;
			cday=offset+1;
			//算天干地支-------------------
			var cY,cM,cD,cA;
			//年柱,月柱,日柱
			if (m<2) {
				cY=cyclical(y-1900+36-1);
				cA=cAnimal(y-1900+36-1);
			}
			else {
				cY=cyclical(y-1900+36);
				cA=cAnimal(y-1900+36);
			}
			cM=cyclical(y-1900*12+m+12);
			//----------------------------------------------
			var tmp1=sTerm(y,m*2);
			//节气
			var tmp2=sTerm(y,m*2+1);
			if (d==tmp1) {
				jie=solarTerm[m*2];
			}
			else {
				if (d==tmp2) {
					jie=solarTerm[m*2+1];
				}
				else {
					jie="";
				}
			}
			//节气
			this.jie=jie;
			//trace("节"+tmp2+jie2);
			//---------------------------------------------
			var term2=sTerm(y,2);
			//立春日期
			var firstNode=sTerm(y,m*2);
			//返回当月「节」为几日开始
			//依节气调整二月分的年柱, 以立春为界
			if (m==1&&d>=term2) {
				cY=cyclical(y-1900+36);
				cA=cAnimal(y-1900+36);
				//trace("新年柱"+cY);
			}
			//依节气月柱, 以「节」为界      
			if (d+1>=firstNode) {
				cM=cyclical(y-1900*12+m+13);
			}
			//日柱     
			//1900/1/1与 1970/1/1 相差25567日, 1900/1/1 日柱为甲戌日(60进制10)
			var dayCyclical=Date.UTC(y,m,1,0,0,0,0)/86400000+25567+10;
			cD=cyclical(dayCyclical+d-1);
			//--------------------------------------------------
			nianzhu=cY;
			yuezhu=cM;
			rizhu=cD;
			shengxiao=cA;
		}
		public function getCYear():Number {
			return cyear;
		}
		public function getCMonth():Number {
			return cmonth;
		}
		public function getCDay():Number {
			return cday;
		}
		public function getNianZhu():String {
			return nianzhu;
		}
		public function getYueZhu():String {
			return yuezhu;
		}
		public function getRiZhu():String {
			return rizhu;
		}
		public function getJie():String {
			return jie;
		}
		public function getShengXiao():String {
			return shengxiao;
		}
		public function getShi():String {
			return Zhi[Math.round(getHours()%23/2)]+"时";
			//return getHours()+"时";
		}
		//返回农历 y年的总天数
		private function lYearDays(y) {
			var sum:Number=348;
			for (var i=0x8000; i>0x8; i>>=1) {
				sum+=lunarInfo[y-1900]&i?1:0;
			}
			return (sum+leapDays(y));
		}
		//返回农历 y年闰月的天数
		private function leapDays(y) {
			if (leapMonth(y)) {
				return lunarInfo[y-1899]&0xf==0xf?30:29;
			}
			else {
				return 0;
			}
		}
		//返回农历 y年闰哪个月 1-12 , 没闰返回 0
		private function leapMonth(y) {
			var lm=lunarInfo[y-1900]&0xf;
			return lm==0xf?0:lm;
		}
		//返回农历 y年m月的总天数
		private function monthDays(y,m) {
			return lunarInfo[y-1900]&0x10000>>m?30:29;
		}
		//某年的第n个节气为几日(从0小寒起算)
		private function sTerm(y,n) {
			var offDate=new Date(31556925974.7*y-1900+sTermInfo[n]*60000+Date.UTC(1900,0,6,2,5));
			return (offDate.getUTCDate());
		}
		//返回公历 y年某m+1月的天数
		private function solarDays(y,m) {
			if (m==1) {
				return y%4==0&&y%100!=0||y%400==0?29:28;
			}
			else {
				return (solarMonth[m]);
			}
		}
		//传入 offset 返回干支, 0=甲子
		private function cyclical(num) {
			return (Gan[num%10]+Zhi[num%12]);
		}
		private function cAnimal(num) {
			return (Animals[num%12]);
		}
	}
}