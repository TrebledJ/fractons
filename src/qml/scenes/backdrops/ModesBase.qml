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
		string getCorrectAnswer()			//	returns an answer that would have been marked as correct
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
	
	//	returns an answer that would have been marked as correct
	function getCorrectAnswer() {
		
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

//	TODO implement velocity

SceneBase {
	id: scene
	
	signal checkButtonClicked
	signal nextButtonClicked
	signal difficultyChanged(int index, string difficulty)
	signal correctAnswer
	signal wrongAnswer
	
	property var lastQuestions: ({})
	property alias drawingArea: drawingArea
	
	property alias numberPad: numberPad
	property alias numberPadEnabled: numberPad.visible
	
	property string modeName
	property var difficulties: []
	property int difficultyIndex: 0

	property bool hasInputError: false
	property string errorMessage
	property string textMessage
	property bool hasMessage: errorMessage || textMessage
	
	property int rewardAmount: 0
	property string unit	//	"fractons" or "tokens"	//	TODO deprecate?
	
	property alias help: infoItem.info
	property alias centerpiece: centerpieceItem.centerpiece
	
	//	this function will create animated text floating upwards across the eventSpace
	function logEvent(text, color, fontSize, x) {
		text = text !== undefined ? text : "Hello world?";
		color = color !== undefined ? color : "yellow";
		fontSize = fontSize !== undefined ? fontSize : 12;
		
		//	x is should be a real number from 0 to 1
		if (x === undefined)
			x = 0;
		else if (x === "random")
			;
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
		
		
		var obj = eventTextComponent.createObject(eventSpace, props);
		
		obj.font.pointSize = fontSize;
		
		var randY = JMath.randI(-25, -5);
		
		if (x === "random")
			obj.x = JMath.randI(0, eventSpace.width - obj.width);
		
		var from = eventSpace.height;
		var to = 20;
		
//		obj.animation1.from = from + randY;
//		obj.animation1.to = to + randY;
		obj.setVerticalAnimation(from + randY, to + randY);
		
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
			logEvent('Combo ' + num + ' ⭐️', "yellow", 8, 0.05);
		}
	}
	
	function addCombo() {
		JStorage.addCombo(1);
		logCombo();
	}
	
	function resetCombo() {
		JStorage.setCombo(0);
	}
	
	//	this will modify properties such that there IS a state of error present
	function rejectInput(msg) {
		errorMessage = msg;
		textMessage = "";
		hasInputError = true;
	}
	
	//	this will modify properties such that there is NO state of error present
	function acceptInput() {
		errorMessage = "";
		hasInputError = false;
	}
	
	//	this will clear the input in answerField
	function clearInput() {
		errorMessage = "";
		textMessage = "";
		answerField.clear();
	}
	
	function setCustomNumpadKeys(keys) {
		numberPad.keys = keys;
	}
	
	function userInput() {
		return answerField.text;
	}
	
	
	//	== OBJECT PROPERTIES ==
	
	animationLargerYBound: numberPadEnabled ? numberPad.y : textFieldColumn.y
	state: "listening"
	
	Component.onCompleted: {
		//	check if platform is mobile
		if (JStorage.isMobile)
		{
			textField.height = 30;
			textField.font.pointSize = 12;
			
			answerField.height = 30;
			answerField.font.pointSize = 18;
		}
		
		//	generate a random question
		generateRandomQuestion();
	}
	
	onDifficultyIndexChanged: {
		console.warn("Difficulty Index Changed:", difficultyIndex, difficulties[difficultyIndex])
		
		//	generate a new random question
		if (lastQuestions[difficultyIndex] === undefined)
			generateRandomQuestion();
		else
			parseQuestionState(lastQuestions[difficultyIndex]);
		
		modesBase.difficultyChanged(difficultyIndex, difficulties[difficultyIndex]);
		
		clearInput();
	}
	
	onCheckButtonClicked: {
		checkButton.animateScalar();
		
		//	processing logic
		var text = answerField.text;
		
		//	back to logic-processing
		var hasAcceptableInput = checkInput(text);
		if (!hasAcceptableInput)
		{
			//	ACVM : no u
			if (text.toLowerCase() === "no u")
			{
				console.warn("NO U!");
				JGameAchievements.addProgressByName("no u", 1);
				
				rejectInput(text + '!');
			}
			//	ACVM : pseudonym
			if (text.toLowerCase() === "technist")
			{
				console.warn("Pseudonym I!");
				JGameAchievements.addProgressByName("pseudonym i", 1);
				rejectInput("That's me!");
			}
			if (text.toLowerCase() === "trebledj")
			{
				console.warn("Pseudonym II!");
				JGameAchievements.addProgressByName("pseudonym ii", 1);
				rejectInput("That's me!");
			}
			if (text.toLowerCase() === "tinman" || text.toLowerCase() === "tin man")
			{
				console.warn("Pseudonym III!");
				JGameAchievements.addProgressByName("pseudonym iii", 1);
				rejectInput("That's me!");
			}
			if (text.toLowerCase() === "trebuchetms" || text.toLowerCase() === "trebuchet ms")
			{
				console.warn("Pseudonym IV!");
				JGameAchievements.addProgressByName("pseudonym iv", 1);
				rejectInput("That's me!");
			}
			
			return;
		}
		
		var isCorrect = checkAnswer(text);
		if (isCorrect)
		{
			correctAnswer();	//	emit a signal
		}
		else
		{
			wrongAnswer();
		}
		
		JGameStatistics.incDailyAttempted();
		
		//	TODO perhaps remake the statistics schema on a per question basis
//		JGameStatistics.pushQuestion(modeName, difficulties[difficultyIndex], question, input, answer, isCorrect);	//	TODO uncomplete
		
		state = "static";
		
	}
	
	onNextButtonClicked: {
		//	animation logic
		checkButton.animateScalar();
		
		clearInput();
		generateRandomQuestion();
		
		state = "listening";
	}
	
	onCorrectAnswer: {
		textMessage = JMath.choose([
									   "That's the correct answer!",
									   "Correct!",
									   "Bravo!",
									   "Yes!",
									   "You did it!",
								   ]);
		
		addCombo();	//	increment the combo
		
		var combo = JStorage.combo();
		
		//	TOKENS
		if (combo > 0 && combo % 25 == 0)	//	check that combo is a multiple of 25 greater than 0
		{
			JStorage.addTokens(1);
			
			//	TOKENS
			if (JFractons.currentLevel() >= 15)
				logEvent("+1 Token", "yellow", 10, "random");	//	notify only if lvl ≥ 15 (i.e. when user is 'aware' of tokens)
		}
		
		addFractons(rewardAmount);	//	give reward in fractons
		
		//	QUEST : key = questions
		JQuests.addQuestProgressByKey("questions", 1, modeName);
		
		//	ACVM : studious
		JGameAchievements.addProgressByName("studious i", 1);
		JGameAchievements.addProgressByName("studious ii", 1);
		JGameAchievements.addProgressByName("studious iii", 1);
		JGameAchievements.addProgressByName("studious iv", 1);
		JGameAchievements.addProgressByName("studious v", 1);
		
		//	ACVM : sprinter
		if (combo > JGameAchievements.getByName("sprinter i").progress)
			JGameAchievements.addProgressByName("sprinter i", 1);
		if (combo > JGameAchievements.getByName("sprinter ii").progress)
			JGameAchievements.addProgressByName("sprinter ii", 1);
		if (combo > JGameAchievements.getByName("sprinter iii").progress)
			JGameAchievements.addProgressByName("sprinter iii", 1);
		if (combo > JGameAchievements.getByName("sprinter iv").progress)
			JGameAchievements.addProgressByName("sprinter iv", 1);
		if (combo > JGameAchievements.getByName("sprinter v").progress)
			JGameAchievements.addProgressByName("sprinter v", 1);
		
		//	ACVM : associate
		JGameAchievements.addProgressByName("associate", 1)
		
		//	add to statistics
		JGameStatistics.incDailyCorrect();
	}
	
	onWrongAnswer: {
		errorMessage = "Oh no! The answer was " + getCorrectAnswer() + ".";
		resetCombo();
	}

	onShownChanged: {
		var msg = modeName + " Mode";

		if (shown)
			backgroundAnimationTimer.run(msg, null, scene, 20);
		else
			backgroundAnimationTimer.cancel(msg);
		
		answerField.forceActiveFocus();
	}
	
	
	//	== CHILD OBJECTS ==
	
	Item {
		id: infoItem
		
		property Item info
		
		anchors.fill: drawingArea
		opacity: 0
		
		onInfoChanged: {
			info.parent = infoItem;
			info.anchors.fill = infoItem;
			info.anchors.margins = 20;
		}
		
		Behavior on opacity {
			PropertyAnimation {  duration: 1000; easing.type: infoButton.containsMouse ? Easing.InExpo : Easing.OutExpo }
		}
	}
	
	NumberPad {
		id: numberPad
		anchors { left: drawingArea.left; right: drawingArea.right; bottom: textFieldColumn.top; margins: 5 }
		height: 150 - textField.height
		
		enabled: scene.state === "listening"
		opacity: enabled ? 1 : 0.6
		
		onKeyPressed: /*params: {string key}*/ {
			if (scene.state === "static")
				return;
			
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
		anchors { top: scene.top; left: scene.left; bottom: scene.bottom }
		
		color: "navy"
		
		ColumnLayout {
			id: panelColumn
			anchors { fill: parent; margins: 10 }
			spacing: 10
			
			//	this is the row of buttons at the top of the panel
			RowLayout {
				width: parent.width; height: 30
				spacing: 10
				
				Item { Layout.fillWidth: true }
				
				BubbleButton {
					id: infoButton
					property bool containsMouse: mouseArea.containsMouse
					
					width: height; height: 30
					text: "?"
					
					onEntered: { infoItem.opacity = 1; centerpieceItem.opacity = 0; }
					onExited: { infoItem.opacity = 0; centerpieceItem.opacity = 1; }
				}
			}
			
			BubbleButton {
				id: difficultyButton
				width: parent.width; height: 30
				background.radius: 5
				
				text: difficulties.length === 0 ? "" : difficulties[difficultyIndex]
				visible: difficulties.length > 0
				
				onClicked: {
					if (scene.state === "listening")
						lastQuestions[difficultyIndex] = getQuestionState();
					
					scene.state = "listening";
					difficultyIndex = (difficultyIndex + 1) % difficulties.length;
				}
			}
			
			Rectangle {
				id: eventSpace
				width: parent.width
				Layout.fillHeight: true
				
				color: "skyblue"	//	DEBUG?
//				color: "transparent"
			}
			
			BubbleButton {
				id: checkButton
				width: parent.width; height: 30
				background.radius: 5
				
				text: scene.state === "listening" ? "Check" : "Next"
				
				onClicked: {
					if (infoButton.containsMouse)
						return;
					
					if (scene.state === "listening")
						scene.checkButtonClicked();
					else
						scene.nextButtonClicked();
				}
			}
			
			TextBase {
				id: fractonDisplay
				width: parent.width; height: contentHeight + 5
				Layout.alignment: Qt.AlignHCenter
				
				text: 'Level ' + JFractons.currentLevel() + '   ' + JFractons.fractons + '/' + JFractons.nextThresh() + " ƒ"
				font.pointSize: 8
				
				color: "yellow"
				
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
					anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 2 }
					width: (parent.width - 6) * JFractons.progress() + 2; height: parent.height - 4
					radius: 5
					color: "navy"
				}
			}
		}	//	Column: panelColumn
	}	//	Rectangle: panel
	
	
	//	this column holds text fields, anchored to the bottom of the scene (for non-mobile/tvos platforms only)
	Column {
		id: textFieldColumn
		anchors { left: panel.right; right: scene.right; bottom: scene.bottom }
		
		//	this will popup above the answerField below when there is an error message
		TextField {
			id: textField
			width: parent.width; height: hasMessage ? 20 : 0
			padding: 2
			
			text: errorMessage || textMessage
			font { pointSize: 8; family: "Trebuchet MS" }
			
			color: errorMessage ? "red" : "green"
			opacity: 0.8
			
			readOnly: true
			
			Behavior on height { 
				PropertyAnimation {  easing.type: Easing.OutBack; duration: hasMessage ? 500 : 800 }
			}
		}
		
		//	this is similar to a qlineedit, and is where the user will enter input
		TextField {
			id: answerField
			width: parent.width; height: 20
			
			placeholderText: "Answer"
			font.pointSize: 8
			font.family: "Trebuchet MS"
			padding: 2
			
			color: "navy"
			
			readOnly: scene.state === "static" || infoButton.containsMouse
			
			background: rect
			
			Keys.onReturnPressed: {
				if (JStorage.isMobile)
					return;
				
				//	mouse shouldn't be contained in infoButton
				if (infoButton.containsMouse)
					return;
				
				checkButton.clicked();
			}
		
			onTextChanged: {
				//	update the errCode which will update the background if the answer is invalid
				var text = answerField.text;
				
				var error = hasParsingError(text);
				hasInputError = error;
			}
			
			Rectangle {
				id: rect
				anchors.fill: parent
				color: "white"
				border.color: "lightgrey"
				Rectangle {
					anchors { fill: parent; margins: 1 }
					color: hasInputError ? "red" : "green"; opacity: 0.5
				}
			}
		}
	}
	
	//	this will be referenced in child scenes for appropriate drawing points
	Rectangle {
		id: drawingArea
		anchors {
			left: panel.right; right: scene.right; top: scene.top
			bottom: numberPad.visible ? numberPad.top : textFieldColumn.top
		}
		color: "transparent"
		
		Item {
			id: centerpieceItem
			property Item centerpiece
			anchors.centerIn: parent
			onCenterpieceChanged: {
				centerpiece.parent = centerpieceItem;
				centerpiece.anchors.centerIn = centerpieceItem;
			}
			
			Behavior on opacity {
				PropertyAnimation {
					easing.type: infoButton.containsMouse ? Easing.OutExpo : Easing.InExpo
					duration: 1000 
				}
			}
		}
		
	}
	
	//	an object to store private variables
	QtObject {
		id: priv
		property int eventCounter: 0
	}
	
	Component {
		id: eventTextComponent
		TextBase {
			id: eventText
			
			function setVerticalAnimation(y1, y2) {
				animation1.from = y1;
				animation1.to = y2;
			}
			
			function start() {
				seqAnimation.start();
			}
			
			SequentialAnimation {
				id: seqAnimation
				NumberAnimation { id: animation1; target: eventText; property: 'y'; duration: 8000 }
				NumberAnimation { target: eventText; property: 'opacity'; from: 1; to: 0; duration: 2000 }
				onStopped: eventText.destroy()
			}
		}
	}

	
	//	== STATES ==
	
	states: [
		State { name: "listening" },
		State { name: "static" }
	]
}
