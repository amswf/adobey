package tvc.config
{
	public class TextView
	{
		//显示文本的X坐标
		private var x:Number = 0;
		//显示文本的Y坐标
		private var y:Number = 0;
		//显示文本内容
		private var textOut:String = "";
		
		public function setX(x:Number):void{
			this.x = x;
		}
		
		public function setY(y:Number):void{
			this.y = y;
		}
		
		public function setTextOut(text:String):void{
			this.textOut = text;
		}
		
		public function getX():Number{
			return this.x;
		}
		
		public function getY():Number{
			return this.y;
		}
		
		public function getTextOut():String{
			return this.textOut;
		}
		
	}
}