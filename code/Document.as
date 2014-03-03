package code {

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Document extends MovieClip {
		private var dayNodes:DayNodes;
		private var bg:Background;
		private var character:Character;
		
		private var currentDay:int;
		
		var nodes:XML;
		
		
		public function Document() {
			//stop();
			stop();

			buttonStart.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
			
			currentDay = 1;
			//buttonStart.addEventListener(MouseEvent.MOUSE_DOWN,startGame);
			
		}
		
		function startGame(e:MouseEvent):void {
			gotoAndStop(2);
			
			choice1.visible = false;
			choice2.visible = false;
			choice3.visible = false;
			buttonRestart.visible = false;

			
			choice1.addEventListener(MouseEvent.CLICK, answerOne);
			choice2.addEventListener(MouseEvent.CLICK, answerTwo);
			choice3.addEventListener(MouseEvent.CLICK, answerThree);
			
			init_game(currentDay);			
		}
		
		public function init_game(day:int){
			//currentDay = 1;
			trace("Document Currentday:" + currentDay);
			dayNodes = new DayNodes(this,day);
			addChild(dayNodes);
			
			bg = new Background(this,"black");
			background_holder.addChild(bg);
			character = new Character(this,"none","normal");
			character_holder.addChild(character);
		}
		
		function dayEnd(){
			removeChild(dayNodes);
			currentDay++;
			
			background_holder.removeChild(bg);
			character_holder.removeChild(character);
			
			init_game(currentDay);
			

		}
		
		private function restartGame(e:MouseEvent):void {
			removeChild(dayNodes);
			currentDay = 1;
			//background_holder.removeChild(bg);
			//character_holder.removeChild(character);
			buttonNext.visible = true;
			init_game(currentDay);
			buttonRestart.visible = false;
			
		}

		//Update Form: Thie controls the visibility of the buttons,
		//visibility of the "next" button on the lower right
		//visibility of various characters according to who you will interact with
		//will put more in here later...
		function UpdateForm():void {
			//Updates textbox with current text
			textBox.text_main.text = dayNodes.mainText;
			
			//Updates the speaker textbox with the current text
			textBox_speaker.visible = dayNodes.checkSpeaker();
			textBox_speaker.text_speaker.text = dayNodes.speakerText;
			
			//Updates with current background if it is specified
			
			//Updates with current character on the screen if applicable
			
			
		}
		
		private function answerOne(e:MouseEvent):void {
			dayNodes.returnAttribute(0);
		}
		
		private function answerTwo(e:MouseEvent):void {
			dayNodes.returnAttribute(1);
		}
		
		private function answerThree(e:MouseEvent):void {
			dayNodes.returnAttribute(2);
		}
		
		//Makes the choice buttons visible and the next button and text box invisible
		public function showChoices():void {
			buttonNext.visible = false;
				
			choice1.visible = true;
			choice2.visible = true;
			choice3.visible = true;
			
			choice1.text_choice1.text = dayNodes.returnAnswers(1);
			choice2.text_choice2.text = dayNodes.returnAnswers(2);
			choice3.text_choice3.text = dayNodes.returnAnswers(3);
			//text_main.visible = false;
		}
		
		//Makes the choice buttons invisible and the next button and text box visible
		public function hideChoices():void {
			buttonNext.visible = true;
				
			choice1.visible = false;
			choice2.visible = false;
			choice3.visible = false;
	
			textBox.text_main.visible = true;
			
			choice1.text_choice1.text = "";
			choice2.text_choice2.text = "";
			choice3.text_choice3.text = "";
		}
		
		private function removeBackground():void {
			background_holder.removeChild(bg);
		}
		
		public function changeBackground(new_bg:String):void {
			bg = new Background(this,new_bg);
			//background_holder.removeChild(bg);
			background_holder.addChild(bg);
		}
		
		public function changeCharacter(new_character:String):void {
			//fadeOut(character_holder);
			character_holder.removeChild(character);
			character = new Character(this,new_character,"normal");
			character_holder.addChild(character);
		}
		
		public function changeCharacterEmotion(new_character:String,new_emotion:String){
			//fadeOut(character_holder);
			character_holder.removeChild(character);
			character = new Character(this,new_character,new_emotion);
			character_holder.addChild(character);
		}
		
		public function hideNextButton():void {
			buttonNext.visible = false;
			buttonRestart.visible = true;
			
			buttonRestart.addEventListener(MouseEvent.MOUSE_DOWN,restartGame);
		}
	}
	
}
