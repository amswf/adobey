package test{
	import com.snsoft.util.di.DependencyInjection;
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
				trace(user.name,user.i,user.num);
				
				var u2:User = new User();
				DependencyInjection.diObjToObj(user,u2) as User;
				trace("name","i","num");
				trace(u2.name,u2.i,u2.num);
			}
		}
		
		private function attributeToProperty():void{
			
		}
	}
}