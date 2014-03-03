package code {
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class Background extends MovieClip {
		
		private var myDoc:Document;
		private var url:URLRequest;
		
		//url loader
		public var bgLoader:URLLoader = new URLLoader();
		
		
		public function Background(aDoc:Document, bgString:String) {
			myDoc = aDoc;
			
			url = new URLRequest("images/bg/" + bgString + ".png");
			loadImage();
		
		}
		
		public function loadImage():void {
    		var loader:Loader = new Loader;
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
    		loader.load(url);
		}
		
		private function imageLoaded(event:Event):void {
  			var image:Bitmap = new Bitmap(event.target.content.bitmapData);
			addChild(image);
		}

	}
	
}
