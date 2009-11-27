/*
 * DateUtil.as
 * Copyright (c) 2009  CYJB
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.cyjb.dates {

	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * <code>DateUtil</code> 类包含了与 <code>Date</code> 有关的工具类.
	 * 
	 * <p>该工具类包括以下函数或属性:</p>
	 * <ul>
	 * <li><code>DAYS_IN_MONTH</code> :每个月的天数(二月为 28 天).</li>
	 * <li><code>SECOND</code> :一秒相当于的毫秒数.</li>
	 * <li><code>MINUTE</code> :一分钟相当于的毫秒数.</li>
	 * <li><code>HOUR</code> :一小时相当于的毫秒数.</li>
	 * <li><code>DAY</code> :一天相当于的毫秒数.</li>
	 * <li><code>isLeapYear()</code> :获取指定年份是否是闰年.</li>
	 * <li><code>getDays()</code> :获取指定月份的天数.</li>
	 * <li><code>isEqual()</code> :判断两个 <code>Date</code> 对象的日期或时间是否相同.</li>
	 * <li><code>elapsedTimes()</code> :得到两个 <code>Date</code> 对象相差的时间</li>
	 * </ul>
	 *
	 * @author CYJB
	 * @versions 1.0
	 * @since 2009-1-29
	 */
	public final class DateUtil {
		/**
		 * @private
		 * 该类的版本.
		 */
		public static const version:String = "1.0";
		/**
		 * 每个月的天数(二月为 28 天).
		 * 
		 * 月份是从 <code>0</code> 到 <code>11</code>,分别代表一月到十二月.
		 */
		public static const DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 
				31, 30, 31, 30, 31];
		/**
		 * 一秒相当于的毫秒数.
		 */
		public static const SECOND:uint = 1000;
		/**
		 * 一分钟相当于的毫秒数.
		 */
		public static const MINUTE:uint = SECOND * 60;
		/**
		 * 一小时相当于的毫秒数.
		 */
		public static const HOUR:uint = MINUTE * 60;
		/**
		 * 一天相当于的毫秒数.
		 */
		public static const DAY:uint = HOUR * 24;
		/**
		 * 获取指定年份是否是闰年.
		 * 
		 * @param year 要判断的年份.
		 * 
		 * @return 如果是闰年,则返回 <code>true</code>;否则返回 <code>false</code>.
		 * 
		 * @internal 能整除 4 但不能整除 100 的是闰年,能整除 400 的也是闰年.
		 * 不存在公元 0 年,如果 year 传入 0,返回 false.
		 */
		public static function isLeapYear(year:uint):Boolean {
			if(year == 0)
				return false;
			return ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)));
		}
		/**
		 * 获取指定月份的天数.
		 * 
		 * 如果指定了年份,会将闰年计算在内.
		 * 
		 * @param month 月份.
		 * @param year 年份.
		 * 
		 * @return 该月的天数.
		 */
		public static function getDays(month:uint, year:uint = 0):uint {
			var m:uint = month % 12;
			var re:uint = DAYS_IN_MONTH[m];
			if((m == 1) && year && isLeapYear(year + month / 12)){
				//2 月闰年 29 天
				re ++;
			}
			return re;
		}
		/**
		 * 判断两个 <code>Date</code> 对象的日期或时间是否相同.
		 * 
		 * 可以分别比较日期和时间.
		 * 
		 * @param date1 要比较的 <code>Date</code> 对象.
		 * @param date2 要比较的 <code>Date</code> 对象.
		 * @param date 是否比较日期.
		 * @param time 是否比较时间(精确到秒).
		 * @param milliseconds 是否比较毫秒.
		 * 
		 * @return 如果两个日期相同,则返回 <code>true</code>;否则返回 <code>false</code>.
		 * 
		 * @includeExample examples/DateUtil.isEqual.1.as -noswf
		 */
		public static function isEqual(date1:Date, date2:Date, 
				date:Boolean = true, time:Boolean = true, 
				milliseconds:Boolean = false):Boolean {
			if(!date1 || !date2) {
				return false;
			}
			if(date) {
				//比较年,月,日
				if(date1.date != date2.date || date1.month != date2.month || 
						date1.fullYear != date2.fullYear)
					return false;
			}
			if(time) {
				//比较时,分,秒
				if(date1.hours != date2.hours || date1.minutes != date2.minutes ||
						date1.seconds != date2.seconds)
					return false;
			}
			//比较毫秒
			if(milliseconds && (date1.milliseconds != date2.milliseconds)) {
				return false;
			}
			return true;
		}
		/**
		 * 得到两个 <code>Date</code> 对象相差的时间.
		 * 
		 * 默认的到的相差的毫秒数,通过更改 <code>divisor</code> 参数,可以得到其他单位的数值.
		 * 
		 * @param date1 第一个 <code>Date</code> 对象.
		 * @param date2 第二个 <code>Date</code> 对象.
		 * @param divisor 时间的除数,用于更改单位.
		 * 
		 * @return 两个对象相差时间.
		 * 
		 * @includeExample examples/DateUtil.elapsedTimes.1.as -noswf
		 */
		public static function elapsedTimes(date1:Date, date2:Date, 
				divisor:uint = 1):Number {
			if(!date1 || !date2) {
				return 0;
			}
			return (date1.time - date2.time) / divisor;
		}
	}
}
