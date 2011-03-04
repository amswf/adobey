package com.snsoft.fmc{
	
	/**
	 * Net status Info Code , NetStatusEvent.info.code 的值
	 * @author Administrator
	 * 
	 */	
	public class NSICode{
		
		/**
		 * 数据的接收速度不足以填充缓冲区。 数据流将在缓冲区重新填充前中断，此时将发送 NetStream.Buffer.Full 消息，并且该流将重新开始播放。
		 */		
		public static const NetStream_Buffer_Empty:String = "NetStream.Buffer.Empty";
		
		/**
		 * 缓冲区已满并且流将开始播放。
		 */		
		public static const NetStream_Buffer_Full:String = "NetStream.Buffer.Full";
		
		/**
		 * 数据已完成流式处理，剩余的缓冲区将被清空。
		 */		
		public static const NetStream_Buffer_Flush:String = "NetStream.Buffer.Flush";
		
		/**
		 * 仅限 Flash Media Server。 发生了错误，在其它事件代码中没有列出此错误的原因。
		 */		
		public static const NetStream_Failed:String = "NetStream.Failed";
		
		/**
		 * 已经成功发布。
		 */		
		public static const NetStream_Publish_Start:String = "NetStream.Publish.Start";
		
		/**
		 * 试图发布已经被他人发布的流。
		 */		
		public static const NetStream_Publish_BadName:String = "NetStream.Publish.BadName";
		
		/**
		 * 流发布者空闲而没有在传输数据。
		 */		
		public static const NetStream_Publish_Idle:String = "NetStream.Publish.Idle";
		
		/**
		 * 已成功执行取消发布操作。
		 */		
		public static const NetStream_Unpublish_Success:String = "NetStream.Unpublish.Success";
		
		/**
		 * 播放已开始。
		 */		
		public static const NetStream_Play_Start:String = "NetStream.Play.Start";
		
		/**
		 * 播放已结束。
		 */		
		public static const NetStream_Play_Stop:String = "NetStream.Play.Stop";
		
		/**
		 * 出于此表中列出的原因之外的某一原因（例如订阅者没有读取权限），播放发生了错误。
		 */		
		public static const NetStream_Play_Failed:String = "NetStream.Play.Failed";
		
		/**
		 * 无法找到传递给 play() 方法的 FLV。
		 */		
		public static const NetStream_Play_StreamNotFound:String = "NetStream.Play.StreamNotFound";
		
		/**
		 * 由播放列表重置导致。
		 */		
		public static const NetStream_Play_Reset:String = "NetStream.Play.Reset";
		
		/**
		 * 到流的初始发布被发送到所有的订阅者。
		 */		
		public static const NetStream_Play_PublishNotify:String = "NetStream.Play.PublishNotify";
		
		/**
		 * 从流取消的发布被发送到所有的订阅者。
		 */		
		public static const NetStream_Play_UnpublishNotify:String = "NetStream.Play.UnpublishNotify";
		
		/**
		 * 仅限 Flash Media Server。 客户端没有足够的带宽，无法以正常速度播放数据。 
		 */		
		public static const NetStream_Play_InsufficientBW:String = "NetStream.Play.InsufficientBW";
		
		/**
		 * 播放器检测到无效的文件结构并且将不会尝试播放这种类型的文件。用于 Flash Player 9.0.115.0 及更高版本。
		 */		
		public static const NetStream_Play_FileStructureInvalid:String = "NetStream.Play.FileStructureInvalid";
		
		/**
		 * 放器未检测到任何支持的音轨（视频、音频或数据）并且将不会尝试播放该文件。用于 Flash Player 9.0.115.0 及更高版本。
		 */		
		public static const NetStream_Play_NoSupportedTrackFound:String = "NetStream.Play.NoSupportedTrackFound";
		
		/**
		 * 限 Flash Media Server 3.5 和更高版本。服务器收到因位速率流切换而需要过渡到其他流的命令。此代码指示用于启动流切换的 NetStream.play2() 调用的成功状态事件。如果切换失败，则服务器将改为发送 NetStream.Play.Failed 事件。当发生流切换时，将调度带有代码“NetStream.Play.TransitionComplete”的 onPlayStatus 事件。用于 Flash Player 10 及更高版本。
		 */		
		public static const NetStream_Play_Transition:String = "NetStream.Play.Transition";
		
		/**
		 * 流已暂停。
		 */		
		public static const NetStream_Pause_Notify:String = "NetStream.Pause.Notify";
		
		/**
		 * 流已恢复。
		 */		
		public static const NetStream_Unpause_Notify:String = "NetStream.Unpause.Notify";
		
		/**
		 * 录制已开始。
		 */		
		public static const NetStream_Record_Start:String = "NetStream.Record.Start";
		
		/**
		 * 试图录制仍处于播放状态的流或客户端没有访问权限的流。
		 */		
		public static const NetStream_Record_NoAccess:String = "NetStream.Record.NoAccess";
		
		/**
		 * 录制已停止。
		 */		
		public static const NetStream_Record_Stop:String = "NetStream.Record.Stop";
		
		/**
		 * 尝试录制流失败。
		 */		
		public static const NetStream_Record_Failed:String = "NetStream.Record.Failed";
		
		/**
		 * 搜索失败，如果流处于不可搜索状态，则会发生搜索失败。
		 */		
		public static const NetStream_Seek_Failed:String = "NetStream.Seek.Failed";
		
		/**
		 * 对于使用渐进式下载方式下载的视频，用户已尝试跳过到目前为止已下载的视频数据的结尾或在整个文件已下载后跳过视频的结尾进行搜寻或播放。 message.details 属性包含一个时间代码，该代码指出用户可以搜寻的最后一个有效位置。
		 */		
		public static const NetStream_Seek_InvalidTime:String = "NetStream.Seek.InvalidTime";
		
		/**
		 * 搜寻操作完成。
		 */		
		public static const NetStream_Seek_Notify:String = "NetStream.Seek.Notify";
		
		/**
		 * 以不能识别的格式编码的数据包。 
		 */				
		public static const NetConnection_Call_BadVersion:String = "NetConnection.Call.BadVersion";
		
		/**
		 * NetConnection.call 方法无法调用服务器端的方法或命令。
		 */		
		public static const NetConnection_Call_Failed:String = "NetConnection.Call.Failed";
		
		/**
		 * Action Message Format (AMF) 操作因安全原因而被阻止。 或者是 AMF URL 与 SWF 不在同一个域，或者是 AMF 服务器没有信任 SWF 文件的域的策略文件。 
		 */		
		public static const NetConnection_Call_Prohibited:String = "NetConnection.Call.Prohibited";
		
		/**
		 * 成功关闭连接。
		 */		
		public static const NetConnection_Connect_Closed:String = "NetConnection.Connect.Closed";
		
		/**
		 * 连接尝试失败。
		 */		
		public static const NetConnection_Connect_Failed:String = "NetConnection.Connect.Failed";
		
		/**
		 * 连接尝试成功。
		 */		
		public static const NetConnection_Connect_Success:String = "NetConnection.Connect.Success";
		
		/**
		 * 连接尝试没有访问应用程序的权限。
		 */		
		public static const NetConnection_Connect_Rejected:String = "NetConnection.Connect.Rejected";
		
		/**
		 * 正在关闭指定的应用程序。
		 */		
		public static const NetConnection_Connect_AppShutdown:String = "NetConnection.Connect.AppShutdown";
		
		/**
		 * 连接时指定的应用程序名无效。
		 */		
		public static const NetConnection_Connect_InvalidApp:String = "NetConnection.Connect.InvalidApp";
		
		/**
		 * 成功关闭 P2P 连接。info.stream 属性指示已关闭的流。
		 */		
		public static const NetStream_Connect_Closed:String = "NetStream.Connect.Closed";
		
		/**
		 * P2P 连接尝试失败。info.stream 属性指示已失败的流。
		 */		
		public static const NetStream_Connect_Failed:String = "NetStream.Connect.Failed";
		
		/**
		 * P2P 连接尝试成功。info.stream 属性指示已成功的流。
		 */		
		public static const NetStream_Connect_Success:String = "NetStream.Connect.Success";
		
		/**
		 * P2P 连接尝试没有访问另一个对等方的权限。info.stream 属性指示被拒绝的流。
		 */		
		public static const NetStream_Connect_Rejected:String = "NetStream.Connect.Rejected";
		
		/**
		 * “待定”状态已解析并且 SharedObject.flush() 调用成功。
		 */		
		public static const SharedObject_Flush_Success:String = "SharedObject.Flush.Success";
		
		/**
		 * 待定”状态已解析，但 SharedObject.flush() 失败。
		 */		
		public static const SharedObject_Flush_Failed:String = "SharedObject.Flush.Failed";
		
		/**
		 * 使用永久性标志对共享对象进行了请求，但请求无法被批准，因为已经使用其它标记创建了该对象。
		 */		
		public static const SharedObject_BadPersistence:String = "SharedObject_BadPersistence";
		
		/**
		 * 试图连接到拥有与共享对象不同的 URI (URL) 的 NetConnection 对象。
		 */		
		public static const SharedObject_UriMismatch:String = "SharedObject.UriMismatch";
	
		
		public function NSICode()
		{
		}
	}
}