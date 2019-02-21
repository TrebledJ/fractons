//	ModesBase.qml

import VPlay 2.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "../../common"
import "../../game"

import "../../js/Math.js" as JMath

/*	ModesBase provides an interface/template for building questions and accepting answers. It builds on a SceneBase by drawing a panel on the left
	with the following buttons:
		+ Back (previous scene)
		+ i (information)
		+ Go (checks the answer and generates a new question)
	
	The panel also contains a vertical xp bar, information on the level & xp, as well as a log feed.
		
	When inheriting ModesBase to construct a question, the following abstract functions should be noted and implemented:
		int hasParsingError(text: string)	//	checks if text has a parsing error (this shouldn't include empty-string checking)
		bool checkInput(text: string)		//	checks text against input validation
		bool checkAnswer(text: string)		//	checks the answer provided by text (should return true if the answer is correct)
		void generateRandomQuestion()		//	generates a new, random question
	
	When a difficulty is changed, the following abstract functions will be in use. If a question has no difficulty levels,
	the following functions may be ignored.
		string getQuestionState()				//	encodes the current question's state
		void parseQuestionState(state: string)	//	decodes the state provided
		
	Template: 
	
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
	
  */


SceneBase {
	id: scene
	
//	signal backButtonClicked	//	signal provided by SceneBase
	signal goButtonClicked
	signal difficultyChanged(int index, string difficulty)
	
	property var lastQuestions: ({})
	
	property alias panel: panel
	property alias goButton: goButton
	property alias answerField: answerField
	
	property alias drawingArea: drawingArea
	
	property alias numberPad: numberPad
	property alias numberPadVisible: numberPadSwitch.checked
	
	
	property var difficulties: []
	property int difficultyIndex: 0

	property bool hasInputError: false
	property string errorMessage
	
	property int xpAmount: 0
//	property int combo: 0
	
	
	useDefaultBackButton: false
	
	Component.onCompleted: {
//		console.debug("Level", JFractureuns.levelAt());
//		console.debug("fractureuns", JFractureuns.fCurrent);
//		console.debug("leveling_constant", JFractureuns.fLevelingConstant);
		
//		for (var i = 0; i < 10; i++)
//		{
//			console.debug("Level", i, "has a thresh of", JFractureuns.xpThresh(i));
//		}
		
//		for (var i = 0; i < 20; i++)
//		{
//			console.debug("XP", i * 10, "has level", JFractureuns.levelAt(i*10));
//		}
		
		
		//	ACVM : no u
		priv.nou = JGameAchievements.getByName("no u").progress;
//		console.debug("[ModesBase] Got nou progress:", priv.nou)
		
		
		//	check if platform is mobile
		if (JStorage.isMobile)
		{
			errorField.height = 30;
			errorField.font.pointSize = 12;
			
			answerField.height = 30;
			answerField.font.pointSize = 18;
		}
		else	//	non-mobile
		{
			numberPadVisible = false;	//	computers default to no numpad
			
//			answerField.onEditingFinished.connect(function(){ goButton.clicked(); });
		}
		
		//	generate a random question
		generateRandomQuestion();
	}
	
	
	BubbleButton {
		id: numberPadSwitch
		width: height; height: 30
		anchors {
			top: drawingArea.top
			right: drawingArea.right
			margins: 10
		}
		color: "navy"
		
		text: "C"
		textBase.color: "yellow"
		
		checked: true
		isCheckButton: true
		
		onClicked: {
			if (numberPad.visible)
				numberPad.animate();
		}
	}
	
	NumberPad {
		id: numberPad
		height: 150
		anchors {
			left: drawingArea.left
			right: drawingArea.right
			bottom: textFieldColumn.top
			margins: 5
		}
		
		visible: numberPadVisible
		
		onKeyPressed: /*params: {string key}*/ {
			if (key === 'back')
			{
				if (answerField.text.length > 0)
					answerField.text = answerField.text.substring(0, answerField.text.length - 1);
				
				return;
			}
			
			answerField.text += key;
		}
	}
	
	Rectangle {
		id: panel
		width: scene.width / 4
		anchors {
			top: scene.top
			left: scene.left
			bottom: scene.bottom
		}
		
		color: "navy"
		
		Column {
			id: panelColumn
			anchors.fill: parent
			anchors.margins: 10
			spacing: 10
			
			//	this is the row of buttons at the top of the panel
			Row {
				width: parent.width; height: 30
				spacing: 10
				
				BubbleButton {
					id: backButton
					width: parent.width - parent.spacing - infoButton.width; height: parent.height
					background.radius: 5
					color: "yellow"
					
					text: "Back"
					
					onClicked: scene.backButtonClicked()
				}
				
				BubbleButton {
					id: infoButton
					width: height; height: parent.height
					background.radius: 5
					color: "yellow"
					
					text: "i"
				}
			}
			
			BubbleButton {
				id: difficultyButton
				width: parent.width; height: 30
				background.radius: 5
				color: "yellow"
				
				text: difficulties.length === 0 ? "" : difficulties[difficultyIndex]
				
				
				visible: difficulties.length > 0
				
				onClicked: {
					lastQuestions[difficultyIndex] = getQuestionState();
					
					difficultyIndex = (difficultyIndex + 1) % difficulties.length;
				}
			}
			
			Row {
				width: parent.width; height: parent.height - parent.spacing - backButton.height
													- (difficultyButton.visible ? parent.spacing + difficultyButton.height : 0)
				spacing: 10
				
				//	this will display the fracs
				Rectangle {
					id: fractureunOuterBar
					width: 10; height: parent.height
					radius: 5
					
					color: "lightgoldenrodyellow"
					
					Rectangle {
						id: fractureunMeter
						width: 4; height: (parent.height - 4.0) * JFractureuns.fProgress()
						radius: 4
						anchors {
							left: parent.left
							right: parent.right
							bottom: parent.bottom
							margins: 2
						}
						
						color: "navy"
					}
				}	//	Rectangle: fractureunOuterBar
				
				//	this column will display miscellaneous objects
				//	 event logs, the Go button, level/xp labels
				Column {
					width: parent.width - parent.spacing - fractureunOuterBar.width; height: parent.height
					spacing: 10
					
					Rectangle {
						id: eventSpace
						width: parent.width
						height: parent.height - parent.spacing - goButton.height
									- parent.spacing - fractureunDisplay.height
						
						color: "skyblue"	//	debug
//						color: "transparent"
					}
					
					BubbleButton {
						id: goButton
						width: parent.width; height: 30
						background.radius: 5
						color: "yellow"
						
						text: "Go"
						
						onClicked: {
							//	broadcast
							scene.goButtonClicked();
							
							//	all the intense logic is kept out of here for brevity
						}
					}
					
					TextBase {
						id: fractureunDisplay
						height: contentHeight + 5
						anchors.horizontalCenter: parent.horizontalCenter
						
						text: 'Level ' + JFractureuns.currentLevel() + '   ' + JFractureuns.fCurrent + '/' + JFractureuns.fNextThresh() + " F"
						color: "yellow"
						
						font.pointSize: 10
						verticalAlignment: Text.AlignBottom
					}
					
					
				}	//	Column
			}	//	Row
		}	//	Column: panelColumn
	}	//	Rectangle: panel
	
	//	this column holds text fields, anchored to the bottom of the scene (for non-mobile/tvos platforms only)
	Column {
		id: textFieldColumn
		
		anchors.left: panel.right
		anchors.right: scene.right
		anchors.bottom: scene.bottom
		
		//	TODO make some animation for the error field so that it will slide above the answerField
		
		//	this will popup above the answerField below when there is an error message
		TextField {
			id: errorField
			width: parent.width; height: 20
			padding: 2
			
			text: errorMessage
			color: "red"
			
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			visible: errorMessage !== ""
			opacity: 0.8
			
			readOnly: true
		}
		
		//	this is similar to a qlineedit, and is where the user will enter input
		TextField {
			id: answerField
			
			width: parent.width; height: 20
			padding: 2
			
			placeholderText: "Answer"
			
			color: "navy"
			font.pointSize: 8
			font.family: "Trebuchet MS"
			
			Keys.onReturnPressed: {
				if (JStorage.isMobile)
					return;
				
				//	simulate goButton being clicked
				goButton.clicked();
			}
			
			background: Rectangle {
				anchors.fill: parent
				
				color: "white"
				border.color: answerField.enabled ? "lightgrey" : "transparent"
				
				Rectangle {
					anchors.fill: parent
					anchors.margins: 1
					
					//	TODO find suitable substitute to "red"
					color: hasInputError ? "red" : answerField.enabled ? "green" : "white"
					opacity: 0.5
				}
			}
		
			onTextChanged: {
				//	update the errCode which will update the background if the answer is invalid
				var text = answerField.text;

				var error = hasParsingError(text);
				hasInputError = error;
			}
		}
	}
	
	//	this will be referenced in child scenes for appropriate drawing points
	Rectangle {
		id: drawingArea
		anchors {
			left: panel.right
			right: scene.right
			top: scene.top
			bottom: ignoreItems ? scene.bottom : (numberPad.visible ? numberPad.top : textFieldColumn.top)
		}
		
		property bool ignoreItems: false
		
		color: "transparent"
	}
	
	//	an object to store private variables
	QtObject {
		id: priv
		
		property var eventTextComponent: Qt.createComponent("../../common/TextAnimation.qml")
		property int eventCounter: 0
		
		//	ACVM : no u
		property int nou: 0
	}
	
	onDifficultyIndexChanged: {
		console.warn("Difficulty Index Changed:", difficultyIndex)
		console.log(JSON.stringify(lastQuestions))
		
		//	generate a new random question
		if (lastQuestions[difficultyIndex] === undefined)
			generateRandomQuestion();
		else
			parseQuestionState(lastQuestions[difficultyIndex]);
		
		modesBase.difficultyChanged(difficultyIndex, difficulties[difficultyIndex]);
	}
	
	onGoButtonClicked: {
		//	animation logic
		goButton.animateScalar(goButton.pressedFrom, goButton.pressedTo);
		
		//	processing logic
		var text = answerField.text;
		
		//	ACVM : no u
		if (text === "no u")
		{
			console.warn("NO U!");
			priv.nou++;
			
			JGameAchievements.addProgressByName("no u", 1);
		}
		
		//	back to logic-processing
		var hasAcceptableInput = checkInput(text);
		if (!hasAcceptableInput)
			return;
		
		var isCorrect = checkAnswer(text);
		if (isCorrect)
		{
			addCombo();
			
			//	ACVM : jogger
			if (JStorage.combo() > JGameAchievements.getByName("jogger").progress)
				JGameAchievements.addProgressByName("jogger", 1);
			
			
			addFractureuns(xpAmount);
			
			//	ACVM : associate
			JGameAchievements.addProgressByName("associate", 1)
//			if ()
		}
		else
		{
			resetCombo();
		}
		
		clearInput();
		generateRandomQuestion();
	}
	
	
	//	this function will create animated text floating upwards across the eventSpace
	function logEvent(text, color, fontSize) {
		text = text !== undefined ? text : "Hello world?";
		color = color !== undefined ? color : "yellow";
		fontSize = fontSize !== undefined ? fontSize : 12;
		
		priv.eventCounter++;
		
		var id = "eventText" + priv.eventCounter;
		
		var props = {
			id: id,
			text: text,
			color: color,
		};
		
		
		var obj = priv.eventTextComponent.createObject(eventSpace, props);
		
		obj.font.pointSize = fontSize;
		
		var randY = JMath.randI(-25, -5);
		
		var from = eventSpace.height;
		var to = 20;
		
		obj.animation1.from = from + randY;
		obj.animation1.to = to + randY;
		
		
		obj.x = JMath.randI(0, eventSpace.width - 30);
		obj.horizontalAlignment = Text.AlignHCenter
		
		obj.start();
	}
	
	//	this will increment (or decrement) the xp variable and log the increase (or decrease)
	function addFractureuns(amount) {
		if (isNaN(amount) || amount === "") {
			console.error("addFractureuns(): Expected numeric amount, got", amount === "" ? "<empty>" : amount);
			return;
		}
		
		JFractureuns.addFractureuns(amount);
		if (amount >= 0)
			logEvent('+' + amount + 'F', "yellow", 8);
		else
			logEvent(amount + 'F', "red", 8);
	}
	
	//	this will log the combo with a special emoticon format for milestones, such as the combos divisible
	//	by 5, 10, and 100
	function logCombo(num) {
		num = num !== undefined ? num : JStorage.combo();
		
		if (num % 100 == 0)
		{
			logEvent('Combo ' + num + ' ✨', "lightgoldenrodyellow", 16);
		}
		else if (num % 10 == 0)
		{
			logEvent('Combo ' + num + ' 💫', "lightgoldenrodyellow", 12);
		}
		else if (num % 5 == 0)
		{
			logEvent('Combo ' + num + ' 🌟', "lightgoldenrodyellow", 10);
		}
		else
		{
			logEvent('Combo ' + num + ' ⭐️', "yellow", 8);
		}
	}
	
	function addCombo() {
		JStorage.addCombo(1);
		logCombo();
	}
	
	function resetCombo() {
//		combo = 0;
		JStorage.setCombo(0);
		
		var expressions = [
					"Oh no!",
					"Oh no!",
					"Oops!",
					"Oh dear...",
					"Combo 0",
				];
		var emojis = [
					"😢",
					"😭",
					"😥",
					"😱"
				];
		logEvent(JMath.choose(expressions) + ' ' + JMath.choose(emojis), "red", 8);
	}
	
	//	this will modify properties such that there IS a state of error present
	function rejectInput(msg) {
		errorMessage = msg;
		hasInputError = true;
	}
	
	//	this will modify properties such that there is NO state of error present
	function acceptInput() {
		errorMessage = "";
		hasInputError = false;
	}
	
	//	this will clear the input in answerField
	function clearInput() {
		answerField.clear();
	}
	
	function setCustomNumpadKeys(keys) {
		numberPad.keys = keys;
	}
}
