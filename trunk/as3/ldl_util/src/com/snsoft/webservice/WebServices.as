package com.snsoft.webservice{
        
        /******************************************************************************
         *
         * 解析WebServices服务
         *
         ******************************************************************************/
        import flash.events.*;
        import flash.net.*;
        
        public class WebServices extends EventDispatcher{
                private var wsUrl:String;
                private var xmlns:String;
                private var headerArray:Array;
                private var methods:Object;
                
                private var mathodArray:Array;
                private var analyseCompleteFlag:Boolean;
                
                public function WebServices(url:String):void{
                        wsUrl = url;
                        methods = {};
                        
                        headerArray = [];                        //SOAP头参数
                        mathodArray = [];                        //方法数组及参数规则,用于在分析完服务之前保存调用方法，待分析完后再执行，避免调用不成功
                        analyseCompleteFlag = false;//分析服务完成标记
                        analyseService();                        //分析服务
                }
                
                public function load(methodName:String, ...args):void{
                        trace("analyseCompleteFlag:"+analyseCompleteFlag);                        
                        if(!analyseCompleteFlag){        //如果服务还未分析完，将方法及参数暂存入数组对象
                                mathodArray.push( {methodName:methodName, args:args} );
                        }else{
                                if(methods[methodName] != null){
                                        var ws:loadWSMethod = new loadWSMethod();
                                        ws.addEventListener("callComplete", callCompleteHandler);
                                        ws.addEventListener("callError", callErrorHandler);                                        

                                        //trace(methodName+":"+args.length+":"+args.toString());
                                        var strParam:String = "";        //
                                        strParam = args.toString();        // by alby:如果该方法在服务分析完之前调用，放进mathodArray被callMethods方法调用，则args会变成只有一个元素的数组，该元素其实也是数组，这里处理
                                        //trace(methodName+":"+strParam)
                                        args = strParam.split(/,/);        //
                                        //trace(methodName+":"+args.length);
                                        ws.load(wsUrl, xmlns, headerArray,methods[methodName], methodName, args);                                        

                                }else{
                                        dispatchEvent(new eventer("wsIOError", {code:"WebServices.call.noMethod",method:methodName}));
                                }
                        }
                }
                
                private function callCompleteHandler(e:eventer):void{
                        dispatchEvent(new eventer("wsComplete", {method:e.eventInfo.m, data:e.eventInfo.d}));
                        e.target.removeEventListener("callComplete", callCompleteHandler);
                        e.target.removeEventListener("callComplete", callErrorHandler);        
                }
                
                private function callErrorHandler(e:eventer):void{
                        dispatchEvent(new eventer("wsIOError", {code:"WebServices.call.Error",method:e.eventInfo.m}));
                        e.target.removeEventListener("callComplete", callCompleteHandler);
                        e.target.removeEventListener("callComplete", callErrorHandler);        
                }
                
                private function analyseService():void{
                        var urlLoader:URLLoader = new URLLoader();
                        urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
                        
                        var urlRequest:URLRequest = new URLRequest();
                        urlRequest.url = wsUrl + "?wsdl";
                        urlRequest.method = URLRequestMethod.POST;
                        urlLoader.addEventListener("complete", completeHandler);
                        urlLoader.addEventListener("ioError", ioerrorHandler);
                        urlLoader.load(urlRequest);
                }
                
                private function completeHandler(e:Event):void{
                        var tmpXML:XML, wsdl:Namespace, s:Namespace, i:int, j:int, item:String, elementXML:XML, itemLen:int;
                        
                        tmpXML = XML(e.target.data);
                        wsdl = tmpXML.namespace();
                        for (i = 0; i < tmpXML.namespaceDeclarations().length; i++) {
                                s = tmpXML.namespaceDeclarations()[i];
                                var prefix:String = s.prefix;
                                if (prefix == "s") break;
                        }
                        //by alby:分析自定义SOAP头
                        elementXML = tmpXML.wsdl::["types"].s::["schema"].s::["complexType"].(@name=="AuthHeader");
                        itemLen = elementXML.s::sequence.s::element.length()
                        for (i=0;i<itemLen;i++){
                                headerArray.push(elementXML.s::sequence.s::element[i].@name);
                        }
                        
                        //elementXML = tmpXML.wsdl::["types"].s::["schema"].s::["element"] by alby 因为加上自定义SOAP头，所以改为以下：
                        //xmlns = elementXML.@targetNamespace;
                        elementXML = tmpXML.wsdl::["types"].s::["schema"].s::["element"].(@name!="AuthHeader");
                        xmlns = elementXML.parent().@targetNamespace;

                        for (i =0; i<elementXML.length(); i+=2) {
                                item = elementXML[i].@name;
                                methods[item] = new Array();
                                itemLen = elementXML[i].s::complexType.s::sequence.s::element.length();
                                for (j =0; j<itemLen; j++){
                                        methods[item].push(elementXML[i].s::complexType.s::sequence.s::element[j].@name);
                                }
                        }
                        //dispatchEvent(new eventer("wsAnalyseComplete", {methods:methods}));
                        analyseCompleteFlag = true;
                        callMethods();
                        e.target.removeEventListener("complete", completeHandler);
                        e.target.removeEventListener("ioError", ioerrorHandler);
                }
                
                private function callMethods():void{
                        for(var m:String in mathodArray){
                                load(mathodArray[m].methodName, mathodArray[m].args);//args数组是作为一个参数传递到load方法的，所以laod方法会把数组认为是一个整体的参数
                                //trace(mathodArray[m].args is Array)
                                //trace(mathodArray[m].args.length)
                                //trace("方法及数据4："mathodArray[m].methodName+":"+mathodArray[m].args)
                        }
                        mathodArray = null;
                }
                
                private function ioerrorHandler(e:IOErrorEvent):void{
                        dispatchEvent(new eventer("wsIOError", {code:"WebServices.analyse.IOError",method:"analyseService"}));
                        e.target.removeEventListener("complete", completeHandler);
                        e.target.removeEventListener("ioError", ioerrorHandler);
                }
        }
}



/******************************************************************************
*
* 调用WebServices方法
*
******************************************************************************/
import flash.events.*;
import flash.net.*;
import mx.messaging.channels.StreamingAMFChannel;

class loadWSMethod extends EventDispatcher{
        
        private static var soap:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
        private static var soapXML:XML = <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                                                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                                                                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header/><soap:Body/></soap:Envelope>;
        private var urlLoader:URLLoader;
        private var urlRequest:URLRequest;
        private var targetMethodName:String;
        
        public function loadWSMethod():void{
                urlLoader = new URLLoader();
                urlRequest = new URLRequest();
                //urlLoader.addEventListener("httpStatus", httpstateHandler);
                urlLoader.addEventListener("complete", completeHandler);                 
                urlLoader.addEventListener("ioError", ioerrorHandler);
        }
        
        public function load(wsUrl:String, xmlns:String, headerArray:Array,labels:Array, methodName:String, args:Array):void{
			//trace("方法：loadWSMethod load")                
			var tempXML:XML = soapXML;
			var hearderXML:XML = XML("<AuthHeader xmlns=\"" + xmlns + "\"/>");
			for (var i:int =0;i<headerArray.length;i++)
			{
			        hearderXML.appendChild( new XML("<" + headerArray[i] +">" + args[i] + "</" + headerArray[i] + ">") );
			}
			tempXML.soap::["Header"].appendChild(hearderXML);
			
			targetMethodName = methodName;
			   var methodXML:XML = XML("<" + methodName + " xmlns=\"" + xmlns + "\"/>");
			
			if(args.length!=1||args[0]!=""){        //by alby:当无参数时,传递过来的为数组，只有一个元素，为空字符串
			                                                                        //如果需要，这里可以加一个参数个数是否对应的判断
			//trace(args.length)
			        for (i=headerArray.length; i<args.length; i++)                        
			           methodXML.appendChild( new XML("<" + labels[i-headerArray.length] +">" + args[i] + "</" + labels[i-headerArray.length] + ">") );
			}                
			
			   tempXML.soap::["Body"].appendChild(methodXML);
			
			//trace(tempXML)
			if(xmlns.lastIndexOf("/") == xmlns.length - 1) xmlns = xmlns.substr(0, xmlns.length - 1);
			urlRequest.url = wsUrl + "?op=" + methodName;   
			        //trace(wsUrl + "?op=" + methodName)
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml;charset=utf-8"));        
			urlRequest.requestHeaders.push(new URLRequestHeader("SOAPAction", xmlns + "/" + methodName));
			urlRequest.data = tempXML;
			urlLoader.load(urlRequest);
        }
        
        private function completeHandler(e:Event):void{
                dispatchEvent(new eventer("callComplete", {m:targetMethodName, d:e.target.data}));
                e.target.removeEventListener("complete", completeHandler);
                e.target.removeEventListener("ioError", ioerrorHandler);
        }
        private function ioerrorHandler(e:IOErrorEvent):void{
                dispatchEvent(new eventer("callError", {e:e,m:targetMethodName}));
                e.target.removeEventListener("complete", completeHandler);
                e.target.removeEventListener("ioError", ioerrorHandler);
        }
}




/******************************************************************************
*
* 事件扩展,附加传递参数eventInfo
*
******************************************************************************/
class eventer extends Event {
        private var info:Object;

        public function eventer(type:String, info:Object, bubbles:Boolean = false, cancelable:Boolean = false):void{
                super(type, bubbles, cancelable);
                this.info = info;
        }
        public function get eventInfo():Object {
                return this.info;
        }
        public override function toString():String {
                return formatToString("Event:", "type", "bubbles", "cancelable", "eventInfo");
        }
}
