package test{
	import com.snsoft.xmldom.Node;
	import com.snsoft.xmldom.NodeList;
	import com.snsoft.xmldom.XMLDom;
	
	import flash.display.Sprite;

	public class Main extends Sprite{
		public function Main()
		{
			var xml:XML = <xml>
							<users>
								<user name="a" num="90.34" i="90" />
							</users>
						  </xml>;
			
			var xmldom:XMLDom = new XMLDom(xml);
			var node:Node = xmldom.parse();
			
			var usersNode:Node = node.getNodeListFirstNode("users");
			var userList:NodeList = usersNode.getNodeList("user");
			for(var i:int =0;i<userList.length();i++){
				var userNode:Node = userList.getNode(i);
				var user:User = userNode.ormAttribute(User) as User;
				
				trace("name","i","num");
				trace(user.name,user.num,user.i);
			}
		}
		
		private function attributeToProperty():void{
			
		}
	}
}