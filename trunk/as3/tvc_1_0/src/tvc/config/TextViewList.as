package tvc.config
{
	public class TextViewList
	{
		private var array:Array = new Array();
		
		public function push(tv:TextView):void{
			array.push(tv);
		}
		
		public function pop(index:int):TextView{
			return this.array[index];
		}
		public function getLength():int{
			return this.array.length;
		}
	}
}