package code {
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class Character extends MovieClip {
		
		private var myDoc:Document;
		private var url:URLRequest;
		
		//url loader
		public var cLoader:URLLoader = new URLLoader();
		
		
		public function Character(aDoc:Document,characterString:String,emotionString:String) {
			myDoc = aDoc;
			this.x = (myDoc.stage.width/2)-(myDoc.stage.width/7);
			
			if(characterString != "none"){
				trace("images/characters/" + characterString + "_" + emotionString + ".png");
				url = new URLRequest("images/characters/" + characterString + "_" + emotionString + ".png");
				loadImage();
			}
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
