package tvc 
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.display.MovieClip;

    public class LoaderMedia extends Sprite {
        private var url:String = "default.jpg";
		private var loader:Loader = new Loader();
		
		
		/**
		 * 
		 */
        public function LoaderMedia(url:String) {
            this.url = url;
        }
        
        
        /**
        * 
        */
        public function getMedia():Loader {
        	configureListeners(loader.contentLoaderInfo);
            //loader.addEventListener(MouseEvent.CLICK, clickHandler);
            var request:URLRequest = new URLRequest(url);
            loader.load(request);
            return loader;
        }


		/**
		 * 
		 */
        private function configureListeners(dispatcher:IEventDispatcher):void {
            //dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            //dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            //dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            //dispatcher.addEventListener(Event.OPEN, openHandler);
            //dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            //dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            trace("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            trace("unLoadHandler: " + event);
        }

        private function clickHandler(event:MouseEvent):void {
            trace("clickHandler: " + event);
            var loader:Loader = Loader(event.target);
            loader.unload();
        }
    }
}