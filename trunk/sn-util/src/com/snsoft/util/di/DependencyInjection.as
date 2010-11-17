﻿package com.snsoft.util.di{
	 
	import com.snsoft.util.StringUtil;
	
	/**
	 * 依赖注入 
	 * @author Administrator
	 * 
	 */	
	public class DependencyInjection{
		public function DependencyInjection(){
			
		}
		
		/**
		 * 
		 * 
		 * 按源对象的属性或按指定的属性名称，把源对象的值注入到目的对象中
		 * 
		 */		
		public static function diObject(fobj:Object,tobj:Object,...name):void{
			var ary:Array = name;
			
			var op:ObjectProperty = new ObjectProperty(fobj);
			
			var v:Vector.<String>;
			if(ary == null || name.length > 0){
				v = new Vector.<String>();
				for(var i:int = 0;i < ary.length;i ++){
					var aName:String = String(ary[i]);
					if(aName != null && aName.length > 0 && StringUtil.isEffective(aName)){
						v.push(String(aName));
					}
				}
			}
			else {
				v = op.propertyNames;
			}
			trace(v);
			for(var i2:int = 0;i2<v.length;i2++){
				var pName:String = v[i2];
				if(tobj.hasOwnProperty(pName)){
					tobj[pName] = fobj[pName];
				}
			}
		}
	}
}