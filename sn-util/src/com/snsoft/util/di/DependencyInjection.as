package com.snsoft.util.di{
	 
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
		 * 根据类创建对象并给对象注入值 
		 * @param fobj
		 * @param ToClass
		 * @param name
		 * @return 
		 * 
		 */		
		public static function diObjByClass(fobj:Object,ToClass:Class,...name):Object{
			var tobj:Object = new ToClass();
			var nameArray:Array = name;
			diObjToObjByArray(fobj,tobj,nameArray);
			return tobj;
		}
		
		/**
		 * 
		 * 
		 * 按源对象的属性或按指定的属性名称，把源对象的值注入到目的对象中
		 * 
		 */		
		public static function diToObj(fobj:Object,tobj:Object,...name):void{
			var nameArray:Array = name;
			diObjToObjByArray(fobj,tobj,nameArray);
		}
		
		/**
		 * 按源对象的属性或按指定的属性名称，把源对象的值注入到目的对象中
		 * @param fobj
		 * @param tobj
		 * @param nameArray
		 * 
		 */		
		private static function diObjToObjByArray(fobj:Object,tobj:Object,nameArray:Array):void{
			var v:Vector.<String>;
			if(nameArray != null && nameArray.length > 0){
				v = new Vector.<String>();
				for(var i:int = 0;i < nameArray.length;i ++){
					var aName:String = String(nameArray[i]);
					if(aName != null && aName.length > 0){
						v.push(String(aName));
					}
				}
			}
			else {
				var op:ObjectProperty = new ObjectProperty(fobj);
				v = op.propertyNames;
			}
			for(var i2:int = 0;i2<v.length;i2++){
				var pName:String = v[i2];
				if(tobj.hasOwnProperty(pName)){
					tobj[pName] = fobj[pName];
				}
			}
		}
		
		/**
		 * 给对象注入值
		 * @param obj
		 * @param name
		 * @param value
		 * 
		 */		
		public static function diValueToObj(obj:Object,name:String,value:Object,judgeProperty:Boolean = true):void{
			if(obj.hasOwnProperty(name) || !judgeProperty){
				obj[name] = value;
			}
		}
	}
}