import QtQuick 2.0

import "../backdrops"

ModesBase {
	id: modesBase
	
	modeName: 'Bar'
	numberPadVisible: false
	
	Component.onCompleted: {
//		modesBase.textFieldColumn.visible = false;
	}
	
	//	checks if text has a parsing error
	function hasParsingError(text) {
		
	}
	
	//	checks text against input validation
	function checkInput(text) {
		
	}
	
	//	checks the answer provided by text
	function checkAnswer(text) {
		
	}
	
	//	generates a new, random question
	function generateRandomQuestion() {
		
	}
	
	
	
	//	== If there is more than one difficulty: == //
	
	//	encodes the current question's state
	function getQuestionState() {
		
	}
	
	//	decodes the state provided
	function parseQuestionState(state) {
		
	}
}
