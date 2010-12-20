package com.snsoft.fmc{
	public class NSPublishType{
		
		/**
		 * 省略此参数或传递“live”，则 Flash Player 将发布实时数据而不进行录制。
		 */		
		public static const LIVE:String = "live";
		
		/**
		 * 如果传递“record”，Flash Player 将发布并录制实时数据，同时将录制的数据保存到名称与传递给 name 参数的值相匹配的新文件中。 该文件保存在服务器上服务器应用程序所在目录的子目录中。 如果该文件存在，则覆盖该文件。
		 */		
		public static const RECORD:String = "record";
		
		/**
		 * 如果传递“append”，Flash Player 将发布并录制实时数据，同时将录制的数据附加到名称与传递给 name 参数的值相匹配的文件中，该文件存储在服务器上包含服务器应用程序的目录的子目录中。如果未找到与 name 参数相匹配的文件，则创建一个文件。
		 */		
		public static const APPEND:String = "append";
		
		public function NSPublishType()
		{
		}
	}
}