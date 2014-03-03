package code {
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.sampler.StackFrame;
	
	public class DayNodes extends MovieClip {
		
		private var myDoc:Document;
		
		//the text of the node/ use this for the attributes as well
		private var currentNode:Number;
		private var currentText:Number;
		private var currentLocation:String;
		private var currentCharacter:String;
		private var currentEmotion:String;
		
		//URLLoaders
		var dayLoader:URLLoader = new URLLoader();
		
		//contains the xml for each day and the nodes inside it so we can call them
		private var day:int;
		private var dayXML:XML;
		private var node:XMLList;
		
		public var mainText:String;
		public var speakerText:String;
		
		private var isQuestion:Boolean = false;
		private var isDayDone:Boolean = false;

		public function DayNodes(aDoc:Document, tempDay:int) {
			//will load the textfiles according to which day they pertain to
			myDoc = aDoc;
			
			day = tempDay;
			
			loadDay(day);
			this.dayLoader.addEventListener(Event.COMPLETE,newDay);
			
			myDoc.buttonNext.addEventListener(MouseEvent.CLICK, goNext);
			
			currentNode=0;
			currentText=0;
			currentLocation = "black";
			
			currentEmotion = "normal";
			currentCharacter = "none";
			
			
		}
		
		private function loadDay(dayNum:int):void {
			trace("time to load xml");
			
			dayLoader.load(new URLRequest("day"+dayNum+".xml"));
		}
		
		private function newDay(e:Event):void {
			dayXML = new XML(e.target.data);
			
			trace("new xml loaded!");
			checkNext();
			//trace(dayXML.toString());
		}
		
		private function goNext(e:MouseEvent):void {
		   //trace("number of texts:" +dayXML.node[currentNode].text.length());
		
			if(isDayDone){
		  	 trace("done with the day!");
		   		currentNode=0;
				currentText=0;
				myDoc.dayEnd();
				isDayDone = false;
				myDoc.buttonNext.removeEventListener(MouseEvent.CLICK, goNext);
				this.dayLoader.removeEventListener(Event.COMPLETE,newDay);
			   } else {
				checkNext();
			}
		}
		
		private function checkNext():void {
			if(currentNode == (dayXML.node.length())-1){
				isDayDone = true;
				mainText = dayXML.node[currentNode].text[currentText].toString();
				myDoc.UpdateForm();
				trace("isDayDone is true");
				
				if("@done" in dayXML.node[currentNode])
					myDoc.hideNextButton();
				
			} else {//checks if a question has been asked
				if(isQuestion == true) {
					trace("loading questions");
					mainText = dayXML.node[currentNode].question.toString();
					myDoc.UpdateForm();
					myDoc.showChoices();
					isQuestion = false;
				} else {

					mainText = dayXML.node[currentNode].text[currentText].toString();
			
					trace("currentNode: " +currentNode);
					trace("currentText: " +currentText);
					//trace(dayXML.node[currentNode].toString());
					//trace(dayXML.node[currentNode].text.length());
				
					this.checkSpeaker();
					
					if(currentCharacter != dayXML.node[currentNode].text[currentText].@character)
						this.checkCharacter();
						
					this.checkEmotion();
					
					if(currentText == 0 && currentLocation != dayXML.node[currentNode].@location.toString()){
						this.checkLocation();					
					}

				
					myDoc.UpdateForm();
				
					currentText++;
				
			
					//checks if it's at the end of the node
					if(currentText == dayXML.node[currentNode].text.length()) {
						//checks if there is a link in the node to another node
						if("@link" in dayXML.node[currentNode]){
							trace("link exists");
							currentNode = (dayXML.node[currentNode].@link)-2;
							trace("currentNode with link:" + currentNode);
						}
					
						
						//checks if the node has a question property
						if(dayXML.node[currentNode+1].hasOwnProperty("question")){
							trace("The next node (" +(currentNode+2)+") has a question");
							isQuestion = true;
						}
							currentNode++;
							
							currentText = 0;
					}
				}
			}//end else statement
		}
		
		public function returnAnswers(answerNum:int):String {
			return dayXML.node[currentNode].answer[answerNum-1].toString();
		}
		
		public function returnAttribute(id:int):void {
			
			var linkID:int = dayXML.node[currentNode].answer[id].@link;
			trace("link = " + linkID);
			
			currentNode = linkID-1;
			currentText = 0;
			
			mainText = dayXML.node[currentNode].text[currentText].toString();
			
			checkNext();
			
			myDoc.hideChoices();
			isQuestion = false;
			
			//this.checkNext();
			
			myDoc.UpdateForm();
			
		}
		
		//this will display the character speaking
		public function checkSpeaker():Boolean {
			if(dayXML.node[currentNode].hasOwnProperty("question")){
			   return false;
			   } else if("@speaker" in dayXML.node[currentNode].text[currentText]){
					trace("the speaker is: " +dayXML.node[currentNode].text[currentText].@speaker);
					this.speakerText = dayXML.node[currentNode].text[currentText].@speaker.toString();
					return true;
				} else {
					this.speakerText = "";
					return false;
					}
		}
		
		public function checkCharacter():void {
			if("@character" in dayXML.node[currentNode].text[currentText]){
				trace("the character displayed is: " + dayXML.node[currentNode].text[currentText].@character);
				currentCharacter = dayXML.node[currentNode].text[currentText].@character;
				myDoc.changeCharacter(currentCharacter);
			}
		}
		
		public function checkEmotion():void {
			if("@emotion" in dayXML.node[currentNode].text[currentText]){
				trace("their emotion is: " + dayXML.node[currentNode].text[currentText].@emotion);
				currentEmotion = dayXML.node[currentNode].text[currentText].@emotion;
				myDoc.changeCharacterEmotion(currentCharacter,currentEmotion);
			}
		}
		
		public function checkLocation():void {
			if("@location" in dayXML.node[currentNode]){
				trace("the location is: " + dayXML.node[currentNode].@location);
				currentLocation = dayXML.node[currentNode].@location;
				myDoc.changeBackground(dayXML.node[currentNode].@location);
			}
		}
		
	}
	
}
