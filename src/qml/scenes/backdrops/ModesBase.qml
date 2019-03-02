//	ModesBase.qml
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

import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../../common"
import "../../game"
import "../../game/singles"

import "../../js/Math.js" as JMath

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
	
	property string modeName
	property var difficulties: []
	property int difficultyIndex: 0

	property bool hasInputError: false
	property string errorMessage
	
	property int xpAmount: 0
//	property int combo: 0
	
	
	useDefaultBackButton: false
	animationLargerYBound: numberPadVisible ? numberPad.y : textFieldColumn.y
	
	Component.onCompleted: {
//		console.debug("Level", JFractons.levelAt());
//		console.debug("fractons", JFractons.fCurrent);
//		console.debug("leveling_constant", JFractons.fLevelingConstant);
		
//		for (var i = 0; i < 10; i++)
//		{
//			console.debug("Level", i, "has a thresh of", JFractons.xpThresh(i));
//		}
		
//		for (var i = 0; i < 20; i++)
//		{
//			console.debug("XP", i * 10, "has level", JFractons.levelAt(i*10));
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
		id: infoButton
		width: height; height: 30
		anchors {
			top: drawingArea.top
			right: drawingArea.right
			margins: 10
		}
		
		text: "i"
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
		
		ColumnLayout {
			id: panelColumn
			anchors.fill: parent
			anchors.margins: 10
			spacing: 10
			
			/*TextBase {
				Layout.alignment: Qt.AlignHCenter
				width: parent.width
				color: "yellow"
				text: modeName  // + "\nMode"
				
				horizontalAlignment: Text.AlignHCenter
				
				font.pointSize: 16
			}*/
			
			//	this is the row of buttons at the top of the panel
			Row {
				width: parent.width; height: 30
				spacing: 10
				
				BubbleButton {
					id: backButton
					width: parent.width - parent.spacing - infoButton.width; height: parent.height
					background.radius: 5
					
					text: "Back"
					
					onClicked: scene.backButtonClicked()
				}
				
				BubbleButton {
					id: numberPadSwitch
					width: height; height: parent.height
					
					image.source: "qrc:/assets/icons/calculator"
					
					isCheckButton: true
					checked: true
					
					onClicked: {
						if (numberPad.visible)
							numberPad.animate();
					}
				}
			}
			
			BubbleButton {
				id: difficultyButton
				width: parent.width; height: 30
				background.radius: 5
				
				text: difficulties.length === 0 ? "" : difficulties[difficultyIndex]
				
				
				visible: difficulties.length > 0
				
				onClicked: {
					lastQuestions[difficultyIndex] = getQuestionState();
					
					difficultyIndex = (difficultyIndex + 1) % difficulties.length;
				}
			}
			
			Rectangle {
				id: eventSpace
				width: parent.width; Layout.fillHeight: true
				
				color: "skyblue"	//	debug
//				color: "transparent"
			}
			
			BubbleButton {
				id: goButton
				width: parent.width; height: 30
				background.radius: 5
				
				text: "Go"
				
				//	broadcast
				onClicked: scene.goButtonClicked();
				//	all the intense logic is kept out of here for brevity
				//	and moved to the onGoButtonClicked signal handler below
			}
			
			TextBase {
				id: fractonDisplay
				width: parent.width; height: contentHeight + 5
				Layout.alignment: Qt.AlignHCenter
				
				color: "yellow"
				
				text: 'Level ' + JFractons.currentLevel() + '   ' + JFractons.fCurrent + '/' + JFractons.fNextThresh() + " ƒ"
				
				font.pointSize: 10
				
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignBottom
			}
					
			//	displays the frac progress
			Rectangle {
				id: fractonOuterBar
				width: parent.width; height: 10
				radius: 5
				
				color: "lightgoldenrodyellow"
				
				Rectangle {
					id: xpMeter
					width: (parent.width - 6) * JFractons.fProgress() + 2; height: parent.height - 4
					radius: 5
					anchors {
						left: parent.left
						top: parent.top
						bottom: parent.bottom
						margins: 2
					}
					
					color: "navy"
				}
			}	//	Rectangle: fractonOuterBar
					
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
		goButton.animateScalar();
		
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
			
			//	ACVM : sprinter1
			if (JStorage.combo() > JGameAchievements.getByName("sprinter i").progress)
				JGameAchievements.addProgressByName("sprinter i", 1);
			
			
			addFractons(xpAmount);
			
			//	ACVM : associate
			JGameAchievements.addProgressByName("associate", 1)
//			if ()
			JGameStatistics.incDailyCorrect();
		}
		else
		{
			resetCombo();
		}
		
		JGameStatistics.incDailyAttempted();
//		JGameStatistics.pushQuestion(modeName, difficulties[difficultyIndex], question, input, answer, isCorrect);	//	TODO uncomplete
		
		clearInput();
		generateRandomQuestion();
	}
	
	
	onStateChanged: {
		var msg = modeName + " Mode";
		
		if (state === "show")
			backgroundAnimationTimer.run(msg, null, scene, 20);
		else
			backgroundAnimationTimer.cancel(msg);
	}
	
	//	this function will create animated text floating upwards across the eventSpace
	function logEvent(text, color, fontSize, x) {
		text = text !== undefined ? text : "Hello world?";
		color = color !== undefined ? color : "yellow";
		fontSize = fontSize !== undefined ? fontSize : 12;
		
		//	x is should be a real number from 0 to 1
		if (x === undefined)
			x = 0;
		else
			x = x*eventSpace.width;
		
		priv.eventCounter++;
		
		var id = "eventText" + priv.eventCounter;
		
		var props = {
			id: id,
			text: text,
			color: color,
			x: x,
		};
		
		
		var obj = priv.eventTextComponent.createObject(eventSpace, props);
		
		obj.font.pointSize = fontSize;
		
		var randY = JMath.randI(-25, -5);
		
		if (x === "random")
			obj.x = JMath.randI(0, eventSpace.width - obj.width);
		
		var from = eventSpace.height;
		var to = 20;
		
		obj.animation1.from = from + randY;
		obj.animation1.to = to + randY;
		
		obj.horizontalAlignment = Text.AlignHCenter
		
		obj.start();
	}
	
	//	this will increment (or decrement) the xp variable and log the increase (or decrease)
	function addFractons(amount) {
		if (isNaN(amount) || amount === "") {
			console.error("addFractons(): Expected numeric amount, got", amount === "" ? "<empty>" : amount);
			return;
		}
		
		JFractons.addFractons(amount);
		if (amount > 0)
			logEvent('+' + amount + 'ƒ', "green", 8, 0.75);
		else if (amount === 0)
			logEvent('+' + amount + 'ƒ', "yellow", 8, 0.75);
		else
			logEvent(amount + 'ƒ', "red", 8, 0.75);
	}
	
	//	this will log the combo with a special emoticon format for milestones, such as the combos divisible
	//	by 5, 10, and 100
	function logCombo(num) {
		num = num !== undefined ? num : JStorage.combo();
		
		var x = JMath.randI(1, 10) / 100;
		
		if (num % 100 == 0)
		{
			logEvent('Combo ' + num + ' ✨', "lightgoldenrodyellow", 16, "random");
		}
		else if (num % 10 == 0)
		{
			logEvent('Combo ' + num + ' 💫', "lightgoldenrodyellow", 12, "random");
		}
		else if (num % 5 == 0)
		{
			logEvent('Combo ' + num + ' 🌟', "lightgoldenrodyellow", 10, "random");
		}
		else
		{
			logEvent('Combo ' + num + ' ⭐️', "yellow", 8, "random");
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
		
		var x = JMath.randI(0, 50) / 100;
		
		logEvent(JMath.choose(expressions) + ' ' + JMath.choose(emojis), "red", 12, x);
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
