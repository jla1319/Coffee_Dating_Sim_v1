package code {
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class DayNodes extends MovieClip {
		
		private var myDoc:Document;
		
		//the text of the node/ use this for the attributes as well
		private var currentNode:Number = 0;
		
		//URLLoaders
		var dayLoader:URLLoader = new URLLoader();
		
		//contains the xml for each day and the nodes inside it so we can call them
		private var day:int;
		private var dayXML:XML;
		private var node:XMLList;

		public function DayNodes(aDoc:Document, tempDay:int) {
			//will load the textfiles according to which day they pertain to
			myDoc = aDoc;
			
			day = tempDay;
			
			loadDay(day);
			this.dayLoader.addEventListener(Event.COMPLETE,newDay);
			
		}
		
		private function loadDay(dayNum:int):void {
			trace("time to load xml");
			
			dayLoader.load(new URLRequest("day"+dayNum+".txt"));
		}
		
		private function newDay(e:Event):void {
			dayXML = new XML(e.target.data);
			
			trace(dayXML.toString());
		}

	}
	
}
