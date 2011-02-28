package com.snsoft.util{


	import flash.utils.*;

	public class AbstractBase {
		private var _className:String;
		private var _objectClass:Class;

		public function AbstractBase() {
			_className = getQualifiedClassName(this);
			_objectClass = getDefinitionByName(_className) as Class;
			createAbstractClass(AbstractBase);
		}

		protected final function createAbstractClass(abstractClass:Class):void {
			if (_objectClass == abstractClass) {
				throw new Error("\"" + _className + "\" is an abstract class, you can't create an instance of it");
			}
		}

		protected final function createAbstractMethod(methodName:String):* {
			throw new Error("\"" + methodName + "\" is an abstract method, you must override it in " + _className);
			return null;
		}
	}
}